require 'sinatra/base'
require 'active_support/inflector'

module Sinatra
  module Helpers
    module Haml
      module Forms
        CHECKBOX_DEFAULTS = {:type => :checkbox, :value => 1}
        FILE_FIELD_DEFAULTS = {:type => :file}
        HIDDEN_FIELD_DEFAULTS = {:type => :hidden}
        PASSWORD_FIELD_DEFAULTS = {:type => :password}
        TEXT_FIELD_DEFAULTS = {:type => :text}
        TEXT_AREA_DEFAULTS = {}
        SELECT_DEFAULTS = {}

        def errors_for(object)
          unless object.errors.empty?
            errors = object.errors.full_messages
            haml_tag :div, :id => 'errors' do
              haml_tag :p, %Q(Unable to save #{object.class.name.humanize} due to the following #{errors.size == 1 ? 'error' : "#{errors.size} errors"}:)
              haml_tag :ul do
                haml_concat list_of(errors) { |error| haml_concat(error) }
              end
            end
          end
        end

        def parameterize(arg)
          case arg
          when Array
            arg.compact.collect { |a| parameterize(a) }
          when String
            arg
          when Symbol, Numeric
            arg.to_s
          else
            arg.class.name.underscore
          end
        end

        def object_for(*args)
          args.pop if args.last.is_a?(Hash)
          args.pop
          case object = args.last
          when String, Symbol
            if args.length > 1
              object_for(*args).send(object)
            else
              instance_variable_get "@#{object}"
            end
          else
            object
          end
        end

        def value_for(*args)
          object = object_for(*args)
          options = args.last.is_a?(Hash) ? args.pop : {}
          object.send args.pop
        end

        def id_for(*args)
          options = args.last.is_a?(Hash) ? args.pop : {}
          index = options[:index]
          method = args.pop
          args << index << method
          parameterize(args).join('_')
        end

        def name_for(*args)
          options = args.last.is_a?(Hash) ? args.pop : {}
          index = options[:index]
          method = args.pop
          # pluralize collection name when indexed... explicit parameterization
          args << parameterize(args.pop).pluralize << index if index
          args << method
          parameterize(args).inject { |name,part| "#{name}[#{part}]" }
        end

        def extract_options(*args)
          args.last.is_a?(Hash) ? args.last.reject { |k,v| k.to_s == 'index' } : {}
        end

        def label(*args)
          { :for => id_for(*args) }.merge extract_options(*args)
        end

        def input(*args)
          { :id => id_for(*args), :name => name_for(*args) }.merge extract_options(*args)
        end

        def checkbox(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          options[:checked] = value_for(*args) unless options.include?(:checked)
          CHECKBOX_DEFAULTS.merge input(*args)
        end
    
        def file_field(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          options[:value] = value_for(*args) unless options.include?(:value)
          FILE_FIELD_DEFAULTS.merge input(*args)
        end

        def hidden_field(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          options[:value] = value_for(*args) unless options.include?(:value)
          HIDDEN_FIELD_DEFAULTS.merge input(*args)
        end
    
        def password_field(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          options[:value] = value_for(*args) unless options.include?(:value)
          PASSWORD_FIELD_DEFAULTS.merge input(*args)
        end
    
        def text_field(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          options[:value] = value_for(*args) unless options.include?(:value)
          TEXT_FIELD_DEFAULTS.merge input(*args)
        end
    
        def text_area(*args)
          args << {} unless args.last.is_a?(Hash)
          options = args.last
          TEXT_AREA_DEFAULTS.merge input(*args)
        end
    
        def select(*args)
          SELECT_DEFAULTS.merge input(*args)
        end
    
        def options_of(collection, options = {}, &block)
          collection.each do |option|
            text, value = option
            selected = block_given? ? block.call(option) : nil
            haml_tag :option, text, options.merge(:selected => selected, :value => value)
          end
        end
      end
    end
  end

  helpers Helpers::Haml::Forms
end
