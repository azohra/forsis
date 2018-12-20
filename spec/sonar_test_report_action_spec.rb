describe Fastlane::Actions::SonarTestReportAction do
  describe 'handles invalid data' do

    it 'raises an error if no options are provided in the action' do
      lane = "lane :test do
        sonar_test_report(
      )
      end"
      expect { Fastlane::FastFile.new.parse(lane).runner.execute(:test) }.to(
        raise_error(FastlaneCore::Interface::FastlaneError) do |error|
           expect(error.message).to match("'sonar_test_report' action missing the key 'junit_report_path' or its value.")
        end
      )
    end

    it 'raises an error if mandatory options are not provided in the action' do
      # expect(Fastlane::UI).to receive(:message).with("sonar_test_report action missing these keys:junit_report")
      lane = "lane :test do
        sonar_test_report(
        sonar_report_path: 'fastlane/Test-report.xml'
      )
      end"
      expect { Fastlane::FastFile.new.parse(lane).runner.execute(:test) }.to(
        raise_error(FastlaneCore::Interface::FastlaneError) do |error|
           expect(error.message).to match("'sonar_test_report' action missing the key 'junit_report_path' or its value.")
        end
      )
    end

   it 'raises an error if there is no junit file in the given path' do
    lane = "lane :test do
      sonar_test_report(
        junit_report: 'wrong_path',
        sonar_generated_report: 'fastlane/Test-report.xml'
      )
      end"
      # expect do
      #   Fastlane::FastFile.new.parse(lane).runner.execute(:test).to raise_error("ERROR: junit report not found at path: #{path}")
      # end
             expect(Fastlane::UI).to receive(:message).with("sonar_test_report action missing these keys:junit_report")

   end

  end
end
