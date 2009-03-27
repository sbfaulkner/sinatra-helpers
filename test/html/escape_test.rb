require File.dirname(__FILE__) + '/../test_helper'

class EscapeTest < Test::Unit::TestCase
  include Sinatra::Helpers::Html::Escape

  def test_h_should_escape_text
    assert_equal 'this &amp; that', h('this & that')
  end

  def test_h_should_return_blank_for_empty_string
    assert_equal '', h('')
  end

  def test_h_should_return_blank_for_nil
    assert_equal '', h(nil)
  end

  def test_hbang_should_escape_text
    assert_equal 'this &amp; that', h!('this & that')
  end

  def test_hbang_should_return_nbsp_for_empty_string
    assert_equal '&nbsp;', h!('')
  end

  def test_hbang_should_return_nbsp_for_nil
    assert_equal '&nbsp;', h!(nil)
  end

  def test_hbang_should_return_arbitrary_placeholder_for_empty_string
    assert_equal 'N/A', h!('', 'N/A')
  end

  def test_hbang_should_return_arbitrary_placeholder_for_nil
    assert_equal 'N/A', h!(nil, 'N/A')
  end
end
