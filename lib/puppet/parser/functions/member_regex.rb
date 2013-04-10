#
# member_regex.rb
# see: https://github.com/puppetlabs/puppetlabs-stdlib/pull/141
#


module Puppet::Parser::Functions
  newfunction(:member_regex, :type => :rvalue, :doc => <<-EOS
This function determines if a variable is a member of an array.

*Examples:*

    member_regex(['a','b'], 'b')

Would return: true

    member_regex(['a','b'], 'c')

Would return: false
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "member_regex(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'member_regex(): Requires array to work with')
    end

    item = arguments[1]

    raise(Puppet::ParseError, 'member_regex(): You must provide item ' +
      'to search for within array given') if item.empty?

    array.flatten.any? do |el|
      case el
        when String
          item == el
        when Regexp
          item =~ Regexp.compile(el)
      end
    end

  end
end

# vim: set ts=2 sw=2 et :
