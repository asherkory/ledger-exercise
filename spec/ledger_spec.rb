require_relative "spec_helper"
require_relative "../lib/ledger"

RSpec.describe Ledger do

  context "When ledger file contains multiple valid lines" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_multiple.txt" ) }
    # should handle ledger files with multiple lines

    # account balance should start at 0
    # should ignore blank/empty lines
    # should handle ledger files with negative and positive amounts
    # should handle ledger files where dates aren't in order
  end

  context "When ledger file contains just one valid line" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_one.txt" ) }
    # should handle ledger files with one line

    # account balance should start at 0
  end

  context "When ledger file contains some valid lines and some invalid lines" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_combination.txt" ) }
    # should print error if ledger lines have invalid formatting, invalid dates, or invalid amounts
  end

  context "When ledger file is blank" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_blank.txt" ) }
    # should print error if ledger file is empty
  end

  context "When ledger file does not exist" do

    expect{ Ledger.new( "fake_file.txt" ) }.to # output error
    # should print error if ledger file is invalid
  end

end