require 'date'

class Ledger
  attr_accessor :transactions

  def initialize( ledger_file )
    @transactions = []
    
    if File.file?( ledger_file )
      parse_ledger( ledger_file )
    else
      puts "Error: invalid file"
    end
  end

  def balance_by_date( date_string, account_name )
    date = parse_date( date_string )
    unless date.nil?
      
      # find transactions for the given account, before the given date
      applicable_transactions = transactions.select do | transaction | 
        transaction[ :name ] == account_name && transaction[ :date ] < date
      end

      if applicable_transactions.empty?
        puts "Error: no transactions found for #{ account_name } before #{ date_string }"
      else
        
        # calculate the balance by adding the transaction amounts
        applicable_transactions.reduce do | balance, transaction |
          balance + transaction[ :amount ]
        end
      end
    end
  end

  private

  def parse_ledger( file )
    ledger_contents = File.read( file )
    transactions = ledger_contents.split( "\n" )
    
    if transactions.empty?
      puts "Error: empty ledger file"
    else
      transactions.each do | transaction |
        if transaction.size == 4
          
          date, source_account, destination_account, amount = transaction.split( "," )
          parsed_date = parse_date( date )

          unless parsed_date.nil?
            transactions << { date: parsed_date, name: source_account, amount: -amount.to_f }
            transactions << { date: parsed_date, name: destination_account, amount: amount.to_f }
          end
        else
          puts "Error: invalid ledger transaction format"
        end
      end
    end
  end

  def parse_date( date_string )
    year, month, day = date_string.split( "-" ).map( &:to_i )
    if Date.valid_date?( year, month, day )
      Date.strptime( date_string, "%Y-%m-%d" )
    else
      puts "Error: invalid transaction date #{ date_string }"
    end
  end
end