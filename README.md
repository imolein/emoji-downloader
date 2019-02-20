# emoji-downloader

Do you ever thought: "Oh, this instance have nice emoji's, I want them too."? Then just use this script to download them.

Inspired by [emoji-stealer](https://github.com/mirro-chan/emoji-stealer)

**Note:** I'm still learning, so if you find weird stuff in my code, please inform me about it and/or tell me how I can inprove it. I'm happy about any input :)

## Dependencies

* lua (>=5.1)
* [lpath](https://github.com/starwing/lpath)
* [copas](https://github.com/keplerproject/copas)
* [luasec](https://github.com/brunoos/luasec)
* [lua-rapidjson](https://github.com/xpol/lua-rapidjson)
* [argparse](https://github.com/mpeterv/argparse)

"Uhhh, why so much more dependencies?" you might think, so let me explain: The previous version depended on [lua-requests](https://github.com/JakobGreen/lua-requests), which has 5 dependencies on it's own, of which two were not even needed for this script. So we're at the same dependency level as before, but this time all dependencies are used. I could remove the argparse dependenciy and write my own short version, but...laziness. ;)

## Install

### Method one

* Download and install using the rockspec directly from the repository: `sudo luarocks install https://git.kokolor.es/imo/emoji-downloader/raw/branch/master/emoji-downloader-1.0-0.rockspec`
* The script should be installed in `/usr/local/bin/`, so you can use it like this: `emoji-downloader domain.tld`
* You can also use the `--local` option, if you don't want to install it global. If you do so, the script is install in `~/.luarocks/` and you have to use the full path to use it

### Method two

* Clone this git
* Change into the cloned folder
* Install dependencies:

```
luarocks init
luarocks init --reset
luarocks build --only-deps
```

* After the installation is complete you can run it like this: `./lua emoji-downloader.lua domain.tld`

## Usage

If installed directly with **luarocks** use it like this:

```
Usage: emoji-downloader [-a <apipath>] [-c <concurrent>] [-d <dir>]
       [-v] [-h] <url>

Download emojis from mastodon or pleroma instances

Arguments:
   url                   The URL of the instance, from where you want to download the emoji's

Options:
          -a <apipath>,  Define the custom emoji api path (default: /api/v1/custom_emojis)
   --apipath <apipath>
             -c <concurrent>,
   --concurrent <concurrent>
                         Concurrent downloads
      -d <dir>,          Define the directory where the downloaded emoji's are stored (default: /tmp/)
   --dir <dir>
   -v, --verbose         Shows a message per downloaded emoji
   -h, --help            Show this help message and exit.
```

If you cloned this repository and installed only the dependencies with luarocks, you can use it the same way as described above, but with .lua file extension at the end:

```
lua emoji-downloader.lua "https://example.com"
```

## Changelog

### 1.0-0 (2019-02-20)

* reworte most of the stuff
* concurrent download of emoji's (default 5 at once)
* Changed license from WTFPL to Unlicense

### scm-0 (2018-10-19)

* first version

## Works with

* [Pleroma](https://pleroma.social)
* [Mastodon](https://joinmastodon.org)
