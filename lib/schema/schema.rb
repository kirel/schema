module Schema
  # transform
  # @param object The object to be transformed.
  # @param schema A valid schema. For hashes only hashes and for arrays only arrays are valid schemas.
  #   For everything else either a type (e.g. <tt>Float</tt>)
  #   or an Array with a single type element (e.g. <tt>[String]</tt>) is a valid Schema.
  def self.transform object, schema
    case schema
    when Array
      raise ArgumentError, "An empty Array is not a valid schema." unless schema.first
      # for now we only transform into the first schema-array element
      case object
      when nil
        []
      when Array
        object.map { |e| e.transform(schema.first) }
      else
        [object.transform(schema.first)]
      end
    when Hash
      raise ArgumentError, "A #{schema.class} is no valid schema for a #{object.class}." unless object.is_a?(Hash)
      schema.inject({}) do |h, (key, subschema)|
        h.update(key => object[key].transform(subschema))
      end
    else
      schema.from(object)
    end
  end  
end