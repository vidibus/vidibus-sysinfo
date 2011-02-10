require "spec_helper"

describe "Vidibus::Sysinfo::Memory" do
  let(:this) {Vidibus::Sysinfo::Memory}
  let(:output) do
    "Mem:         12041      11873        167          0         75      10511"
  end

  describe ".command" do
    it "should return 'free -m | grep Mem:'" do
      this.command.should eql("free -m | grep Mem:")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(1362)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the number of CPU cores" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(1362)
    end

    it "should yield an error if /proc/cpuinfo is not available" do
      stub(this).perform(this.command) {["", "sh: free: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
