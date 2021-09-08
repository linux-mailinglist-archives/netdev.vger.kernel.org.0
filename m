Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE207403E06
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352292AbhIHQ5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:57:52 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:43015 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349999AbhIHQ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 12:57:51 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Miqzy-1mtnOX3RY4-00exig; Wed, 08 Sep 2021 18:56:41 +0200
Received: by mail-wr1-f47.google.com with SMTP id t18so4390722wrb.0;
        Wed, 08 Sep 2021 09:56:41 -0700 (PDT)
X-Gm-Message-State: AOAM533oDNzKetqzApjoyCaoKRan32dRS6hzofEEwM+Qy76zRz4zQhJi
        sZZeg/YI/vcHcgfJBUSW/Fc53NOb/4Cv2BxysnU=
X-Google-Smtp-Source: ABdhPJwcocFM9OAq7VwP5lDXlDVhqgm1fdUp0h8xqCE/B+fuvzp4uvB0PS7Bz4fzjuBe7pj6aM8HUHjsb3+/dBvc4Cs=
X-Received: by 2002:a5d:528b:: with SMTP id c11mr5060071wrv.369.1631120201451;
 Wed, 08 Sep 2021 09:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <53ce8db-3372-b5e2-cee7-c0ebe9c45a9@tarent.de> <CANn89iJzyPbR-fS8S_oAMSJzUGTHAfx49CXVc6ZSckUk91Opvg@mail.gmail.com>
 <CAHk-=whkOK2DTHMt1rQ7wCBCqW=itkihpQBcZ=T6vrciEE4ycA@mail.gmail.com>
In-Reply-To: <CAHk-=whkOK2DTHMt1rQ7wCBCqW=itkihpQBcZ=T6vrciEE4ycA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Sep 2021 18:56:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1r_-7hsU8ZPv7Pow7jEkOhzDNQ9e16_pb+h+nG86AbgQ@mail.gmail.com>
Message-ID: <CAK8P3a1r_-7hsU8ZPv7Pow7jEkOhzDNQ9e16_pb+h+nG86AbgQ@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Thorsten Glaser <t.glaser@tarent.de>,
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
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:AUzJX5SCn3HfUVKOOm17oyVJ7FU2co24FEFbfskcTiyQMmo8paE
 YhDdPvanf28YoAkwKIxdE25GfPciVl6k3+N+sszG5FCy8fC69A1lhkd/X0CYKA/YN/JDXuJ
 /BNROQ5JPbIMSFBkmyuq6FLAbU4/PeW3FkeE6GTn9APJG4xuo4UT/w2ViGCzo15blXIB8of
 Qkdfy7s2ETb5+XmeFp/Xg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jdj8MSBaAT8=:/xCi0cgwY88KZxoPwBICI5
 MbqskY4yf2w10+wh2z4Grpv48FcMZXSLpCQIfB+f9DAGkt6jNH5mNg6vzL8qHDnDhSWAS0RNa
 i+h1IOeE013UkakVbZ6t7mC7dsw9R5MWe9lhfWOmJ2KS9OxBZibKfPgF5FFsAKeQszLfDfvzz
 ZVTr4eHGivjpwMxM+0x0W+USAcwOwK7TZ1AKM/2DfArj5kMLm2YcSmCGCd0NaQmS4K5eMbcJL
 6LI9h9PlcfWWuGVcDOL+5k7bfR5SxC6GYM35kh4unpeD8SrVsZYG/24NZKo8tTimWVRRXyeVb
 27pMw1coGDUbffTUwq4U3T7uhdjgZnWWHQCxGlbMCBsygpodw+8OFE02HwYVAyUqyV/AJjElp
 ob0n42qLgiPJ8z3KyfqVyRdlSrHCtZxt8DmlBND9gcWSAlZK2oL4Ff9sCCsgkBKzz3mi+ABlK
 3OtW11S7BaKjWAKwj+a0n+C0A7+0FKNV7qhChBhtAF72afI8obgBfpqQJkSbMqnuScWr5tNlY
 RoSoINEg8LGn73w6q7CkJ/AGsILRhMFztLAhuL5u6I0to1N1gOcl2IMVT3BXjbzd51uiHkHnP
 MCFtNtpH76mTYTJrqZ9iUwmOUylNUli8sRjOgBQyXfy8sM6PHakk3eZ9x8+lBohndhNWigoKf
 L7Tbpeig/syxAdjuJxe3E86wTU42aV50wR03+Tpqtioky4t5EfjDBMeIwf+XWw4w1THZ58oB8
 cq8pnZY4dUjGAxS7I2pX5MGibLb8PDzUb5BKvTMK7OujsPLmQpRrD4c6MpOJrN+THP2ggqH44
 OYIOk06pgzGntdDC5zhhnNv9ohgMb3K5BAqKLbb8aOUKpwnMjYFjLas/cvGkinkFnArrBfc0i
 8EJSGxM2Y5UnWrMedOUg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 5:49 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Sep 8, 2021 at 7:50 AM Eric Dumazet <edumazet@google.com> wrote:
> In the past I've seen at least two patterns
>
>  (a) not merging stack slots at all
>
>  (b) some odd "pattern allocator" problems, where I think gcc ended up
> re-using previous stack slots if they were the right size, but failing
> when previous allocations were fragmented
>
> that (a) thing is what -fconserve-stack is all about, and we also used
> to have (iirc) -fno-defer-pop to avoid having function call argument
> stacks stick around.

CONFIG_KASAN_STACK leads to (a), and this has been the source of
long discussions about whether to turn it off altogether, the current state
being that it's disabled for CONFIG_COMPILE_TEST on clang because
this can explode the stack usage even further when it starts spilling
registers.

gcc also runs into this problem, but at least newer versions at not nearly
as bad as they used to be in the past.

       Arnd
