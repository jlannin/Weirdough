require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  before :each do
    Food.create!(:name => "Test")

    x = Recipe.new(:name => "Dark Chocolate Peanut Butter Cup", :directions => "Unwrap and enjoy!", :cooking_time => 10)
    x.ingredients.new(:quantity => 1, :food_id => 1) 

    x.save
    visit "/recipes"
    click_link("Dark Chocolate Peanut Butter Cup")
    click_link("Write a Review")
  end

describe "POST #create" do

    it "should show redirect to show on the create good for review" do
      rec = Recipe.find(parms[:recipe_id])
      r = Review.new
      Review.should_receive(:new).and_return(r)
      rec.should_receive(:save).and_return(true)
      post :create, { :review => { "stars"=>"3", "comments"=>"Good","recipe_id"=>"#{rec.id}"} }
      response.should redirect_to(recipes_path(rec))
    end

    it "should show redirect to create review page on the create fail for reviews" do
      rec = Recipe.find(parms[:recipe_id])
      r = Review.new
      Review.should_receive(:new).and_return(r)
      rec.should_receive(:save).and_return(false)
      post :create, { :review => { "stars"=>"3", "comments"=>"Good","recipe_id"=>"#{rec.id}"} }
      response.should redirect_to(new_recipe_review_path)
  end

end
end