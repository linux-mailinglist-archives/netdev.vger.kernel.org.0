Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B751C6263
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgEEUv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:51:56 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:44865 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbgEEUvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:51:55 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MMWcT-1joyyM0F4J-00Jaoz; Tue, 05 May 2020 22:51:53 +0200
Received: by mail-qk1-f176.google.com with SMTP id s9so3881547qkm.6;
        Tue, 05 May 2020 13:51:52 -0700 (PDT)
X-Gm-Message-State: AGi0PuY94GjZLvlCWF8QhKb4mcf+YL2GDCDp44zv6NWiO5RWGoZ6n7k5
        uiYBwdrETuPu0dgQbPAdsX//YI4JORASWImJXxo=
X-Google-Smtp-Source: APiQypLeVpLfwvXnNr/kh8i7h3BF2MM1Zc18IcQzr8YZsPeSIkoUm3Eo4GM+Wy9kCf4P/OTrcCYa62E4Z/KzmhLco3M=
X-Received: by 2002:a37:b543:: with SMTP id e64mr5487687qkf.394.1588711911720;
 Tue, 05 May 2020 13:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200505141327.746184-1-arnd@arndb.de> <CAHmME9oTO7DiWCXoeCBjmPOBMoZQ2hUhHjZ4_oi-nVP_9pRpSg@mail.gmail.com>
In-Reply-To: <CAHmME9oTO7DiWCXoeCBjmPOBMoZQ2hUhHjZ4_oi-nVP_9pRpSg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 May 2020 22:51:35 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3vno7BYwJZna8w1spRCcou2veXSbQZefnUbPpswkRGzQ@mail.gmail.com>
Message-ID: <CAK8P3a3vno7BYwJZna8w1spRCcou2veXSbQZefnUbPpswkRGzQ@mail.gmail.com>
Subject: Re: [PATCH] net: wireguard: avoid unused variable warning
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:z5+pIoeQtH7SIz5NVx/42ZjLU8ORva5IW4Ry7DMSrYJNgVhxtoT
 R2OaGXs/TWAuk7TLS+4lSRWpYVhIdSNZmiNoCo1G+7apU0U6d0vjVc0P52qaP2tuVLg5M1q
 KVKs03GvY9sci8H4FmDCsOpUK+653CbH/mm+csUOJ4y7RQMnjWiJCEXFyfN5dP+muhbbAfq
 /DvLcNXkMWPBt8BN0z3vg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Z8toKnlnSpE=:Y51mBigACJ3t72pC5mEZuk
 YApItYk7gVWtWM1idKlowCMI2lOY3bl7A3mzRA7JCTl4eDLWU56uDF+fcQtEsBbaUSNlBcxwf
 2Hk6ZuwqqepXH6d8AiesfgjT0Ej6V2gqEEVyVn4mx2XWm7zODqmcVq6BdQ60x5AAqwm7jwzBI
 x5/fMJUftjluVCgY3E/SNawYOpS17U8td9+MrAgXd0I4RMiG0Em99XVZncwbdNUxQuxWFjOph
 Nn84Ou1WTRw0vDTNB2n4MtYa3yPm3AHCG+hVr9jW5KuIVaqVDlPv/kv3SmHsnbQ4gBAPHTqVA
 Z1BSQKvd2JXP4oQfCM2DXd85ptUH++RKIWwTGFFR2iLYjBLM/T1yGWMQiPzIkBo4iAel1DLa+
 fxRCQygiNxvnBR5IilxGF0Y8DMfwBpha/oyVVHMbg7tp+MjPmiVLYP5ODg8VpuJLiyBXrUNBQ
 VJKV3kklNJBH/bEqmpGcs7Ei6B2nYTG6eWhEGYckD7g8OVm1c4X27jrZVwP9ImstbdNMv96KI
 Pv5/QqIJ6ElwzcnUSveCENxYPV0BBruPBpALl5yKRTchCMH0DPCf2pTLKhiWfER/UL8jkRmZh
 FrrQDDRld8TM2bDJERY/xJzV5TjTx8qAbl/IvGfyYjqinlsRsMDOYFoLl/sVGAn81bl8Rs8RY
 kfipYMznNHwHEW2elfBDSWg92E2/t7KFlhJgpvKzICXcwPdWP9eZPQ3lpRYC9xFndXV4tXvpU
 WWgEocjVXPTkaFoJGpB9OfPjzN0YzZx9j62HGPJwWJjh3ls7I7JCtWR0Lslc5lhntmro38Zw8
 yUJAwY++W1A9fWkUcOF24/HIPD2g0W3mX6BZvbeYQHzVMaWpkM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 10:07 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Tue, May 5, 2020 at 8:13 AM Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > clang points out a harmless use of uninitialized variables that
> > get passed into a local function but are ignored there:
> >
> > In file included from drivers/net/wireguard/ratelimiter.c:223:
> > drivers/net/wireguard/selftest/ratelimiter.c:173:34: error: variable 'skb6' is uninitialized when used here [-Werror,-Wuninitialized]
> >                 ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
> >                                                ^~~~
> > drivers/net/wireguard/selftest/ratelimiter.c:123:29: note: initialize the variable 'skb6' to silence this warning
> >         struct sk_buff *skb4, *skb6;
> >                                    ^
> >                                     = NULL
> > drivers/net/wireguard/selftest/ratelimiter.c:173:40: error: variable 'hdr6' is uninitialized when used here [-Werror,-Wuninitialized]
> >                 ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
> >                                                      ^~~~
> > drivers/net/wireguard/selftest/ratelimiter.c:125:22: note: initialize the variable 'hdr6' to silence this warning
> >         struct ipv6hdr *hdr6;
> >                             ^
>
> Seems like the code is a bit easier to read and is more uniform
> looking by just initializing those two variables to NULL, like the
> warning suggests. If you don't mind, I'll queue something up in my
> tree to this effect.

I think we really should fix clang to not make this suggestion, as that
normally leads to worse code ;-)

The problem with initializing variables to NULL (or 0) is that it hides
real bugs when the NULL initialization end up being used in a place
where a non-NULL value is required, so I try hard not to send patches
that add those.

It's your code though, so if you prefer to do it that way, just do that
and add me as "Reported-by:"

> By the way, I'm having a bit of a hard time reproducing the warning
> with either clang-10 or clang-9. Just for my own curiosity, would you
> mind sending the .config that results in this?

See https://pastebin.com/6zRSUYax

       Arnd
