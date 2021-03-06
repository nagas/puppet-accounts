#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the member_regex function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("member_regex").should == "function_member_regex"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_member_regex([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return true if a member is in an array" do
    result = scope.function_member_regex([["a","b","c"], "a"])
    result.should(eq(true))
  end

  it "should return false if a member is not in an array" do
    result = scope.function_member_regex([["a","b","c"], "d"])
    result.should(eq(false))
  end

  it "should return true if a member is in a nested array" do
    result = scope.function_member_regex([["a","b",["bar","foo"]], "foo"])
    result.should(eq(true))
  end

  it "should return false if a member is not in a nested array" do
    result = scope.function_member_regex([["a","b",["bar","foo"]], "buzz"])
    result.should(eq(false))
  end

  it "should return true if a member matches regexp pattern(s)" do
    result = scope.function_member_regex([[/foo/,/^bar$/], "fooo"])
    result.should(eq(true))
  end

  it "should return false if a member doesn't match regexp pattern(s)" do
    result = scope.function_member_regex([[/foo/,/^bar$/], "barr"])
    result.should(eq(false))
  end

  it "should return true if a member is in an array or matches regexp patterns(s)" do
    # is member
    result = scope.function_member_regex([["foo",/bar/], "foo"])
    result.should(eq(true))
  end

  it "should return true if a member is in an array or matches regexp patterns(s)" do
    # matches regexp pattern
    result = scope.function_member_regex([["foo",/bar/], "bar"])
    result.should(eq(true))
  end

  it "should return false if a member is not in an array and doesn't match regexp patterns(s)" do
    result = scope.function_member_regex([["foo",/bar/], "buzz"])
    result.should(eq(false))
  end
end
