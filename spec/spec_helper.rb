# frozen_string_literal: true

$LOAD_PATH << File.expand_path('lib')

module FixtureHelper
  FIXTURE_DIR = Pathname.new(File.expand_path('../fixtures/', __FILE__))

  def fixture(file)
    FIXTURE_DIR.join(file)
  end

  def all_fixtures_in_folder(folder)
    FIXTURE_DIR.join(folder).entries.reject { |entry| entry.to_s[0] == '.' }
               .map { |entry| FIXTURE_DIR.join(folder, entry) }
               .tap do |entries|
      entries.each { |entry| yield entry } if block_given?
    end
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
