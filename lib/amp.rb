require "amp/parser"

module Amp
  def self.compile(text, 
                   full_filename="index.html", 
                   current_class="current", 
                   current_parent_class="current-parent")

    parser = Parser.new({
      :text => text,
      :filename => full_filename,
      :current_class => current_class, 
      :current_parent_class => current_parent_class
    })

    return parser.parse()
  end
end