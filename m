Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC1E27D2BC
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgI2P3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 11:29:23 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:35143 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgI2P3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:29:23 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N4yNG-1kXHwj1vng-010vPY; Tue, 29 Sep 2020 17:29:21 +0200
Received: by mail-qt1-f179.google.com with SMTP id c18so3862140qtw.5;
        Tue, 29 Sep 2020 08:29:21 -0700 (PDT)
X-Gm-Message-State: AOAM5317LkKvvxuzsi2MsXArNlWcblwQXLxwdFEBICLscrZIrvjBfQ8k
        ORzPu/VLCD3IhI0jGnOnP5JTCwJFSMHy/bpI3nk=
X-Google-Smtp-Source: ABdhPJz9k/+3tANJB0rfgjiHIQ7nS0YJd5brzJANpAcdDDYLyyNmthovIwW6+viK77YcNpw2ms452kKZTl6zTF0jGxE=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr5108378qkf.352.1601393358920;
 Tue, 29 Sep 2020 08:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com> <20200929134302.GF3950513@lunn.ch>
 <CAHp75VcMbNqizMnwz_SwBEs=yPG0+uL38C0XeS7r_RqFREj7zQ@mail.gmail.com>
 <20200929143239.GI3950513@lunn.ch> <CAHp75VfjOBDpuY_df1wdxUUfFQV_t_k2PjrwHjd0dvE3jojZ=w@mail.gmail.com>
In-Reply-To: <CAHp75VfjOBDpuY_df1wdxUUfFQV_t_k2PjrwHjd0dvE3jojZ=w@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 29 Sep 2020 17:29:02 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1AdhWdfC148p2kRgYg1f9oYioweGGXw=V8s04m4_FuaQ@mail.gmail.com>
Message-ID: <CAK8P3a1AdhWdfC148p2kRgYg1f9oYioweGGXw=V8s04m4_FuaQ@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:mQmuimSRPfUjA+Y4ZwNetGU7p31zJt0xJ9vTV6xSsJCjn+JAcPP
 7Y8uVwiI0XHNiQtPq1YZOV0Uk27X9/7/XRjf4MA7n3ZgSTLX8JUFDCWD+T6EHxAB6TUR6i8
 qPrLNds94QQrri0gAo8WpATQfK7vEdSHRkd30hn8+lQ8YFSiGFSd+8/6f/PbcvXPBaws+56
 +Jk8vK1m1UdNrZox1nLdA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OzGHeofpsjY=:0Kk9t66pcqnJa7wGjNz5kl
 3BDxOWcS+839O1WWIJOXAZe0ZpiGlFPu23CkTLgi/zNaNf56KXh0yugMS2JlFEWAYCwVHo1OV
 VBS5aF6A+jss26T9w2tUmuYP8NLBBZTjGRTVay/aKzGj3yALYnijlv6bD+s8aJY/COoZWniEl
 b4MVTga8zMp1pChC8arBF8xun9A0nvvP3tlzt3thXHrKgrOyI+P5hlgmLKomB+oDBEo4MtmCr
 m+gV0ZbXLdDIBGls5e+0h5jeQrjD8/RvjLVtowaNWUGimxihFIZ/I7MOolHuRm5eI3kNKqprl
 eR7I1sL6tX4Ga3KGrEXZN3+qdhga495rvfB+Rdw39ImW5eEFn9/GLZzBJ95HyEUhXlXSIsMf4
 cYERMbKcUYgdEXdtmjLtof3pDqVJJHoxnN2HgPrJGsNb5Yjw/Ys25oCRNx09ZuNkQ+bBTYMKw
 kdZ24h+3W4EcIuQ2DwD4YtQCISrYE3+FcI9RVGf9DDGXi+zpFXRlkY3JxivIf0HE0PrcoEa9s
 qyVwJu3kSMdZRpKtGuDhXEpJhTpy5JVryBvNUVTNk4/ZV3gfNQX38TMrf53YbqLjiakSOIwAK
 1ptdq/PhLpxQakw/mB++C0AvcsTS4OrE9eXEIJ98U+wMN9LrbDHAgDBhoDBHa0dsA/hF1andd
 1dUqOZv0du/2bdRBCDOoN6N939f1i+IrjioGcE9V3xbsOHRcVlM5Big6Hq6xgtwl1Wyd68n/r
 +nAye1ynCXgrlMy4GpnOu1/X7hWO9xID7eJrdNoZQIEHAs9drngQ/33WpCMxKz0zd9TyjEeuP
 I31cxUw98oHZnzBMvNZSLGijQXjEvZEQTE06SKktcnYJv+O+EbIPBODvF6LkymDbYovc64CfY
 9mSMrvDiXIJjcd3Y0w85MyEGWfsIT/dvYuHX8F/Ba1+3dG32tcVROBCQnu/OiElfT/DEElHfQ
 o7irRRFA22g5Lp5MrFg/vYBSIdOsNuww8YZ9o6TX2LR3tfdNCQgtT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:49 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, Sep 29, 2020 at 5:32 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > On Tue, Sep 29, 2020 at 04:55:40PM +0300, Andy Shevchenko wrote:
> >  Does Tianocore, or any
> > other implementations, have the needed le32_to_cpu() calls so that
> > they can boot on a big endian CPU?
>
> Not of my knowledge.

> > Is it feasible to boot an ARM system big endian?
>
> Not an ARM guy.

Most CPUs these days support both big-endian and little-endian,
and either allow code to switch between the two modes at runtime
or are stateless in the way that you have two sets of load/store
instructions, making endianness purely a compiler construct (see
also: Intel's icc compiler has a big-endian mode using the MOVBE
instruction).

For Arm kernels, we assume that the firmware is little-endian, but
you can build a big-endian kernel that switches into big-endian
mode before doing anything else. As I said, I don't think that will
ever be used with UEFI (and ACPI, by extension), since it would
be a ton of work and few users care about big-endian kernels.

    Arnd
