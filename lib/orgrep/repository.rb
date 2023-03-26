# frozen_string_literal: true

module Orgrep
  class Repository
    REPOSITORY_TXT_PATH = File.join(File.dirname(__FILE__), '../../tmp/repositories.txt')
    SPECIFIED_REPOSITORY_TXT_PATH = File.join('./repositories.txt')

    def initialize
      File.write(REPOSITORY_TXT_PATH, '') unless FileTest.exist?(REPOSITORY_TXT_PATH) # create file when it haven't created
    end

    def add(file_name)
      File.write(REPOSITORY_TXT_PATH, "\n#{file_name}", mode: "a")
      true
    end

    def remove(file_name)
      removed_repositories = repositories.filter { _1 != file_name }
      File.write(REPOSITORY_TXT_PATH, removed_repositories.join("\n"))
      removed_repositories
    end

    def repositories
      if FileTest.exist?(SPECIFIED_REPOSITORY_TXT_PATH) # create file when it haven't created
        return File.read(SPECIFIED_REPOSITORY_TXT_PATH).split("\n").uniq
      end

      @repositories ||= File.read(REPOSITORY_TXT_PATH).split("\n").uniq
    end    
  end
end
