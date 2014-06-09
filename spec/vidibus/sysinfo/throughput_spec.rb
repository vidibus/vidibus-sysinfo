require "spec_helper"

describe "Vidibus::Sysinfo::Throughput" do
  let(:this) {Vidibus::Sysinfo::Throughput}
  let(:first_output) do
    "  eth0:11987621067 183430993    0    0    0     0          0         0 639006876738 427999432    0    0    0     0       0          0"
  end
  let(:second_output) do
    "   eth0: 11987897466 183435418    0    0    0     0          0         0 639026477572 428012510    0    0    0     0       0          0"
  end
  let(:values) do
    {
      input: 2.08,
      output: 149.52
    }
  end

  describe ".command" do
    it "should return 'cat /proc/net/dev | grep eth0:'" do
      this.command.should eql("cat /proc/net/dev | grep eth0:")
    end
  end

  describe ".parse" do
    it 'should return a hash of input and output in megabytes' do
      hash = {
        input: 11432.29,
        output: 609404.45
      }
      this.parse(first_output).should eql(hash)
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

    it 'should return a result instance' do
      this.call.should be_a(Vidibus::Sysinfo::Throughput::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::Throughput::Result).new(values)
      this.call
    end

    it "should accept a seconds argument as interval" do
      mock(this).sleep(2)
      this.call(2)
    end

    it "should divide the results by given seconds" do
      stub(this).sleep(3)
      result = this.call(3)
      result.input.should eql(0.69)
      result.output.should eql(49.84)
    end

    it 'should yield an error if command is not available' do
      stub(this).perform(this.command) {["", "cat: /proc/net/dev: No such file or directory\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Throughput::Result.new(values)
    end

    it 'should respond to #input' do
      result.input.should eq(2.08)
    end

    it 'should respond to #output' do
      result.output.should eq(149.52)
    end

    it 'should respond to #total' do
      result.total.should eq(151.6)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(152)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(151.6)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values.merge(total: 151.6))
    end
  end
end
