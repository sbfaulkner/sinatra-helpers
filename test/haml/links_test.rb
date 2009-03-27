require File.dirname(__FILE__) + '/../test_helper'

class LinksTest < Test::Unit::TestCase
  include Haml::Helpers
  include Sinatra::Helpers::Haml::Links

  attr_reader :request

  def setup
    @request = mock()
    @request.stubs(:host => 'www.example.com')
    init_haml_helpers
    super
  end

  def test_domain
    assert_equal 'example.com', domain
  end

  def test_subdomain
    assert_equal 'test.example.com', subdomain('test')
  end

  def test_subdomain_url
    assert_equal 'http://another.example.com', subdomain_url('another')
  end

  def test_asset_url
    assert_equal 'http://assets.example.com/images/logo.gif', asset_url('/images/logo.gif')
  end

  def test_css
    assert_equal({ :href => 'http://assets.example.com/stylesheets/test.css', :media => 'all', :rel => 'stylesheet', :type => 'text/css' }, css('/stylesheets/test.css'))
  end

  def test_icon
    assert_equal({ :href => 'http://assets.example.com/icons/save.gif', :rel => 'icon', :type => 'image/x-icon' }, icon('/icons/save.gif'))
  end

  def test_javascript
    assert_equal({ :src => 'http://assets.example.com/javascripts/jquery.js', :type => 'text/javascript' }, javascript('/javascripts/jquery.js'))
  end

  def test_image
    assert_equal({ :alt => 'test', :height => '100', :src => 'http://assets.example.com/images/test.jpg', :width => '200' }, image('/images/test.jpg', :size => '200x100'))
  end

  def test_action
    assert_equal({ :action => '/invoices/123', :method => 'post' }, action('/invoices/123'))
  end

  def test_action_should_override_method
    assert_equal({ :action => '/invoices/123', :method => 'delete' }, action('/invoices/123', :method => 'delete'))
  end

  def test_href
    assert_equal({ :href => '/link' }, href('/link'))
  end

  def test_href_should_support_method_using_hidden_form
    assert_equal({ :href => '#', :onclick => "$('<form></form>').css('display','none').attr({'method':'post','action':'/link'}).append($('<input type=\"hidden\">').attr({'name':'_method','value':'put'})).appendTo($(this).parent()).submit();return false;" }, href('/link', :method => 'put'))
  end

  def test_href_should_support_confirm
    assert_equal({ :href=>"/link", :onclick => "if (confirm('Really?')) { return true; }; return false;" }, href('/link', :confirm => 'Really?'))
  end

  def test_href_should_support_ajax
    assert_equal({ :href=> "#", :onclick=> "$.ajax({url:'/link',success:function(html){$('#result').replaceWith(html);}});return false;" }, href('/link', :success => { :update => '#result' }))
  end
end
