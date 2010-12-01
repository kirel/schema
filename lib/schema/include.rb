module Schema
  module Include
    # Include this module into Object to have a handy #transform on every object.
    # Then object.transform(schema) is like calling Schema.transform(object, schema).
    def transform schema
      Schema.transform self, schema
    end
  end
end