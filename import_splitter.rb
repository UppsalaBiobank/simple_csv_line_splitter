## Due to FP limitations, most records for import need to be limited to around a 1000 lines. This will take a file and splint into chunks.
require 'csv'

input_file = './csv/PbVC.csv'
output_dir = './csv/inläsningsfiler/'
filename = 'PbVC'
chunk_size = 1000

headers = nil
chunk   = []
chunk_start = 1
file_count  = 1


CSV.foreach(input_file, col_sep: ';', headers: true) do |row|
  headers ||= row.headers

  chunk << row.fields

  if chunk.size == chunk_size
    chunk_end = chunk_start + chunk_size - 1
    output_file = "#{output_dir}#{filename}_#{chunk_start}-#{chunk_end}.csv"

    CSV.open(output_file, 'w', col_sep: ';') do |csv|
      csv << headers
      chunk.each { |r| csv << r }
    end

    puts "Written #{output_file}"
    chunk       = []
    chunk_start = chunk_end + 1
    file_count += 1
  end
end

# Write any remaining rows that didn't fill a full chunk
unless chunk.empty?
  chunk_end   = chunk_start + chunk.size - 1
  output_file = "#{output_dir}#{filename}_#{chunk_start}-#{chunk_end}.csv"

  CSV.open(output_file, 'w', col_sep: ';') do |csv|
    csv << headers
    chunk.each { |r| csv << r }
  end

  puts "Written #{output_file}"
end

puts "Done! #{file_count} files written."
