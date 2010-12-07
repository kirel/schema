# Schema

Schema is a mechanism for enforcing schemas for ruby hashes. Type conversions are specified in a schema-hash and applied to a hash that shall be transformed.

### SYNOPSIS

    Schema.transform({:float => '42', :array_of_strings => 23}, {:float => Float, :array_of_strings => [String]})
    # => {:float => 42.0, :array_of_strings => ['23']}

or

    Schema.include!
    
    {:float => '42', :array_of_strings => 23}.transform({:float => Float, :array_of_strings => [String]})
    # => {:float => 42.0, :array_of_strings => ['23']}

### Schemas

A Schema is either a type that implements `#from` or a hash of schemas or an array with a schema as it's single element.

    Float # is a schema
    [Float] # is a schema
    { :string => String } # is a schema
    { :foo => [{ :bar => DateTime }]} # is a schema

Ruby has no Boolean class, therefore we define it, so we have:

    "true".transform(Boolean) == true

nil is also a valid schema but it transforms everything to nil:

    "string".transform(nil) == nil

In Hash-schemas keys may be optional indicated by a trailing question mark.

    { :optional => '42' }.transform({ :optional? => Float }) == { :optional => 42.0 }
    {}.transform({ :optional? => Float }) == {}

This also enables circular schemas (for eg. trees)

    schema = { :value => Float }
    schema.update { :children? => [schema] }

### Issues

- Works only for symbol keys. Not yet sure if this is a bug or a feature...

### Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright (c) 2010 Daniel Kirsch. See LICENSE for details.
