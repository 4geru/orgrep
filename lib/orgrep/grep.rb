# frozen_string_literal: true

require "parallel"
require_relative "./search_word_list"

module Orgrep
  # grep class of orgrep
  class Grep
    def search(search_words)
      # TODO: raise error when repositories are not registered
      # === initial setup ===
      puts("=== initial setup ===")
      fork_unforked_services
      # === setup ===
      puts("=== setup ===")
      git_stash_files
      fetch_origin_head_name
      # execute service
      puts("=== running ===")
      # TODO: export as csv file in executed path
      specified_search_words = SearchWordList.words(search_words)
      print(export_as_csv(specified_search_words))
      # === clean up ===
      puts("=== clean up ===")
      git_stash_pop_files
    end

    private

    def fork_unforked_services
      Parallel.each(repositories, in_threads: 10) do |service|
        `git clone #{ENV["ORGREP_ORG_URI"]}/#{service}.git` unless FileTest.directory?(service)
      end
    end

    def fetch_origin_head_name
      error_repositorys = []
      Parallel.each(repositories, in_threads: 10) do |repository|
        res = `cd #{repository} && git fetch origin && git checkout origin/HEAD`
        error_repositorys << repository unless res.empty?
      end
      return if error_repositorys.empty?

      puts "=== please check #{error_repositorys.join(",")} status ==="
    end

    def export_as_csv(search_words)
      service_table_map = find_codes(search_words)
      csv_strings = []
      header = [nil, repositories].join(",")
      csv_strings << header
      search_words.each do |search_word|
        csv_strings << [search_word, repositories.map { service_table_map[_1][search_word] }].join(",")
      end
      "#{csv_strings.join("\n")}\n"
    end

    def git_stash_files
      Parallel.each(repositories, in_threads: 10) do |repository|
        res = `cd #{repository} && git add . && git stash`
        raise ScriptError, "#{repository}, #{res}" if res.match?("needs merge")
      end
    end

    def git_stash_pop_files
      Parallel.each(repositories, in_threads: 10) do |repository|
        `cd #{repository} && git stash pop`
      end
    end

    # { repository: { search_word: 0 } }
    def find_codes(search_words)
      service_table_map = repositories.map { [_1, {}] }.to_h
      search_words.each do |search_word|
        next if search_word.nil?

        Parallel.each(repositories, in_threads: 10) do |repository|
          count = `cd #{repository} && git grep -e "#{search_word}" -e "#{search_word.camelize}" | wc -l`.compact.to_i
          service_table_map[repository][search_word] = count
        end
      end
      service_table_map
    end

    def repositories
      @repositories ||= Orgrep::Repository.repositories
    end
  end
end
