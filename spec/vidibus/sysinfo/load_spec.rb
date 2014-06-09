require "spec_helper"

describe "Vidibus::Sysinfo::Load" do
  let(:this) {Vidibus::Sysinfo::Load}
  let(:output) {" 19:52:41 up 2 days,  9:39,  4 users,  load average: 0.46, 0.53, 0.56"}
  let(:values) do
    {
      one: 0.46,
      five: 0.53,
      fifteen: 0.56
    }
  end

  before do
    stub(Vidibus::Sysinfo::System).call do
      {cpus: 2}
    end
  end

  describe ".command" do
    it "should return 'uptime'" do
      this.command.should eql("uptime")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output).should be_a(Vidibus::Sysinfo::Load::Result)
    end

    it 'should initialize result with correct values' do
      normalised = {
        one: 0.23,
        five: 0.27,
        fifteen: 0.28
      }
      mock(Vidibus::Sysinfo::Load::Result).new(normalised) { true }
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

    it "should yield a ParseError if output of uptime could not be parsed" do
      stub(this).perform(this.command) {["20:14  up 6 days, 22:03, 20 users, load averages: 0,41 0,26 0,29\n",""]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::ParseError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Load::Result.new(values)
    end

    it 'should respond to #one' do
      result.one.should eq(0.46)
    end

    it 'should respond to #five' do
      result.five.should eq(0.53)
    end

    it 'should respond to #fifteen' do
      result.fifteen.should eq(0.56)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(0.46)
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
