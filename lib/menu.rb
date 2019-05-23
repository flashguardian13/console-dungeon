MENU_PAGE_SIZE = 10

def menu_page_keys(page, options)
  options.keys[(MENU_PAGE_SIZE * page)...(MENU_PAGE_SIZE * (page + 1))]
end

def do_menu(name, options)
  page_count = options.keys.length / MENU_PAGE_SIZE + 1
  page_count -= 1 if options.keys.length % MENU_PAGE_SIZE == 0

  page = 0

  10.times do
    header = "=== #{name} ==="

    page_bar_left = page > 0 ? ' << (p)rev' : '          '
    page_bar_right = page < page_count - 1 ? '(n)ext >> ' : '          '
    page_bar = "#{page_bar_left} | page #{page + 1} of #{page_count} | #{page_bar_right}"

    max_length = [header.length, page_bar.length].max
    wing_length = (max_length - header.length) / 2
    header = ('=' * wing_length) + header + ('=' * wing_length)

    puts header
    puts page_bar if page_count > 1
    menu_page_keys(page, options).each do |key|
      puts "#{key}) #{options[key]}"
    end
    print "Choice? "

    choice = $stdin.gets.strip
    puts

    case choice
    when /\Ap(rev(ious)?)?\Z/i
      page -= 1 if page > 0
    when /\An(ext)?\Z/i
      page += 1 if page < page_count - 1
    else
      matching_options = menu_page_keys(page, options).select do |key|
        key.to_s.downcase.include?(choice.downcase)
      end
      if matching_options.length == 1
        return matching_options.first
      elsif matching_options.length > 1
        puts "Did you mean one of these?"
        puts matching_options
        puts
        next
      end

      matching_options = options.keys.select do |key|
        key.to_s.downcase.include?(choice.downcase)
      end
      if matching_options.length == 1
        return matching_options.first
      elsif matching_options.length > 1
        puts "Did you mean one of these?"
        puts matching_options
        puts
      else
        puts "#{choice.inspect} is not a valid option."
        puts
      end
    end
  end

  nil
end
