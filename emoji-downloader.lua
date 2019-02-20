--
-- Download emojis from mastodon or pleroma instances
--

local copas = require('copas')
local http = require('copas.http')
local limit = require('copas.limit')
local ltn12 = require('ltn12')
local argparse = require('argparse')
local url_parser = require('socket.url').parse
local json = require('rapidjson').decode
local exists = require('path.fs').exists
local mkdir = require('path.fs').makedirs

http.SSLPROTOCOL = 'tlsv1_2'
http.USERAGENT = 'emoji-downloader/1.0-0 (https://codeberg.org/imo/emoji-downloader)'

-- Parse given arguments
local function parse_args()
  local opts
  local parser = argparse({
    name = 'emoji-downloader',
    description = 'Download emojis from mastodon or pleroma instances.'
  })

  parser:option('-a --apipath', 'Define the custom emoji api path', '/api/v1/custom_emojis')
  parser:option('-c --concurrent', 'Concurrent downloads', 5)
    :convert(tonumber)
  parser:option('-d --dir', 'Define the directory where the downloaded emoji\'s are stored', '/tmp/')
  parser:flag('-v --verbose', 'Shows a message per downloaded emoji')
  parser:argument('url', 'The URL of the instance, from where you want to download the emoji\'s')
    :args(1)
    :action(function(dt, index, arg)
      local parsed = url_parser(arg)
      local url = parsed.scheme and arg or 'https://' .. arg
      dt[index] = ( url:sub(-1) == '/' and url:sub(1, -2) ) or url
    end)

  opts = parser:parse()
  opts.dir = opts.dir .. opts.url:match('^https?://([%w%.]+%w+)/?$') .. '/'

  return opts
end

-- Download custom emoji list from given url
local function download_list(url)
  local jresp, resp, err

  copas.addthread(function(_url)
    resp, err = http.request(_url)
  end, url)

  copas.loop()

  assert(resp, ('Download of emoji list failed with: %s'):format(err))

  jresp, err = json(resp)

  assert(jresp, ('Decoding of JSON object failed: %s'):format(err))

  return jresp
end

-- Downloads and saves the emoji
-- Works only inside copas dispatcher
local function download_file(url, filename, folder, verbose)
  local _, code = http.request({
    url = url,
    method = 'GET',
    sink = ltn12.sink.file(io.open(folder .. filename, 'wb')),
    redirect = 'all'
  })

  if verbose and code == 200 then
    io.write(('[INFO] Downloaded emoji: %s\n'):format(filename))
  end
end

-- main function
local function main()
  local opts = parse_args()

  io.write('[INFO] emoji-downloader started...\n')

  if not exists(opts.dir) then
    assert(mkdir(opts.dir), '[ERROR] Couldn\'t create directory!')

    io.write(('[INFO] Created folder %s\n'):format(opts.dir))
  end

  io.write(('[INFO] Download custom emoji list from %s\n'):format(opts.url))
  local emoji_list = download_list(opts.url .. opts.apipath)

  io.write(('[INFO] Start downloading %d emojis to %s\n'):format(#emoji_list, opts.dir))
  copas.addthread(function(list, _opts)
    local query = limit.new(_opts.concurrent)

    for _, e in ipairs(list) do
      local filename = e.shortcode .. e.url:match('https?://.+/.*(%.%w+)[%?%d]*$')

      query:addthread(download_file, e.url, filename, _opts.dir, _opts.verbose)
    end

    query:wait()
  end, emoji_list, opts)

  copas.loop()
  io.write(('[INFO] Done! You can find the emoji\'s in %s\n'):format(opts.dir))
end

main()