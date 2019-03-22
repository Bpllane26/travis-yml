describe Travis::Yaml::Load do
  subject { described_class.apply(parts) }

  describe 'given a single string' do
    let(:parts) { 'foo: bar' }
    it { should eq 'foo' => 'bar' }
  end

  describe 'given an array of strings' do
    let(:parts) { ["foo:\n bar: baz", "foo:\n baz: buz"] }
    it { should eq 'foo' => { 'bar' => 'baz' } }
  end

  describe 'given an array of Parts' do
    let(:one) { Travis::Yaml::Part.new("foo:\n bar: baz\n one: one", 'one.yml', :merge) }
    let(:two) { Travis::Yaml::Part.new("foo:\n baz: buz\n one: two", 'two.yml', mode) }
    let(:parts) { [one, two] }

    describe 'merge' do
      let(:mode) { :merge }
      it { should eq 'foo' => { 'bar' => 'baz', 'one' => 'one' } }
    end

    describe 'deep_merge' do
      let(:mode) { :deep_merge }
      it { should eq 'foo' => { 'bar' => 'baz', 'baz' => 'buz', 'one' => 'one' } }
    end
  end
end
