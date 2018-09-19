#!/usr/bin/env lua
--
-- Copyright © 2018 Sebastian Huebner
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file or http://www.wtfpl.net/ 
-- for more details.

package.path = './src/?.lua;' .. package.path

require('emoji_downloader')(arg)