require "spec_helper"

describe "Vidibus::Sysinfo::Memory" do
  let(:this) {Vidibus::Sysinfo::Memory}
  let(:output_1) do
'             total       used       free     shared    buffers     cached
Mem:         32040       7991      24048          0        276       3895
-/+ buffers/cache:       3819      28220
Swap:        16375          0      16375'
  end
  let(:output_2) do
'              total        used        free      shared  buff/cache   available
Mem:          64260         973       45162         361       18123       62352
Swap:         32735           0       32735'
  end
  let(:values_1) do
    {
      total: 32040,
      used: 3820,
      free: 28220
    }
  end
  let(:values_2) do
    {
      total: 64260,
      used: 973,
      free: 63287
    }
  end

  describe ".command" do
    it "should return 'free -m'" do
      this.command.should eql("free -m")
    end
  end

  describe ".parse" do
    it 'should return nil from invalid output' do
      this.parse('something').should be_nil
    end

    context 'of first output variant' do
      it 'should return a result instance' do
        this.parse(output_1).should be_a(Vidibus::Sysinfo::Memory::Result)
      end

      it 'should initialize result with correct values' do
        mock(Vidibus::Sysinfo::Memory::Result).new(values_1) { true }
        this.parse(output_1)
      end
    end

    context 'of second output variant' do
      it 'should return a result instance' do
        this.parse(output_2).should be_a(Vidibus::Sysinfo::Memory::Result)
      end

      it 'should initialize result with correct values' do
        mock(Vidibus::Sysinfo::Memory::Result).new(values_2) { true }
        this.parse(output_2)
      end
    end
  end

  describe ".call" do
    it 'should call #parse' do
      stub(this).perform(this.command) {[output_1, '']}
      mock(this).parse(output_1) { true }
      this.call
    end

    it 'should yield an error if command is not available' do
      stub(this).perform(this.command) {['', "sh: free: command not found\n"]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Memory::Result.new(values_1)
    end

    it 'should respond to #total' do
      result.total.should eq(32040)
    end

    it 'should respond to #used' do
      result.used.should eq(3820)
    end

    it 'should respond to #free' do
      result.free.should eq(28220)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(3820)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(3820.0)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values_1)
    end

    it 'should support metrics as hash key' do
      values_1.keys.each do |metric|
        result[metric].should eq(values_1[metric])
      end
    end
  end
end
