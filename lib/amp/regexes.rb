    # Regexes. Regices?
    module Regexes
      def self.href_regex(filename)
        /href=["']#{filename}["']/m
      end

      def self.current_parent_regex(maximum_number_of_levels)
        if maximum_number_of_levels > 0
          /href=["'](..\/){0,#{maximum_number_of_levels}}index.html["']/m
        else
          /href=["']index.html["']/m
        end
      end
    end