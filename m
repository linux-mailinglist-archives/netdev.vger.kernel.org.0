Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FF6119CBA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbfLJWdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:33:06 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45544 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbfLJWdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:33:04 -0500
Received: by mail-ed1-f66.google.com with SMTP id v28so17457702edw.12;
        Tue, 10 Dec 2019 14:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LNQ0jMB8gZFPp0NLmxkrc1EEggT9LCv92qH5mLZQn7E=;
        b=UdleQTCYzdto/XDkDBc0wy0oLO9O4UIossFAYL5j0SionlEc7/2rUDr8jXaqyJ9pUb
         Shbj9aRQQaf7KUfTzdP/aOvEZ/rRQLxXFANN9vJNbo6yjqqRy8e1tSzj4Q5hZVoIYVpC
         vtdFjKf/3QSroyGtG75X1FYUVRYqaLc77bsKJu7OiidnciVjhrxe3JcYkDHMo+adPAsg
         CWTX7MMnTkJdo+xDRWDHAZxje6kv37fl+WL6Bu2b6ho+zPrpSJyIZa47uOyKxRQT+kkV
         kGK6bx+iSRD6Y/K+lCrjig4my6gDqyq8LxCok2pFAFs9u1apu9PCUyPBXj2LXEHoYL4J
         DRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNQ0jMB8gZFPp0NLmxkrc1EEggT9LCv92qH5mLZQn7E=;
        b=Jsn/20VAXTuLAwMLLOeNhLdwe0OCFRTQmvT3cB5B0e1QEaeR5gWH/l9bAlQ2V/pw0k
         fAl/tiGhWXw8Vaa6QKbaEjjyvUwOtsvQS7346eUKnFGBHP/KeMaG3+EwzX892iQwMkt7
         5DBx7PqlVS1kduokoPD1cXSF9AHgeKuOryUrFP4/fc9Xj/cmzK0N23WgmMj0RpJmQA+4
         ubcA5Hcjgxpm4eRr/VVakM8FuCSXjkMepvjgj52EQ2plVafAMJDF78nAg5BtLEgAYjwE
         ydUmOz6tXRsY6owqj6jDnNUqAfiHmKIHG1aUq8hmR5p+hEElBEgPyfF0m2QNsMrV2QtU
         nZYA==
X-Gm-Message-State: APjAAAUyTiiMwynukoXUmsVLjwRXkcASSUC39/Hpj/4oVlggnKgoe+/d
        YqlE7CEODowvWUEv7D2lbVcRlqh+IXdMHPWvMrE=
X-Google-Smtp-Source: APXvYqzJqt2wsYt+KWKc8RcKL1/b0ohlGjdmwKmNy00TpZUVg1gYRTKgogUZBgR44Oi2QRRp4XJWLVXoAVG14pZC2cg=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr40134592edq.18.1576017182883;
 Tue, 10 Dec 2019 14:33:02 -0800 (PST)
MIME-Version: 1.0
References: <20191210203710.2987983-1-arnd@arndb.de> <CA+h21hrJ45J2N4DD=pAtE8vN6hCjUYUq5vz17pY-7=TpkA51rA@mail.gmail.com>
 <CAK8P3a2ONPojLz=REmbBMwnSsB3GVyqLYtCD28mmKk5qr3KpdQ@mail.gmail.com>
In-Reply-To: <CAK8P3a2ONPojLz=REmbBMwnSsB3GVyqLYtCD28mmKk5qr3KpdQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 11 Dec 2019 00:32:51 +0200
Message-ID: <CA+h21hp1gg2SNX3f-+3gG3au90XsrYkzjvWYXmHdiWv-Bu=KPQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: ocelot: add NET_VENDOR_MICROSEMI dependency
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 at 00:04, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Dec 10, 2019 at 10:37 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Arnd,
> >
> > On Tue, 10 Dec 2019 at 22:37, Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > Selecting MSCC_OCELOT_SWITCH is not possible when NET_VENDOR_MICROSEMI
> > > is disabled:
> > >
> > > WARNING: unmet direct dependencies detected for MSCC_OCELOT_SWITCH
> > >   Depends on [n]: NETDEVICES [=y] && ETHERNET [=n] && NET_VENDOR_MICROSEMI [=n] && NET_SWITCHDEV [=y] && HAS_IOMEM [=y]
> > >   Selected by [m]:
> > >   - NET_DSA_MSCC_FELIX [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && NET_DSA [=y] && PCI [=y]
> > >
> > > Add a Kconfig dependency on NET_VENDOR_MICROSEMI, which also implies
> > > CONFIG_NETDEVICES.
> > >
> > > Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> >
> > This has been submitted before, here [0].
> >
> > It isn't wrong, but in principle I agree with David that it is strange
> > to put a "depends" relationship between a driver in drivers/net/dsa
> > and the Kconfig vendor umbrella from drivers/net/ethernet/mscc ("why
> > would the user care/need to enable NET_VENDOR_MICROSEMI to see the DSA
> > driver" is a valid point to me). This is mainly because I don't
> > understand the point of CONFIG_NET_VENDOR_* options, they're a bit
> > tribalistic to my ears.
> >
> > Nonetheless, alternatives may be:
> > - Move MSCC_OCELOT_SWITCH core option outside of the
> > NET_VENDOR_MICROSEMI umbrella, and make it invisible to menuconfig,
> > just selectable from the 2 driver instances (MSCC_OCELOT_SWITCH_OCELOT
> > and NET_DSA_MSCC_FELIX). MSCC_OCELOT_SWITCH has no reason to be
> > selectable by the user anyway.
>
> You still need 'depends on NETDEVICES' in that case, otherwise this sounds
> like a good option.
>

I don't completely understand this. Looks like NETDEVICES is another
one of those options that don't enable any code. I would have expected
that NET_SWITCHDEV depended on it already? But anyway, it's still a
small compromise and not a problem.

> > - Remove NET_VENDOR_MICROSEMI altogether. There is a single driver
> > under drivers/net/ethernet/mscc and it's already causing problems,
> > it's ridiculous.
>
> It's only there for consistency with the other directories under
> drivers/net/ethernet/.
>
> > - Leave it as it is. I genuinely ask: if the build system tells you
> > that the build dependencies are not met, does it matter if it compiles
> > or not?
>
> We try very hard to allow all randconfig builds to complete without
> any output from the build process when building with 'make -s'.
> Random warnings like this just clutter up the output, even if it's
> harmless there is a risk of missing something important.
>
> Yet another option is
> - Change NET_DSA_MSCC_FELIX to use 'depends on
>   MSCC_OCELOT_SWITCH' instead of 'select NET_DSA_MSCC_FELIX'.
>

That's strange too. MSCC_OCELOT_SWITCH just enables a common driver
core which is used by both NET_DSA_MSCC_FELIX and
MSCC_OCELOT_SWITCH_OCELOT (possibly by more in the future). I don't
see any reason why the common library (purely an implementation
detail) should even be user-visible, let alone why it should hide a
DSA driver.

So, if you agree, I can take care of this tomorrow by reworking the
Kconfig in the 1st proposed way. I hope you don't mind that I'm
volunteering to do it, but the change will require a bit of explaining
which is non-trivial, and I don't expect that you really want to know
these details, just that it compiles with no issue from all angles.

>
>      Arnd

Thanks,
-Vladimir
