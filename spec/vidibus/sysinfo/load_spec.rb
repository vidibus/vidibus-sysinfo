require "spec_helper"

describe "Vidibus::Sysinfo::Load" do
  let(:this) {Vidibus::Sysinfo::Load}
  let(:output) {" 19:52:41 up 2 days,  9:39,  4 users,  load average: 0.46, 0.53, 0.56"}

  before {stub(Vidibus::Sysinfo::Core).call {2}}

  describe ".command" do
    it "should return 'uptime'" do
      this.command.should eql("uptime")
    end
  end

  describe ".parse" do
    it "should return a decimal from valid output" do
      this.parse(output).should eql(0.23)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the system load as decimal" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(0.23)
    end

    it "should yield a ParseError if output of uptime could not be parsed" do
      stub(this).perform(this.command) {["20:14  up 6 days, 22:03, 20 users, load averages: 0,41 0,26 0,29\n",""]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::ParseError)
    end
  end
end
