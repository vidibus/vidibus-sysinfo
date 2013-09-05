require "spec_helper"

OUTPUT = 'Architecture:          x86_64
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

describe "Vidibus::Sysinfo::Core" do
  let(:this) {Vidibus::Sysinfo::Core}

  describe ".command" do
    it "should return 'lscpu'" do
      this.command.should eql("lscpu")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(OUTPUT).should eql(4)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the number of CPU cores" do
      stub(this).perform(this.command) {[OUTPUT, ""]}
      this.call.should eql(4)
    end

    it "should yield an error if lscpu is not available" do
      stub(this).perform(this.command) {["       0\n", "cat: command not found: lscpu\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end
end
