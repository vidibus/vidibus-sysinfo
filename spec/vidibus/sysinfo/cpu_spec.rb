require "spec_helper"

describe "Vidibus::Sysinfo::Cpu" do
  let(:this) {Vidibus::Sysinfo::Cpu}
  let(:output) {"Average:     all    0.05    0.00    0.02    0.17    0.00    0.15    0.00    0.00   99.60"}

  describe ".command" do
    it "should return 'mpstat 5 1 | grep Average:'" do
      this.command.should eql("mpstat 5 1 | grep Average:")
    end
  end

  describe ".parse" do
    it "should return a decimal from valid output" do
      this.parse(output).should eql(0.40)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the CPU load in percent" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(0.40)
    end

    it "should yield an error if mpstat is not installed" do
      stub(this).perform(this.command) {["", "sh: mpstat: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
