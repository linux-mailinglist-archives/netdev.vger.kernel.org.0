Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C31381DBF
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhEPJvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhEPJvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 05:51:18 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C619BC061573;
        Sun, 16 May 2021 02:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cz9qn7+jdUb8tbmliAGpSloeH8WkxiSELtKnjIcyduQ=; b=FFwDTVAbtAOtI+HtY00AxXtT54
        ScqsWkpPUku76SBIOengRfcPjtgj0WxW1J1MxPNjxOAE3tvc3ohmj6s379/3LbfvkD1wx2xXe8x7q
        ebnCh18PH2zXAAwPqAkm0wE3d8BPH9sDa2n5k+MgjeSu61+D8zOduLFYtzIeShXgSNUrpX/vzxz+I
        OHVTltHAp1z1BoPtOWqx4Bcc9Bw1DQpYGbqyPasMvx3JmhqCSq97l+C521/k/rsGMqSI4Wt0PO/Jt
        ASsyPsDd6nyh5O9OqWyL4dfPgCrNCj2Tl7K18pHZ23kkIBnu0er0OxSiTO3nC95vnxsRX3pfPFHPx
        PjXN5x7w==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1liDPL-000255-GT; Sun, 16 May 2021 10:49:59 +0100
Date:   Sun, 16 May 2021 10:49:59 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
Message-ID: <20210516094959.GM11733@earth.li>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch>
 <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
 <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKAFMg+rJsspgE84@Ansuel-xps.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 07:30:26PM +0200, Ansuel Smith wrote:
> On Sat, May 15, 2021 at 06:00:46PM +0100, Jonathan McDowell wrote:
> > On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
> > > On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
> > > > On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
> > > > > Fix mixed whitespace and tab for define spacing.
> > > > 
> > > > Please add a patch [0/28] which describes the big picture of what
> > > > these changes are doing.
> > > > 
> > > > Also, this series is getting big. You might want to split it into two,
> > > > One containing the cleanup, and the second adding support for the new
> > > > switch.
> > > > 
> > > > 	Andrew
> > > 
> > > There is a 0/28. With all the changes. Could be that I messed the cc?
> > > I agree think it's better to split this for the mdio part, the cleanup
> > > and the changes needed for the internal phy.
> > 
> > FWIW I didn't see the 0/28 mail either. I tried these out on my RB3011
> > today. I currently use the GPIO MDIO driver because I saw issues with
> > the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> > both QCA8337 devices and traffic flows as expected, so no obvious
> > regressions from your changes.
> > 
> > I also tried switching to the IPQ8064 MDIO driver for my first device
> > (which is on the MDIO0 bus), but it's still not happy:
> > 
> > qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13
> > 
> Can you try the v6 version of this series?

FWIW I tried v6 without altering my DT at all (so still using the GPIO
MDIO driver, and not switching to use the alternate PHY support) and got
an oops due to a NULL pointer dereference, apparently in the mdio_bus
locking code. I'm back porting to 5.10.37 (because I track LTS on the
device) so I might be missing something, but the v4 version I tried
previously worked ok.

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000558
pgd = (ptrval)
[00000558] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 20 Comm: kworker/0:1 Not tainted 5.10.37-00045-g7d01aa2545cb #2
Hardware name: Generic DT based system
Workqueue: events deferred_probe_work_func
PC is at mutex_lock+0x20/0x50
LR is at _cond_resched+0x28/0x4c
pc : [<c0a36b24>]    lr : [<c0a34530>]    psr: 60000013
sp : c1569c38  ip : 00000001  fp : c17bd1dc
r10: c17bd1c0  r9 : 00000000  r8 : 00000000
r7 : 00000002  r6 : 00000558  r5 : 00000000  r4 : 00000558
r3 : c1560000  r2 : c0e54389  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5787d  Table: 4220406a  DAC: 00000051
Process kworker/0:1 (pid: 20, stack limit = 0x(ptrval))
Stack: (0xc1569c38 to 0xc156a000)
9c20:                                                       c8020000 c07ee9b8
9c40: c17cc000 c17cc000 00000001 c07eea54 c17cc000 c07e25b8 c1569d14 c06d0f14
9c60: 00000000 30353630 ffff0a00 c17cc558 c17cc000 00000001 00000002 00000000
9c80: 00000000 c17bd1c0 c17bd1dc c07e2810 c0f04cc8 c17cc000 00000001 c0f04cc8
9ca0: 00000000 c07df518 ffffff08 ffff0a00 c0f0517c 00000000 00000000 ffffffff
9cc0: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
9ce0: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
9d00: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
9d20: ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff 58cdc110
9d40: c17cc578 c0f04cc8 c17cc000 c17cc000 00000001 c17cc578 00000000 c17bd1c0
9d60: c17bd1dc c07e20a0 00000000 c17bd1c0 c17bd1dc 58cdc110 00000001 c17cc000
9d80: 00000001 c17cc008 c17cc578 00000000 c17bd1c0 c07e29a4 c17bc040 00000000
9da0: c17bc040 c17d2800 c17bd0cc 00000001 c17bd1c0 c0a11814 00000000 00000dc0
9dc0: c0b81b20 c0f04cc8 c17bd1dc c0ceca94 c0d6e2b4 c17bd1c0 00000005 c17d2640
9de0: 00000040 c177c400 00000000 c0fe8b08 c17bc000 00000040 c177c400 00000000
9e00: 00000000 58cdc110 c0b59f78 c0fc4e44 c177c400 c102f58c 00000000 c0fe8b08
9e20: c0fc4e44 00000001 00000000 c07e2d04 c177c400 c102f584 c102f58c c0755e50
9e40: 60000013 58cdc110 c0d2b58c c177c400 c0fc4e44 c1569ecc c0fe8b08 00000001
9e60: c0d2b58c c0fe8b08 ffffe000 c0756400 c177c400 00000001 00000001 00000000
9e80: c0f04cc8 c1569ecc c0756664 00000001 c0d2b58c c0fe8b08 ffffe000 c0754028
9ea0: c0d2b58c c15aac6c c17808b8 58cdc110 c177c400 c177c400 c0f04cc8 c177c444
9ec0: c0fba314 c0755ca8 00000002 c177c400 00000001 58cdc110 c177c400 c177c400
9ee0: c0fc21f4 c0fba314 c0fe8b08 c0754dac c177c400 c0fba300 c0fba300 c075530c
9f00: c0fba340 c1403f00 df6917c0 df694900 00000000 c0fdf300 00000000 c033c034
9f20: c1560000 df6917c0 00000008 c1403f00 c1403f14 df6917c0 00000008 c0f03d00
9f40: df6917d8 df6917c0 ffffe000 c033c3cc c1560000 c0fdeb1e c0cdfe28 c033c388
9f60: c1403f00 c14e6040 c1549280 00000000 c1568000 c033c388 c1403f00 c14bdea4
9f80: c14e6064 c034282c 00000001 c1549280 c03426dc 00000000 00000000 00000000
9fa0: 00000000 00000000 00000000 c0300148 00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c0a36b24>] (mutex_lock) from [<c07ee9b8>] (qca8k_mdio_read+0x30/0xac)
[<c07ee9b8>] (qca8k_mdio_read) from [<c07eea54>] (qca8k_phy_read+0x20/0x30)
[<c07eea54>] (qca8k_phy_read) from [<c07e25b8>] (__mdiobus_read+0x3c/0x1ac)
[<c07e25b8>] (__mdiobus_read) from [<c07e2810>] (mdiobus_read+0x30/0x44)
[<c07e2810>] (mdiobus_read) from [<c07df518>] (get_phy_device+0x13c/0x25c)
[<c07df518>] (get_phy_device) from [<c07e20a0>] (mdiobus_scan+0xb0/0x190)
[<c07e20a0>] (mdiobus_scan) from [<c07e29a4>] (__mdiobus_register+0x17c/0x2fc)
[<c07e29a4>] (__mdiobus_register) from [<c0a11814>] (dsa_register_switch+0xbb8/0xc6c)
[<c0a11814>] (dsa_register_switch) from [<c07e2d04>] (mdio_probe+0x2c/0x50)
[<c07e2d04>] (mdio_probe) from [<c0755e50>] (really_probe+0x108/0x4f4)
[<c0755e50>] (really_probe) from [<c0756400>] (driver_probe_device+0x78/0x1e4)
[<c0756400>] (driver_probe_device) from [<c0754028>] (bus_for_each_drv+0x80/0xc4)
[<c0754028>] (bus_for_each_drv) from [<c0755ca8>] (__device_attach+0xe0/0x178)
[<c0755ca8>] (__device_attach) from [<c0754dac>] (bus_probe_device+0x84/0x8c)
[<c0754dac>] (bus_probe_device) from [<c075530c>] (deferred_probe_work_func+0x9c/0xdc)
[<c075530c>] (deferred_probe_work_func) from [<c033c034>] (process_one_work+0x22c/0x580)
[<c033c034>] (process_one_work) from [<c033c3cc>] (worker_thread+0x44/0x5c8)
[<c033c3cc>] (worker_thread) from [<c034282c>] (kthread+0x150/0x154)
[<c034282c>] (kthread) from [<c0300148>] (ret_from_fork+0x14/0x2c)
Exception stack(0xc1569fb0 to 0xc1569ff8)
9fa0:                                     00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
Code: e3c33d7f e3c3303f e593300c f594f000 (e1941f9f)
---[ end trace cc9433437c472cd4 ]---

J.

-- 
101 things you can't have too much of : 42 - Pepsi.
This .sig brought to you by the letter P and the number  1
Product of the Republic of HuggieTag
