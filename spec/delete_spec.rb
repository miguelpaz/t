# encoding: utf-8
require 'helper'

describe T::Delete do

  before :each do
    T::RCFile.instance.path = fixture_path + "/.trc"
    @delete = T::Delete.new
    @old_stderr = $stderr
    $stderr = StringIO.new
    @old_stdout = $stdout
    $stdout = StringIO.new
  end

  after :each do
    T::RCFile.instance.reset
    $stderr = @old_stderr
    $stdout = @old_stdout
  end

  describe "#block" do
    before do
      @delete.options = @delete.options.merge("profile" => fixture_path + "/.trc")
      stub_post("/1.1/blocks/destroy.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @delete.block("sferik")
      a_post("/1.1/blocks/destroy.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should have the correct output" do
      @delete.block("sferik")
      $stdout.string.should =~ /^@testcli unblocked 1 user\.$/
    end
    context "--id" do
      before do
        @delete.options = @delete.options.merge("id" => true)
        stub_post("/1.1/blocks/destroy.json").
          with(:body => {:user_id => "7505382"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @delete.block("7505382")
        a_post("/1.1/blocks/destroy.json").
          with(:body => {:user_id => "7505382"}).
          should have_been_made
      end
    end
  end

  describe "#dm" do
    before do
      @delete.options = @delete.options.merge("profile" => fixture_path + "/.trc")
      stub_get("/1.1/direct_messages/show.json").
        with(:query => {:id => "1773478249"}).
        to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1.1/direct_messages/destroy.json").
        with(:body => {:id => "1773478249"}).
        to_return(:body => fixture("direct_message.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      $stdout.should_receive(:print).with("Are you sure you want to permanently delete the direct message to @pengwynn: \"Creating a fixture for the Twitter gem\"? [y/N] ")
      $stdin.should_receive(:gets).and_return("yes")
      @delete.dm("1773478249")
      a_get("/1.1/direct_messages/show.json").
        with(:query => {:id => "1773478249"}).
        should have_been_made
      a_post("/1.1/direct_messages/destroy.json").
        with(:body => {:id => "1773478249"}).
        should have_been_made
    end
    context "yes" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete the direct message to @pengwynn: \"Creating a fixture for the Twitter gem\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("yes")
        @delete.dm("1773478249")
        $stdout.string.chomp.should == "@testcli deleted the direct message sent to @pengwynn: \"Creating a fixture for the Twitter gem\""
      end
    end
    context "no" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete the direct message to @pengwynn: \"Creating a fixture for the Twitter gem\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("no")
        @delete.dm("1773478249")
        $stdout.string.chomp.should be_empty
      end
    end
    context "--force" do
      before do
        @delete.options = @delete.options.merge("force" => true)
      end
      it "should request the correct resource" do
        @delete.dm("1773478249")
        a_post("/1.1/direct_messages/destroy.json").
          with(:body => {:id => "1773478249"}).
          should have_been_made
      end
      it "should have the correct output" do
        @delete.dm("1773478249")
        $stdout.string.chomp.should == "@testcli deleted the direct message sent to @pengwynn: \"Creating a fixture for the Twitter gem\""
      end
    end
  end

  describe "#favorite" do
    before do
      @delete.options = @delete.options.merge("profile" => fixture_path + "/.trc")
      stub_get("/1.1/statuses/show/28439861609.json").
        with(:query => {:include_my_retweet => "false", :trim_user => "true"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1.1/favorites/destroy.json").
        with(:body => {:id => "28439861609"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      $stdout.should_receive(:print).with("Are you sure you want to remove @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\" from your favorites? [y/N] ")
      $stdin.should_receive(:gets).and_return("yes")
      @delete.favorite("28439861609")
      a_get("/1.1/statuses/show/28439861609.json").
        with(:query => {:include_my_retweet => "false", :trim_user => "true"}).
        should have_been_made
      a_post("/1.1/favorites/destroy.json").
        with(:body => {:id => "28439861609"}).
        should have_been_made
    end
    context "yes" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to remove @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\" from your favorites? [y/N] ")
        $stdin.should_receive(:gets).and_return("yes")
        @delete.favorite("28439861609")
        $stdout.string.should =~ /^@testcli unfavorited @sferik's status: "The problem with your code is that it's doing exactly what you told it to do\."$/
      end
    end
    context "no" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to remove @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\" from your favorites? [y/N] ")
        $stdin.should_receive(:gets).and_return("no")
        @delete.favorite("28439861609")
        $stdout.string.chomp.should be_empty
      end
    end
    context "--force" do
      before do
        @delete.options = @delete.options.merge("force" => true)
      end
      it "should request the correct resource" do
        @delete.favorite("28439861609")
        a_post("/1.1/favorites/destroy.json").
          with(:body => {:id => "28439861609"}).
          should have_been_made
      end
      it "should have the correct output" do
        @delete.favorite("28439861609")
        $stdout.string.should =~ /^@testcli unfavorited @sferik's status: "The problem with your code is that it's doing exactly what you told it to do\."$/
      end
    end
  end

  describe "#list" do
    before do
      @delete.options = @delete.options.merge("profile" => fixture_path + "/.trc")
      stub_get("/1.1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/lists/show.json").
        with(:query => {:owner_screen_name => "sferik", :slug => 'presidents'}).
        to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1.1/lists/destroy.json").
        with(:body => {:owner_id => "7505382", :list_id => "8863586"}).
        to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      $stdout.should_receive(:print).with("Are you sure you want to permanently delete the list \"presidents\"? [y/N] ")
      $stdin.should_receive(:gets).and_return("yes")
      @delete.list("presidents")
      a_get("/1.1/account/verify_credentials.json").
        should have_been_made
      a_post("/1.1/lists/destroy.json").
        with(:body => {:owner_id => "7505382", :list_id => "8863586"}).
        should have_been_made
    end
    context "yes" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete the list \"presidents\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("yes")
        @delete.list("presidents")
        $stdout.string.chomp.should == "@testcli deleted the list \"presidents\"."
      end
    end
    context "no" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete the list \"presidents\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("no")
        @delete.list("presidents")
        $stdout.string.chomp.should be_empty
      end
    end
    context "--force" do
      before do
        @delete.options = @delete.options.merge("force" => true)
      end
      it "should request the correct resource" do
        @delete.list("presidents")
        a_get("/1.1/account/verify_credentials.json").
          should have_been_made
        a_post("/1.1/lists/destroy.json").
          with(:body => {:owner_id => "7505382", :list_id => "8863586"}).
          should have_been_made
      end
      it "should have the correct output" do
        @delete.list("presidents")
        $stdout.string.chomp.should == "@testcli deleted the list \"presidents\"."
      end
    end
    context "--id" do
      before do
        @delete.options = @delete.options.merge("id" => true)
        stub_get("/1.1/lists/show.json").
          with(:query => {:owner_screen_name => "sferik", :list_id => "8863586"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete the list \"presidents\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("yes")
        @delete.list("8863586")
        a_get("/1.1/lists/show.json").
          with(:query => {:owner_screen_name => "sferik", :list_id => "8863586"}).
          should have_been_made
        a_get("/1.1/account/verify_credentials.json").
          should have_been_made
        a_post("/1.1/lists/destroy.json").
          with(:body => {:owner_id => "7505382", :list_id => "8863586"}).
          should have_been_made
      end
    end
  end

  describe "#status" do
    before do
      @delete.options = @delete.options.merge("profile" => fixture_path + "/.trc")
      stub_get("/1.1/statuses/show/26755176471724032.json").
        with(:query => {:include_my_retweet => "false", :trim_user => "true"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1.1/statuses/destroy/26755176471724032.json").
        with(:body => {:trim_user => "true"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      $stdout.should_receive(:print).with("Are you sure you want to permanently delete @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\"? [y/N] ")
      $stdin.should_receive(:gets).and_return("yes")
      @delete.status("26755176471724032")
      a_get("/1.1/statuses/show/26755176471724032.json").
        with(:query => {:include_my_retweet => "false", :trim_user => "true"}).
        should have_been_made
      a_post("/1.1/statuses/destroy/26755176471724032.json").
        with(:body => {:trim_user => "true"}).
        should have_been_made
    end
    context "yes" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("yes")
        @delete.status("26755176471724032")
        $stdout.string.chomp.should == "@testcli deleted the Tweet: \"The problem with your code is that it's doing exactly what you told it to do.\""
      end
    end
    context "no" do
      it "should have the correct output" do
        $stdout.should_receive(:print).with("Are you sure you want to permanently delete @sferik's status: \"The problem with your code is that it's doing exactly what you told it to do.\"? [y/N] ")
        $stdin.should_receive(:gets).and_return("no")
        @delete.status("26755176471724032")
        $stdout.string.chomp.should be_empty
      end
    end
    context "--force" do
      before do
        @delete.options = @delete.options.merge("force" => true)
      end
      it "should request the correct resource" do
        @delete.status("26755176471724032")
        a_post("/1.1/statuses/destroy/26755176471724032.json").
          with(:body => {:trim_user => "true"}).
          should have_been_made
      end
      it "should have the correct output" do
        @delete.status("26755176471724032")
        $stdout.string.chomp.should == "@testcli deleted the Tweet: \"The problem with your code is that it's doing exactly what you told it to do.\""
      end
    end
  end

end
