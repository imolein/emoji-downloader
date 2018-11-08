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
local exists = require('path.fs').exists
local mkdir = require('path.fs').makedirs

local emoji_downloader = {}

-- prints the help message
local function show_help()
  io.write('emoji-downloader: emoji-downloader [OPTIONS] URL\n' ..
    'Download custom emoji\'s from a Pleroma or Mastodon instance.\n\n' ..
    'Useable options:\n' ..
    '  -d FOLDER      Define the folder where the downloaded emoji\'s are stored (default: /tmp)\n' ..
    '  -ap API PATH   Define the custom emoji api path (defaul: /api/v1/custom_emojis)\n' ..
    '  -et            Generates the emoji.txt which is needed for Pleroma\n' ..
    '  -h             Shows this message\n' ..
    '  -v             Verbose - shows a message per downloaded emoji\n\n')
  os.exit(1)
end

-- returns the url if valid, if not it return nil
local function validate_fqdn(url)
  return url:match('^https?://[%w%.]+%w+/?$')
end

-- check and format the options
local function finalize_opts(opts)
  assert(validate_fqdn(opts.url), 'URL format incorrect!')
  opts.url = ( opts.url:sub(-1) == '/' and opts.url:sub(1, -2) ) or opts.url
  opts.dest = (( opts.dest:sub(-1) ~= '/' and opts.dest .. '/' ) or opts.dest ) ..
    opts.url:match('^https?://([%w%.]+%w+)/?$') .. '/'

  return opts
end

-- parse given arguments
local function parse_args(args)
  if #args == 0 then show_help() end

  local opts = {
    verbose = false,
    create_emoji_txt = false,
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
    elseif a == '-et' then
      opts.create_emoji_txt = true
    elseif a == '-ap' then
      opts.ce_api_path = args[i + 1]
    end
  end

  return finalize_opts(opts)
end

-- downloads and saves the emoji
local function download_file(url, filename, folder)
  local resp, err = requests.get(url)

  if not resp then return nil, err end

  local file = io.open(folder .. filename, 'wb')
  file:write(resp.text)
  file:close()

  return true
end

-- main function
function emoji_downloader.main(args)
  local opts = parse_args(args)

  if not exists(opts.dest) then assert(mkdir(opts.dest), 'Couldn\'t create directory!') end

  -- get the list of emoji's
  local emoji_list = assert(requests.get(opts.url .. opts.ce_api_path).json())

  -- iterate over the list and download the files to the given download destination
  for _, e in ipairs(emoji_list) do
    local filename = e.shortcode .. e.url:match('https?://.+/.*(%.%w+)[%?%d]*$')
    local success, err = download_file(e.url, filename, opts.dest)

    if success then
      if opts.verbose then
        io.write(('Downloaded emoji: %s\n'):format(e.shortcode))
      end

      if opts.create_emoji_txt then
        local file = io.open(opts.dest .. 'emoji.txt', 'a')

        if file then
          file:write(('%s, /emoji/custom/%s\n'):format(e.shortcode, filename))
          file:close()
        end
      end
    else
      io.write(('The following error occured during the download of %s: %s\n'):format(e.shortcode, err))
    end
  end

  io.write(('Look into folder %s to find the downloaded emoji\'s!\n'):format(opts.dest))
end

return emoji_downloader.main
