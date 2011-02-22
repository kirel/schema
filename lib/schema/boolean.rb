class Boolean
  def self.from val
    case val.to_s
    when /^true$/i
      true
    when /^false$/i
      false
    else
      raise ArgumentError, "Could not create Boolean from #{val}"
    end
  end
end
