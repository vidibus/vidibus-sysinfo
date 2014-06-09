require "spec_helper"

describe "Vidibus::Sysinfo::Cpu" do
  let(:this) {Vidibus::Sysinfo::Cpu}
  let(:output) {"Average:     all    0.05    0.25    0.03    0.17    0.00    0.15    0.01    0.02   99.31"}
  let(:values) do
    {
      user: 0.05,
      nice: 0.25,
      system: 0.03,
      iowait: 0.17,
      irq: 0.0,
      soft: 0.15,
      steal: 0.01,
      guest: 0.02,
      idle: 99.31,
      used: 0.69
    }
  end

  describe ".command" do
    it "should return 'mpstat 1 5 | grep Average:'" do
      this.command.should eql("mpstat 1 5 | grep Average:")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output).should be_a(Vidibus::Sysinfo::Cpu::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::Cpu::Result).new(values) { true }
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
      stub(this).perform(this.command) do
        ['', "sh: mpstat: command not found\n"]
      end
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Cpu::Result.new(values)
    end

    it 'should respond to #user' do
      result.user.should eq(0.05)
    end

    it 'should respond to #nice' do
      result.nice.should eq(0.25)
    end

    it 'should respond to #system' do
      result.system.should eq(0.03)
    end

    it 'should respond to #iowait' do
      result.iowait.should eq(0.17)
    end

    it 'should respond to #irq' do
      result.irq.should eq(0.0)
    end

    it 'should respond to #soft' do
      result.soft.should eq(0.15)
    end

    it 'should respond to #steal' do
      result.steal.should eq(0.01)
    end

    it 'should respond to #guest' do
      result.guest.should eq(0.02)
    end

    it 'should respond to #idle' do
      result.idle.should eq(99.31)
    end

    it 'should respond to #used' do
      result.used.should eq(0.69)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(1)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(0.69)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values)
    end
  end
end
