require 'spec_helper.rb'

describe 'Day05' do
  it "should print part 1 & part 2 answers" do
    expect(STDOUT).to receive(:puts).with(989)
    expect(STDOUT).to receive(:puts).with(548)
    require_relative '../05.rb'
  end
end
