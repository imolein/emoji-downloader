#!/usr/bin/env lua

package.path = './src/?.lua;' .. package.path

local emoji_downloader = require('emoji_downloader')

local options = {
  dest = './download/', -- destination root
  verbose = false
}

local function show_help()
  io.write('Use the script like this:\n' ..
    '  emoji_downloader.lua "https://example.com"\n' ..
    'or in verbose mode:\n' ..
    '  emoji-downloader.lua -v "https://example.com"\n\n')
  os.exit(1)
end

-- returns the url if valid, if not it return nil
local function validate_url(url)
  return url:match('^https?://[%w%.]+%w+/?$')
end

-- check given arguments first
if #arg > 1 then
  if arg[1]:lower() == '-v' then
    options.verbose = true
  end
  
  if validate_url(arg[2]) then
    options.url = arg[2]
  else
    show_help()
  end
elseif #arg == 1 and validate_url(arg[1]) then
  options.url = arg[1]
else
  show_help()
end

-- remove trailing / from url, if given and set download folder
options.url = ( options.url:sub(-1) == '/' and options.url:sub(1, -2) ) or options.url
options.dest = options.dest .. options.url:match('^https?://([%w%.]+%w+)/?$') .. '/'

--- Emoji Downloader
-- Arguments:
-- url = string
-- download_folder = string
-- custom_emoji_path = string (optional) (default: '/api/v1/custom_emojis')
emoji_downloader(options)