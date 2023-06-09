# frozen_string_literal: true

module Orgrep
  # call search word from argv or text file.
  class SearchWordList
    def self.words(words)
      return words if words

      File.read(Orgrep::SPECIFIED_SEARCH_WORDS_TXT_PATH).split("\n").uniq
    end
  end
end
