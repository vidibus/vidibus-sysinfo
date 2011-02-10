require "spec_helper"

describe "Vidibus::Sysinfo" do
  let(:this) {Vidibus::Sysinfo}

  describe ".core" do
    it "should call Vidibus::Sysinfo::Core" do
      mock(this::Core).call
      this.core
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

  describe ".bandwidth" do
    it "should call Vidibus::Sysinfo::Bandwidth" do
      mock(this::Bandwidth).call(1)
      this.bandwidth
    end

    it "should accept a seconds argument" do
      mock(this::Bandwidth).call(2)
      this.bandwidth(2)
    end
  end

  describe ".storage" do
    it "should call Vidibus::Sysinfo::Storage" do
      mock(this::Storage).call
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
