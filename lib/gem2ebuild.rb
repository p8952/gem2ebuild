require "gem2ebuild/version"

module Gem2ebuild

  class CLI

    def initialize(arguments)
      @arguments = arguments
    end

    def run
      puts @arguments
    end

  end

end
