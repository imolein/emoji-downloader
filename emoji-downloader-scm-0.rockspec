package = 'emoji-downloader'
version = 'scm-0'
source = {
  url = "git://github.com/imolein/emoji-downloader",
  branch = "master"
}
description = {
  summary = 'Download Pleroma or Mastodon custom emojis',
  detailed = [[
    Do you ever thought: "Oh, this instance have nice emoji's,
    I want them too."? Then just use this script to download
    them.
  ]],
  homepage = 'http://olivinelabs.com/busted/',
  license = 'WTPFL <http://www.wtfpl.net/>'
}
dependencies = {
  'lua >= 5.1',
  'lua-requests',
  'lpath'
}

build = {
  type = 'builtin',
  modules = {
    ['emoji_downloader'] = 'src/emoji_downloader.lua'
  },
  install = {
    bin = {
      ['emoji-downloader'] = 'emoji-downloader.lua'
    }
  }
}
