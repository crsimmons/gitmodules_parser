# frozen_string_literal: true

require 'json'

module Parsers
  # GitmodulesParser parses gitmodule files into JSON
  class GitmodulesParser
    def initialize(gitmodules)
      @gitmodules = gitmodules
    end

    def parse
      begin
        file_contents = File.read(gitmodules)
      rescue
        return '{}'
      end
      return '{}' if file_contents.empty?
      buffer = StringScanner.new(file_contents)
      JSON.pretty_generate(parse_all_modules(buffer))
    end

    private

    attr_reader :gitmodules

    def parse_all_modules(buffer)
      modules = []
      modules.push(buffer.scan_until(/url = .*$/)) until buffer.eos?

      modules.map do |m|
        module_buffer = StringScanner.new(m)
        parse_module(module_buffer)
      end
    end

    def parse_module(buffer)
      name = sanatize_string(buffer.scan_until(/]/).match(/"(.*)"/))
      buffer.skip_until(/= /)
      path = sanatize_string(buffer.scan_until(/\n/))
      buffer.skip_until(/= /)
      url = sanatize_string(buffer.scan_until(/$/))
      {
        name: name,
        path: path,
        url: url
      }
    end

    def sanatize_string(string)
      string.to_s.strip.tr('"', '')
    end
  end
end
