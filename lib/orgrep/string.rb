# frozen_string_literal: true

class String
  # reference: https://gist.github.com/Kameshwaran/61a547f9751e7bd12954
  def camelize
    split("_").map(&:capitalize).join
  end

  def compact
    split(" ").join
  end
end
