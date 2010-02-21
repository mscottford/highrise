require File.dirname(__FILE__) + '/../spec_helper'
require 'time'

describe Highrise::Base do
  
  before(:each) do
    @base = Highrise::Base.new
    @expected_result = Object.new
    @expected_result_array = [Object.new]
    @expected_result_empty_array = []
  end
  
  it "should be instance of ActiveResource::Base" do
    @base.kind_of?(ActiveResource::Base).should be_true
  end
    
  describe "account" do
    it "should delegate to find one from /account.xml" do
      Highrise::Base.should_receive(:find).with(:one, {:from => "/account.xml"}).and_return(@expected_result)
      Highrise::Base.account.should == @expected_result
    end
  end
  
  describe "me" do
    it "should delegate to find one from /me.xml" do      
      Highrise::Base.should_receive(:find).with(:one, {:from => "/me.xml"}).and_return(@expected_result)
      Highrise::Base.me.should == @expected_result
    end
  end
  
  describe "recordings" do
    it "should delegate to find all from /recordings.xml since date and ask for more data" do
      date = Time.now
      
      Highrise::Base.should_receive(:find).with(:all, {
        :from => "/recordings.xml", 
        :params => {
          :since => date.highrise_format
        }
      }).and_return(@expected_result_array)
      
      Highrise::Base.should_receive(:find).with(:all, {
        :from => "/recordings.xml", 
        :params => {
          :since => date.highrise_format,
          :n => @expected_result_array.length
        }
      }).and_return(@expected_result_empty_array)
      
      result = Highrise::Base.recordings(date)
      result.should == @expected_result_array
      result.length.should == @expected_result_array.length
    end
    
    it "should keep asking for more data until it does not receive any data" do
      cloned_expected_result_array = @expected_result_array.dclone
      date = Time.now
      
      Highrise::Base.should_receive(:find).with(:all, {
        :from => "/recordings.xml", 
        :params => {
          :since => date.highrise_format
        }
      }).and_return(@expected_result_array)
      
      Highrise::Base.should_receive(:find).with(:all, {
        :from => "/recordings.xml", 
        :params => {
          :since => date.highrise_format, 
          :n => @expected_result_array.length
          }
        }).and_return(cloned_expected_result_array)      
        
      Highrise::Base.should_receive(:find).with(:all, {
        :from => "/recordings.xml", 
        :params => {
          :since => date.highrise_format, 
          :n => @expected_result_array.length + cloned_expected_result_array.length
        }
      }).and_return(@expected_result_empty_array)      
      
      result = Highrise::Base.recordings(date)
      
      (result & @expected_result_array).should == @expected_result_array
      (result & cloned_expected_result_array).should == cloned_expected_result_array
      result.length.should == @expected_result_array.length + cloned_expected_result_array.length
    end    
  end
  
end
