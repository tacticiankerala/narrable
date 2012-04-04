$:.unshift File.join(File.dirname(__FILE__),"")
HTML_FOLDER = "html"
CSS_FOLDER = "css"

def get_html_files(folder)
  Dir.foreach(folder).select{|file| file if file.match(/\.html$/i)}
end
def get_css_files(corresponding_htmls)
  corresponding_htmls.collect{ |file| file.sub(/.html$/i,".css")}
end

html_files = get_html_files(HTML_FOLDER)
css_files =  get_css_files(html_files)
for css_file in css_files
  if ! File.exists?(File.join(CSS_FOLDER,css_file))
    puts "\n\n"+css_file+" does not exist!!\n\n"
    fail
  end
end
open("source.xml","w"){|xml|
  xml.puts '<?xml version="1.0"?>'
  xml.puts '<narrable>'
  for i in (0...html_files.length)
    html_file_name = html_files[i]
    css_file_name = css_files[i]
    html_file = File.join(HTML_FOLDER,html_file_name)
    css_file = File.join(CSS_FOLDER,css_file_name)
    xml.puts '<choice value="'+(i+1).to_s+'">'
    xml.puts '<title>'+html_file_name.sub(/\.html$/i,'')+'</title>'
    xml.puts '<html-text><![CDATA['
    open(html_file,"r"){|html|

      while  (line = html.gets)
        xml.puts line.chomp
      end
    }
    xml.puts ']]></html-text>'
    xml.puts '<style-text>'
    open(css_file,"r"){ |css|
      while  (line = css.gets)
        xml.puts line.chomp
      end
    }
    xml.puts '</style-text>'
    xml.puts '</choice>'
    puts html_file_name+" --- "+css_file_name
  end
  xml.puts '</narrable>'
}
puts "Success!"
