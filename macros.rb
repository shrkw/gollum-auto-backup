module Gollum
  class Macro
    class AllPageLinks < Gollum::Macro
      def render
        if @wiki.pages.size > 0
          '<ul id="pages">' + @wiki.pages.map { |p| "<li><a href='#{p.url_path_display}'>#{p.name}</a></li>" }.join + '</ul>'
        end
      end
    end
    class AllPagesLastUpdated < Gollum::Macro
      def render(length='10')
        if @wiki.pages.size > 0
          pages = @wiki.pages.sort_by { |p| p.versions[0].authored_date }.reverse.slice(0, length.to_i)
          result = '<ul>' + pages.map { |p| "<li><a href=\"#{p.url_path}\">#{p.url_path_display}</a> <span class=\"tiny\">#{p.versions[0].authored_date}</span></li>" }.join + '</ul>'
        end
        "<div class=\"toc\"><div class=\"toc-title\">Order by Last Modified Limit (#{length})</div>#{result}</div>"
      end
    end
  end
end
