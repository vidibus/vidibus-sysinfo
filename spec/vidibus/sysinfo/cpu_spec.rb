require "spec_helper"

describe "Vidibus::Sysinfo::Cpu" do
  let(:this) {Vidibus::Sysinfo::Cpu}
  let(:output) {"Average:     all    0.72    0.00    0.21    0.41    0.05    0.26    0.00   98.35   2950.20"}

  describe ".command" do
    it "should return 'mpstat 5 1 | grep Average:'" do
      this.command.should eql("mpstat 5 1 | grep Average:")
    end
  end

  describe ".parse" do
    it "should return a decimal from valid output" do
      this.parse(output).should eql(1.65)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the CPU load in percent" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(1.65)
    end

    it "should yield an error if mpstat is not installed" do
      stub(this).perform(this.command) {["", "sh: mpstat: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
