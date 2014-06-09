require "spec_helper"

describe "Vidibus::Sysinfo::Memory" do
  let(:this) {Vidibus::Sysinfo::Memory}
  let(:output) do
    "Mem:         12041      11873        167          0         75      10511"
  end
  let(:values) do
    {
      total: 12041,
      used: 1287,
      free: 10754
    }
  end

  describe ".command" do
    it "should return 'free -m | grep Mem:'" do
      this.command.should eql("free -m | grep Mem:")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output).should be_a(Vidibus::Sysinfo::Memory::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::Memory::Result).new(values) { true }
      this.parse(output)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it 'should call #parse' do
      stub(this).perform(this.command) {[output, '']}
      mock(this).parse(output) { true }
      this.call
    end

    it 'should yield an error if command is not available' do
      stub(this).perform(this.command) {['', "sh: free: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Memory::Result.new(values)
    end

    it 'should respond to #total' do
      result.total.should eq(12041)
    end

    it 'should respond to #used' do
      result.used.should eq(1287)
    end

    it 'should respond to #free' do
      result.free.should eq(10754)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(1287)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(1287.0)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values)
    end

    it 'should support metrics as hash key' do
      values.keys.each do |metric|
        result[metric].should eq(values[metric])
      end
    end
  end
end
