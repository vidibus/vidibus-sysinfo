require "spec_helper"

describe "Vidibus::Sysinfo::Swap" do
  let(:this) {Vidibus::Sysinfo::Swap}
  let(:output) do
    "Swap:         2053          0       2052"
  end

  describe ".command" do
    it "should return 'free -m | grep Swap:'" do
      this.command.should eql("free -m | grep Swap:")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(0)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the number of CPU cores" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(0)
    end

    it "should yield an error if /proc/cpuinfo is not available" do
      stub(this).perform(this.command) {["", "sh: free: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
