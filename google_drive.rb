# gem install google_drive
# ruby google_drive.rb --function_name='upload_file' --folder_name='API_GD' --file_name='rate.png' --path=/home/rigpa/rate.png --debug
# XXX NOT_WORKING XXX ruby google_drive.rb --function_name='download_file' --folder_name='API_GD' --file_name='rate.png' --path=/home/rigpa/new_rate.png --debug
# >> WILL DOWNLOAD CSV <<
# ruby google_drive.rb --function_name='download_sheet' --file_name='TestingSheet' --sheet_name='Sheet1' --path=/home/rigpa/testing_sheet_one.tsv --debug
# ruby google_drive.rb --function_name='update_sheet' --file_name='TestingSheet' --sheet_name='Sheet1' --path=/home/rigpa/testing_sheet_one.tsv --debug

require 'optparse'
require 'google_drive'
require 'csv'

class GD

  def self.download_file(session, options, debug)
    puts "Download file" if debug
    folder = session.file_by_title(options[:folder_name]) rescue nil
    if folder
      file = folder.file_by_title(options[:file_name]) rescue nil
      if file
        file.download_to_file(options[:path])
        puts "File downloaded"
      else
        puts "File not found"
      end
    else
      puts "Folder not found"
    end
  end

  def self.upload_file(session, options, debug)
    puts "Upload file" if debug
    folder = session.file_by_title(options[:folder_name]) rescue nil
    if folder
      folder.upload_from_file(options[:path], options[:file_name], convert: false)
      puts "File uploaded"
    else
      puts "Folder not found"
    end
  end

  def self.download_sheet(session, options, debug)
    puts "Download sheet" if debug
    spreadsheet = session.file_by_title(options[:file_name]) rescue nil
    if spreadsheet
      worksheet = spreadsheet.worksheet_by_title(options[:sheet_name]) rescue nil
      if worksheet
        if debug
          puts "Reached export as file step"
        end
        worksheet.export_as_file(options[:path])
        puts "Sheet downloaded"
      else
        puts "Worksheet not found"
      end
    else
      puts "Spreadsheet not found"
    end
  end

  def self.update_sheet(session, options, debug)
    puts "Update sheet" if debug
    spreadsheet = session.file_by_title(options[:file_name]) rescue nil
    if spreadsheet
      worksheet = spreadsheet.worksheet_by_title(options[:sheet_name]) rescue nil
      if worksheet
        worksheet.delete_rows(1, worksheet.num_rows)
        row = 1
        CSV.foreach(options[:path], :col_sep => "\t", :quote_char => "\x00") do |data|
          data.each_with_index do |value, col|
            worksheet[row, col+1] = value
          end
          row += 1
        end
        worksheet.save
        puts "Sheet updated"
      else
        puts "Worksheet not found"
      end
    else
      puts "Spreadsheet not found"
    end
  end
end

options = {}
OptionParser.new do |opt|
  opt.on('--function_name FUNCTIONNAME') { |o| options[:function_name] = o }
  opt.on('--folder_name FOLDERNAME') { |o| options[:report_type] = o }
  opt.on('--file_name FILENAME') { |o| options[:report_type] = o }
  opt.on('--sheet_name SHEETNAME') { |o| options[:from] = o }
  opt.on('--path PATH') { |o| options[:path] = o }
  opt.on('--debug', '--verbose')
end.parse!(into: options)

=begin
#Override the default method to convert them to tsv files instead csv
module GoogleDrive
  class Worksheet
    def tsv_export_url
      'https://docs.google.com/spreadsheets/d/%s/export?gid=%s&format=tsv' %
        [spreadsheet.id, gid]
    end

    def export_as_string
      @session.request(:get, tsv_export_url, response_type: :raw)
    end
  end
end
=end 

debug = false
debug = true if options[:debug]

puts "Debugging mode ON" if debug
puts options if debug

session = GoogleDrive::Session.from_service_account_key('credentials/gd_config.json')
GD.send(options[:function_name], session, options, debug)
