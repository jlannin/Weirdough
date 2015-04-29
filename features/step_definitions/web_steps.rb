# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file was generated by Cucumber-Rails and is only here to get you a head start
# These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# visit pages, interact with widgets and make assertions about page content.
#
# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong
#


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

Given /^these foods:$/i do |table|
  table.hashes.each do |fhash|
    r = Food.create!(fhash)
  end
end

Given /^these units:$/i do |table|
  table.hashes.each do |fhash|
    r = Unit.create!(fhash)
  end
end

Given /^a user with these groceries:$/i do |table|
  step %{I go to the recipes page}
  step %{I press "Login"}
  step %{I sign in}
  u = User.find(1)
  table.hashes.each do |fhash|
    x = fhash.delete("groceries")
    x =~  /\s?(.*)\s(\d*)\s(.*)/
    hash = Hash.new
    hash[:food_id] = Food.find_by('name = ?', $1).id
    hash[:quantity] = $2
    hash[:unit_id] = Unit.find_by('unit =?', $3).id
    u.groceries.new(hash) 
    u.save
  end
  step %{I press "Sign Out"}
end


Given /^these recipes:$/i do |table|
  table.hashes.each do |fhash|
    arr = fhash.delete("Ingredients")
    fhash[:average_rating] = 0
    r = Recipe.new(fhash)
    arr = arr.split(",")
    arr.each do |x|
      x =~  /\s?(.*)\s(\d*)\s(.*)/
      hash = Hash.new
      hash[:food_id] = Food.find_by('name = ?', $1).id
      hash[:quantity] = $2
      hash[:unit_id] = Unit.find_by('unit =?', $3).id
      r.ingredients.new(hash)
    end
    r.save
  end
end

When /^I view my fridge/ do
    step %{I go to the recipes page}
    step %{I press "Login"}
    step %{I fill in "Email" with "jd.roth@comcast.net"}
    step %{I fill in "Password" with "tester123"}
    step %{I press "Log in"}
    step %{I press "My fridge"}
end

Then /^I select "(.*?)" for grocery "(.*?)" food$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "food_select_#{arg2}")
end

Then /^I select "(.*?)" for grocery "(.*?)" unit$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "unit_select_#{arg2}")
end

Then /^I select "(.*?)" for new grocery "(.*?)" food$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "newfood_select_#{arg2}")
end

Then /^I select "(.*?)" for new grocery "(.*?)" unit$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "newunit_select_#{arg2}")
end

Then /^I select "(.*?)" for ingredient "(.*?)" food$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "food_select_#{arg2}")
end

Then /^I select "(.*?)" for ingredient "(.*?)" unit$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "unit_select_#{arg2}")
end

Then /^I select "(.*?)" for new ingredient "(.*?)" food$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "newfood_select_#{arg2}")
end

Then /^I select "(.*?)" for new ingredient "(.*?)" unit$/ do |arg1, arg2|
  page.select("#{arg1}", :from => "newunit_select_#{arg2}")
end

Then /^I select "(.*?)" for rating$/ do |arg1|
  page.select("#{arg1}", :from => "review_stars")
end

Then /^I should see that "(.*?)" has a quantity of "(.*?)"$/ do |ingredient, quantity|
  #byebug
  name_arr = all(".name").map {|x| x.text}
  index = name_arr.index(ingredient)
  all(".quantity")[index].text.should == quantity
end

Then /^I review "(.+)" with "(.+)"$/ do |name, rating|
    
    step %{I press "Write a Review"}
    step %{I should be reviewing "#{name}" on create new review page}
    step %{I fill in "review_comments" with "Theyrrrree Greeeaat!"}
    step %{I select "#{rating}" for rating}
    step %{I press "Post Review"}
end


Then /^I should see that the recipe "(.*?)" has a rating of "(.*?)"$/ do |name, rating|
  recipes_arr = all(".recipe_name").map {|x| x.text}
  index = recipes_arr.index(name)
  my_stars=""
  1.upto(rating.to_i) do
  my_stars<<"★"
  end
  all(".rating")[index].text.should == my_stars
end


Then /^I should see that the review with "(.*?)" has a rating of "(.*?)"$/ do |comment, rating|
  review_arr = all(".comment").map {|x| x.text}
  index = review_arr.index(comment)
  my_stars=""
  1.upto(rating.to_i) do
  my_stars<<"★"
  end
  all(".starry_show")[index].text.should == my_stars
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end
 
When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_on(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  
  fill_in(field, :with => value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /^(?:|I )fill in the following:$/ do |fields|
  #byebug
  fields.rows_hash.each do |name, value|
    When %{I fill in "#{name}" with "#{value}"}
  end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, :from => field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
  attach_file(field, File.expand_path(path))
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /^I should see the image "(.*?)"$/ do |arg1|
  find("img")['src'].should =~ /\/#{arg1}/
end

Then /^I should see recipe name in sorted order$/ do
  name_arr = all(".recipe_name").map {|x| x.text}
  name_arr.should == name_arr.sort
end

Then /^I should see that "(.*?)" has directions of "(.*?)"$/ do |arg1, arg2|
  name_arr = all(".recipe_name").map {|x| x.text}
  index = name_arr.index(arg1)
  all("#directions")[index].text.should == arg2
end

Then /^I should see recipe cooking time in sorted order$/ do
  #byebug
  time_arr = all("#time").map do |x|
    x.text =~ /(\d+)[a-zA-Z\s]*\s(\d+)?/
    if $2 == nil
      $1.to_i
    else
      ($1.to_i * 60) + $2.to_i
    end
  end
  time_arr.should == time_arr.sort
end

Then /^I should see the recipe rating in sorted order$/ do
  
  star_arr = all(".rating").map {|x| x.text}
  star_arr = star_arr.map do |x|
    if(x.length>5)
      x=0
    else
      x=x.length
    end
  end
  avg_arr=[]
  Recipe.all.each do |r|
    if(r.average_rating == nil)
      avg_arr<<0
    else
      avg_arr<<r.average_rating.round
    end
  end
  avg_arr.sort.reverse.should == star_arr
end

Then /^I should see that "(.*?)" has a cooking time of "(.*?)"$/ do |arg1, arg2|
  name_arr = all(".recipe_name").map {|x| x.text}
  index = name_arr.index(arg1)
  all("#time")[index].text.should == arg2
end

Then /^I should see that "(.*?)" has an image of "(.*?)"$/ do |arg1, arg2|
  name_arr = all(".recipe_name").map {|x| x.text}
  index = name_arr.index(arg1)
  all("img")[index]['src'].should =~ /\/#{arg2}/
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)
  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end


Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  #byebug
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end


Then /^(?:|I )should not see the ingredient "([^"]*)"$/ do |arg1|
  name_arr = all(".name").map {|x| x.text}
  index = name_arr.index(arg1)
  index.should == nil
end
 

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" field should have the error "([^"]*)"$/ do |field, error_message|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')

  form_for_input = element.find(:xpath, 'ancestor::form[1]')
  using_formtastic = form_for_input[:class].include?('formtastic')
  error_class = using_formtastic ? 'error' : 'field_with_errors'

  if classes.respond_to? :should
    classes.should include(error_class)
  else
    assert classes.include?(error_class)
  end

  if page.respond_to?(:should)
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      error_paragraph.should have_content(error_message)
    else
      page.should have_content("#{field.titlecase} #{error_message}")
    end
  else
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      assert error_paragraph.has_content?(error_message)
    else
      assert page.has_content?("#{field.titlecase} #{error_message}")
    end
  end
end

Then /^the "([^"]*)" field should have no error$/ do |field|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')
  if classes.respond_to? :should
    classes.should_not include('field_with_errors')
    classes.should_not include('error')
  else
    assert !classes.include?('field_with_errors')
    assert !classes.include?('error')
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

When(/^I delete ingredient "(.*?)"$/) do |arg1|
  index = arg1.to_i - 1
  page.all('.del_ing')[index].click
end


Then /^I sign in$/ do
  step %{I press "Sign up"}
  step %{I fill in "Email" with "jd.roth@comcast.net"} 
  step %{I fill in "Password" with "tester123"}
  step %{I fill in "Password confirmation" with "tester123"}
  step %{I press "Sign up"}
end

Then /^(?:|I )should be reviewing "(.*)" on (.+)$/ do |recipe, page_name|
  r=Recipe.find_by('name = ?',recipe)
  r_id=r.id
  #path_to(page_name)=~/new(.*)$/#hardwire

  #current_path = "/review/new"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == "/recipes/#{r_id}#{path_to(page_name)}"
  else
    assert_equal "/recipes/#{r_id}#{path_to(page_name)}", current_path
  end
end


Then /^(?:|I )should be creating on (.+)$/ do |page_name|
  #byebug
  path_to(page_name)=~/new(.*)$/#hardwire
  current_path = "/recipes/new"+$1
  #current_path = URI.parse(current_url).path+$1
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  #byebug
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')} 
  
  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then /^show me the page$/ do
  save_and_open_page
end
