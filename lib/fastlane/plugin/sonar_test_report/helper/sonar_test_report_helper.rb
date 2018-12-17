require 'fastlane_core/ui/ui'
require 'nokogiri'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    module SonarTestReport
      
      def generate(junit_report, sonarqube_report)
        f = File.open(sonarqube_report, 'a')
        test_suites = junit_report.xpath("//testsuite")
        builder = Nokogiri::XML::Builder.new do |xml|
            xml.testExecutions({version: :"1"}) {
                test_suites.each do |test_file|
                    file_name = `echo #{test_file["name"]}| cut -d'.' -f 2`.gsub(/\n/, '')
                    file_path = `cd .. && find . -iname "#{file_name}.swift"`.gsub(/\n/, '')
                    test_cases = []
                    # binding.pry
                    test_file.children.each do |child|
                        test_cases << child if child.class ==  Nokogiri::XML::Element 
                    end
                    xml.file({path: :"#{file_path}"}){
                        test_cases.each do |test|
                            test_duration = (test["time"].to_f * 1000).round
                            test_failures = []
                            test.children.each do |test_child|
                                test_failures << test_child if test_child.class ==  Nokogiri::XML::Element 
                            end
                            #  binding.pry
                            xml.testCase({name: :"#{test["name"]}", duration: :"#{test_duration}"}) {
                                test_failures.each do |failure|
                                    failure_type = failure.name
                                    failure_message = failure["message"]
                                    failure_description = failure.text
                                    xml.send("failure", failure_description, :message => failure_message)                            
                                end
                            }
                        end
                    }
              end
            }
                #    
        end
            
        f.puts builder.to_xml
      end

      def self.show_message
        UI.message("Hello from the sonar_test_report plugin helper!")
      end

    end
  end
end
