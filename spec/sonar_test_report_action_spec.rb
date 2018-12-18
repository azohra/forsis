describe Fastlane::Actions::SonarTestReportAction do
  describe 'handles invalid data' do
    
    it 'raises an error if mandatory options are not provided in the action' do

      # Fastlane::Actions::SonarTestReportAction.run(nil)
      # expect(Fastlane::UI).to receive(:message).with("sonar_test_report action missing these keys:junit_report")
      lane = "lane :test do
      sonar_test_report(
        sonar_generated_report: 'fastlane/Test-report.xml'
      )
      end"
      expect do
        Fastlane::FastFile.new.parse(lane).runner.execute(:test).to raise_error("sonar_test_report action missing these keys: junit_report")
      end
   end

  end
end
