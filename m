Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF831ADB01
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgDQKZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 06:25:18 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:51859 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbgDQKZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 06:25:16 -0400
Received: from mail-qv1-f53.google.com ([209.85.219.53]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MVaQW-1jqzE40EHE-00RZzt; Fri, 17 Apr 2020 12:25:12 +0200
Received: by mail-qv1-f53.google.com with SMTP id fb4so607467qvb.7;
        Fri, 17 Apr 2020 03:25:11 -0700 (PDT)
X-Gm-Message-State: AGi0PuZWLl2qM+AGVO525O3nGWCzx7Bs8FZF7lV45SVq3IIic1k2JjTk
        PboGWa2pbEfvTS5bnIeaWYDOccnZJSfx34Qkr7E=
X-Google-Smtp-Source: APiQypIB2zeumiLa3MV5PYzBoQjOUFtHKNbyl4fGbow5Q2vMaBcCtz4gWpqlw/ntLojC4LisiS1Dfdptk6HkaKY1e3k=
X-Received: by 2002:a0c:eb11:: with SMTP id j17mr1919854qvp.197.1587119110584;
 Fri, 17 Apr 2020 03:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200417011146.83973-1-saeedm@mellanox.com>
In-Reply-To: <20200417011146.83973-1-saeedm@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 17 Apr 2020 12:24:54 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2LXR1pHoid7F69Q6VZp4E0g-Fcdt03PaGdebxWpguexw@mail.gmail.com>
Message-ID: <CAK8P3a2LXR1pHoid7F69Q6VZp4E0g-Fcdt03PaGdebxWpguexw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Pitre <nico@fluxnic.net>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Leon Romanovsky <leon@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        David Airlie <airlied@linux.ie>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:FKewQyedx4MT95mr2TOU1/1mQ/CNhYY4mnJwtHzgnmnsXdB4uTA
 ArAC2d45lYaeKOWrsZAG3xBhidATB0pcOOJ2olVR7ReDdiZMlCmq0NZUcK1XcikzVNY+oyq
 w2BcTGBN/hfdmxJDGslVB7zgSthwoDNqb4ylOQx5JEJMPf6Ha44HQ9P89BhU37mgH+HDzjK
 /WSoS9FWp40Yghdkai1Ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:68JXqcqwA1Q=:o2PR7LcuJAO/9T3Pf5qxuV
 boVSQg7iRUg6VH8QKZclMmfu7cSx1dd/26lov4u6YPbgmOy+CiiG8vs046gVs9XjvKwq60oYW
 1UU9msB5FvsX5TGu+wjMTOPmLbHp8y7V/zC2x+ox1sPnn4THnZLRLaFMTYv8rhhKaJAmUIrEC
 d3yDwssBf2Q/q13er8PBNVpt1aGKhAaF974e+d8q38V6KvxdC0KlJWI8AwuIs4M9PYcXUb8u4
 iQ8cMeh2Mzg78fpW0XG+WTlJd5c/KFn8Ky8Sud2MO10Fu5jqe9ibEi9Ncr2BODtG4HlhMAVQm
 6j4MM/w9MBPou5MxuCR8gCYgoq9Wlo5uOfpqh7wdKA2l9nPzhThh2erYAYYkl/+Rpe6dXcoxb
 /JndQ7+ye4gEVKXVQm6/yH5RWjdFsrk2zxVnqeUGZ4x4Hx5o6k/hF7k35vNUNZjbYDKcDlKH4
 EV7TVruo7sAKhJL88/jG2EBfTtiONUUYZBkW+izhdnsScoQ1SxnQXOMPM6hxFGuf1S8GxX0yl
 XrgfvzdkEZvGyS+l/5oq4xCNGhEIKGYUZjT9kQztklArZFe8t7jC1o4AHnLdGZOn/3fLiAGG0
 b2dDuaJt2ykdPZGo5qwgOIDBrh8x9Eph5iPG8mW9X/1z7gF5lt3Z5Cv8EoiNU9dSx984aiylM
 yue36YGGDkQ6s3h/zLeWON63sfPfmr18UoWpv0v8FraDnzU0uXoy+2P1MUWRjFdiQUoDoiXqh
 MSDSIKSLqwrCWOexFBY9/JgRB385P0ae9jum8b+J0vR99JEH6Tq4VfiKU6hxR6qdI2Gj8XXUM
 7vAF/aeoD63NYVqpMuiW1TVd/zTHVky+2rovxuAogbiqkBe2Fo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 3:12 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Due to the changes to the semantics of imply keyword [1], which now
> doesn't force any config options to the implied configs any more.
>
> A module (FOO) that has a weak dependency on some other modules (BAR)
> is now broken if it was using imply to force dependency restrictions.
> e.g.: FOO needs BAR to be reachable, especially when FOO=y and BAR=m.
> Which might now introduce build/link errors.
>
> There are two options to solve this:
> 1. use IS_REACHABLE(BAR), everywhere BAR is referenced inside FOO.
> 2. in FOO's Kconfig add: depends on (BAR || !BAR)
>
> The first option is not desirable, and will leave the user confused when
> setting FOO=y and BAR=m, FOO will never reach BAR even though both are
> compiled.
>
> The 2nd one is the preferred approach, and will guarantee BAR is always
> reachable by FOO if both are compiled. But, (BAR || !BAR) is really
> confusing for those who don't really get how kconfig tristate arithmetics
> work.
>
> To solve this and hide this weird expression and to avoid repetition
> across the tree, we introduce new keyword "uses" to the Kconfig options
> family.
>
> uses BAR:
> Equivalent to: depends on symbol || !symbol
> Semantically it means, if FOO is enabled (y/m) and has the option:
> uses BAR, make sure it can reach/use BAR when possible.
>
> For example: if FOO=y and BAR=m, FOO will be forced to m.
>
> [1] https://lore.kernel.org/linux-doc/20200302062340.21453-1-masahiroy@kernel.org/

Thanks a lot for getting this done. I've tried it out on my randconfig
build tree
and can confirm that this works together with your second patch to address the
specific MLX5 problem.

I also tried out replacing all other instances of 'depends on FOO ||
!FOO', using
this oneline script:

git ls-files | grep Kconfig |  xargs sed -i
's:depends.on.\([A-Z0-9_a-z]\+\) || \(\1 \?= \?n\|!\1\):uses \1:'

Unfortunately, this immediately crashes with:

$ make -skj30
how to free type 0?
double free or corruption (fasttop)
make[6]: *** [/git/arm-soc/scripts/kconfig/Makefile:71: olddefconfig]
Aborted (core dumped)
make[5]: *** [/git/arm-soc/Makefile:587: olddefconfig] Error 2
make[4]: *** [/git/arm-soc/scripts/kconfig/Makefile:95:
allrandom.config] Error 2
make[3]: *** [/git/arm-soc/Makefile:587: allrandom.config] Error 2
make[2]: *** [Makefile:180: sub-make] Error 2
make[2]: Target 'allrandom.config' not remade because of errors.
make[1]: *** [makefile:127: allrandom.config] Error 2

It's probably easy to fix, but I did not look any deeper into the bug.

       Arnd
