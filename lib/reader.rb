module HtmlToKramdown
  class Reader

    def by_line(file)
      IO.readlines(file)
    end

    def all(file)
      IO.read(file)
    end
  end
end
