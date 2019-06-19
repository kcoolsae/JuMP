# Includes meta data into an .md page that comes from an optional separate metadata file,
# per file and per directory
#
# Idea inspirder by https://github.com/jekyll/jekyll/issues/1082 - message karelv 30 jan 2016
# but substantially altered
#

require "jekyll-optional-front-matter"

module ProcessFiles

  class Generator < JekyllOptionalFrontMatter::Generator

    safe true
    priority :normal

    def add_metadata (path, doc)
        if File.exist?(path)
          SafeYAML.load_file(path).each do |key, value|
            doc.data[key] = value
          end
        end
    end  

    def pages_to_add      
      super
      pages.each do |doc|
        add_metadata File.dirname(doc.path)+ File::SEPARATOR+"_dir.yml", doc
        add_metadata doc.path + ".yml", doc
        next doc unless markdown_extension?(doc.extname)
        replace_relative_links! doc
      end      
    end

# Below:  Based on jekyll-relative-links plugin - which did not work    

    # Use Jekyll's native relative_url filter
    include Jekyll::Filters::URLFilters

    LINK_TEXT_REGEX = %r!(.*?)!.freeze
    FRAGMENT_REGEX = %r!(#.+?)?!.freeze
    INLINE_LINK_REGEX = %r!\[#{LINK_TEXT_REGEX}\]\(([^\)]+?)#{FRAGMENT_REGEX}\)!.freeze
    REFERENCE_LINK_REGEX = %r!^\s*?\[#{LINK_TEXT_REGEX}\]: (.+?)#{FRAGMENT_REGEX}\s*?$!.freeze
    LINK_REGEX = %r!(#{INLINE_LINK_REGEX}|#{REFERENCE_LINK_REGEX})!.freeze

    def replace_relative_links!(document)

      url_base = File.dirname(document.relative_path)
      return document if document.content.nil?

      document.content = document.content.dup.gsub(LINK_REGEX) do |original|
        link_type, link_text, relative_path, fragment = link_parts(Regexp.last_match)
        next original unless replaceable_link?(relative_path)
        replacement_text(link_type, link_text, relative_path, fragment)
      end
    rescue ArgumentError => e
      raise e unless e.to_s.start_with?("invalid byte sequence in UTF-8")
    end

    private

    def link_parts(matches)
      link_type     = matches[2] ? :inline : :reference
      link_text     = matches[link_type == :inline ? 2 : 5]
      relative_path = matches[link_type == :inline ? 3 : 6]
      fragment      = matches[link_type == :inline ? 4 : 7]

      [link_type, link_text, relative_path, fragment]
    end

    def markdown_extension?(extension)
      extension == ".md"
    end

    def url_for_path(path)
      target = potential_targets.find { |p| p.relative_path.sub(%r!\A/!, "") == path }
      relative_url(target.url) if target&.url
    end

    def replacement_text(type, text, url, fragment = nil)
      url = url.sub(/.md$/, ".html")
      url << fragment if fragment

      if type == :inline
        "[#{text}](#{url})"
      else
        "\n[#{text}]: #{url}"
      end
    end


    def replaceable_link?(string)
      !fragment?(string) && !absolute_url?(string)
    end

    def absolute_url?(string)
      return unless string

      Addressable::URI.parse(string).absolute?
    rescue Addressable::URI::InvalidURIError
      nil
    end

    def fragment?(string)
      string&.start_with?("#")
    end


    
  end
  
end
