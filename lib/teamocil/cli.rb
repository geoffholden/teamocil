module Teamocil
  class CLI < ClosedStruct.new(:arguments, :environment)
    DIRECTORY = '$HOME/.teamocil'

    def run!
      Teamocil.parse_options!(arguments: arguments)

      # List available layouts
      return Teamocil::Layout.print_available_layouts(directory: root) if Teamocil.options[:list]

      # Fetch the Layout object
      layout = Teamocil::Layout.new(path: layout_file_path)

      # Open layout file in $EDITOR
      return layout.edit! if Teamocil.options[:edit]

      # Output the layout raw content
      return layout.show! if Teamocil.options[:show]

      # Nothing? Let’s execute this layout!
      layout.execute!
    end

  private

    def root
      DIRECTORY.sub('$HOME', environment['HOME'])
    end

    def layout_file_path
      if layout = Teamocil.options[:layout]
        layout
      elsif arguments.length == 0 and File.exists? ".teamocil.yml"
        ".teamocil.yml"
      else
        File.join(root, "#{arguments.first}.yml")
      end
    end
  end
end
