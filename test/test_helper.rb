require 'rubygems'

$:.unshift File.dirname(__FILE__) + '../lib'

require 'haml'

require 'sinatra-helpers'

require 'test/unit'
require 'mocha'
require 'hpricot'

class Test::Unit::TestCase
  def assert_html(*args) # [doc], selector, match)
    match = args.pop
    selector = args.pop
    html = args.pop || haml_buffer.buffer
    html = html.to_html if html.respond_to? :to_html
    selection = Hpricot(html)/selector unless match.nil?
    case match
    when NilClass
      assert_equal selector, html
    when Numeric
      assert_equal match, selection.size, "Expected selection of exactly <#{match}>"
    when String
      assert_equal match, selection.inner_html, "Expected selection to equal <#{match}>"
    when Regexp
      assert_match match, selection.inner_html, "Expected selection to match <#{match}>"
    when Hash
      assert selection.size >= match[:min], "Expected selection of at least <#{match[:min]}>" if match.include?(:min)
      assert selection.size <= match[:max], "Expected selection of at most <#{match[:max]}>" if match.include?(:max)
      assert_html html, selector, match[:count] if match.include?(:count)
      assert_html html, selector, match[:html] if match.include?(:html)
    end
    if block_given? && !selection.empty?
      yield selection
    end
  end
end
