class AddAttachmentResultFToScrapes < ActiveRecord::Migration
  def self.up
    change_table :scrapes do |t|
      t.attachment :result_f
    end
  end

  def self.down
    drop_attached_file :scrapes, :result_f
  end
end
