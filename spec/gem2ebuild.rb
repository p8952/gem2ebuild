require_relative '../lib/gem2ebuild.rb'

describe Gem2Ebuild do
  it "should not accept 0 arguments" do
    gem2ebuild = Gem2Ebuild.new()
    gem2ebuild.check_args([]).should eq(1)
  end
  it "should not accept 3 arguments" do
    gem2ebuild = Gem2Ebuild.new()
    gem2ebuild.check_args(["1", "2", "3"]).should eq(1)
  end
  it "should not accept non-existing gem names" do
    gem2ebuild = Gem2Ebuild.new()
    gem2ebuild.check_args(["this_is__not_a_real_gem"]).should eq("The rubygem this_is__not_a_real_gem could not be found.")
  end
end
