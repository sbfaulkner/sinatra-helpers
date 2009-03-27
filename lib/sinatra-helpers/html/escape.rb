require 'sinatra/base'

module Sinatra
  module Helpers
    module Html
      module Escape
        def h(text)
          Rack::Utils.escape_html(text)
        end

        def h!(text, blank_text = '&nbsp;')
          return blank_text if text.nil? || text.empty?
          h text
        end
      end
    end
  end

  helpers Helpers::Html::Escape
end
