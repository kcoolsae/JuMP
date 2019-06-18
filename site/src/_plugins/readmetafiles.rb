# Includes meta data into an .md page that comes from an optional separate metadata file,
# per file and per directory
#
# Idea inspirder by https://github.com/jekyll/jekyll/issues/1082 - message karelv 30 jan 2016
# but substantially altered
#

require "jekyll-optional-front-matter"

module ReadMetaFiles

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
      end      
    end
    
  end
  
end
