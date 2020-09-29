Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016DF27D1AE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgI2OpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:45:03 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60203 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730178AbgI2OpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:45:03 -0400
Received: from mail-qv1-f50.google.com ([209.85.219.50]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1Mvbr4-1kfUmQ1Cdi-00sbtz; Tue, 29 Sep 2020 16:45:00 +0200
Received: by mail-qv1-f50.google.com with SMTP id cy2so2386914qvb.0;
        Tue, 29 Sep 2020 07:45:00 -0700 (PDT)
X-Gm-Message-State: AOAM5329VG6Sm4kSdgXIIBrjZzL2iSkPl1ADeApq8tx6HnOWftJH9X+c
        YQH52mgygp8LxKzv/AwcMk7GPHfSu371JnFGIHY=
X-Google-Smtp-Source: ABdhPJwUEfLhT6nEy8ORtCHOtevdRiC8FaJEppGWP4S0Kst6X+Go5tNb3MHPIZkiC1rq7E3ZnET/8yIm2xBApzpFJ+I=
X-Received: by 2002:a0c:b902:: with SMTP id u2mr4523553qvf.7.1601390699012;
 Tue, 29 Sep 2020 07:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com> <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com> <20200929134302.GF3950513@lunn.ch>
In-Reply-To: <20200929134302.GF3950513@lunn.ch>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 29 Sep 2020 16:44:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0etJf_SG8qLY0VjR+JamKQ8MtyPwoXnb0mpnGZawLfRA@mail.gmail.com>
Message-ID: <CAK8P3a0etJf_SG8qLY0VjR+JamKQ8MtyPwoXnb0mpnGZawLfRA@mail.gmail.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Networking <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UUe3p5BSAPrZMPuBiKGlJgcQ4Yfc0LA18XRo+o58zuDx+8Ng/LL
 diGKDwWdDu/n/alwvSBYFdxi+j/fMZbpM8uxkbPSsGT9BsPAMrosYwYYzFi/SBcjdvSZnzR
 G+qXxLexkqd1EKwII4t2JOuwrpLr3hidlRlEIaAMhklGhIO5PFnBdb0dqPtzjlgk2bdlsLi
 I1nBftaFuyEp574fjEUrA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OT0b7/YjpFI=:7Rm9kzr41J2o3XfuD6FULb
 kQidru2cUnkLy3a+Glk8fiSQBhVbEfswNuKKW7/a/Vq2cZ9NOGLKudZrdyNEFGqdSlt4D+Jw6
 QzCMDK9h1NFFaSSi0ZRgJF/w/C61C61JOyPQBgZj4FaRpg33ni4PSOLap77NBzMXBI08McUZ0
 QB5wXZ8dnhNT4tCHKuZnKVjayOA4LDfpjpU97g9ouVS3snoeDaOu3062jrfk8+e8RhBsmXdIr
 zaMqsK0iObHsTf0fD19Qp8j5pBhYnr6bPj5YRwNJw2mNtns8yABPuiLhJeBQ8g3/NRU4J3rhv
 Y7i2G3xjsu8o/TsLlk0KbQUL7uVxvoi8BCqqeGIAEFmJp6336w9aiNyeaYBgZJhHRczE+JAyR
 N5LCsWUskq1bUD24mYZ1qecVjrp5/4puar6FS47BpNK+1oe+uGfJblBDPpxgJHVv7R68tid/E
 jI8O3EHCNKXtzalVfA2YK+1evc4CPYzKL8kNbMGU8XIrnQEXBo/oaQ62kiajtiJNJR+g+FR/7
 3gBYw+7O8HEvwJ4St5QCFCfEc2ZUgkIDUEWHmMQUyrjf+1r7t9iLawazS2QXJ0ZfgFVk2Rfgs
 JLhm3moTVDHiL3bB1WDz/fSV9au1agSkjB/7ShwssrhZ3DQD+KrcuFf3BOXpCSzsjCjf/q1ns
 HBERv4+VnJsoAyD+1PaTTFuqV4oV3oS9U8/cdsmuTW6mxLGmfOhWevKXNfgjLMg/IZ1Ou/W+B
 CEjY2oomlJ7c/ZigZDVkPdX8RPaGI3O07CJP91TtuAxXBD9miU9mkhG/Hj97eBg7wMjC8B/77
 f6G0s4cOK6+RiCmY71ltRJ71GsmpesyStwbBYx6znyBKBoMOJ1RRCT0qW3FG5mz2qrN4ji2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 3:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Tue, Sep 29, 2020 at 10:47:03AM +0530, Calvin Johnson wrote:
> > On Fri, Sep 25, 2020 at 02:34:21PM +0100, Grant Likely wrote:
> > > > +DSDT entry for MDIO node
> > > > +------------------------
> > > > +a) Silicon Component
> > > > +--------------------
> > > > + Scope(_SB)
> > > > + {
> > > > +   Device(MDI0) {
> > > > +     Name(_HID, "NXP0006")
> > > > +     Name(_CCA, 1)
> > > > +     Name(_UID, 0)
> > > > +     Name(_CRS, ResourceTemplate() {
> > > > +       Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
> > > > +       Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
> > > > +        {
> > > > +          MDI0_IT
> > > > +        }
> > > > +     }) // end of _CRS for MDI0
> > > > +     Name (_DSD, Package () {
> > > > +       ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > > +       Package () {
> > > > +          Package () {"little-endian", 1},
> > > > +       }
> > >
> > > Adopting the 'little-endian' property here makes little sense. This looks
> > > like legacy from old PowerPC DT platforms that doesn't belong here. I would
> > > drop this bit.
> >
> > I'm unable to drop this as the xgmac_mdio driver relies on this variable to
> > change the io access to little-endian. Default is big-endian.
> > Please see:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/freescale/xgmac_mdio.c?h=v5.9-rc7#n55
>
> Hi Calvin
>
> Are we talking about the bus controller endiannes, or the CPU
> endianness?
>
> If we are talking about the CPU endiannes, are you plan on supporting
> any big endian platforms using ACPI? If not, just hard code it.
> Newbie ACPI question: Does ACPI even support big endian CPUs, given
> its x86 origins?

IIRC both UEFI and ACPI define only little-endian data structures.
The code does not attempt to convert these into CPU endianness
at the moment.  In theory it could be changed to support either, but
this seems non-practical for the UEFI runtime services that require
calling into firmware code in little-endian mode.

> If this is the bus controller endianness, are all the SoCs you plan to
> support via ACPI the same endianness? If they are all the same, you
> can hard code it.

NXP has a bunch of SoCs that reuse the same on-chip devices but
change the endianness between them based on what the chip
designers guessed the OS would want, which is why the drivers
usually support both register layouts and switch at runtime.
Worse, depending on which SoC was the first to get a DT binding
for a particular NXP on-chip device, the default endianness is
different, and there is either a "big-endian" or "little-endian"
override in the binding.

I would guess that for modern NXP chips that you might boot with
ACPI the endianness is always wired the same way, but I
understand the caution when they have been burned by this
problem before.

       Arnd
