require 'date'

class Float
  def self.from val
    val.to_f
  end
end

class Integer
  def self.from val
    val.to_i
  end
end

class String
  def self.from val
    val.to_s
  end
end

class Date
  def self.from val
    parse val
  end
end

class DateTime
  def self.from val
    parse val
  end
end