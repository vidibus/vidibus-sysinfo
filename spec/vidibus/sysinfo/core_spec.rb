require "spec_helper"

describe "Vidibus::Sysinfo::Core" do
  let(:this) {Vidibus::Sysinfo::Core}
  let(:output) {"8"}

  describe ".command" do
    it "should return 'cat /proc/cpuinfo | grep processor | wc -l'" do
      this.command.should eql("cat /proc/cpuinfo | grep processor | wc -l")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(8)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the number of CPU cores" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(8)
    end

    it "should yield an error if /proc/cpuinfo is not available" do
      stub(this).perform(this.command) {["       0\n", "cat: /proc/cpuinfo: No such file or directory\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
