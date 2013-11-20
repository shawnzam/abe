class AddAttachmentLinksFToScrapes < ActiveRecord::Migration
  def self.up
    change_table :scrapes do |t|
      t.attachment :links_f
    end
  end

  def self.down
    drop_attached_file :scrapes, :links_f
  end
end
