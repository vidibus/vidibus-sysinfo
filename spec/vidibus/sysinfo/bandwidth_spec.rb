require "spec_helper"

describe "Vidibus::Sysinfo::Bandwidth" do
  let(:this) {Vidibus::Sysinfo::Bandwidth}
  let(:first_output) do
    "  eth0:11987621067 183430993    0    0    0     0          0         0 639006876738 427999432    0    0    0     0       0          0"
   end
   let(:second_output) do
    "   eth0:11987897466 183435418    0    0    0     0          0         0 639026477572 428012510    0    0    0     0       0          0"
   end

  describe ".command" do
    it "should return 'cat /proc/net/dev | grep eth0:'" do
      this.command.should eql("cat /proc/net/dev | grep eth0:")
    end
  end

  describe ".parse" do
    it "should return a float of megabytes from valid output" do
      this.parse(first_output).should eql(620836.73)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    let(:calls) do
      [
        [first_output, ""],
        [second_output, ""]
      ]
    end

    before do
      stub(this).perform(this.command) {calls.shift}
    end

    it "should return the currently used bandwidth in MBit/s" do
      this.call.should eql(151.68)
    end

    it "should accept a seconds argument as interval" do
      mock(this).sleep(2)
      this.call(2)
    end

    it "should divide the result by given seconds" do
      stub(this).sleep(3)
      this.call(3).should eql(151.68/3)
    end

    it "should yield an error if /proc/net/dev is not available" do
      stub(this).perform(this.command) {["", "cat: /proc/net/dev: No such file or directory\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
