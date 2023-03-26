# frozen_string_literal: true
require 'dotenv/load'
require_relative "orgrep/version"
require_relative "orgrep/repository"
require_relative "orgrep/string"
require_relative "orgrep/grep"

require 'logger'

module Orgrep
  class Error < StandardError; end

  def self.run(argv)
    log = Logger.new(STDOUT)
    case argv[0]
    when 'repository', 'repo'
      repository = Orgrep::Repository.new
      case argv[1]
      when 'add'
        repository.add(argv[2])
      when 'remove'
        repository.remove(argv[2])
      when 'show'
        puts '>> registered repositories >>'
        puts repository.repositories
      end
    when 'search'
      Orgrep::Grep.new.search(argv[1])
    end
  end
end
