require File.dirname(__FILE__) + '/../spec_helper'
require 'time'

describe Time do
  it "should have a highrise_format instance method" do
    Time.new.methods.include?("highrise_format").should be_true
  end
  
  describe "highrise_format" do
    it "should return date string 'yyyymmddhhmmss'" do
      Time.parse("12/12/2008 05:50:20 UT").highrise_format.should == "20081212055020"
    end

    it "should convert to the UTC timezone" do
      Time.parse("12/12/2008 05:50:20 EST").highrise_format.should == "20081212105020"
    end    
  end
end