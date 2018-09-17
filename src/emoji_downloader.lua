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
local lfs = require('lfs')

local emoji_downloader = {}


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
function emoji_downloader.main(opts)
  local url = assert((opts.url), 'URL needed!')
  local d_folder = opts.dest or './download/'
  local ce_path = opts.ce_path or '/api/v1/custom_emojis'
  if not exists(d_folder) then lfs.mkdir(d_folder) end

  local emoji_list = assert(requests.get(url .. ce_path).json())
  
  for _, e in ipairs(emoji_list) do
    local success, err = download_file(e.url, e.shortcode, d_folder)
    
    if not success then
      io.write(('The following error occured during the download of %s: %s\n'):format(e.shortcode, err))
    else
      if opts.verbose then
        io.write(('Downloaded emoji: %s\n'):format(e.shortcode))
      end
    end
  end
  
  io.write(('Look into folder %s to find the downloaded emoji\'s!\n'):format(d_folder))
end




setmetatable(emoji_downloader, {
    __call = function(_, opts)
      return emoji_downloader.main(opts)
    end
  }
)

return emoji_downloader