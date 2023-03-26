# frozen_string_literal: true

require 'parallel'
require_relative './search_word_list'

module Orgrep
  class Grep
    def search(search_word)
      # TODO raise error when repositories are not registered
      # === initial setup ===
      puts('=== initial setup ===')
      fork_unforked_services
      # === setup ===
      puts('=== setup ===')
      git_stash_files
      fetch_origin_head_name
      # execute service
      puts('=== running ===')
      # TODO export as csv file in executed path
      search_words = SearchWordList.words(search_word)
      print(export_as_csv(search_words))
      # === clean up ===
      puts('=== clean up ===')
      git_stash_pop_files
    end

    private

    def fork_unforked_services
      Parallel.each(repositories, in_threads: 10) do |service|
        unless FileTest.directory?(service)
          `git clone #{ENV['ORGREP_ORG_URI']}/#{service}.git`
        end
      end
    end

    def fetch_origin_head_name
      error_repositorys = []
      Parallel.each(repositories, in_threads: 10) do |repository|
        res = `cd #{repository} && git fetch origin && git checkout origin/HEAD`
        unless res.size.zero?
          error_repositorys << repository
        end
      end
      if !error_repositorys.length.zero?
        puts "=== please check #{error_repositorys.join(",")} status ==="
      end
    end

    def export_as_csv(search_words)
      service_table_map = find_codes(search_words)
      csv_strings = []
      header = [nil, repositories].join(',')
      csv_strings << header
      search_words.each do |search_word|
        csv_strings << [search_word, repositories.map { service_table_map[_1][search_word] }].join(',')
      end
      csv_strings.join("\n") + "\n"
    end

    def git_stash_files
      Parallel.each(repositories, in_threads: 10) do |repository|
        res = `cd #{repository} && git add . && git stash`
        if res.match?('needs merge')
          raise ScriptError.new("#{repository}, #{res}")
        end
      end
    end

    def git_stash_pop_files
      Parallel.each(repositories, in_threads: 10) do |repository|
        `cd #{repository} && git stash pop`
      end
    end

    private

    # { repository: { search_word: 0 } }
    def find_codes(search_words)
      service_table_map = repositories.map{ [_1, {}] }.to_h
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
      @repositories ||= Orgrep::Repository.new.repositories
    end
  end
end
