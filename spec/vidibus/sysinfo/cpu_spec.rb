require "spec_helper"

describe "Vidibus::Sysinfo::Cpu" do
  let(:this) {Vidibus::Sysinfo::Cpu}
  let(:output) do
"Linux 3.13.0-29-generic (x2)  08/01/2014  _x86_64_  (12 CPU)

02:10:28 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
02:10:29 AM  all    0.08    0.00    0.17    0.00    0.00    0.00    0.00    0.00    0.00   99.75
02:10:30 AM  all    0.08    0.00    0.08    0.33    0.00    0.00    0.00    0.00    0.00   99.50
02:10:31 AM  all    0.17    0.08    0.42    0.00    0.08    0.00    0.00    0.00    0.00   99.25
02:10:32 AM  all    7.10    0.00    0.25    0.00    0.00    0.00    0.00    0.00    0.00   92.65
02:10:33 AM  all    4.67    0.00    0.33    0.08    0.08    0.00    0.00    0.00    0.00   94.83
Average:     all    0.05    0.25    0.03    0.17    0.00    0.15    0.01    0.02    0.00   99.31"
  end

    let(:alternative_output) do
'Linux 3.11.0-18-generic (de11.cdn.vidibus.net)   08/01/2014  _x86_64_  (8 CPU)

02:08:24 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
02:08:25 AM  all    0.00    0.00    0.12    0.00    0.00    0.00    0.00    0.00   99.88
02:08:26 AM  all    0.13    0.00    0.13    0.00    0.00    0.00    0.00    0.00   99.75
02:08:27 AM  all    0.00    0.00    0.12    0.00    0.00    0.00    0.00    0.00   99.88
02:08:28 AM  all    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00  100.00
02:08:29 AM  all    0.00    0.00    0.12    0.00    0.00    0.00    0.00    0.00   99.88
Average:     all    0.05    0.25    0.03    0.17    0.00    0.15    0.01    0.02   99.31'
    end


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
    it "should return 'mpstat 1 5'" do
      this.command.should eql("mpstat 1 5")
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

    context 'with alternative output' do
      it 'should initialize result with correct values' do
        mock(Vidibus::Sysinfo::Cpu::Result).new(values) { true }
        this.parse(alternative_output)
      end
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

    it 'should support metrics as hash key' do
      values.keys.each do |metric|
        result[metric].should eq(values[metric])
      end
    end
  end
end
