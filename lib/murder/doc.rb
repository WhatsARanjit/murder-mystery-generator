require 'erb'
require 'redcarpet'
require 'pdfkit'

module MURDER
  class Doc

    def initialize(template, scope)
      @template = template
      
      scope.each do |var, value|
        instance_variable_set("@#{var}", value)
      end

      create_markdown_dir
      create_pdf_dir
    end

    def create_markdown_dir
      dir = "#{Dir.pwd}/markdown"
      puts "== Markdown directory #{dir}" if
      (
        Dir.mkdir dir unless File.exists?(dir)
      )
    end

    def create_pdf_dir
      dir = "#{Dir.pwd}/pdf"
      puts "== PDF directory #{dir}" if
      (
        Dir.mkdir dir unless File.exists?(dir)
      )
    end

    def profile_template
      File.read(File.dirname(__FILE__) + '/../../templates/' + @template)
    end

    def render_md
      ERB.new(profile_template, nil, '-').result(binding)
    end

    def save_md
      File.write("markdown/#{cleanup_name(@name)}.md", render_md)
    end

    def render_html(markdown)
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true,
        tables: true,
        strikethrough: true,
        fenced_code_blocks: true).render(markdown)
    end

    def cleanup_name(dirty)
      dirty.gsub(/[\s\-]/, '_').downcase
    end

    def render_pdf(markdown)
      pdf = PDFKit.new(
        render_html(markdown),
        :page_size => 'Letter'
      )
      #pdf.stylesheets << '/Users/ranjit/Customers/PS/ranjit.css'
      pdf.to_file("pdf/#{cleanup_name(@name)}.pdf")
    end
  end
end
