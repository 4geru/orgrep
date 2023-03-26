# frozen_string_literal: true

module Orgrep
  class Init
    def self.setup
      create_file(Orgrep::SPECIFIED_REPOSITORY_TXT_PATH)
      create_file(Orgrep::SPECIFIED_SEARCH_WORDS_TXT_PATH)
      create_file(Orgrep::ENV_PATH)
      setup_env_file
      puts "initialize complete"
    end

    class << self
      private
    
      def create_file(path)
        if FileTest.exist?(path)
          puts "#{path} already exists"
        else
          File.write(path, '')
          puts "created files #{path}"
        end
      end

      def setup_env_file
        if `cat #{Orgrep::ENV_PATH} | grep ORGREP_ORG_URI`.empty?
          File.write(Orgrep::ENV_PATH, "ORGREP_ORG_URI=TODO_WRITE\n", mode: "a")
        end
      end
    end
  end
end
