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