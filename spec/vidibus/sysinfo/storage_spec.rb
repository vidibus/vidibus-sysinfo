require "spec_helper"

describe "Vidibus::Sysinfo::Storage" do
  let(:this) {Vidibus::Sysinfo::Storage}

  let(:output) do
'/dev/md2               2822276   1547374   1132668  58% /
tmpfs                    16073         0     16073   0% /lib/init/rw
udev                     16068         1     16067   1% /dev
tmpfs                    16073         0     16073   0% /dev/shm
/dev/md1                   496        31       440   7% /boot'
  end

  let(:output_home) do
    '/dev/md3        11119045 642677   9915978   7% /home'
  end

  let(:values) do
    {
      total: 2756.13,
      used: 1511.11,
      free: 1106.12
    }
  end

  let(:values_home) do
    {
      total: 10858.44,
      used: 627.61,
      free: 9683.57
    }
  end

  describe ".command" do
    context 'of the default mount point' do
      it "should return \"df -m | grep '/'\"" do
        this.command('/').should eql("df -m | grep '/'")
      end
    end

    context 'of a custom mount point' do
      it "should return \"df -m | grep '/home'\"" do
        this.command('/home').should eql("df -m | grep '/home'")
      end
    end

    context 'of a illegal mount point' do
      it 'should sanitize input' do
        this.command('/some; rm -rf /').should eql("df -m | grep '/somermrf/'")
      end
    end

    context 'with nil argument' do
      it "should return \"df -m | grep '/'\"" do
        this.command(nil).should eql("df -m | grep '/'")
      end
    end

    context 'with empty argument' do
      it "should return \"df -m | grep '/'\"" do
        this.command('').should eql("df -m | grep '/'")
      end
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

    context 'with filtered output' do
      it 'should initialize result with correct values' do
        mock(Vidibus::Sysinfo::Storage::Result).new(values_home) { true }
        this.parse(output_home)
      end
    end
  end

  describe ".call" do
    it 'should call #perform with mount point input' do
      mock(this).perform(this.command('/home')) {[output, '']}
      stub(this).parse(output) { true }
      this.call('/home')
    end

    it 'should call #parse' do
      stub(this).perform(this.command('/')) {[output, '']}
      mock(this).parse(output) { true }
      this.call('/')
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
