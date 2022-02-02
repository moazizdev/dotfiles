Ticker
======

A tiny, one-source-file C program used to create a scrolling "news ticker" effect in programs like Conky.

It reads from standard input until EOF is encountered, then outputs a portion of its input to standard output. Which portion is output depends on the modulus of the current system time. When called repeatedly over time, the output appears to scroll horizontally.

Usage Example
-------------

```bash
# Display the currently-playing song in MPD using a scrolling ticker.
mpc current | ticker --length=50 --always-scroll
```

Options
-------

`ticker` accepts the following options:

`-a`, `--always-scroll`

>  Always scroll, even when the input length is less than the ticker length.

`-b char`, `--blank=char`

> Fill blank space with 'char'. Defaults to ' '.

`-l N`, `--length=N`

> The length, in columns, of the output. Defaults to 80.

`-r`, `--reverse`

> Scroll from left to right, instead of the default (right to left).

`-t ms`, `--tick=ms`

> The amount of time, in milliseconds, it takes for the ticker to move by one character. Defaults to 100.

Compilation
-----------

On any Linux system with GCC installed, you should be able to just run `compile.sh`, then copy the generated `ticker` executable anywhere on your PATH to use it. As far as I know, it has no dependencies outside of the C standard library.

Caveats
-------

- `ticker` was designed to be small and fast, so the only input formatting it performs is removing a trailing newline if one exists. Other newlines will still be contained in the output, which will look ugly. If the input you are passing to `ticker` may contain newlines, consider piping the output of `ticker` through another program that will replace the newlines with spaces.

- Only UTF-8 input is supported. If your system's default encoding is something other than UTF-8, I can't guarantee that `ticker` will work correctly (or at all). 7-bit ASCII input should be fine, because ASCII is a subset of UTF-8.

Why?
----

Horizintally-scrolling text in conky seems like a simple task (I've seen people implement it using `sed` and some clever shell tricks), so why did I write a C program to do it?

One reason is performance. When a program is called over and over, possibly every 100ms, it needs to be fast and light. Any `bash` script is likely to be slower than `ticker`, simply because a `bash` script would likely involve running several processes, while `ticker` is a self-contained, standalone executable.

However, the main reason was as an excuse to teach myself more about C. After taking a college class on C and C++ programming, I wanted to try writing something in C that I would actually use. Because I don't have much experience in C, I can't guarantee that everything in `ticker` is written in the "best" possible way (constructive criticism is appreciated!), but it's a fairly simple program and it seems completely stable.

License
-------

This program is distrubuted under the BSD license:

    Copyright (c) 2013, Adam R. Nelson
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification,
    are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
       list of conditions and the following disclaimer.
       
    2. Redistributions in binary form must reproduce the above copyright notice,
       this list of conditions and the following disclaimer in the documentation
       and/or other materials provided with the distribution.
      
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
    TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
    THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

