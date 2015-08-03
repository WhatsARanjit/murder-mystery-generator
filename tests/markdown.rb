require 'erb'
require 'redcarpet'
require 'pdfkit'

profile_template = File.read('./templates/profile.md.erb')

@name = 'Fob Shark'

renderer = ERB.new(profile_template, nil, '-')
md = renderer.result()
html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true, strikethrough: true, fenced_code_blocks: true).render(md)
pdf = PDFKit.new(html, :page_size => 'Letter')
#pdf.stylesheets << '/Users/ranjit/Customers/PS/ranjit.css'
pdf.to_file("document.pdf")
