# frozen_string_literal: true

module Orgrep
  class SearchWordList
    def self.words(word)
      return [word] if word

      File.read('./search_words.txt').split("\n").uniq
    end
  end
end
