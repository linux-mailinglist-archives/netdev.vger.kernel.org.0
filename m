Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A312D4AE55C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 00:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbiBHXRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 18:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiBHXRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 18:17:47 -0500
X-Greylist: delayed 897 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 15:17:47 PST
Received: from hs01.dk-develop.de (hs01.dk-develop.de [173.249.23.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2FFC061577
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 15:17:46 -0800 (PST)
Date:   Tue, 8 Feb 2022 23:52:44 +0100
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YgLxYeRzruu3Ugr1@pollux>
References: <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <YGcOBkr2V1onxWDt@lunn.ch>
 <YGoEo3s/AxrjowLH@arch-linux>
 <CAMuHMdUCDYvjZCrybxSF5rLGM81Ujkg=CSp-ymFWV+E8S5Wq6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUCDYvjZCrybxSF5rLGM81Ujkg=CSp-ymFWV+E8S5Wq6A@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

On Tue, Feb 08, 2022 at 05:30:01PM +0100, Geert Uytterhoeven wrote:
> On Sun, Apr 4, 2021 at 8:26 PM Danilo Krummrich
> <danilokrummrich@dk-develop.de> wrote:
> >
> > Yes, I'll get it ready once I got some spare time.
> 
> Did this ever happen? I cannot find such a patch.
> 
> I'm asking because I have access to a board with Marvell 88Q2110 PHYs
> (ID 0x002b0983).
No, it happened that I neither got access to the datasheet nor to a board I
could test on again.

I still have some reverse engineered protocol data and I/O traces from a
proprietary driver, which I can provide to you.

However, without a datasheet this might not lead to a proper driver, whereas
when having a proper datasheet this data might be needless.

> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert

- Danilo
