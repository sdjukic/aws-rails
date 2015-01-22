class UserResource < ActiveRecord::Base
  
  AUDIO_EXTENSIONS = ['mp3', 'aac', 'flac', 'm4a', 'wav', 'ogg']
  TEXT_EXTENSIONS = ['pdf', 'txt', 'doc']
  
  belongs_to :user
  validates :user_id, presence: true
  validates :resource_url, presence: true
  validates :resource_name, presence: true
  validates_numericality_of :resource_size, :only_integer => true
  validates_inclusion_of :resource_size, :in => 1..4000000, :message => "Can be between 0 and 4MB"

  def file_extension
    if self['resource_name']
  	  extension = self['resource_name'].match(/(\w+)$/).to_s
      puts "Das extension est #{extension}"
      puts AUDIO_EXTENSIONS.include? extension
      if AUDIO_EXTENSIONS.include? extension
        #resource_icon = 'fa fa-file-audio-o fa-2x'
        resource_icon = 'icono icono-music'
      elsif TEXT_EXTENSIONS.include? extension
        #resource_icon = 'fa fa-file-text fa-2x'
        resource_icon = 'icono icono-document'
      else
        #resource_icon = 'fa fa-file-o fa-2x'
        resource_icon = 'icono icono-file'
      end
      resource_icon
    end
  end
end
