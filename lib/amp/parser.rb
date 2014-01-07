require "amp/regexes"

module Amp
  class Parser

    include Regexes

    def initialize options={}
      @text = options[:text]
      @full_filename = options[:filename]
      @filename = File.basename(options[:filename])
      @current_class = options[:current_class]
      @current_parent_class = options[:current_parent_class]
    end

    def parse
      @text = add_class_with_regex Regexes.href_regex(@filename), @current_class
      @text = parse_for_current_parent @current_parent_class
      return @text
    end

  private

    def parse_for_current_parent(class_to_be_added)
      maximum_number_of_levels = @full_filename.split(File::SEPARATOR).length - 2
      
      if maximum_number_of_levels >= 0
        regex = Regexes.current_parent_regex(maximum_number_of_levels)
        @text = add_class_with_regex(regex, class_to_be_added)
      end
      
      return @text
    end
    
    def add_class_with_regex(regex, class_to_be_added)
      text = @text
      matches = text.enum_for(:scan, regex).map { Regexp.last_match.begin(0) }
      matches.length.times do |match_index|
        text = parse_match(text, match_index, matches, class_to_be_added)
      end
      return text
    end

    # Parse a single match. Extracted form the add_class_with_regex() method.
    # This code is a little hairy and is unchanged from the original implementation!
    def parse_match(text, match_index, matches, class_to_be_added)

      chars = text.chars.to_a
      start = matches[matches.length - match_index - 1]

      # Let's find the start of the <a> tag first
      start_of_a = nil
      character = start

      while character > 0 && start_of_a == nil
        character -= 1

        if chars[character..character+2].join == "<a "
          start_of_a = character
        elsif chars[character] == "<"
          start_of_a = false
          return text
        end
      end
      
      return text unless start_of_a
      
      # Now let's find the end of the <a> tag.
      end_of_a = nil
      character = start
      while end_of_a == nil && character < chars.length
        if !end_of_a && chars[character].to_s == ">"
          end_of_a = character
        end
        character += 1
      end
      

      
      # return text unless end_of_a and start_of_a
      return text if !start_of_a

      # If we're inside an <li> tag, let's find the position where it starts...
      start_of_li = nil
      character = start_of_a
      while start_of_li == nil and character > 0
        
        if chars[character-3..character].join.match /<li( |>)/
          start_of_li = character-3
          break
        end
        
        # Wrong Li!
        if chars[character-4..character].join == "</li>"
          break
        end
        
        character -= 1
      end
    
      # And the position where the <li> tag ends!
      end_of_li = nil
      character = end_of_a
      while end_of_li == nil && character.to_i < chars.length
        if start_of_li
          if end_of_a and chars[character..character+4].join == "</li>"
            end_of_li = character + 5
          end
        end
        character += 1
      end
        
      # If we have a <li> tag, let's replace those parts first, and then update the <a> tag inside.
      if start_of_li && end_of_li
        character = start_of_li

        # Starting at <li, let's find the > character that matches it. That's the end of the <li> opening tag.
        while character < chars.length

          # We can assume that there's no > tags inside this tag. <li something>something> is invalid.
          if chars[character].to_s == ">"

            li_tag          = chars[(start_of_li..character)].join
            original_li_tag = chars[(start_of_li..character)].join
            li_tag = add_class_to_tag(li_tag, class_to_be_added, 2)

            text[start_of_li..character] = li_tag

            # Since we've messed with the wrapper tag, we have to update our text pointers by the difference.
            # That's the number of characters that class="current" takes up, otherwise known as (li_tag.length - original_li_tag.length)
            number_of_characters_inserted_before_a_tag = (li_tag.length - original_li_tag.length)

            # So let's offset these tags by that number.
            start_of_a += number_of_characters_inserted_before_a_tag
            end_of_a   += number_of_characters_inserted_before_a_tag

            break
          end

          character += 1
        end
      end

      # Let's take this tag in its entirety
      a_tag = text[start_of_a..end_of_a] # <a href="index.html" class="whatever" etc>

      # And add a class to it...
      a_tag = add_class_to_tag(a_tag, class_to_be_added, 1)

      # Let's insert the tag back into the document.
      text[start_of_a..end_of_a] = a_tag

      return text
    end
   
    def add_class_to_tag(tag, class_to_be_added, number_of_characters_in_tag)

      if tag.include? "class="
        # Not a very clever substitution, but it'll do for now. 
        # TODO: Make sure this works for edge HTML cases.
        tag.gsub!("class='", "class='#{class_to_be_added} ")
        tag.gsub!("class=\"", "class=\"#{class_to_be_added} ")

      elsif tag.include? "class" 

        # They've done something weird, and included a blank attribute.
        # Since this is only a naive parser, we're not obliged to handle this. 
        # But we will, because that's how we roll.
        tag.gsub!("class", "class='#{class_to_be_added}'")
      else

        # This element is a bit like you.
        # No class.
        tag.insert number_of_characters_in_tag + 1, " class='#{class_to_be_added}'"
      end

      return tag
    end

  end
end