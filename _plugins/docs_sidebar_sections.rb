# frozen_string_literal: true

require 'pathname'
require 'nokogiri'
require 'kramdown'

# Fills site.data.docs_sidebar_sections and doc.data.sidebar_sections with h2–h4 from each doc.
# Uses Kramdown on the markdown body so anchors match the built HTML (no {:toc} required).

module DocsSidebarSections
  class << self
    ANCHOR_RE = /<a\s+name=["']([^"']+)["']\s*>\s*<\/a>\s*/i
    HEADING_MD_RE = /\A([#]{2,4})\s+(.+?)\s*\z/
    SKIP_TITLES = ['table of contents'].freeze

    def register_keys!(site, doc, path, headings)
      h = site.data['docs_sidebar_sections']
      return if h.nil?
      return if headings.nil? || headings.empty?

      if path && File.file?(path)
        base = File.basename(path, File.extname(path))
        h[base] = headings
        h[base.tr('-', '_')] = headings if base.include?('-')
        h[base.tr('_', '-')] = headings if base.include?('_')
      end

      url_variants(doc.url).each { |k| h[k] = headings }
    end

    def url_variants(url)
      u = url.to_s
      vs = [u]
      vs << u.chomp('/') if u.end_with?('/')
      vs << "#{u}/" unless u.end_with?('/')
      vs << u.tr('-', '_') if u.include?('-')
      vs << u.tr('_', '-') if u.include?('_')
      vs.compact.uniq
    end

    def populate_from_disk!(site)
      site.data['docs_sidebar_sections'] = {}
      collection = site.collections['docs']
      return unless collection

      collection.docs.each do |doc|
        path = resolve_source_path(site, doc)
        headings = extract_from_markdown_disk(site, doc, path)
        doc.data['sidebar_sections'] = headings
        register_keys!(site, doc, path, headings)
      end
    end

    def html_fallback!(site)
      collection = site.collections['docs']
      return unless collection

      site.data['docs_sidebar_sections'] ||= {}
      collection.docs.each do |doc|
        existing = doc.data['sidebar_sections']
        next if existing.is_a?(Array) && !existing.empty?

        begin
          html = doc.content.to_s
          next if html.strip.empty?

          headings = extract_headings_from_html(html)
          next if headings.empty?

          doc.data['sidebar_sections'] = headings
          path = resolve_source_path(site, doc)
          register_keys!(site, doc, path, headings)
        rescue StandardError => e
          warn_doc(doc, e)
          doc.data['sidebar_sections'] = []
        end
      end
    end

    def extract_from_markdown_disk(site, doc, path = nil)
      path ||= resolve_source_path(site, doc)
      return [] unless path && File.file?(path)

      raw = File.read(path, encoding: 'UTF-8')
      raw = raw.sub("\xEF\xBB\xBF", '')
      body = strip_front_matter(raw)

      # Walk the source first. It matches this repo's style (### + <a name="…">) and
      # cannot be skipped if Kramdown::Document raises on Jekyll's kramdown options.
      headings = walk_markdown_lines(body)
      if headings.empty?
        begin
          headings = headings_from_kramdown(body, site)
        rescue StandardError => e
          warn_doc(doc, e)
        end
      end
      headings
    rescue StandardError => e
      warn_doc(doc, e)
      []
    end

    def headings_from_kramdown(body, site)
      opts = kramdown_options(site)
      html = Kramdown::Document.new(body, opts).to_html
      extract_headings_from_html(html)
    end

    def kramdown_options(site)
      # Defaults first so a partial _config kramdown map does not drop auto_ids, etc.
      opts = { auto_ids: true }
      (site.config['kramdown'] || {}).each do |k, v|
        next if v.nil?

        opts[k.to_sym] = v
      end
      opts
    end

    def extract_headings_from_html(html)
      frag = Nokogiri::HTML::DocumentFragment.parse(html)
      seen_id = {}
      out = []

      frag.css('h2, h3, h4').each do |h|
        id = h['id'].to_s
        next if id.empty?
        next if seen_id[id]

        title = heading_title_from_node(h)
        next if title.empty? || skip_title?(title)

        seen_id[id] = true
        out << {
          'title' => title,
          'anchor' => id,
          'level' => h.name[1].to_i
        }
      end
      out
    rescue StandardError
      []
    end

    def heading_title_from_node(h)
      h.inner_text.to_s.strip.gsub(/\s+/, ' ')
    end

    def skip_title?(title)
      SKIP_TITLES.include?(title.downcase)
    end

    def walk_markdown_lines(body)
      headings = []
      pending_anchor = nil

      body.each_line do |line|
        line = line.chomp
        if (m = line.match(ANCHOR_RE))
          pending_anchor = m[1]
        else
          ls = line.strip
          next if ls.empty?
          next unless (m = ls.match(HEADING_MD_RE))

          level = m[1].length
          title = clean_title(m[2])
          next if title.empty? || skip_title?(title)

          anchor = pending_anchor || Jekyll::Utils.slugify(title)
          headings << {
            'title' => title,
            'anchor' => anchor,
            'level' => level
          }
          pending_anchor = nil
        end
      end

      headings
    end

    def resolve_source_path(site, doc)
      src = File.expand_path(site.source.to_s)
      candidates = []

      if doc.respond_to?(:relative_path) && doc.relative_path
        rp = doc.relative_path.to_s.tr('\\', '/').sub(%r{\A/+}, '')
        candidates << File.join(src, rp)
      end

      if doc.respond_to?(:path) && doc.path
        pth = doc.path.to_s.tr('\\', '/')
        candidates << pth
        candidates << File.expand_path(pth, src)
        unless Pathname.new(pth).absolute?
          candidates << File.join(src, pth.sub(%r{\A/+}, ''))
        end
      end

      found = candidates.compact.uniq.find { |c| File.file?(c) }
      return found if found

      resolve_via_docs_glob(site, doc)
    end

    def resolve_via_docs_glob(site, doc)
      src = File.expand_path(site.source.to_s)
      dir = File.join(src, '_docs')
      return nil unless Dir.exist?(dir)

      slugs = []
      slugs << doc.slug.to_s if doc.respond_to?(:slug) && !doc.slug.to_s.empty?

      u = doc.url.to_s.sub(%r{\A/}, '').chomp('/')
      segs = u.split('/')
      slugs << segs.last if segs.length >= 2 && segs.first == 'docs'

      slugs.compact.uniq.each do |slug|
        [slug, slug.tr('_', '-'), slug.tr('-', '_')].uniq.each do |base|
          %w[md markdown].each do |ext|
            f = File.join(dir, "#{base}.#{ext}")
            return f if File.file?(f)
          end
        end
      end
      nil
    end

    def strip_front_matter(raw)
      stripped = raw.sub(/\A---\r?\n.*?\r?\n---\r?\n/m, '')
      return stripped if stripped != raw

      raw.sub(/\A---\r?\n.*?\r?\n---\s*\r?\n/m, '')
    end

    def clean_title(raw_title)
      t = raw_title.strip
      t = t.gsub(/\*\*([^*]+)\*\*/, '\1')
      t = t.gsub(/`([^`]+)`/, '\1')
      t.gsub(/\[([^\]]+)\]\([^)]+\)/, '\1').strip
    end

    def warn_doc(doc, err)
      label = doc.respond_to?(:relative_path) && doc.relative_path ? doc.relative_path : doc.path
      Jekyll.logger.warn("DocsSidebar: #{label}: #{err.message}")
    end
  end
end

class DocsSidebarSectionsFromDisk < Jekyll::Generator
  priority :high
  safe true

  def generate(site)
    DocsSidebarSections.populate_from_disk!(site)
  end
end

class DocsSidebarSectionsHtmlFallback < Jekyll::Generator
  priority :lowest
  safe true

  def generate(site)
    DocsSidebarSections.html_fallback!(site)
  end
end
