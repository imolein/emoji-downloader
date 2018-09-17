# emoji-downloader

Do you ever thought: "Oh, this instance have nice emoji's, I want them too."? Then just use this script to download them.

Inspired by [emoji-stealer](https://github.com/mirro-chan/emoji-stealer)

## Dependencies

* lua (>=5.1)
* [lua-requests](https://github.com/JakobGreen/lua-requests)
* [luafilesystem](https://github.com/keplerproject/luafilesystem)

## Install

The easiest way to install this script is to install it directly with [luarocks](https://luarocks.org/#quick-start) like this:

```
luarocks install https://raw.githubusercontent.com/imolein/emoji-downloader/master/emoji-downloader-scm-0.rockspec
```

But you can also clone this git, install the dependencies listed above using [luarocks](https://luarocks.org/#quick-start) and run the script directly.

```
luarocks install lua-requests
luarocks instlal luafilesystem
```

# Usage

If installed directly with **luarocks**:

```
emoji-downloader https://example.com
```

or if you want a message für each downloade emoji:

```
emoji-downloader -v https://example.com
```

If you cloned the repo, just use it like this:

```
lua emoji-downloader.lua "https://example.com"
```

or

```
lua emoji-downloader.lua -v "https://example.com"
```

## Works with

* [Pleroma](https://pleroma.social)
* [Mastodon](https://joinmastodon.org)

## TODO

* Configurable download folder via -d argument
* Clean this ugly code up