# Download MP3 files from http://www.myinstants.com.
# Change the value of TOTAL_PAGES if you want to download more files.

require 'rubygems'
require 'bundler/setup'
require 'open-uri'
Bundler.require

TOTAL_PAGES = 7
not_downloaded = []
audios = []

class Audio
  attr_accessor :name, :path
  def initialize(name, path)
    @name = name
    @path = name
  end
end

Parallel.map(1..TOTAL_PAGES, :in_threads=> 10, :progress => "Get URLSs") do |page|
  page = Nokogiri::HTML(open("http://www.myinstants.com/?page=#{page+1}"))  
  page.css("div.small-button").each do |link|
    begin 
      l = link.to_s.split[2]
      end_at = l.index("mp3")
      start_at = l.index("'")
      sound_path = l[start_at + 1, end_at-12]
      name_audio =  sound_path[sound_path.rindex("/")+1..sound_path.size]
      audios << Audio.new(name_audio, sound_path)
    rescue
      # who cares 
    end
  end
end

Parallel.map(audios, :in_threads=> 10, :progress => "Downloading audios") do |audio|
 begin
   download = open("http://www.myinstants.com/media/sounds/#{audio.path}")
   IO.copy_stream(download, "#{Dir.home}/audios/#{audio.name}")
 rescue => e
   not_downloaded << audio.name
 end
end

puts "#{not_downloaded.size} failed"
