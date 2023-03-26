# frozen_string_literal: true

module Orgrep
  # call repositories from text file.
  class Repository
    def self.repositories
      if FileTest.exist?(Orgrep::SPECIFIED_REPOSITORY_TXT_PATH)
        return File.read(Orgrep::SPECIFIED_REPOSITORY_TXT_PATH).split("\n").uniq
      end

      @repositories ||= File.read(Orgrep::REPOSITORY_TXT_PATH).split("\n").uniq
    end
  end
end
