describe Fastlane::Actions::SonarTestReportAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The sonar_test_report plugin is working!")

      Fastlane::Actions::SonarTestReportAction.run(nil)
    end
  end
end
