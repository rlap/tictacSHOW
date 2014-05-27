# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    ActionController::Base.helpers.asset_path("placeholder.png")
  end

  version :thumb do
    process :resize_to_fill => [200, 200]
  end

  # Create different versions of your uploaded files:

  version :player1_board do
    process :add_red
    process :resize_to_fill => [100,100]
  end

  version :player2_board do
    process :add_blue
    process :resize_to_fill => [100,100]
  end

  def add_blue
    manipulate! do |img|
      img = img.colorize(0,0,0.40,'blue')
    end
  end

  def add_red
    manipulate! do |img|
      img = img.colorize(0.40,0,0,'red')
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
