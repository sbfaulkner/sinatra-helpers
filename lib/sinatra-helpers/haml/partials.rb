require 'sinatra/base'
require 'enumerator'

module Sinatra
  module Helpers
    module Haml
      module Partials
        def haml_partial(name, options = {})
          item_name = name.to_sym
          counter_name = "#{name}_counter".to_sym
          if collection = options.delete(:collection)
            collection.enum_for(:each_with_index).collect do |item,index|
              haml_partial name, options.merge(:locals => {item_name => item, counter_name => index+1})
            end.join
          elsif object = options.delete(:object)
            haml_partial name, options.merge(:locals => {item_name => object, counter_name => nil})
          else
            haml "_#{name}".to_sym, options.merge(:layout => false)
          end
        end
      end
    end
  end

  helpers Helpers::Haml::Partials
end
