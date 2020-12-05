require 'spec_helper.rb'

describe 'Day01' do
  it "should print part 1 & part 2 answers" do
    expect(STDOUT).to receive(:puts).with(a_string_including("1005459"))
    expect(STDOUT).to receive(:puts).with(a_string_including("92643264"))
    require_relative '../01.rb'
  end
end
