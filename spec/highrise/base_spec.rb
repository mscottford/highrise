require File.dirname(__FILE__) + '/../spec_helper'
require 'time'

describe Highrise::Base do
  
  before(:each) do
    @base = Highrise::Base.new
    @expected_result = Object.new
    @expected_result_array = [Object.new]
    @expected_result_array_max_items = Array.new(Highrise::PAGE_LIMIT) { Object.new }
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
    it "should delegate to find all from /recordings.xml since date" do
      date = Time.now
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format}}).and_return(@expected_result_array)
      Highrise::Base.recordings(date).should == @expected_result_array
    end
    
    it "should ask for more data if the returned set contains the same number of items as the page limit" do
      date = Time.now
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format}}).and_return(@expected_result_array_max_items)
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format, :n => Highrise::PAGE_LIMIT}}).and_return(@expected_result_array)      
      result = Highrise::Base.recordings(date)
      (result & @expected_result_array_max_items).should == @expected_result_array_max_items
      (result & @expected_result_array).should == @expected_result_array
      result.length.should == @expected_result_array_max_items.length + @expected_result_array.length
    end
    
    it "should ask for more data again if the second returned set contains the same number of items as the page limit" do
      cloned_max_results_array = @expected_result_array_max_items.dclone
      date = Time.now
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format}}).and_return(@expected_result_array_max_items)
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format, :n => Highrise::PAGE_LIMIT}}).and_return(cloned_max_results_array)      
      Highrise::Base.should_receive(:find).with(:all, {:from => "/recordings.xml", :params => {:since => date.highrise_format, :n => Highrise::PAGE_LIMIT * 2}}).and_return(@expected_result_array)      
      result = Highrise::Base.recordings(date)
      (result & @expected_result_array_max_items).should == @expected_result_array_max_items
      (result & cloned_max_results_array).should == cloned_max_results_array
      (result & @expected_result_array).should == @expected_result_array
      result.length.should == @expected_result_array_max_items.length + cloned_max_results_array.length + @expected_result_array.length
    end
  end
  
end
