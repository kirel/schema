require 'spec_helper'

Schema.include!

describe "Schema" do

  it "should cast nil" do
    42.transform(nil).should == nil
    "string".transform(nil).should == nil
  end

  it "should cast simple types" do
    42.transform(String).should == '42'
    42.transform(String).should be_kind_of(String)
    '42'.transform(Float).should == 42.0
    '42'.transform(Float).should be_kind_of(Float)
    '42'.transform(Integer).should == 42
    '42'.transform(Integer).should be_kind_of(Integer)
    'true'.transform(Boolean).should == true
    'true'.transform(Boolean).should be_kind_of(TrueClass)
    'false'.transform(Boolean).should == false
    'false'.transform(Boolean).should be_kind_of(FalseClass)
  end
  
  it "should cast dates" do
    dt = DateTime.now
    dt.transform(DateTime).should == dt
    '2010-12-01T12:00:00+01:00'.transform(DateTime).should == DateTime.parse('2010-12-01T12:00:00+01:00')
    '2010-12-01'.transform(Date).should == Date.parse('2010-12-01')
  end
  
  it "should cast hashes of simple types" do
    {:string => 'string'}.transform({:string => String}).should == {:string => 'string'}
    {:float => '42'}.transform({:float => Float}).should == {:float => 42.0}
    {:integer => '42'}.transform({:integer => Integer}).should == {:integer => 42}
  end
  
  it "should cast arrays" do
    {}.transform({:float => [Float]}).should == {:float => []}
    {:float => '42'}.transform({:float => [Float]}).should == {:float => [42.0]}
    {:float => ['42']}.transform({:float => [Float]}).should == {:float => [42.0]}
    {:float => ['42','13']}.transform({:float => [Float]}).should == {:float => [42.0, 13.0]}
  end
  
  it "should cast nested hashes" do
    { :nested => { :hash => '42' } }.transform({ :nested => { :hash => Integer } }).should ==
      { :nested => { :hash => 42 } }
  end
  
  it "should cast nested arrays of simple types" do
    { :nested => { :hash => '42' } }.transform({ :nested => { :hash => [Integer] } }).should ==
      { :nested => { :hash => [42] } }    
  end

  it "should cast nested arrays of hashes" do
    { :nested => { :hash => '42' } }.transform({ :nested => [{ :hash => Integer }] }).should ==
      { :nested => [{ :hash => 42 }] }    
  end
  
  it "should preserve nil values" do
  { :probably_nil => nil }.transform({ :probably_nil? => nil }).should ==
    { :probably_nil => nil }    
  end
  
  ### optional keys in schemas
  
  it "should allow optional keys in schemas" do
    schema = { :optional? => Float }
    { :optional => '42' }.transform(schema).should == { :optional => 42.0 }
    {}.transform(schema).should == {}
  end

  it "should cast circular schemas" do
    schema = { :float => Float }
    schema.update :circular? => schema # circular schemas _MUST_ be optional
    
    { :float => '42', :circular => { :float => '17' } }.transform(schema).should ==
      { :float => 42.0, :circular => { :float => 17.0 } }
  end

  it "should cast circular schemas with optional arrays" do
    schema = { :float => Float }
    schema.update :circular? => [schema]
    
    { :float => '42', :circular => { :float => '17' } }.transform(schema).should ==
      { :float => 42.0, :circular => [{ :float => 17.0 }] }

    { :float => '42', :circular => [{ :float => '17' }, { :float => '23' }] }.transform(schema).should ==
      { :float => 42.0, :circular => [{ :float => 17.0 }, { :float => 23.0 }] }
  end

  it "should cast circular schemas with non optional arrays" do
    schema = { :float => Float }
    schema.update :circular => [schema]
    
    { :float => '42', :circular => { :float => '17' } }.transform(schema).should ==
      { :float => 42.0, :circular => [{ :float => 17.0, :circular => [] }] }

    { :float => '42', :circular => [{ :float => '17' }, { :float => '23' }] }.transform(schema).should ==
      { :float => 42.0, :circular => [{ :float => 17.0, :circular => [] }, { :float => 23.0, :circular => [] }] }
  end
  
  ### how to cope with non-present keys
  
  it "should erase keys not present in the schema" do
    {:not => 'present'}.transform({}).should == {}
  end
  
  ### misuse
  
  it "should not allow non hash transform with hash" do
    lambda { 42.transform({}) }.should raise_error(ArgumentError)
  end
  
  it "should not allow an empty array as schema" do
    lambda { 42.transform([]) }.should raise_error(ArgumentError)
  end
  
  # it "should not cast arrays to simple types" do
  #   lambda { [].transform([]) }.should raise_error(ArgumentError)
  # end
  
end
