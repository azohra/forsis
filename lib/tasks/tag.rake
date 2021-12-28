require_relative '../fastlane/plugin/forsis/version.rb'

namespace :validate do
    desc "Validates the gem version"
    task :version do
        include Fastlane::Forsis
        current_version = "v#{Fastlane::Forsis::VERSION}"
        puts "current: #{current_version.inspect}"
        latest_tag = `git ls-remote --tags --refs --sort=v:refname origin | tail -n 1 | cut -d '/' -f 3` 
        puts "latest tag: #{latest_tag.tr("\n", '').inspect}"   
        if current_version == latest_tag.tr("\n", '')
            puts "ERROR: Tag already exists"
            exit 1
        end
    end
end