# frozen_string_literal: true
require 'dotenv/load'
require_relative "orgrep/version"
require_relative "orgrep/repository"
require_relative "orgrep/string"
require_relative "orgrep/grep"
require_relative "orgrep/init"

require 'logger'

module Orgrep
  SPECIFIED_REPOSITORY_TXT_PATH = File.join('./repositories.txt')
  SPECIFIED_SEARCH_WORDS_TXT_PATH = File.join('./search_words.txt')
  ENV_PATH = File.join('./.env')

  def self.run(argv)
    log = Logger.new(STDOUT)
    case argv[0]
    when 'init'
      Orgrep::Init.setup
    when 'search'
      Orgrep::Grep.new.search(argv[1...])
    end
  end
end
