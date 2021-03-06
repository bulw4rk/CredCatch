#!/usr/bin/env ruby

require 'mechanize'
require 'nokogiri'
require 'namae'
require 'optparse'
require 'ruby-progressbar'
require './lib/e.rb'

trap "SIGINT" do
  puts "\nBye Bye, thanks for using CredE :)"
  exit 130
end

ARGV << '-h' if ARGV.empty?

options = {}
optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
    opts.banner = "Usage: CredE.rb " 
    # Define the options, and what they do
    options[:company] = false
    opts.on( '-c', '--company "Company, Inc"', 'Name of Company on LinkedIn' ) do|company|
        options[:company] = company
    end

    options[:domain] = false
    opts.on( '-d', '--domain company.com', 'Domain name used with Email' ) do|domain|
        options[:domain] = domain
    end

    options[:format] = false
    opts.on( '-f', '--format "{first}.{last}@{domain}"', 'Format of email' ) do|email_format|
        options[:format] = email_format
    end

    options[:outfile] = false
    opts.on( '-o', '--outfile emails.txt', 'File to save the results' ) do|outfile|
        options[:outfile] = outfile
    end
    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
    end
end

optparse.parse!

if options[:domain] and options[:company] and options[:format]
    puts "[*] Initializing CredE..."
    credE = CredE.new(options[:domain], options[:company], options[:format])
    puts "[+] Starting scan against #{options[:company]}"
    emails = credE.scan()
    puts ""
    puts "[*] Scan complete! Generated #{emails.length} emails!"
    puts ""

    if options[:outfile]
        file = File.open(options[:outfile], "w+")
        emails.each do |email|
            file.write(email + "\n")
        end
        file.close
        puts "[+] Emails saved to #{options[:outfile]}"
    else
        puts emails
    end
end


