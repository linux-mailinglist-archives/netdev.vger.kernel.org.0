Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85C63C4B46
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfJBKXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:23:07 -0400
Received: from mail-vk1-f196.google.com ([209.85.221.196]:44910 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfJBKXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 06:23:07 -0400
Received: by mail-vk1-f196.google.com with SMTP id j21so4189894vki.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 03:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/jUUFpwTFmW5dFyAGDc97uDanV/D5VTHXHSx1PRA2NA=;
        b=dIzaFpJqUYIfg1tzQu7aopdJchA5p4ywAbr5sl7UK5NW3t4SmLNWNCvoefJme/jDtK
         KrLEru/TqK9orDxoWW+Gcnw13b0AucMrh/ASwRrjf68bg3j0iCMJMZ0uYEjjnWKb+Fk0
         A/dt1Dgttou+z8GtMk0h1HS1bE/SLQYPk+aoiYZLXzqGbj8WT94R0vlBeeKfRTdkU+Zo
         Vg4wG0tciv1UaVS/1GzhD+9PX/cpdu6dkSptp2Am2rN5SUnd+aBkD3DgkAFOnAAccn5z
         jENlsWDj3mwLkx3xUygqEg5p5Bb86qH8Chb+ajuDNn8ULCFBaVZEIrhlmHnApT3KmCKY
         8I/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/jUUFpwTFmW5dFyAGDc97uDanV/D5VTHXHSx1PRA2NA=;
        b=W16a50mVUUHGSNl4A16oChosKaQXrE2BhO13eJoVoTj6fbxdCKR5PnZhuPpSYXPVbu
         AFcAPJh39yXtiVVTtn6noGLwVPU+Pf/AE3G24UUXORap5XY6dyy7I3t72V8HeyR8gxux
         Ec+VyAJFi3fbsvnOthSFRupqRxoWekkC87152jm5DyRImVH70whx8iPhfa+UL212LLC0
         dS3xnXmIDNAMs96V1NMOppHGwZjRPZa6HjF5q0NhPDbgzOFOo1ZFat3JFA22vi0dDFB5
         DVH+aeIEzyjNh6LS+qirLGpy35RJjsMUJmJhkIzwDz46UIta2o3vRlEK+NEMjeM8KtuB
         FlHw==
X-Gm-Message-State: APjAAAUUitgtIwK2VJICjxVg7m1sSOC7K0P/WBcGItcWDc4AOdGYWYol
        /kk5kzeQ9fSsjHY4DGWoYNRgCCv/8OPyPPkaS0bUbg==
X-Google-Smtp-Source: APXvYqwRmHjZ3eZir5reMowy1hVTb73IlreG7jEHPpVscHxVmVTgaTZ5vkeSDVJW4fP5tSjdOgI90SlLp2wQDIgexmE=
X-Received: by 2002:a1f:4154:: with SMTP id o81mr1564318vka.56.1570011785313;
 Wed, 02 Oct 2019 03:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
 <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com> <a3066098-9fba-c2f4-f2d3-b95b08ef5637@gmail.com>
 <71ccd182-beec-31f4-5a25-a81a7457ca55@gmail.com>
In-Reply-To: <71ccd182-beec-31f4-5a25-a81a7457ca55@gmail.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Wed, 2 Oct 2019 18:22:28 +0800
Message-ID: <CAPpJ_efajCONc=7LaUdGftEpKpnpSMXn8YBE6=epJ57fF_WekA@mail.gmail.com>
Subject: Re: Driver support for Realtek RTL8125 2.5GB Ethernet
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> =E6=96=BC 2019=E5=B9=B410=E6=9C=882=
=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=881:54=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> On 26.07.2019 21:05, Heiner Kallweit wrote:
> > On 24.07.2019 22:02, Heiner Kallweit wrote:
> >> On 24.07.2019 10:19, Jian-Hong Pan wrote:
> >>> Hi all,
> >>>
> >>> We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
> >>> Ethernet [1] recently.  But, there is no related driver in mainline
> >>> kernel yet.  So, we can only use the vendor driver [2] and customize
> >>> it [3] right now.
> >>>
> >>> Is anyone working on an upstream driver for this hardware?
> >>>
> >> At least I'm not aware of any such work. Issue with Realtek is that
> >> they answer individual questions very quickly but company policy is
> >> to not release any datasheets or errata documentation.
> >> RTL8169 inherited a lot from RTL8139, so I would expect that the
> >> r8169 driver could be a good basis for a RTL8125 mainline driver.
> >>
> > Meanwhile I had a look at the RTL8125 vendor driver. Most parts are
> > quite similar to RTL8168. However the PHY handling is quite weird.
> > 2.5Gbps isn't covered by Clause 22, but instead of switching to
> > Clause 45 Realtek uses Clause 22 plus a proprietary chip register
> > (for controlling the 2.5Gbps mode) that doesn't seem to be accessible
> > via MDIO bus. This may make using phylib tricky.
> >
> In case you haven't seen it yet: Meanwhile I added RTL8125 support to
> phylib and r8169, it's included in 5.4-rc1. I tested it on a
> RTL8125-based PCIe add-on card, feedback from your system would be
> appreciated. Note that you also need latest linux-firmware package
> from Sep 23rd.

Thank you!!!

I tried kernel 5.4.0-rc1 on the desktop equipped with Realtek RTL8125
2.5GB Ethernet.

$ sudo lspci -nnvs 04:00.0
[sudo] password for dev:
04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
Device [10ec:8125] (rev 01)
    Subsystem: Acer Incorporated [ALI] Device [1025:1354]
    Flags: bus master, fast devsel, latency 0, IRQ 17
    I/O ports at 3000 [size=3D256]
    Memory at a4200000 (64-bit, non-prefetchable) [size=3D64K]
    Memory at a4210000 (64-bit, non-prefetchable) [size=3D16K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable- Count=3D1/1 Maskable+ 64bit+
    Capabilities: [70] Express Endpoint, MSI 01
    Capabilities: [b0] MSI-X: Enable+ Count=3D4 Masked-
    Capabilities: [d0] Vital Product Data
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [148] Virtual Channel
    Capabilities: [168] Device Serial Number 01-00-00-00-68-4c-e0-00
    Capabilities: [178] Alternative Routing-ID Interpretation (ARI)
    Capabilities: [188] Single Root I/O Virtualization (SR-IOV)
    Capabilities: [1c8] Transaction Processing Hints
    Capabilities: [254] Latency Tolerance Reporting
    Capabilities: [25c] L1 PM Substates
    Capabilities: [26c] Vendor Specific Information: ID=3D0002 Rev=3D4 Len=
=3D100 <?>
    Kernel driver in use: r8169
    Kernel modules: r8169

Module r8169 works for it.

$ dmesg | grep r8169
[   19.631623] libphy: r8169: probed
[   19.631978] r8169 0000:04:00.0 eth0: RTL8125, 94:c6:91:5f:1f:45,
XID 609, IRQ 127
[   19.631983] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
[   19.635492] r8169 0000:04:00.0 enp4s0: renamed from eth0
[   21.778431] RTL8125 2.5Gbps internal r8169-400:00: attached PHY
driver [RTL8125 2.5Gbps internal] (mii_bus:phy_addr=3Dr8169-400:00,
irq=3DIGNORE)
[   21.871953] r8169 0000:04:00.0 enp4s0: Link is Down
[   24.668516] r8169 0000:04:00.0 enp4s0: Link is Up - 1Gbps/Full -
flow control off

Jian-Hong Pan

> >>> [1] https://www.realtek.com/en/press-room/news-releases/item/realtek-=
launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-ap=
plications-including-gaming-solution
> >>> [2] https://www.realtek.com/en/component/zoo/category/network-interfa=
ce-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
> >>> [3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571=
524ed71fd237d32b
> >>>
> >>> Jian-Hong Pan
> >>>
> >> Heiner
> >>
> > Heiner
> >
> Heiner
