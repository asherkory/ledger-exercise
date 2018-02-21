require_relative "spec_helper"
require_relative "../lib/ledger"
require 'date'

RSpec.describe Ledger do

  context "When ledger file contains multiple valid lines" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_multiple.txt") }

    it "correctly displays a starting balance of 0" do
      expect(Ledger.new(file).balance("john")).to eq(0)
    end

    it "correctly displays the balance when querying with a given date string" do
      expect(Ledger.new(file).balance("john", "2015-01-17")).to eq(-125)
    end

    it "correctly displays the balance when querying with a Date object" do
      date = Date.new(2015, 1, 17)
      expect(Ledger.new(file).balance("john", date)).to eq(-125)
    end

    context "with invalid query paramaters" do
      it "outputs an error message when querying the balance with an invalid date" do
        expect{ Ledger.new(file).balance("mary", "bad_date") }.to output( 
          "Error: invalid date format\n" 
        ).to_stdout
      end

      it "outputs an error message querying the balance with an invalid account name" do
        expect{ Ledger.new(file).current_balance("bad_account") }.to output( 
          "Error: no transactions found for bad_account before the given date\n" 
        ).to_stdout
      end
    end
  end

  context "When ledger file has dates out of chronological order" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_order.txt") }

    it "correctly displays the current balance of the first account" do
      expect(Ledger.new(file).current_balance("john")).to eq(-135.0)
    end

    it "correctly displays the current balance of the second account" do
      expect(Ledger.new(file).current_balance("mary")).to eq(115.0)
    end
  end

  context "When ledger file contains transactions with negative amounts" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_negative.txt") }

    it "correctly displays the current balance of the source account" do
      expect(Ledger.new(file).current_balance("insurance")).to eq(100.0)
    end

    it "correctly displays the current balance of the destination account" do
      expect(Ledger.new(file).current_balance("mary")).to eq(25.0)
    end
  end

  context "When ledger file contains just one valid line" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_one.txt") }

    it "correctly displays the current balance for the source account" do
      expect(Ledger.new(file).current_balance("john")).to eq(-125.0)
    end

    it "correctly displays the current balance for the destination account" do
      expect(Ledger.new(file).current_balance("mary")).to eq(125.0)
    end

    it "correctly displays a starting balance of 0 for the source account" do
      expect(Ledger.new(file).balance("john")).to eq(0)
    end

    it "correctly displays a starting balance of 0 for the destination account" do
      expect(Ledger.new(file).balance("mary")).to eq(0)
    end
  end

  context "When ledger file contains some valid lines and some invalid lines" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_combination.txt") }

    it "ignores the invalid or blank lines when calculating a balance" do
      expect(Ledger.new(file).current_balance("john")).to eq(-145.0)
    end

    context "with invalid ledger data" do
      it "outputs error messages for lines with invalid separators and dates" do
        expect{ Ledger.new(file) }.to output( 
          "Error: invalid ledger transaction format\n" +
          "Error: invalid transaction date\n" +
          "Error: invalid ledger transaction format\n" +
          "Error: invalid ledger transaction format\n" +
          "Error: invalid ledger transaction format\n" +
          "Error: invalid ledger transaction format\n"
        ).to_stdout
      end
    end
  end

  context "When ledger file is blank" do
    let(:file) { File.join(File.dirname(__FILE__), "./test_ledger_blank.txt") }

    it "outputs an error message" do
      expect{ Ledger.new(file) }.to output("Error: empty ledger file\n").to_stdout
    end

    context "when asked for an account balance" do
      it "outputs an error message and does not crash" do
        expect{ Ledger.new(file).current_balance("john") }.to output( 
          "Error: empty ledger file\n" +
          "Error: no transactions found for john before the given date\n" 
        ).to_stdout
      end
    end
  end

  context "When ledger file does not exist" do
    it "outputs an error message" do
      expect{ Ledger.new("fake_file.txt") }.to output("Error: invalid file\n").to_stdout
    end

    context "when asked for an account balance" do
      it "outputs an error message and does not crash" do
        expect{ Ledger.new("fake_file.txt").current_balance("john") }.to output(
          "Error: invalid file\n" +
          "Error: no transactions found for john before the given date\n" 
        ).to_stdout
      end
    end
  end

end