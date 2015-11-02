require "spec_helper"

describe "Vidibus::Sysinfo" do
  let(:this) {Vidibus::Sysinfo}

  describe '.system' do
    it 'should call Vidibus::Sysinfo::System' do
      mock(this::System).call
      this.system
    end
  end

  describe ".cpu" do
    it "should call Vidibus::Sysinfo::Cpu" do
      mock(this::Cpu).call
      this.cpu
    end
  end

  describe ".load" do
    it "should call Vidibus::Sysinfo::Load" do
      mock(this::Load).call
      this.load
    end
  end

  describe ".traffic" do
    it "should call Vidibus::Sysinfo::Traffic" do
      mock(this::Traffic).call
      this.traffic
    end
  end

  describe ".throughput" do
    it "should call Vidibus::Sysinfo::Throughput" do
      mock(this::Throughput).call(1)
      this.throughput
    end

    it "should accept a seconds argument" do
      mock(this::Throughput).call(2)
      this.throughput(2)
    end
  end

  describe ".storage" do
    it "should call Vidibus::Sysinfo::Storage with default mount point" do
      mock(this::Storage).call('/')
      this.storage
    end
  end

  describe ".memory" do
    it "should call Vidibus::Sysinfo::Memory" do
      mock(this::Memory).call
      this.memory
    end
  end

  describe ".swap" do
    it "should call Vidibus::Sysinfo::Swap" do
      mock(this::Swap).call
      this.swap
    end
  end
end
