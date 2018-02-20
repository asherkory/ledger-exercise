require_relative "spec_helper"
require_relative "../lib/ledger"

RSpec.describe Ledger do

  let( :ledger ) { Ledger.new }

  # TODO
  # account balance should start at 0
  # should print error if ledger file is invalid or empty
  # should print error if ledger lines have invalid formatting, or invalid dates
  # should ignore invalid amounts
  # should ignore blank/empty lines
  # should handle ledger files with one line, and multiple lines
  # should handle ledger files with negative and positive amounts
  # should handle ledger files where dates aren't in order
  
end