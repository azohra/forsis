describe Fastlane::Actions::SonarTestReportAction do
  after(:all) do
    FileUtils.rm_rf(File.absolute_path('spec/test_output'))
  end

  describe '.available_options' do
    it 'raises an error if no options are provided in the action' do
      lane = 'lane :test do
        forsis(
        )
        end'
      expect { Fastlane::FastFile.new.parse(lane).runner.execute(:test) }.to(
        raise_error(FastlaneCore::Interface::FastlaneError) do |error|
          expect(error.message).to match("'forsis' action missing the key 'junit_report_path' or its value.")
        end
      )
    end

    it 'raises an error if mandatory options are not provided in the action' do
      lane = 'lane :test do
        forsis(
          sonar_report_directory: "fastlane/Test-report.xml"
        )
        end'
      expect { Fastlane::FastFile.new.parse(lane).runner.execute(:test) }.to(
        raise_error(FastlaneCore::Interface::FastlaneError) do |error|
          expect(error.message).to match("'forsis' action missing the key 'junit_report_path' or its value.")
        end
      )
    end

    it 'raises an error if there is no junit file in the given path' do
      lane = 'lane :test do
        forsis(
          junit_report_file: "./wrong/path/to_junit_file",
          sonar_report_directory: "./fastlane"
        )
        end'
      expect { Fastlane::FastFile.new.parse(lane).runner.execute(:test) }.to(
        raise_error(FastlaneCore::Interface::FastlaneError) do |error|
          expect(error.message).to match('ERROR: junit report not found at path: ./wrong/path/to_junit_file')
        end
      )
    end

    it 'creates folders if they do not exist in the given path' do
      output_directory = File.absolute_path('spec/test_output/sonarqube')
      lane = "lane :test do
        forsis(
          junit_report_file: '../spec/fixtures/original_test_report.junit',
          sonar_report_directory: '#{output_directory}'
        )
        end"
      allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:generate)
        .with("../spec/fixtures/original_test_report.junit", output_directory.to_s)
        .and_return("#{output_directory}/Test_sonarqube_report.xml")
      Fastlane::FastFile.new.parse(lane).runner.execute(:test)
      expect(Dir.exist?(output_directory)).to be true
    end

    context 'when running the lane without the option "sonar_report_directory"' do
      after (:each) do
        FileUtils.rm_rf(File.absolute_path('fastlane/fastlane'))
      end

      it 'uses the default value if the sonar_report_directory is not set' do
        lane = 'lane :test do
          forsis(
            junit_report_file: "../spec/fixtures/original_test_report.junit"
          )
          end'
        Fastlane::FastFile.new.parse(lane).runner.execute(:test)
        sonarqube_report_default_path = File.absolute_path('fastlane/fastlane/Test_sonarqube_report.xml')
        expect(File.exist?(sonarqube_report_default_path)).to be true
      end
    end
  end

  describe '.run' do
    it 'generates the correct format of SonarQube generic execution' do
      output_directory = File.absolute_path('spec/test_output')
      lane = "lane :test do
      forsis(
        junit_report_file: '../spec/fixtures/original_test_report.junit',
        sonar_report_directory: '#{output_directory}'
      )
      end"
      allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
        .with('ClassOneTests').and_return('./ExampleTests/ClassOneTests.swift')
      allow(Fastlane::Helper::SonarTestReportHelper::Generator).to receive(:get_test_file_path)
        .with('ClassTwoTests').and_return('./ExampleTests/ClassTwoTests.swift')
      Fastlane::FastFile.new.parse(lane).runner.execute(:test)
      expected_sonarqube_report = File.absolute_path('spec/fixtures/sonarqube_generic_test_report.xml')
      generated_sonarqube_report = output_directory + '/Test_sonarqube_report.xml'

      expect(File.exist?(generated_sonarqube_report)).to be true
      expect(FileUtils.compare_file(generated_sonarqube_report, expected_sonarqube_report)).to be true
    end
  end
end
