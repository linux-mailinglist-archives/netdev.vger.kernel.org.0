Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440AA11A57D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 08:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfLKH6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 02:58:17 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:43221 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfLKH6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 02:58:16 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue011 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mq33i-1hswtB086U-00nC11; Wed, 11 Dec 2019 08:58:15 +0100
Received: by mail-qt1-f177.google.com with SMTP id 5so5512162qtz.1;
        Tue, 10 Dec 2019 23:58:14 -0800 (PST)
X-Gm-Message-State: APjAAAWujv/5DOfEq91zRO4Hxn1PrMrpqVv5IHLCumRyiezB26dXfhhW
        lgvQdYzPzJxjOhh+paY1BMkOPpinq80nE0B2nVI=
X-Google-Smtp-Source: APXvYqwaO6ygNI/YjrKsZsmfiPRjEO9YCitE0sPil72zQapjP36ejQ/hjJM6YqeIimph30jJFbk5N29y//l7ykIh/pQ=
X-Received: by 2002:ac8:3a27:: with SMTP id w36mr1595586qte.204.1576051093887;
 Tue, 10 Dec 2019 23:58:13 -0800 (PST)
MIME-Version: 1.0
References: <20191210203710.2987983-1-arnd@arndb.de> <CA+h21hrJ45J2N4DD=pAtE8vN6hCjUYUq5vz17pY-7=TpkA51rA@mail.gmail.com>
 <CAK8P3a2ONPojLz=REmbBMwnSsB3GVyqLYtCD28mmKk5qr3KpdQ@mail.gmail.com> <CA+h21hp1gg2SNX3f-+3gG3au90XsrYkzjvWYXmHdiWv-Bu=KPQ@mail.gmail.com>
In-Reply-To: <CA+h21hp1gg2SNX3f-+3gG3au90XsrYkzjvWYXmHdiWv-Bu=KPQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 11 Dec 2019 08:57:57 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2J2zLGnCNG=Py+LMFELCrtjPoyPY9CZRVdRsWa+Mt=tw@mail.gmail.com>
Message-ID: <CAK8P3a2J2zLGnCNG=Py+LMFELCrtjPoyPY9CZRVdRsWa+Mt=tw@mail.gmail.com>
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
X-Provags-ID: V03:K1:+Jy7L1UZU8QDHmCRHghgXHzrZdld6hWgpveoupzzJHC32k1McU3
 ZKfLgFUbtWGN3Yg1pfzJyjRtW5u3psY9FCxJ158EBy1YgWnKjJH+PZzLLosYJLPf1FBBI2a
 agcSivsJAktd1nsWJ1iUiYTAptRMRS9ncwupinY1hhZ+JOu6kW3X8NvHspngYLdgbrAhRB+
 NYL8sN14fnpCwfaYvRg2A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NKYZpOml388=:ANrIohBgQ3e/W/Zqlt19C9
 bmsgX85AXiIASY01wdMyiR7iv1XSK27qVqdAk+QfdIQ1Zv+lZMUEytNWGMJSvxEmlzfOCn5om
 PfueCL7kvjI64h4vcpxJEjALvJYW22iAtJAPRGbuiKctHZNiBfRTRQQSG+KpLh+PrFCdxlN8a
 xB/9ZtJsuRiQb4JQ4EGDXDMnjfzTgQcpMbYLFh3mgXrRK743j7AMLttIMMcY8ktE5+5Gm5Tnj
 I5kP4XId0Yr8AwDUd/m/adYyxq5Fnxwi5RiznB9DAMT844IB3eYOuaYgYbzFmYC+Xyt4F4wC7
 OqPLWvXFI4/ffqc5zXw2OMIsCZLXIVWpHxUYGPWFzOe+lLXzl4VmloLTvkzRkvaka+jrq688a
 KN/f4g3I3IRs7z3GNTp+Y4/oTm73ZNuLmiOVK7nDLDWOYqmSyOKtfSejJ3xRCIW6hH1wojoll
 yrGdq05GTtEL6tWsOOwn1H4G6BdQWKGUbuXU8HV61eWVFwP2kDnDisFb141E4+I3d4UlRAGBe
 TTV9mRfAhw7U6UcJuZOXUzNUIWuz3zhOgRHEbDNbx0ORApckNF0zLzBHPM/kNVMjMQ9121neh
 XBFImlfi1Cbfl+76CjnrGoq+6eVA5hgljNmV1d5WDoUAHKMqgq+ACL+yTO6XNP4Agc8ipb2zE
 LzG5p3dHY0E1OvHyD/P0vxjzHllrOl2sttPjNLTXYSDE/FH8/JPRqcSE3Zxj2xJJAwIggmnhN
 ceA7S+HF+atFCXERpeBGwQ1/1/lti2FPFTqEAW39RQnd8H+FEYPPwU8OW4L5wehi+Np2ZQ8rp
 5w0TkI0s5709P598ejxXVovxGV1I57K9oloe7j4hjijtd0aqvS5oSIOzxszri2XXo8Mcu4bNu
 XfMxTcKwSciiF1ZZB/qA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 11:33 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, 11 Dec 2019 at 00:04, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tue, Dec 10, 2019 at 10:37 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > Nonetheless, alternatives may be:
> > > - Move MSCC_OCELOT_SWITCH core option outside of the
> > > NET_VENDOR_MICROSEMI umbrella, and make it invisible to menuconfig,
> > > just selectable from the 2 driver instances (MSCC_OCELOT_SWITCH_OCELOT
> > > and NET_DSA_MSCC_FELIX). MSCC_OCELOT_SWITCH has no reason to be
> > > selectable by the user anyway.
> >
> > You still need 'depends on NETDEVICES' in that case, otherwise this sounds
> > like a good option.
> >
>
> I don't completely understand this. Looks like NETDEVICES is another
> one of those options that don't enable any code. I would have expected
> that NET_SWITCHDEV depended on it already? But anyway, it's still a
> small compromise and not a problem.

My mistake: When I had tried it, I did run into this problem, but it was
CONFIG_ETHERNET, not CONFIG_NETDEVICES.

NET_SWITCHDEV depends only on INET, NET_DSA also depends on
NETDEVICES, but neither of them depends on ETHERNET, which
only controls drivers under drivers/net/ethernet, but not support for
ethernet itself.
>
> So, if you agree, I can take care of this tomorrow by reworking the
> Kconfig in the 1st proposed way. I hope you don't mind that I'm
> volunteering to do it, but the change will require a bit of explaining
> which is non-trivial, and I don't expect that you really want to know
> these details, just that it compiles with no issue from all angles.

Sounds good, thanks!

If you like, I can give your patch a spin on my randconfig build
system before you submit it for inclusion, in case there is another
problem we both missed.

        Arnd
