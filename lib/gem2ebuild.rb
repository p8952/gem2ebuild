require 'gem2ebuild/version'
require 'gems'
require 'json'

class Gem2Ebuild

  def initialize()
  
  end

  def run(arguments)
    a = check_args(arguments)
    case a
      when 0
        write_ebuild(get_ebuild_hash(@arg_name, @arg_version))
      when 1
        show_help
      else
        puts a
    end
  end

  def check_args(arguments)
    # Only accept either 1 or 2 arguments
    if arguments.length < 1 or arguments.length > 2
      return 1
    end

    # Show help if requested
    if ['-h', '--h', '-help', '--help'].include?(arguments[0])
      return 1
    end

    # Check arguments[0] is a valid gem name
    if Gems.info(arguments[0]) != 'This rubygem could not be found.'
      @arg_name = arguments[0]
    else
      return "The rubygem #{arguments[0]} could not be found."
    end

    # If no version is passed use the latest available
    if arguments[1].nil?
      Gems.info(arguments[0]).each do |key, value|
        @arg_version = value if key == 'version'
      end
    else
      @arg_version = arguments[1]
    end
    return 0
  end

  def show_help()
    puts 'Help'
    exit 0
  end

  # Query https://rubygems.org/ for metadata and format it as a hash
  def get_ebuild_hash(name, version)
    ebuild_hash = {
      :NAME => nil,
      :VERSION => nil,
      :DESCRIPTION => nil,
      :HOMEPAGE => nil,
      :LICENSE => nil,
      :DEPEND => nil,
    }
    ebuild_hash[:NAME] = @arg_name
    ebuild_hash[:VERSION] = @arg_version
    Gems.info(@arg_name).each do |key, value|
      ebuild_hash[:DESCRIPTION] = value if key == 'info'
      ebuild_hash[:HOMEPAGE] = value if key == 'homepage_uri'
    end
    Gems.dependencies([ebuild_hash[:NAME]]).each do |version|
      ebuild_hash[:DEPEND] = version[:dependencies] if version[:number] == ebuild_hash[:VERSION] and version[:platform] == 'ruby'
    end
    return ebuild_hash
  end

  # Take a hash of metadata and build an ebuild from it
  def write_ebuild(hash, path=Dir.pwd)
    ebuild_string = <<-eos
      # Copyright 1999-#{Time.now.year} Gentoo Foundation
      # Distributed under the terms of the GNU General Public License v2

      EAPI=5
      USE_RUBY="ruby18 ruby19 ruby20"

      inherit ruby-fakegem

      DESCRIPTION="#{hash[:DESCRIPTION]}"
      HOMEPAGE="#{hash[:HOMEPAGE]}"

      LICENSE=""
      SLOT="0"
      KEYWORDS="~amd64 ~x86"
      IUSE=""
    eos
    File.open("#{path}/#{hash[:NAME]}-#{hash[:VERSION]}.ebuild", 'w') do |file|
      file.write(ebuild_string.gsub(/^( |\t)+/, ""))
    end
  end

end
