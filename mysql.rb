require 'mysql2'

  client = Mysql2::Client.new(host: "localhost", username: "root", password: '', database: 'mysql')

  escaped = client.escape('performance_schema')
  results = client.query("SELECT Db  FROM db WHERE Db = '#{escaped}'")

  results.each do |row|
    puts row
    puts row['Db']
  end