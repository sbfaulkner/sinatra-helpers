require File.dirname(__FILE__) + '/../test_helper'

class MockFlash < Hash
  def initialize(flash = {})
    flash.each { |k,v| self[k] = v }
  end

  alias_method :has?, :include?
end

class FlashTest < Test::Unit::TestCase
  include Haml::Helpers
  include Sinatra::Helpers::Haml::Flash

  attr_reader :flash

  def setup
    init_haml_helpers
    super
  end

  def test_should_not_show_message_for_empty_flash
    @flash = MockFlash.new
    flash_messages
    assert_html ''
  end

  def test_should_show_message_for_error_flash
    @flash = MockFlash.new :error => 'error message'
    flash_messages
    assert_html 'div', 1
    assert_html 'div.error', :html => 'error message', :count => 1
  end

  def test_should_show_message_for_warning_flash
    @flash = MockFlash.new :warning => 'warning message'
    flash_messages
    assert_html 'div', 1
    assert_html 'div.warning', :html => 'warning message', :count => 1
  end

  def test_should_show_message_for_notice_flash
    @flash = MockFlash.new :notice => 'notice message'
    flash_messages
    assert_html 'div', 1
    assert_html 'div.notice', :html => 'notice message', :count => 1
  end

  def test_should_show_messages_for_multiple_flash
    @flash = MockFlash.new :error => 'error message', :warning => 'warning message', :notice => 'notice message'
    flash_messages
    assert_html 'div', 3
    assert_html 'div.error', :html => 'error message', :count => 1
    assert_html 'div.warning', :html => 'warning message', :count => 1
    assert_html 'div.notice', :html => 'notice message', :count => 1
  end
end
