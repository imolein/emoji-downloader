#!/usr/bin/env lua
--
-- Download emojis from mastodon or pleroma instances
--
-- Copyright © 2018 Sebastian Huebner
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file or http://www.wtfpl.net/ 
-- for more details.

local requests = require('requests')

local emoji_downloader = {}


local function show_help()
  io.write('emoji-downloader: emoji-downloader [OPTIONS] URL\n' ..
    'Download custom emoji\'s from a Pleroma or Mastodon instance.\n\n' ..
    'Useable options:\n' ..
    '  -d FOLDER      Define the folder where the downloaded emoji\'s are stored (default: /tmp)\n' ..
    '  -ap API PATH   Define the custom emoji api path (defaul: /api/v1/custom_emojis)\n' ..
    '  -h             Shows this message\n' ..
    '  -v             Verbose - shows a message per downloaded emoji\n\n')
  os.exit(1)
end

-- checks if file exists
local function exists(file)
  local ok, err, code = os.rename(file, file)

  if not ok then
    if code == 13 then
      return true
    end
  end

  return ok, err
end

local function mkdir(path)
  local ok = os.execute('mkdir -p ' .. path)

  return ok
end

-- returns the url if valid, if not it return nil
local function validate_fqdn(url)
  return url:match('^https?://[%w%.]+%w+/?$')
end

local function finalize_opts(opts)
  assert(validate_fqdn(opts.url), 'URL format incorrect!')
  opts.url = ( opts.url:sub(-1) == '/' and opts.url:sub(1, -2) ) or opts.url
  opts.dest = (( opts.dest:sub(-1) ~= '/' and opts.dest .. '/' ) or opts.dest ) ..
    opts.url:match('^https?://([%w%.]+%w+)/?$') .. '/'

  return opts
end

local function parse_args(args)
  local opts = {
    verbose = false,
    url = args[#args],
    ce_api_path = '/api/v1/custom_emojis',
    dest = '/tmp/'
  }

  for i, a in ipairs(args) do
    if a == '-h' then
      show_help()
    elseif a == '-d' then
      opts.dest = args[i + 1]
    elseif a == '-v' then
      opts.verbose = true
    elseif a == '-ap' then
      opts.ce_api_path = args[i + 1]
    end
  end

  return finalize_opts(opts)
end

-- downloads and saves the emoji
local function download_file(url, shortcode, folder)
  local file_name = shortcode .. url:match('https?://.+/.*(%.%w+)[%?%d]*$')
  local resp, err = requests.get(url)

  if not resp then return nil, err end

  local file = io.open(folder ..'/' .. file_name, 'w')
  file:write(resp.text)
  file:close()

  return true  
end

-- main function
function emoji_downloader.main(args)
  local opts = parse_args(args)

  if not exists(opts.dest) then assert(mkdir(opts.dest), 'Couldn\'t create directory!') end

  local emoji_list = assert(requests.get(opts.url .. opts.ce_api_path).json())

  for _, e in ipairs(emoji_list) do
    local success, err = download_file(e.url, e.shortcode, opts.dest)

    if not success then
      io.write(('The following error occured during the download of %s: %s\n'):format(e.shortcode, err))
    else
      if opts.verbose then
        io.write(('Downloaded emoji: %s\n'):format(e.shortcode))
      end
    end
  end
  
  io.write(('Look into folder %s to find the downloaded emoji\'s!\n'):format(opts.dest))
end


setmetatable(emoji_downloader, {
    __call = function(_, opts)
      return emoji_downloader.main(opts)
    end
  }
)

return emoji_downloader