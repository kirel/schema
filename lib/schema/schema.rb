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
        if key.to_s =~ /^(.*)\?$/
          optionalkey = $1.to_sym
          h.update(object.key?(optionalkey) || object[optionalkey] ? { optionalkey => object[optionalkey].transform(subschema) } : {})
        else
          h.update(key => object[key].transform(subschema))
        end
      end
    when nil
      nil
    else
      schema.from(object)
    end
  end  
  
  def self.include!
    Object.send :include, Schema::Include
  end
end