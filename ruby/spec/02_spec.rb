require 'spec_helper.rb'

describe 'Day02' do
  it "should print part 1 & part 2 answers" do
    expect(STDOUT).to receive(:puts).with(643)
    expect(STDOUT).to receive(:puts).with(388)
    require_relative '../02.rb'
  end
end
