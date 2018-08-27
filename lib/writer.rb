module HtmlToKramdown
  class Writer
    def by_line(file, line)
      IO.write(file, line)
    end

    def from_array(file, array)
      IO.write(file, array.join)
    end

    def from_string(file, string)
      IO.write(file, string)
    end
  end
end
