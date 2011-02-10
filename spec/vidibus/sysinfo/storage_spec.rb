require "spec_helper"

describe "Vidibus::Sysinfo::Storage" do
  let(:this) {Vidibus::Sysinfo::Storage}
  let(:output) do
    "Filesystem            Size  Used Avail Use% Mounted on
     /dev/md2              1.4T  693G  622G  53% /
     tmpfs                 5.9G     0  5.9G   0% /lib/init/rw
     udev                   10M  764K  9.3M   8% /dev
     tmpfs                 5.9G     0  5.9G   0% /dev/shm
     /dev/md1              251M   22M  217M  10% /boot"
  end

  describe ".command" do
    it "should return 'df -h'" do
      this.command.should eql("df -h")
    end
  end

  describe ".parse" do
    it "should return a number from valid output" do
      this.parse(output).should eql(693.0)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it "should return the used storage in gigabytes" do
      stub(this).perform(this.command) {[output, ""]}
      this.call.should eql(693.0)
    end
  end
end
