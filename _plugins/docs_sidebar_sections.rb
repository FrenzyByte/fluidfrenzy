# frozen_string_literal: true

module Jekyll
  # Builds per-page heading lists for the docs sidebar (mirrors in-page TOC targets).
  class DocsSidebarSectionsGenerator < Generator
    safe true
    priority :lowest

    ANCHOR_RE = /<a\s+name=["']([^"']+)["']\s*>\s*<\/a>\s*/i
    HEADING_RE = Regexp.new('^([#]{2,4})\\s+(.+?)\\s*$')

    def generate(site)
      collection = site.collections['docs']
      return unless collection

      collection.docs.each do |doc|
        doc.data['sidebar_sections'] = extract_sections(doc.path)
      end
    end

    def extract_sections(path)
      return [] unless path && File.file?(path)

      raw = File.read(path, encoding: 'UTF-8')
      body = strip_front_matter(raw)
      headings = []
      pending_anchor = nil

      body.each_line do |line|
        line = line.chomp
        if (m = line.match(ANCHOR_RE))
          pending_anchor = m[1]
        elsif (m = line.match(HEADING_RE))
          level = m[1].length
          title = clean_title(m[2])
          next if title.empty?
          next if title.casecmp('table of contents').zero?

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

    def strip_front_matter(raw)
      raw.sub(/\A---\s*\R.*?\R---\s*\R/m, '')
    end

    def clean_title(raw_title)
      t = raw_title.strip
      t = t.gsub(/\*\*([^*]+)\*\*/, '\1')
      t = t.gsub(/`([^`]+)`/, '\1')
      t.gsub(/\[([^\]]+)\]\([^)]+\)/, '\1').strip
    end

  end
end
