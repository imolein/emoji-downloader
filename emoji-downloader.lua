#!/usr/bin/env lua

package.path = './src/?.lua;' .. package.path

local ed = require('emoji_downloader')
local lfs = require('lfs')
local inspect = require('inspect')

local options = {
  dest = '/tmp/emoji_downloader/', -- destination root
  verbose = false
}

if not ed._exists(options.dest) then
  lfs.mkdir(options.dest)
end

-- check given arguments first
if #arg > 1 then
  if arg[1]:lower() == '-v' then
    options.verbose = true
  end
  
  if ed._validate_url(arg[2]) then
    options.url = arg[2]
  else
    ed._show_help()
  end
elseif #arg == 1 and ed._validate_url(arg[1]) then
  options.url = arg[1]
else
  ed._show_help()
end

-- remove trailing / from url, if given and set download folder
options.url = ( options.url:sub(-1) == '/' and options.url:sub(1, -2) ) or options.url
options.dest = options.dest .. options.url:match('^https?://([%w%.]+%w+)/?$') .. '/'
print(options.dest)
--- Emoji Downloader
-- Arguments:
-- url = string
-- download_folder = string
-- custom_emoji_path = string (optional) (default: '/api/v1/custom_emojis')
ed(options)