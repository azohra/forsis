describe Fastlane::Helper::SonarTestReportHelper::Generator do
  context 'when generating a sonarqube report' do

    after(:each) do
      FileUtils.rm(File.absolute_path('./spec/Test_sonarqube_report.xml'))
    end
    
    it 'generates the correct xml for sonarqube generic execution' do
      junit_file_path = './spec/fixtures/original_test_report.junit'
      sonarqube_report_path = './spec'
      allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
            .with('ClassOneTests').and_return('./ExampleTests/ClassOneTests.swift')
      allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
            .with('ClassTwoTests').and_return('./ExampleTests/ClassTwoTests.swift')
      
      Fastlane::Helper::SonarTestReportHelper::Generator.generate(junit_file_path, sonarqube_report_path )
      expected_sonarqube_report = File.absolute_path('spec/fixtures/sonarqube_generic_test_report.xml')
      generated_sonarqube_report = './spec/Test_sonarqube_report.xml'

      expect(File.exist?(generated_sonarqube_report)).to be true          
      expect(FileUtils.compare_file(generated_sonarqube_report, expected_sonarqube_report)).to be true
    end
  end

  it 'overwrites an existing sonarqube report' do
    junit_file_path = './spec/fixtures/original_test_report.junit'
    sonarqube_report_path = './spec/fixtures'
    existing_sonarqube_file = File.absolute_path(sonarqube_report_path + '/Test_sonarqube_report.xml')
    expect(File.exist?(existing_sonarqube_file)).to be true

    allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
          .with('ClassOneTests').and_return('./ExampleTests/ClassOneTests.swift')
    allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
          .with('ClassTwoTests').and_return('./ExampleTests/ClassTwoTests.swift')
    Fastlane::Helper::SonarTestReportHelper::Generator.generate(junit_file_path, sonarqube_report_path )
    expected_sonarqube_report = File.absolute_path('spec/fixtures/sonarqube_generic_test_report.xml')
    generated_sonarqube_report = './spec/fixtures/Test_sonarqube_report.xml'

    expect(FileUtils.compare_file(generated_sonarqube_report, expected_sonarqube_report)).to be true
  end
end
