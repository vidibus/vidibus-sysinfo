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
  let(:values) do
    {
      total: 2756.13,
      used: 1511.11,
      free: 1106.12
    }
  end

  describe ".command" do
    it "should return 'df -m'" do
      this.command.should eql('df -m')
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output).should be_a(Vidibus::Sysinfo::Storage::Result)
    end

    it 'should initialize result with correct values' do
      mock(Vidibus::Sysinfo::Storage::Result).new(values) { true }
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
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Storage::Result.new(values)
    end

    it 'should respond to #total' do
      result.total.should eq(2756.13)
    end

    it 'should respond to #used' do
      result.used.should eq(1511.11)
    end

    it 'should respond to #free' do
      result.free.should eq(1106.12)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(1511)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(1511.11)
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
