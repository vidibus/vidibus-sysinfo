require "spec_helper"

describe "Vidibus::Sysinfo::Traffic" do
  let(:this) {Vidibus::Sysinfo::Traffic}
  let(:output) do
    "  eth0  /  monthly

       month         rx      |      tx      |   total
    -------------------------+--------------+--------------------------------------
      Feb '11      31.62 GB  |     1.93 TB  |     1.96 TB   ::::::::::::::::::::::
    -------------------------+--------------+--------------------------------------
     estimated        88 GB  |     5.50 TB  |     5.58 TB"
   end

  describe ".command" do
    it "should return 'vnstat -m'" do
      this.command.should eql("vnstat -m")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(2007.04)
    end

    it "should return 0.0 if not enough data is available yet" do
      this.parse(" eth0: Not enough data available yet.\n").should eql(0.0)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the total traffic in gigabytes" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(2007.04)
    end

    it "should yield an error if the command is not available" do
      stub(this).perform(this.command) {["", "/Users/punkrats/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/1.8/open3.rb:73:in `exec': Permission denied - vnstat -m (Errno::EACCES)\n\tfrom /Users/punkrats/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/1.8/open3.rb:73:in `popen3'\n\tfrom..."]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
