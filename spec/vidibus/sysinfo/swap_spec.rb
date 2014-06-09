require "spec_helper"

describe "Vidibus::Sysinfo::Swap" do
  let(:this) {Vidibus::Sysinfo::Swap}
  let(:output) do
    "Swap:         2053          0       2052"
  end
  let(:values) do
    {
      total: 2053,
      used: 0,
      free: 2052
    }
  end

  describe ".command" do
    it "should return 'free -m | grep Swap:'" do
      this.command.should eql("free -m | grep Swap:")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output).should be_a(Vidibus::Sysinfo::Swap::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::Swap::Result).new(values) { true }
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
      Vidibus::Sysinfo::Swap::Result.new(values)
    end

    it 'should respond to #total' do
      result.total.should eq(2053)
    end

    it 'should respond to #used' do
      result.used.should eq(0)
    end

    it 'should respond to #free' do
      result.free.should eq(2052)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(0)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(0.0)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values)
    end
  end
end
