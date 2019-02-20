rockspec_format = '3.0'
package = 'emoji-downloader'
version = '1.0-0'
source = {
  url = "git://github.com/imolein/emoji-downloader",
  tag = "v1.0-0"
}
description = {
  summary = 'Download Pleroma or Mastodon custom emojis',
  detailed = [[
    Do you ever thought: "Oh, this instance have nice emoji's,
    I want them too."? Then just use this script to download
    them.
  ]],
  homepage = 'https://git.kokolor.es/imo/emoji-downloader',
  license = 'Unlicense'
}
dependencies = {
  'lua >= 5.3',
  'lpath',
  'copas',
  'rapidjson',
  'argparse',
  'luasocket',
  'luasec'
}

build = {
  type = 'none',
  install = {
    bin = {
      ['emoji-downloader'] = 'emoji-downloader.lua'
    }
  }
}
