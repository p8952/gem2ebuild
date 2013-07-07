require "gem2ebuild/version"

class Gem2ebuild

  def initialize(arguments)
    @arguments = arguments
  end

  def run
    puts @arguments
  end

end
