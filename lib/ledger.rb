class Ledger
  attr_accessor :transactions, :accounts

  def initialize( ledger_file )
    @transactions = []
    @accounts = []
    
    if File.file?( ledger_file )
      parse_ledger( ledger_file )
    else
      puts "Error: invalid file"
    end
  end

  # interaction methods go here
  def balance_by_date( date, account_name )
  end

  private

  def parse_ledger( file )
    ledger_contents = File.read( file )
    transactions = ledger_contents.split( "\n" )
    
    # TODO add more error checking for invalid file formats
    transactions.each do | transaction |
      date, source_account, destination_account, amount = transaction.split( "," )
      parsed_date = parse_date( date )

      transactions << Transaction.new( parsed_date, source_account, destination_account, amount )
      accounts << source unless accounts.include?( source )
      accounts << destination unless accounts.include?( destination )
    end
  end

  def parse_date( date_string )

  end

end