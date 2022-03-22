Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FBF4E3AAA
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiCVIfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbiCVIfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:35:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8556164EC;
        Tue, 22 Mar 2022 01:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA2E2615B3;
        Tue, 22 Mar 2022 08:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEDEC340F5;
        Tue, 22 Mar 2022 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647938028;
        bh=7yG7Rj1VOotT8xX3nRCCSE4Ps7fblBYLqMoV0UuyWJM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BJK1GGolAjE6rSFsIt3dzd0rnKqmf4VcuC8PJxB7J9TxZ00JG0cVinufnM38eRwIi
         US5k3W99mRVZWG+tV2wHPL+K7icMB0ekx1UpqirgD9DmzzhV6Rz/k/MvxmeQ1TlYNo
         QlcHuSGeJaszLFh/t3HFdA2Ln7AudXLysEQ09E6jQ1pDlbsnBi/MkEq/J1iXUovKu4
         W9zJ/Vi7UtDWXq0wUeoeYTKgGLCtxd+dVroslBbLKSAmB3aMwYW9VhSVKeVSX0pEnx
         yh3uOFpyiRkJ9UX14FLEPB7/BHP3wkg4K2tXHCzWJoXwmHP5F52me7SlOTjuDvK61E
         qqSk0kGNM7xmw==
Received: by mail-wm1-f53.google.com with SMTP id m26-20020a05600c3b1a00b0038c8b999f58so917618wms.1;
        Tue, 22 Mar 2022 01:33:48 -0700 (PDT)
X-Gm-Message-State: AOAM530U0hB5yYlr55Y+FUGEVZ13r7SaF2Ij5/KFwl6bT4JhSzwXf62E
        GH9fpqXV7MnhLp1naErhFvFAt4NJhjL7b2yXWt0=
X-Google-Smtp-Source: ABdhPJz5v+zJtqsD7CQvEue0+LXmyMue51pVlFjcyHnuYqDSz49W6bDG1f2r6DkwUSUn34XRjmur3M91FPmlxkcDMDw=
X-Received: by 2002:a7b:cd13:0:b0:38b:f39c:1181 with SMTP id
 f19-20020a7bcd13000000b0038bf39c1181mr2760345wmj.20.1647938026486; Tue, 22
 Mar 2022 01:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAK8P3a12=qpMHn5daK3-E6PjWuSOYOyWp2u2XU0kfzZ8=EoRdA@mail.gmail.com> <20220321160627.6003e4e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321160627.6003e4e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 22 Mar 2022 09:33:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1tfnWe4nUDDeTyiH-U4XB4tTsZp-n5Oo=X1ovSwLOCVA@mail.gmail.com>
Message-ID: <CAK8P3a1tfnWe4nUDDeTyiH-U4XB4tTsZp-n5Oo=X1ovSwLOCVA@mail.gmail.com>
Subject: Re: Is drivers/net/wan/lmc dead?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 12:06 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 21 Mar 2022 23:10:32 +0100 Arnd Bergmann wrote:
> > On Mon, Mar 21, 2022 at 10:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > The driver for LAN Media WAN interfaces spews build warnings on
> > > microblaze.
> > >
> > > CCing usual suspects and people mentioned as authors in the source code.
> > >
> > > As far as I can tell it has no maintainer.
> > >
> > > It has also received not received a single functional change that'd
> > > indicate someone owns this HW since the beginning of the git era.
> > >
> > > Can we remove this driver or should we invest effort into fixing it?
> >
> > I have not seen the exact error, but I suspect the problem is that
> > microblaze selects CONFIG_VIRT_TO_BUS without actually
> > providing those interfaces. The easy workaround would be to
> > have microblaze not select that symbol.
>
> FWIW the warning is that virt_to_bus() discards the __iomem qualifier.
> I think it's a macro on most platforms but not microblaze.
> Anyway, some approximation of "VIRT_TO_BUS on mircoblaze is broken"
> sounds right.

Ok, I've reproduced it now, and I see that microblaze gets the virt_to_bus()
definition from include/asm-generic/io.h. The definition is in fact
correct, though
arguably microblaze (also h8300 and xtensa, probably more) should not
set CONFIG_VIRT_TO_BUS anyway because they do not use PCI
hardware from the 1990s.

The warning that I get is actually about the descriptor pointers
being marked 'volatile' (not '__iomem') and used as normal pointers
when passed to virt_to_bus(). Not sure whether the volatile here is
correct or not, but either removing it from lmc or adding it to the
virt_to_bus() prototype would avoid the warning.

> > Drivers using virt_to_bus() are inherently nonportable because
> > they don't work on architectures that use an IOMMU or swiotlb,
> > or that require cache maintenance for DMA operations.
> >
> > $ git grep -wl virt_to_bus drivers/
> > drivers/atm/ambassador.c
> > drivers/atm/firestream.c
> > drivers/atm/horizon.c
> > drivers/atm/zatm.c
> > drivers/block/swim3.c
> > drivers/gpu/drm/mga/mga_dma.c
> > drivers/net/appletalk/ltpc.c
> > drivers/net/ethernet/amd/au1000_eth.c
> > drivers/net/ethernet/amd/ni65.c
> > drivers/net/ethernet/apple/bmac.c
> > drivers/net/ethernet/apple/mace.c
> > drivers/net/ethernet/dec/tulip/de4x5.c
> > drivers/net/ethernet/i825xx/82596.c
> > drivers/net/ethernet/i825xx/lasi_82596.c
> > drivers/net/ethernet/i825xx/lib82596.c
> > drivers/net/hamradio/dmascc.c
> > drivers/net/wan/cosa.c
> > drivers/net/wan/lmc/lmc_main.c
> > drivers/net/wan/z85230.c
> > drivers/scsi/3w-xxxx.c
> > drivers/scsi/a2091.c
> > drivers/scsi/a3000.c
> > drivers/scsi/dpt_i2o.c
> > drivers/scsi/gvp11.c
> > drivers/scsi/mvme147.c
> > drivers/scsi/qla1280.c
> > drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
> > drivers/vme/bridges/vme_ca91cx42.c
> >
> > Among the drivers/net/wan/ drivers, I think lmc is actually
> > one of the newer pieces of hardware, most of the other ones
> > appear to even predate PCI.
>
> You know what's even newer than lmc?  Me :S  This HW is so old
> many of us have never interacted with these technologies directly.
>
> How do we start getting rid of this stuff? Should we send out patches
> to delete anything that's using virt_to_bus() under net|atm and see
> which ones don't get shot down?

I found the email from Martin Schiller that gives some background
on how hdlc/x25 is being used:
https://lore.kernel.org/lkml/407acd92c92c3ba04578da89b1a0f191@dev.tdt.de/

In short (and confirmed by Krzysztof's reply), most of the hdlc wan
hardware has been obsolete, but the subsystem itself is still used with
out-of-tree drivers. The situation for ATM is similar IIRC, as nobody uses
actual ATM is pretty much obsolete (I don't know how common it is in
practice) but DSL is still widely used.

I think we can probably come up with a set of atm, wan and appletalk
drivers that use either an ISA bus or the virt_to_bus() interface as
a starting point for a mass removal. From what I can tell, the majority
of the drivers using virt_to_bus() are platform specific already, mostly
m68k, and rooting out virt_to_bus() from all platform-independent
drivers would be good.

       Arnd
