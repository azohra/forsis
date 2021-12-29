require_relative '../fastlane/plugin/forsis/version.rb'

namespace :validate do
    desc "Validate the gem version before release to ensure a corresponding tag doesn't exit"
    task :version do
        include Fastlane::Forsis
        current_version = "v#{Fastlane::Forsis::VERSION}"
        latest_tag = `git ls-remote --tags --refs --sort=v:refname origin | tail -n 1 | cut -d '/' -f 3` 
        if current_version == latest_tag.tr("\n", '')
            puts "ERROR: Tag already exists"
            exit 1
        end
    end
end