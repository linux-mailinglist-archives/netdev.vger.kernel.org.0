Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF187403E18
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352389AbhIHRGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 13:06:37 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:41119 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbhIHRGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 13:06:36 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MTRhS-1mVbBL0h7E-00Thux; Wed, 08 Sep 2021 19:05:27 +0200
Received: by mail-wr1-f51.google.com with SMTP id v10so4350633wrd.4;
        Wed, 08 Sep 2021 10:05:27 -0700 (PDT)
X-Gm-Message-State: AOAM533pasDslRMzbtCw2nyHeiYYVu/vud7oIWn3KApxhwmjIfYPNkga
        9HS1qC/TZfwBTC025q5bOZr4qeEsOq5F4j7IHVA=
X-Google-Smtp-Source: ABdhPJzOUrSEiIv0q10uICqQrwOldGJmWwcvW1SLF5a8/urhNzDqKM4vL1/vvxLsqhtkj4EVD+XB1lj3zMjCDiekuuc=
X-Received: by 2002:a5d:528b:: with SMTP id c11mr5105672wrv.369.1631120726753;
 Wed, 08 Sep 2021 10:05:26 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com> <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
In-Reply-To: <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Sep 2021 19:05:09 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
Message-ID: <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:KH+Kxt+CxavGn9c2xFpOOUmelKCATtvt/4S0bYSXXPjVou+2tC5
 NxJSyIV8u09ba1J5Ik8WStxnWkH8HZfaHtNJOgW7Mw5LFW+6dHDV4xL6sdqDp2bW/pCN7Rd
 ggfjYkFTpadfC+HA9nT5XkgHk/+gnlvvI20PxmNzYp3J3dvwkga8+2IyH7HWmxjIv//N6GR
 OHGUEtAJAdJd+3XtZdDsw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UH8s4HJ8+3Y=:Jt2B6PVkZNHyYKm1twCnYl
 A5QIQEvwPJrI9L50mm1pS31gRjdFtMueLJ1PGBbzqw/Q0YLql3yY3mmrOKfwzgpdbhloGoo5G
 9J4UQLwjjNWXegDzDpcsxtkt8FdyIGs9aluH3xD6qp14EtNkE7ZLKH7wciIwmalxCLCHXviU8
 f0LY+qCK+b2t5Fmb9BnZq65l1wkcF0r5KD2ys96zqcrHYP7/bIAaRpq9D4CXS1LMDxajh4U5z
 H7p+wr4vz0qc5medE6owG1PkjQPXNlraSS1s/XJ1CtYXK3qE8hBKzEL6zjLV/Q01tUn7KFvKo
 twAhQT6Dj5rS9T9PSPi2NXXxUYGOZo4tv4jwV+kJsQFfs+r5TYnKqY3IHn8PEeu6qwdEsp+6W
 31BkAia5oQu9Htl1tnD5H+d8gkQoWpv95tf5acu4CJKRdUT29vUkbqTGDuUnITD/WV1s9bfhA
 GCbbNwq9eGXqTJyXvgmOsM7UjewftcTFs/Wl9WSVBqn7GFvGE05lALQ31WXXhM07rxOORWZ+z
 Ab+mGz8xzHgBN8DshZlewKyzIeWejEZXOJWvZoV27II1GQZ7gkxMeUscpKNwf9/lwu6EubWep
 7k0rS+3T58wjfJ191Xy9g6BNYOfxhicL6RkgW6I3kR7du87eFJuYmRIRzBlslMz+XVwRQnOCJ
 A1NPWYXPu83qNQXGnvGPtHJbZBSZdMG2MOVBV6+e/F9cBAEfJNWR+t9nPeYQ3C+fLtQKzkx38
 NtNKkV6B03zD42tnuYeW/5EYjxR/cjpQpTQB6HOSC6FxQ5+sEU86ONUK2Cf/vQBXTbTktbd50
 ClQkxsJ8XopRQwPM8O7y+xL46ELbg0SyCP08+CoOGFg7FN1BeC9rECrA7UhCmYj++QOdU14+K
 JGVqFlFFOhhMMOnuGz6Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 4:12 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> On 9/7/21 5:14 PM, Linus Torvalds wrote:
> > The KUNIT macros create all these individually reasonably small
> > initialized structures on stack, and when you have more than a small
> > handful of them the KUNIT infrastructure just makes the stack space
> > explode. Sometimes the compiler will be able to re-use the stack
> > slots, but it seems to be an iffy proposition to depend on it - it
> > seems to be a combination of luck and various config options.
> >
>
> I have been concerned about these macros creeping in for a while.
> I will take a closer look and work with Brendan to come with a plan
> to address it.

I've previously sent patches to turn off the structleak plugin for
any kunit test file to work around this, but only a few of those patches
got merged and new files have been added since. It would
definitely help to come up with a proper fix, but my structleak-disable
hack should be sufficient as a quick fix.

       Arnd
