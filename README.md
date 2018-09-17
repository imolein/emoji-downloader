# emoji-downloader

Do you ever thought: "Oh, this instance have nice emoji's, I want them too."? Then just use this script to download them.

Inspired by [emoji-stealer](https://github.com/mirro-chan/emoji-stealer)

## Dependencies

* lua (>=5.1)
* [lua-requests](https://github.com/JakobGreen/lua-requests)

## Install

Since this script depends on [lua-requests](https://github.com/JakobGreen/lua-requests), you need [luarocks](https://luarocks.org/#quick-start) to install it.
If you have **luarocks** installed, install **lua-requests**:

```
luarocks install lua-requests
```

After this is done, clone this repository and run the script like this:

```
lua emoji-downloader.lua "https://example.com"
```



## Works with

* [Pleroma](https://pleroma.social)
* [Mastodon](https://joinmastodon.org)