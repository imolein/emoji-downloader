# emoji-downloader

Do you ever thought: "Oh, this instance have nice emoji's, I want them too."? Then just use this script to download them.

Inspired by [emoji-stealer](https://github.com/mirro-chan/emoji-stealer)

**Note:** I'm still learning, so if you find weird stuff in my code, please inform me about it and/or tell me how I can inprove it. I'm happy about any input :)

## Dependencies

* lua (>=5.1)
* [lua-requests](https://github.com/JakobGreen/lua-requests)
* [lpath](https://github.com/starwing/lpath)

## Install

The easiest way to install this script is to install it directly with [luarocks](https://luarocks.org/#quick-start) like this:

```
luarocks install https://raw.githubusercontent.com/imolein/emoji-downloader/master/emoji-downloader-scm-0.rockspec
```

But you can also clone this git, install the dependencies listed above using [luarocks](https://luarocks.org/#quick-start) and run the script directly.

```
luarocks install lua-requests
```

### Using standalone version

I created a standalone version of the script, using [amalg](https://github.com/siffiejoe/lua-amalg), where all used modules packed into one file. So you only need the lua5.3 interpreter to run the script. You can find it under [Releases](https://git.kokolor.es/imo/emoji-downloader/releases).

## Usage

If installed directly with **luarocks** use it like this:

```
emoji-downloader: emoji-downloader [OPTIONS] URL
Download custom emoji's from a Pleroma or Mastodon instance.

Useable options:
  -d FOLDER      Define the folder where the downloaded emoji's are stored (default: /tmp)
  -ap API PATH   Define the custom emoji api path (defaul: /api/v1/custom_emojis)
  -et            Generates the emoji.txt which is needed for Pleroma
  -h             Shows this message
  -v             Verbose - shows a message per downloaded emoji

```

If you cloned this repository and installed only the dependencies with luarocks, you can use it the same way as described above, but with .lua file extension at the end:

```
lua emoji-downloader.lua "https://example.com"
```


## Works with

* [Pleroma](https://pleroma.social)
* [Mastodon](https://joinmastodon.org)
