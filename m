Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AAC119B8D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfLJWJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:09:18 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:51197 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728856AbfLJWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:04:30 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MtfRv-1hsKxf2QUp-00v7CU; Tue, 10 Dec 2019 23:04:28 +0100
Received: by mail-qt1-f171.google.com with SMTP id b3so458059qti.10;
        Tue, 10 Dec 2019 14:04:28 -0800 (PST)
X-Gm-Message-State: APjAAAW7ZhzwUvO3N2faIvYsrRK+941i/3l72ockKp7WetHd7jz+okYC
        W4dHBIgFDGCz8FMeivB3EEmfJ9i8LLQj/nckF7k=
X-Google-Smtp-Source: APXvYqwTjvXJ/KoAki4o/MUgxzzj/fhwQvf/9FGGYqifR9IsL+5DzL6tYg3p325LEDaNOoZLB5KJXR0sQBvqgJ8RT3Q=
X-Received: by 2002:ac8:47d3:: with SMTP id d19mr85987qtr.142.1576015467432;
 Tue, 10 Dec 2019 14:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20191210203710.2987983-1-arnd@arndb.de> <CA+h21hrJ45J2N4DD=pAtE8vN6hCjUYUq5vz17pY-7=TpkA51rA@mail.gmail.com>
In-Reply-To: <CA+h21hrJ45J2N4DD=pAtE8vN6hCjUYUq5vz17pY-7=TpkA51rA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 Dec 2019 23:04:11 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2ONPojLz=REmbBMwnSsB3GVyqLYtCD28mmKk5qr3KpdQ@mail.gmail.com>
Message-ID: <CAK8P3a2ONPojLz=REmbBMwnSsB3GVyqLYtCD28mmKk5qr3KpdQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:zW9BNAUrHQL6FrpIOCu81hOutpEMn/prPi1pqOev5pKC6WIffOs
 HrzPztIp/xmYtniA24mq/QiV/b477YwWmrdtZ07GKqeehwFWgyIvAsRJbqW6T8zUxFKjP3N
 PyWXRyBdbSwFW2JZAh2dkwNeTAgAo3w4ehgBZGhiWrqMqP3w47NJqD9W8c1xsgSaqJpdT2t
 Icxs56Jw4IPxRwmOUoWAQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xX8tIzNEtV4=:QiZY+obU4/nww/UC6CjsC+
 V6lvjK7a5oH6tir+KwFoan0JXIlgu0mEW7B3l7v6w7WQpxBxv+j+wBkZkRka8Kqcj0ixk33K0
 nWj+QnUALr3QzMHAiEG7Hf7BxXtIDCAZ8Nnr33ypjf1sXbOO5u4AkD5sn2TBTt/H0dCrzOLaj
 nQtDgaCS1M46rbpuD13S20gRwOG7vq3/PyiVdZhprZnX3CAentaY2InZGnaI42vWkH0kdBFGR
 28lrbaRLCbk/Oso3iLW1QR0A3DLQzfNH+8kcQ+HGauqks+9MuScoHOs94ZYk7FiSIMlWDAuT0
 HiE90yuPoBDMtmx2q/g6/iN9ZJyOLiPdLB76BwyeY4fb/KvA3cLwKi6B10Gkk0SXD1T8abQSc
 93Kcn3ve22zlB7hAHUIdEuU/8t6nU0oeif+crccKgbKvDg2Sr/DYJqsdd45gvCbdUw0rnPiEL
 e+C3MeKTw8rg7dQWyYEO19dyDWSM3xTejJzuDl9ujU9/nDz6LJngj2QyXafUT1F32FopDqKhg
 O+Ts/xxLt/1jyhugfzgfNl6VKSEK5iPBADfsM2WPbHVZ+21zaRfgdf3lAPBMZZM5HMxROQOLT
 wXB2ONzfHg9rEYnp64zKnGt4ldBUXovOmLmkwXaLETbk0lKYoqH2ARYRYayex9RBPPqzWvzqo
 Ij8eaf7++zTM7Mzjji7PC5g13M0zvI9VIR7QWMRXgWMZXERt630Y5C5MPxd2iODvBCHHdkjgH
 wUMaJDahhC0bMJR/rTHxe91UkrnLbxGGwwQHCWBWh+kgxVVtnIJM7yduqM6pbbC3mGPRXM7FF
 /0F+tW5ghwIu+WeuFECPiGwcRpPG+8ReCHaKI6Ul/OBp6gJfy/WIckjUDQHqZ1t2YnWFRD497
 ZdBQeSknQzSohs5PwGYQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:37 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Arnd,
>
> On Tue, 10 Dec 2019 at 22:37, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
> > is disabled:
> >
> > WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
> >   Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> >   Selected by [m]:
> >   - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]
> >
> > Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
> > CONFIG_NETDEVICES.
> >
> > Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
>
> This has been submitted before, here [0].
>
> It isn't wrong, but in principle I agree with David that it is strange
> to put a "depends" relationship between a driver in drivers/net/dsa
> and the Kconfig vendor umbrella from drivers/net/ethernet/mscc ("why
> would the user care/need to enable NET_VENDOR_MICROSEMI to see the DSA
> driver" is a valid point to me). This is mainly because I don't
> understand the point of CONFIG_NET_VENDOR_* options, they're a bit
> tribalistic to my ears.
>
> Nonetheless, alternatives may be:
> - Move MSCC_OCELOT_SWITCH core option outside of the
> NET_VENDOR_MICROSEMI umbrella, and make it invisible to menuconfig,
> just selectable from the 2 driver instances (MSCC_OCELOT_SWITCH_OCELOT
> and NET_DSA_MSCC_FELIX). MSCC_OCELOT_SWITCH has no reason to be
> selectable by the user anyway.

You still need 'depends on NETDEVICES' in that case, otherwise this sounds
like a good option.

> - Remove NET_VENDOR_MICROSEMI altogether. There is a single driver
> under drivers/net/ethernet/mscc and it's already causing problems,
> it's ridiculous.

It's only there for consistency with the other directories under
drivers/net/ethernet/.

> - Leave it as it is. I genuinely ask: if the build system tells you
> that the build dependencies are not met, does it matter if it compiles
> or not?

We try very hard to allow all randconfig builds to complete without
any output from the build process when building with 'make -s'.
Random warnings like this just clutter up the output, even if it's
harmless there is a risk of missing something important.

Yet another option is
- Change NET_DSA_MSCC_FELIX to use 'depends on
  MSCC_OCELOT_SWITCH' instead of 'select NET_DSA_MSCC_FELIX'.


     Arnd
