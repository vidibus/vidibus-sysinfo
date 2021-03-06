require "spec_helper"

SYSTEM_OUTPUT = 'Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 60
Stepping:              3
CPU MHz:               800.000
BogoMIPS:              6800.24
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
NUMA node0 CPU(s):     0-7'

describe "Vidibus::Sysinfo::System" do
  let(:this) {Vidibus::Sysinfo::System}
  let(:values) do
    {
      cpus: 8,
      cores: 4,
      sockets: 1
    }
  end

  describe ".command" do
    it "should return 'lscpu'" do
      this.command.should eql("lscpu")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(SYSTEM_OUTPUT).should be_a(Vidibus::Sysinfo::System::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::System::Result).new(values) { true }
      this.parse(SYSTEM_OUTPUT)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it 'should call #parse' do
      stub(this).perform(this.command) {[SYSTEM_OUTPUT, '']}
      mock(this).parse(SYSTEM_OUTPUT) { true }
      this.call
    end

    it 'should yield an error if command is not available' do
      stub(this).perform(this.command) {["       0\n", "cat: command not found: lscpu\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::System::Result.new(values)
    end

    it 'should respond to #cpus' do
      result.cpus.should eq(8)
    end

    it 'should respond to #cores' do
      result.cores.should eq(4)
    end

    it 'should respond to #sockets' do
      result.sockets.should eq(1)
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
