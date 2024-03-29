# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2010-2019 RedmineUP
# http://www.redmineup.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

class RecentlyViewed < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  attr_protected :id if ActiveRecord::VERSION::MAJOR <= 4
  safe_attributes 'viewer'

  RECENTLY_VIEWED_LIMIT = 5

  belongs_to :viewer, :class_name => 'User', :foreign_key => 'viewer_id'
  belongs_to :viewed, :polymorphic => true

  validates_presence_of :viewed, :viewer

  # after_save :increment_views_count
  def self.last(limit=RECENTLY_VIEWED_LIMIT, usr=nil)
    RecentlyViewed.where("#{RecentlyViewed.table_name}.viewer_id" => usr || User.current).order("#{RecentlyViewed.table_name}.updated_at DESC").limit(limit).collect{|v| v.viewed}.select(&:visible?).compact
  end

  private

  def increment_views_count
    self.increment!(:views_count)
  end

end
