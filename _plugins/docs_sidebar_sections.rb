# frozen_string_literal: true

require 'pathname'

# Populates document.data['sidebar_sections'] for the docs collection by parsing
# each source .md file (DocsSidebarSectionsGenerator, priority :high).

module DocsSidebarSections
  class << self
    ANCHOR_RE = /<a\s+name=["']([^"']+)["']\s*>\s*<\/a>\s*/i
    HEADING_RE = Regexp.new('^([#]{2,4})\\s+(.+?)\\s*$')

    def populate!(site)
      collection = site.collections['docs']
      return unless collection

      collection.docs.each do |doc|
        doc.data['sidebar_sections'] = extract_for_doc(site, doc)
      end
    end

    def extract_for_doc(site, doc)
      path = resolve_source_path(site, doc)
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

    def resolve_source_path(site, doc)
      src = site.source
      candidates = []

      if doc.respond_to?(:path) && doc.path
        p = doc.path.to_s
        candidates << p
        unless Pathname.new(p).absolute?
          candidates << File.expand_path(p, src)
          candidates << File.join(src, p.sub(%r{\A/+}, ''))
        end
      end

      if doc.respond_to?(:relative_path) && doc.relative_path
        rp = doc.relative_path.to_s.sub(%r{\A/+}, '')
        candidates << File.join(src, rp)
      end

      candidates.compact.uniq.find { |c| File.file?(c) }
    end

    def strip_front_matter(raw)
      raw.sub(/\A---\r?\n.*?\r?\n---\r?\n/m, '')
    end

    def clean_title(raw_title)
      t = raw_title.strip
      t = t.gsub(/\*\*([^*]+)\*\*/, '\1')
      t = t.gsub(/`([^`]+)`/, '\1')
      t.gsub(/\[([^\]]+)\]\([^)]+\)/, '\1').strip
    end
  end
end

class DocsSidebarSectionsGenerator < Jekyll::Generator
  priority :high
  safe true

  def generate(site)
    DocsSidebarSections.populate!(site)
  end
end
