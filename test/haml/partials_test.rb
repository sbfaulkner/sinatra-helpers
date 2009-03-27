require File.dirname(__FILE__) + '/../test_helper'

class PartialsTest < Test::Unit::TestCase
  include Haml::Helpers
  include Sinatra::Helpers::Haml::Partials
  include Sinatra::Templates

  @templates = {}

  class << self
    attr_accessor :templates
  end

  attr_accessor :options

  def setup
    @options = mock()
    @options.stubs(:views => File.dirname(__FILE__) + '/views')
    init_haml_helpers
    super
  end

  def test_partial
    assert_html haml_partial('thing'), nil, "<p>Hello world</p>\n"
  end

  def test_partial_with_object
    assert_html haml_partial('object', :object => mock(:name => 'object')), nil, "<p>Hello object</p>\n"
  end

  def test_partial_with_locals
    assert_html haml_partial('object', :locals => { :object => mock(:name => 'local')}), nil, "<p>Hello local</p>\n"
  end

  def test_partial_with_collection
    assert_html haml_partial('object', :collection => [ mock(:name => 'one'), mock(:name => 'two')]), nil, "<p>Hello one</p>\n<p>Hello two</p>\n"
  end
end
