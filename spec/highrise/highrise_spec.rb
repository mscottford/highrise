require File.dirname(__FILE__) + '/../spec_helper'

describe Highrise do
  it "should declare a page limit constant of 500" do
    Highrise::PAGE_LIMIT.should == 500
  end
end
