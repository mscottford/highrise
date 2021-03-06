require 'active_resource'
$:.unshift(File.dirname(__FILE__))

require 'highrise/base'
require 'highrise/pagination'
require 'highrise/taggable'
require 'highrise/subject'
require 'highrise/comment'
require 'highrise/company'
require 'highrise/email'
require 'highrise/group'
require 'highrise/kase'
require 'highrise/membership'
require 'highrise/note'
require 'highrise/person'
require 'highrise/task'
require 'highrise/user'
require 'highrise/tag'
require 'highrise/date_format'

module Highrise
  PAGE_LIMIT = 500
end
