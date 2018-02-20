require_relative "spec_helper"
require_relative "../lib/ledger"

RSpec.describe Ledger do

  context "When ledger file contains multiple valid lines" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_multiple.txt" ) }

    it "correctly displays a starting balance of 0" do
    end

    it "correctly displays the balance when querying with a given date string" do
    end

    it "correctly displays the balance when querying with a Date object" do
    end

    it "correctly displays a negative balance" do
    end

    context "querying a balance with an invalid date" do
      it "outputs an error message" do
      end
    end

    context "querying a balance with an invalid account name" do
      it "outputs an error message" do
      end
    end
  end

  context "When ledger file has dates out of chronological order" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_order.txt" ) }

    it "correctly displays the balance of the source account" do
    end

    it "correctly displays the balance of the destination account" do
    end
  end

  context "When ledger file contains transactions with negative amounts" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_negative.txt" ) }

    it "correctly displays the balance of the source account" do
    end

    it "correctly displays the balance of the destination account" do
    end
  end

  context "When ledger file contains just one valid line" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_one.txt" ) }

    it "correctly displays the current balance for the source account" do
    end

    it "correctly displays the current balance for the destination account" do
    end

    it "correctly displays a starting balance of 0 for the source account" do
    end

    it "correctly displays a starting balance of 0 for the destination account" do
    end
  end

  context "When ledger file contains some valid lines and some invalid lines" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_combination.txt" ) }

    it "ignores the invalid or blank lines when calculating a balance" do
      expect{ Ledger.new( file ).current_balance( "John" ) }.to eq( 155 )
    end

    context "for a line with invalid separators" do
      it "outputs an error message" do
        expect{ Ledger.new( file ) }.to output( 
          "Error: invalid ledger transaction format" 
        ).to_stdout
      end
    end

    context "for a line with an invalid date format" do
      it "outputs an error message" do
        expect{ Ledger.new( file ) }.to output( 
          "Error: invalid transaction date" 
        ).to_stdout
      end
    end
  end

  context "When ledger file is blank" do
    let( :file ) { File.join( File.dirname( __FILE__), "./test_ledger_blank.txt" ) }

    it "outputs an error message" do
      expect{ Ledger.new( file ) }.to output( "Error: empty ledger file" ).to_stdout
    end

    context "when asked for an account balance" do
      it "outputs an error message and does not crash" do
        expect{ Ledger.new( file ).current_balance( "John" ) }.to output( 
          "Error: no transactions found for John before the given date" 
        ).to_stdout
      end
    end
  end

  context "When ledger file does not exist" do
    it "outputs an error message" do
      expect{ Ledger.new( "fake_file.txt" ) }.to output( "Error: invalid file" ).to_stdout
    end

    context "when asked for an account balance" do
      it "outputs an error message and does not crash" do
        expect{ Ledger.new( "fake_file.txt" ).current_balance( "John" ) }.to output( 
          "Error: no transactions found for John before the given date" 
        ).to_stdout
      end
    end
  end

end