require 'sinatra/base'

module Sinatra
  module Helpers
    module Haml
      module Links
        def domain(tld_length = 1)
          request.host.split('.')[-(tld_length+1)..-1].join('.')
        end

        def subdomain(name, tld_length = 1)
          "#{name}.#{domain(tld_length)}"
        end

        def subdomain_url(name, tld_length = 1)
          "http://#{subdomain(name, tld_length)}"
        end

        def asset_url(path, tld_length = 1)
          "#{subdomain_url('assets', tld_length)}#{path}"
        end

        def css(path, options = {})
          { :href => asset_url(path), :media => "all", :rel => "stylesheet", :type => "text/css" }.merge(options)
        end

        def icon(path, options = {})
          { :href => asset_url(path), :rel => 'icon', :type => 'image/x-icon' }.merge(options)
        end

        def javascript(path, options = {})
          { :src => asset_url(path), :type => 'text/javascript' }.merge(options)
        end

        def image(path, options = {})
          options[:width], options[:height] = options.delete(:size).split('x') if options.include?(:size)
          options[:alt] ||= File.basename(path, '.*')
          { :src => asset_url(path) }.merge(options)
        end

        def action(path, options = {})
          { :action => path, :method => 'post' }.merge(options)
        end

        def href(path, options = {})
          script = if options.include?(:success)
            path, original_path = '#', path
            javascript_for_ajax(original_path, options)
          elsif method = options.delete(:method)
            path, original_path = '#', path
            javascript_for_method(original_path, method)
          else
            options.delete(:onclick)
          end
          confirm = options.delete(:confirm)
          script = javascript_with_confirmation(script, confirm) if confirm
          result = { :href => path }
          result[:onclick] = script unless script.nil?
          result.merge(options)
        end

      protected
        def javascript_options(options)
          options.collect do |key,value|
            value = "'#{value}'" if [:type,:url].include? key
            "#{key}:#{value}"
          end.join(',')
        end

        def javascript_with_confirmation(javascript, prompt)
          prompt = 'Are you sure?' if prompt == true
          javascript = 'return true;' if javascript.nil?
          "if (confirm('#{prompt}')) { #{javascript} }; return false;"
        end

        def javascript_for_method(action, method)
          javascript = "$('<form></form>').css('display','none').attr({'method':'post','action':'#{action}'})"
          javascript << ".append($('<input type=\"hidden\">').attr({'name':'_method','value':'#{method}'}))" if method != 'post'
          javascript << ".appendTo($(this).parent()).submit();return false;"
        end

        def javascript_for_ajax(url, options = {})
          ajax_options = {:url => url}
          success = options.delete(:success)
          if !success.is_a?(Hash)
            function = "$('#{success}').replaceWith(html)"
          elsif success.include?(:update)
            function = success[:position] || 'replaceWith'
            function = "$('#{success[:update]}').#{function}(html);"
          elsif success.include?(:remove)
            function = "$('#{success[:remove]}').remove();"
          end
          ajax_options[:type] = options.delete(:method) if options.include?(:method)
          ajax_options[:success] = "function(html){#{function}}"
          "$.ajax({#{javascript_options(ajax_options)}});return false;"
        end
      end
    end
  end

  helpers Helpers::Haml::Links
end
