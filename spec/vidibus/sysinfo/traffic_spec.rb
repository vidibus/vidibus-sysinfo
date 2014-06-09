require "spec_helper"

describe "Vidibus::Sysinfo::Traffic" do
  let(:this) {Vidibus::Sysinfo::Traffic}
  let(:output_gb) do
    "  eth0  /  monthly

       month         rx      |      tx      |   total
    -------------------------+--------------+--------------------------------------
      Feb '11      31.62 GB  |     1.93 TB  |     1.96 TB   ::::::::::::::::::::::
    -------------------------+--------------+--------------------------------------
     estimated        88 GB  |     5.50 TB  |     5.58 TB"
  end
  let(:output_gib) do
    " eth0  /  monthly

       month        rx      |     tx      |    total    |   avg. rate
    ------------------------+-------------+-------------+---------------
      Sep '13      2.17 GiB |   51.73 GiB |   53.91 GiB |    1.07 Mbit/s
    ------------------------+-------------+-------------+---------------
    estimated     13.32 GiB |  317.20 GiB |  330.53 GiB |"
  end
  let(:output_mib) do
    " eth0  /  monthly

       month        rx      |     tx      |    total    |   avg. rate
    ------------------------+-------------+-------------+---------------
      Sep '13       588 MiB |     620 MiB |    1.18 GiB |    0.02 Mbit/s
    ------------------------+-------------+-------------+---------------
    estimated        --     |      --     |      --     |"
  end
  let(:values_gb) do
    {
      input: 31.62,
      output: 1976.32
    }
  end
  let(:values_gib) do
    {
      input: 2.17,
      output: 51.73
    }
  end
  let(:values_mib) do
    {
      input: 0.57,
      output: 0.61
    }
  end

  describe ".command" do
    it "should return 'vnstat -m'" do
      this.command.should eql("vnstat -m")
    end
  end

  describe ".parse" do
    it 'should return a result instance' do
      this.parse(output_gb).should be_a(Vidibus::Sysinfo::Traffic::Result)
    end

    it 'should initialize result from terabytes (which really are tibibytes)' do
      mock(Vidibus::Sysinfo::Traffic::Result).new(values_gb) { true }
      this.parse(output_gb)
    end

    it 'should initialize result from gibibytes' do
      mock(Vidibus::Sysinfo::Traffic::Result).new(values_gib) { true }
      this.parse(output_gib)
    end

    it 'should initialize result from mibibytes' do
      mock(Vidibus::Sysinfo::Traffic::Result).new(values_mib) { true }
      this.parse(output_mib)
    end

    it "should return 0.0 if not enough data is available yet" do
      this.parse(" eth0: Not enough data available yet.\n").should eql(0.0)
    end

    it "should return nil from invalid output" do
      this.parse("something").should be_nil
    end
  end

  describe ".call" do
    it 'should call #parse' do
      stub(this).perform(this.command) {[output_gb, '']}
      mock(this).parse(output_gb) { true }
      this.call
    end

    it "should yield an error if the command is not available" do
      stub(this).perform(this.command) {["", "/Users/punkrats/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/1.8/open3.rb:73:in `exec': Permission denied - vnstat -m (Errno::EACCES)\n\tfrom /Users/punkrats/.rvm/rubies/ruby-1.8.7-p249/lib/ruby/1.8/open3.rb:73:in `popen3'\n\tfrom..."]}
      expect {this.call}.to raise_error(Vidibus::Sysinfo::CallError)
    end
  end

  describe 'Result' do
    let(:result) do
      Vidibus::Sysinfo::Traffic::Result.new(values_gb)
    end

    it 'should respond to #input' do
      result.input.should eq(31.62)
    end

    it 'should respond to #output' do
      result.output.should eq(1976.32)
    end

    it 'should respond to #total' do
      result.total.should eq(2007.94)
    end

    it 'should respond to #to_i' do
      result.to_i.should eq(2008)
    end

    it 'should respond to #to_f' do
      result.to_f.should eq(2007.94)
    end

    it 'should respond to #to_h' do
      result.to_h.should eq(values_gb.merge(total: 2007.94))
    end
  end
end
