class UserResource < ActiveRecord::Base
  
  AUDIO_EXTENSIONS = ['mp3', 'aac', 'flac', 'm4a', 'wav', 'ogg']
  IMAGE_EXTENSIONS = ['png', 'jpg']
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
      puts AUDIO_EXTENSIONS.include? extension
      if AUDIO_EXTENSIONS.include? extension
        #resource_icon = 'fa fa-file-audio-o fa-2x'
        resource_icon = 'icono icono-music'
      elsif TEXT_EXTENSIONS.include? extension
        #resource_icon = 'fa fa-file-text fa-2x'
        resource_icon = 'icono icono-document'
      elsif IMAGE_EXTENSIONS.include? extension
        resource_icon = 'icono icono-image'
      else
        #resource_icon = 'fa fa-file-o fa-2x'
        resource_icon = 'icono icono-file'
      end
      resource_icon
    end
  end

  def file_url
    address = ''
    if self['resource_name']
      address = '//s3.amazonaws.com/' + BUCKET_NAME + "/uploads/#{self['user_id']}/#{self['resource_name']}"
    end
    address
  end
  
end
