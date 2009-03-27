require 'sinatra/base'

module Sinatra
  module Helpers
    module Haml
      module Flash
        def flash_messages
          [ :error, :warning, :notice ].each do |f|
            haml_tag :div, flash[f], :class => f if flash.has?(f)
          end
        end
      end
    end
  end

  helpers Helpers::Haml::Flash
end
