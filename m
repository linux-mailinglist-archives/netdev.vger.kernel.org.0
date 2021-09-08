Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DCE403E0D
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352331AbhIHRBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:01:41 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:57721 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbhIHRBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 13:01:37 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M6m5o-1mJ4SL3CGc-008NXK; Wed, 08 Sep 2021 19:00:27 +0200
Received: by mail-wr1-f53.google.com with SMTP id u16so4327339wrn.5;
        Wed, 08 Sep 2021 10:00:27 -0700 (PDT)
X-Gm-Message-State: AOAM530TSVs4nXTroFkyvh+EmOFoJIoK6laTjNuIVhTKqXAmKNIq8f6g
        x8jg7cyXzIovoNKzgymCd5qldoiO+Ji5CZ7P/9w=
X-Google-Smtp-Source: ABdhPJyYNXeDhP7tF/CQVrRXGqA7/4dQLSqX4A+t3+NBG0pTxZiUHLknZtZJu6K+3Y44ngnMkF1tXPm1YREuwJxZQJM=
X-Received: by 2002:adf:f884:: with SMTP id u4mr5014871wrp.411.1631120427390;
 Wed, 08 Sep 2021 10:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <92c20b62-c4a7-8e63-4a94-76bdf6d9481e@kernel.org> <CAHk-=wiynwuneR4EbUNtd2_yNT_DR0VQhUF1QOZ352D-NOncjQ@mail.gmail.com>
 <a2c18c6b-ff13-a887-dd52-4f0aeeb25c27@kernel.org> <CAHk-=whcFKGyJOgmwJtWwDCP7VFPydnTtsvjPL6ZP6d6gTyPDQ@mail.gmail.com>
 <CAHk-=wi+O66NwiiAYBeS6kiix6YGuDvPf-MPddtycE_D4fWV=g@mail.gmail.com>
In-Reply-To: <CAHk-=wi+O66NwiiAYBeS6kiix6YGuDvPf-MPddtycE_D4fWV=g@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Sep 2021 19:00:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3xjZovRz-iOPOC8jQPNsPcupQ5b3hpx-XNxP=oDqhtkQ@mail.gmail.com>
Message-ID: <CAK8P3a3xjZovRz-iOPOC8jQPNsPcupQ5b3hpx-XNxP=oDqhtkQ@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Xzw+e0Z0VljeF4RIdvS+7fav0y4fy6jnrMogsNrTE2J7FZCg6n5
 nl/DwgDDJ7NlXzwlZthVo+pEnjktEkHkJMTNgJyOJtaJ0k1B1izH5DZa7+upZ8BAk3fyVcy
 LEYFLW7N6w26gCwSld/gLCMfn1wgKSzNcO4GEjwwu0pBr8VyE80FiZcZC5UOgpsf5FoEu5s
 oyB0Kl3ASysl4ZZV7FSDA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5TA6WGxdUkg=:EJPZEaMGYtwUpl/aR7KkZG
 f8dpWvuASx3w78ejtsUzTNiS33m3Z572YLrUJ0C92PUhHEqHVdwQ29E6wDv1N4lofAnvh1tf8
 EU166YP3DFjkxAJ8KNl0Pvb0UoEnU8Cp0oVnqjkTkmMjbFi47PRKyaMNaMtYIRD/auP6rk5P7
 jpsDJbG2Yvc3htBuL7U/nWg0MkM5IciRW78kMFuEwiokIKh3R5B0ajWq1nozjr0ilrOIeX+jj
 s+4YgOkdg7k8QpnUiipEEVhkxE3LTwyZp4G4LfENImO3wSVdR8NIOFHy4iv2ySeFHVTzxWMkn
 xkOvaJszdxX5fQJvav0O2TAvlmObim2yTUPjcQoUPbsnvzMsrXT3iJQkH1oYUx+wKz1ln7521
 cmJ+oNUcCZirNwgwHVeSz9I8wRKgxDQGvyXE20heU//BB1AFAqiqEPEACpUbfDMR98hKmili+
 15UaWcVsw4Yx5R4oxk//h/1cEh3rAvEwxQnTufQciuS6/ai0o93ELkUaLGEisQDANke4iv3EB
 TcwKeXD7UwIJEiGZVpOC0luLzSYYNKfNzIMJTXTAk905MDM7giwxMeDpe1kwn4mWYGKP41JF3
 2CVATBYue51Ll0/j2Q9ApP9eU8Ik6U8PO2L85h1zDyv3gdc7uPRiiCD1kIapF808XLbQR3ZQ1
 Fe8b5cs0ocOTkVhWeq32hu7Noaqq6wMebwYg8A/WtmYVli4UVOaMuw6rT3Foofd7gp902q8bs
 yLpvBLSR6XuOA2Pt7HFgn4ptfQfsIWGBUb0VLEjUIOdOi5wm9ekb4rbrXCabxsobboP3YsKda
 HfETM3zRfI5jo/UJNx+H8wT4ayo+GHeZxFssUVLtjRsF4ikPbhZxzXZdChD/dzyl9TUsZni3c
 ks9takDFLd8f6RGI8otA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 3:43 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Sep 7, 2021 at 6:35 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I think a lot of them have just copied the x86 code (it was 4k long
> > ago), without actually understanding all the details.
>
> Just to put the x86 number in perspective: it was raised to 8192 back
> in 2013, with the comment
>
>     x86/cpu: Increase max CPU count to 8192
>
>     The MAXSMP option is intended to enable silly large numbers of
>     CPUs for testing purposes.  The current value of 4096 isn't very
>     silly any longer as there are actual SGI machines that approach
>     6096 CPUs when taking HT into account.
>
>     Increase the value to a nice round 8192 to account for this and
>     allow for short term future increases.
>
> so on the x86 side, people have actually done these things.
>
> Other architectures? I think some IBM power9 machines can hit 192
> cores (with SMT4 - so NR_CPUS of 768), but I don't think there's been
> an equivalent of an SGI for anything but x86.
>
> But admittedly I haven't checked or followed those things. I could
> easily imagine some boutique super-beefy setup.

POWER10 was just announced with threads 1920 using SMT8,
I think the latest s390 and sparc64 (from 2017) are in the same
ballpark when using SMT. The largest arm64 I know of was ThunderX3
with 768 threads on dual-socket machines. This got cancelled before
it was shipped to customers, but it's likely that others will exceed that
in the future.

       Arnd
