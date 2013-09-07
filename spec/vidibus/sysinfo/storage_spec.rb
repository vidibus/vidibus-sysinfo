require "spec_helper"

describe "Vidibus::Sysinfo::Storage" do
  let(:this) {Vidibus::Sysinfo::Storage}
  let(:output) do
'Filesystem           1M-blocks      Used Available Use% Mounted on
/dev/md2               2822276   1547374   1132668  58% /
tmpfs                    16073         0     16073   0% /lib/init/rw
udev                     16068         1     16067   1% /dev
tmpfs                    16073         0     16073   0% /dev/shm
/dev/md1                   496        31       440   7% /boot'
  end

  describe ".command" do
    it "should return 'df -m'" do
      this.command.should eql('df -m')
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(1511.11)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the used storage in gigabytes" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(1511.11)
    end
  end
end
