# encoding: utf-8
require 'helper'

describe T::Utils do

  before :all do
    Timecop.freeze(Time.utc(2011, 11, 24, 16, 20, 0))
    T.utc_offset = 'PST'
    class Test; end
  end

  before :each do
    @test = Test.new
    @test.extend(T::Utils)
  end

  after :all do
    T.utc_offset = nil
    Timecop.return
  end

  describe "#distance_of_time_in_words" do
    it "returns \"a split second\" if difference is less than a second" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 20, 0))).should == "a split second"
    end
    it "returns \"a second\" if difference is a second" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 20, 1))).should == "a second"
    end
    it "returns \"2 seconds\" if difference is 2 seconds" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 20, 2))).should == "2 seconds"
    end
    it "returns \"59 seconds\" if difference is just shy of 1 minute" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 20, 59.9))).should == "59 seconds"
    end
    it "returns \"a minute\" if difference is 1 minute" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 21, 0))).should == "a minute"
    end
    it "returns \"2 minutes\" if difference is 2 minutes" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 16, 22, 0))).should == "2 minutes"
    end
    it "returns \"59 minutes\" if difference is just shy of 1 hour" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 17, 19, 59.9))).should == "59 minutes"
    end
    it "returns \"an hour\" if difference is 1 hour" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 17, 20, 0))).should == "an hour"
    end
    it "returns \"2 hours\" if difference is 2 hours" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 24, 18, 20, 0))).should == "2 hours"
    end
    it "returns \"23 hours\" if difference is just shy of 23.5 hours" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 25, 15, 49, 59.9))).should == "23 hours"
    end
    it "returns \"a day\" if difference is 23.5 hours" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 25, 15, 50, 0))).should == "a day"
    end
    it "returns \"2 days\" if difference is 2 days" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 11, 26, 16, 20, 0))).should == "2 days"
    end
    it "returns \"29 days\" if difference is just shy of 29.5 days" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 12, 24, 4, 19, 59.9))).should == "29 days"
    end
    it "returns \"a month\" if difference is 29.5 days" do
      @test.send(:distance_of_time_in_words, (Time.utc(2011, 12, 24, 4, 20, 0))).should == "a month"
    end
    it "returns \"2 months\" if difference is 2 months" do
      @test.send(:distance_of_time_in_words, (Time.utc(2012, 1, 24, 16, 20, 0))).should == "2 months"
    end
    it "returns \"11 months\" if difference is just shy of 11.5 months" do
      @test.send(:distance_of_time_in_words, (Time.utc(2012, 11, 8, 11, 19, 59.9))).should == "11 months"
    end
    it "returns \"a year\" if difference is 11.5 months" do
      @test.send(:distance_of_time_in_words, (Time.utc(2012, 11, 8, 11, 20, 0))).should == "a year"
    end
    it "returns \"2 years\" if difference is 2 years" do
      @test.send(:distance_of_time_in_words, (Time.utc(2013, 11, 24, 16, 20, 0))).should == "2 years"
    end
  end

  describe "#strip_tags" do
    it "returns string sans tags" do
      @test.send(:strip_tags, '<a href="http://twitter.com/#!/download/iphone" rel="nofollow">Twitter for iPhone</a>').should == "Twitter for iPhone"
    end
  end

  describe "#number_with_delimiter" do
    it "returns number with delimiter" do
      @test.send(:number_with_delimiter, 1234567890).should == "1,234,567,890"
    end
    context "with custom delimiter" do
      it "returns number with custom delimiter" do
        @test.send(:number_with_delimiter, 1234567890, ".").should == "1.234.567.890"
      end
    end
  end

end
