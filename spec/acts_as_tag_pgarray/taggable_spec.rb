require 'spec_helper'

describe ActsAsTaggableArrayOn::Taggable do
  before do 
    @user1 = User.create colors: ['red', 'blue']
    @user2 = User.create colors: ['black', 'white', 'red']
    @user3 = User.create colors: ['black', 'blue']

    User.acts_as_taggable_array_on :colors
  end

  describe "#acts_as_taggable_array_on" do
    it "defines named scope to match any tags" do
      expect(User).to respond_to(:with_any_colors)
    end
    it "defines named scope to match all tags" do
      expect(User).to respond_to(:with_all_colors)
    end
    it "defines named scope not to match any tags" do
      expect(User).to respond_to(:without_any_colors)
    end
    it "defines named scope not to match all tags" do
      expect(User).to respond_to(:without_all_colors)
    end
  end

  describe "#with_any_tags" do
    it "returns users having any tags of args" do
      expect(User.with_any_colors('red', 'blue')).to match_array([@user1,@user2,@user3])
    end
  end

  describe "#with_all_tags" do
    it "returns users having all tags of args" do
      expect(User.with_all_colors('red', 'blue')).to match_array([@user1])
    end
  end
  
  describe "#without_any_tags" do
    it "returns users having any tags of args" do
      expect(User.without_any_colors('red', 'blue')).to match_array([])
    end
  end

  describe "#without_all_tags" do
    it "returns users having all tags of args" do
      expect(User.without_all_colors('red', 'blue')).to match_array([@user2,@user3])
    end
  end

  describe "#all_colors" do
    it "returns all of tag_name" do
      expect(User.all_colors).to match_array([@user1,@user2,@user3].map(&:colors).flatten.uniq)
    end
  end

  describe "#colors_cloud" do
    it "returns tag cloud for tag_name" do
      expect(User.colors_cloud).to match_array(
        [@user1,@user2,@user3].map(&:colors).flatten.group_by(&:to_s).map{|k,v| [k,v.count]}
      )
    end
  end

  describe "with complex scope" do
    it "works properly" do
      expect(User.without_any_colors('white').with_any_colors('blue').order(:created_at).limit(10)).to eq [@user1, @user3]
    end
  end
end
