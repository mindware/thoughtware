# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130318011527) do

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",     :default => 0
    t.string   "commentable_type",   :default => ""
    t.string   "title",              :default => ""
    t.text     "body",               :default => ""
    t.string   "subject",            :default => ""
    t.integer  "user_id",            :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_score", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
  end

  add_index "comments", ["cached_votes_down"], :name => "index_comments_on_cached_votes_down"
  add_index "comments", ["cached_votes_score"], :name => "index_comments_on_cached_votes_score"
  add_index "comments", ["cached_votes_total"], :name => "index_comments_on_cached_votes_total"
  add_index "comments", ["cached_votes_up"], :name => "index_comments_on_cached_votes_up"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "posts", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "status"
    t.string   "thumbnail_url"
    t.text     "thumbnail_code"
    t.text     "auto_embed"
    t.text     "manual_embed"
    t.integer  "comments_last_author"
    t.integer  "views"
    t.date     "last_viewed_date"
    t.integer  "link_directly"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "domain"
    t.integer  "cached_votes_total",    :default => 0
    t.integer  "cached_votes_score",    :default => 0
    t.integer  "cached_votes_up",       :default => 0
    t.integer  "cached_votes_down",     :default => 0
    t.integer  "cached_comments_total", :default => 0
  end

  add_index "posts", ["cached_comments_total"], :name => "index_posts_on_cached_comments_total"
  add_index "posts", ["cached_votes_down"], :name => "index_posts_on_cached_votes_down"
  add_index "posts", ["cached_votes_score"], :name => "index_posts_on_cached_votes_score"
  add_index "posts", ["cached_votes_total"], :name => "index_posts_on_cached_votes_total"
  add_index "posts", ["cached_votes_up"], :name => "index_posts_on_cached_votes_up"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "nickname"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
