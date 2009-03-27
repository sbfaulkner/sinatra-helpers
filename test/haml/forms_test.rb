require File.dirname(__FILE__) + '/../test_helper'

class FormsTest < Test::Unit::TestCase
  include Haml::Helpers
  include Sinatra::Helpers::Haml::Forms

  def setup
    @invoice = mock
    @invoice.stubs(:id => Time.now.to_i, :class => stub(:name => 'Invoice'))
    init_haml_helpers
    super
  end

  def test_object_for_should_return_object
    assert_equal @invoice, object_for(:invoice, :id)
  end

  def test_object_for_should_support_explicit_object
    assert_equal @invoice, object_for(@invoice, :id)
  end

  def test_value_for_should_return_value
    @invoice.stubs(:client_name => 'Client name')
    assert_equal @invoice.client_name, value_for(:invoice, :client_name)
  end

  def test_value_for_should_support_explicit_object
    @invoice.stubs(:client_name => 'Client name')
    assert_equal @invoice.client_name, value_for(@invoice, :client_name)
  end

  def test_id_for_should_build_simple_id
    assert_equal "invoice_id", id_for(:invoice, :id)
  end

  def test_name_for_should_build_simple_name
    assert_equal "invoice[id]", name_for(:invoice, :id)
  end

  def test_id_for_should_support_explicit_object
    assert_equal "invoice_id", id_for(@invoice, :id)
  end

  def test_name_for_should_support_explicit_object
    assert_equal "invoice[id]", name_for(@invoice, :id)
  end

  def test_id_for_should_index_collection
    assert_equal "line_1_id", id_for(:line, :id, :index => 1)
  end

  def test_name_for_should_index_collection
    assert_equal "lines[1][id]", name_for(:line, :id, :index => 1)
  end

  def test_id_for_should_index_collection_by_id
    line = line_stub
    assert_equal "invoice_line_#{line.id}_id", id_for(:invoice, line, :id, :index => line.id)
  end

  def test_name_for_should_index_collection_by_id
    line = line_stub
    assert_equal "invoice[lines][#{line.id}][id]", name_for(:invoice, line, :id, :index => line.id)
  end

  def test_id_for_should_index_collection_by_new_id
    line = line_stub
    assert_equal "invoice_line_#{line.id}_id", id_for(:invoice, line, :id, :index => line.id)
  end

  def test_name_for_should_index_collection_by_new_id
    line = line_stub
    assert_equal "invoice[lines][#{line.id}][id]", name_for(:invoice, line, :id, :index => line.id)
  end

  def test_name_and_id_should_index_collection_by_same_new_id
    line = line_stub
    id = line.id
    assert_equal "invoice_line_#{id}_id", id_for(:invoice, line, :id, :index => line.id)
    assert_equal "invoice[lines][#{id}][id]", name_for(:invoice, line, :id, :index => line.id)
  end

  def test_id_for_should_support_parts
    assert_equal "invoice_invoiced_on_year", id_for(@invoice, :invoiced_on, :year)
  end

  def test_name_for_should_support_parts
    assert_equal "invoice[invoiced_on][year]", name_for(@invoice, :invoiced_on, :year)
  end

  def test_value_for_should_support_parts
    @invoice.stubs(:invoiced_on => Time.now)
    assert_equal @invoice.invoiced_on.year, value_for(@invoice, :invoiced_on, :year)
  end

  def test_id_for_should_support_parent
    assert_equal "invoice_line_1_description", id_for(:invoice, :line, :description, :index => 1)
  end

  def test_name_for_should_support_parent
    assert_equal "invoice[lines][1][description]", name_for(:invoice, :line, :description, :index => 1)
  end

  def test_id_for_should_support_explicit_object_with_parent
    line = line_stub
    assert_equal "invoice_line_1_description", id_for(@invoice, line, :description, :index => 1)
  end

  def test_name_for_should_support_explicit_object_with_parent
    line = line_stub
    assert_equal "invoice[lines][1][description]", name_for(@invoice, line, :description, :index => 1)
  end

  def test_errors_for_returns_nil_when_no_errors
    @invoice.stubs(:errors => stub(:empty? => true))
    errors_for(@invoice)
    assert_html '', nil
  end

  def test_errors_for_returns_error_messages
    @invoice.stubs(:class => stub(:name => 'Class name'), :errors => stub(:empty? => false, :full_messages => ['Field name']))
    errors_for(@invoice)
    assert_html 'p', :html => /Class name/, :count => 1
    assert_html 'li', :html => /Field name/, :min => 1
  end

  def test_label
    result = label(@invoice, :client_name)
    assert_equal id_for(@invoice, :client_name), result[:for]
  end

  def test_checkbox
    line = line_stub(:taxable => true)
    @invoice.stubs(:lines).returns([line])
    result = checkbox(@invoice, line, :taxable, :index => 1)
    assert_equal :checkbox, result[:type]
    assert_equal name_for(@invoice, line, :taxable, :index => 1), result[:name]
    assert_equal id_for(@invoice, line, :taxable, :index => 1), result[:id]
    assert_equal 1, result[:value]
    assert result[:checked]
  end

  def test_checkbox_not_checked
    line = line_stub(:taxable => false)
    @invoice.stubs(:lines => [line])
    result = checkbox(@invoice, line, :taxable, :index => 1)
    assert_equal :checkbox, result[:type]
    assert_equal name_for(@invoice, line, :taxable, :index => 1), result[:name]
    assert_equal id_for(@invoice, line, :taxable, :index => 1), result[:id]
    assert_equal 1, result[:value]
    assert !result[:checked]
  end

  def test_hidden_field
    @invoice.stubs(:client_name => 'Client name')
    result = hidden_field(@invoice, :client_name)
    assert_equal :hidden, result[:type]
    assert_equal name_for(@invoice, :client_name), result[:name]
    assert_equal id_for(@invoice, :client_name), result[:id]
    assert_equal @invoice.client_name, result[:value]
  end

  def test_text_field
    @invoice.stubs(:client_name => 'Client name')
    result = text_field(@invoice, :client_name)
    assert_equal :text, result[:type]
    assert_equal name_for(@invoice, :client_name), result[:name]
    assert_equal id_for(@invoice, :client_name), result[:id]
    assert_equal @invoice.client_name, result[:value]
  end

  def test_text_area
    result = text_area(@invoice, :client_name)
    assert_equal name_for(@invoice, :client_name), result[:name]
    assert_equal id_for(@invoice, :client_name), result[:id]
  end

  def test_select
    result = select(@invoice, :client_name)
    assert_equal name_for(@invoice, :client_name), result[:name]
    assert_equal id_for(@invoice, :client_name), result[:id]
  end

  def test_options_of
    dwarfs = %w(Bashful Doc Dopey Grumpy Happy Sleepy Sneezy)
    options_of dwarfs
    assert_html 'option', :count => 7 do |options|
      assert_equal dwarfs, options.collect { |o| o.inner_html }
    end
  end

  def test_options_of_with_selection
    dwarfs = %w(Bashful Doc Dopey Grumpy Happy Sleepy Sneezy)
    options_of dwarfs do |dwarf|
      dwarf == 'Sleepy'
    end
    assert_html 'option', :count => 7 do |options|
      assert_equal dwarfs, options.collect { |o| o.inner_html }
    end
    assert_html 'option[@selected="selected"]', :count => 1, :html => 'Sleepy'
  end

  def test_options_of_with_values
    months = Date::MONTHNAMES.enum_for(:each_with_index).collect[1..12]
    options_of months
    assert_html 'option', :count => 12 do |options|
      options.each_with_index do |option,i|
        assert_html option, "option[@value='#{months[i].last}']", months[i].first
      end
    end
  end

protected
  def line_stub(methods = {})
    line = stub({:class => stub(:name => 'Line'), :id => Time.now.to_i}.merge(methods))
    @invoice.stubs(:lines).returns([line])
    line
  end
end
