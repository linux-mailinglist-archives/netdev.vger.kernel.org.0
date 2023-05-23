Return-Path: <netdev+bounces-4704-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9EF770DF4B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 758BC1C20E0F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56CFE449D6;
	Tue, 23 May 2023 14:32:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459E1449D4
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:32:25 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1BCE0;
	Tue, 23 May 2023 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Gt6OuL8CneaiBwQzPU5+pzNa/LWBLUojkUkd9+tYBq4=; b=xHpgA035ESTfW6OxAT34YyMjVg
	3QD1QJ14QSOvqoGqaSie/022MatJ2xBc08jgt91qlusGfFH/jq6MB9VqPBxn+mYulk5n9PtUDuVbr
	JR6oRIhn6xo44r75orJE3kqgI305+L1Im/LZswAaMzNStks89rMkm0kpgs+Slis0J0R6TBjzn0bUo
	7EUoKPFZjo2ME2Mz1YFmIOIsqU+BRo7lfTisxa64DCXdlDzxcLgFw7+ixHRoyTS4dqUmicA3DXmZr
	KsQxfhtoZpQ7bxgA0NQIZhIn9stNWqrnLIVqcLg+zJn4BvHHqapXBjosrDXJb8lLtcWi5H84VwSxR
	uqkKEkKg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48098)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1T3d-0000Y0-NF; Tue, 23 May 2023 15:32:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1T3W-0000eE-Np; Tue, 23 May 2023 15:32:06 +0100
Date: Tue, 23 May 2023 15:32:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: David Epping <david.epping@missinglinkelectronics.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: mscc: support VSC8501
Message-ID: <ZGzOZm0oJimLHCDA@shell.armlinux.org.uk>
References: <20230523090405.10655-1-david.epping@missinglinkelectronics.com>
 <c613298d-53bc-46ef-9cb2-4b385e21ba7b@lunn.ch>
 <20230523133236.GA7185@nucnuc.mle>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523133236.GA7185@nucnuc.mle>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 03:32:36PM +0200, David Epping wrote:
> On Tue, May 23, 2023 at 03:16:51PM +0200, Andrew Lunn wrote:
> > > - I left the mutex_lock(&phydev->lock) in the
> > >   vsc85xx_update_rgmii_cntl() function, as I'm not sure whether it
> > >   is required to repeatedly access phydev->interface and
> > >   phy_interface_is_rgmii(phydev) in a consistent way.
> > 
> > Just adding to Russell comment.
> > 
> > As a general rule of thumb, if your driver is doing something which no
> > other driver is doing, you have to consider if it is correct. A PHY
> > driver taking phydev->lock is very unusual. So at minimum you should
> > be able to explain why it is needed. And when it comes to locking,
> > locking is hard, so you really should understand it.
> > 
> > Now the mscc is an odd device, because it has multiple PHYs in the
> > package, and a number of registers are shared between these PHYs. So
> > it does have different locking requirements to most PHYs. However, i
> > don't think that is involved here. Those oddities are hidden behind
> > phy_base_write() and phy_base_read().
> > 
> > 	Andrew
> 
> Russell, Andrew,
> 
> as you stated, locking is hard, and I am not in detail familiar with
> the mscc driver and the supported PHYs behavior. Also, I only have
> VSC8501, the single PHY chip, and none of the multi PHY chips to test.
> And testing these corner cases and race conditions is hard anyways.
> Thus my current patch is not touching the locking code at all, and
> assumes the current mainline code is correct in that regard.
> Because I don't understand all implications, I'm hesitant to change
> the existing locking scheme.
> Maybe this can be a separate patch? In the current patch set I'm not
> making the situation worse (unlike the first one where I added locks
> which Russell pointed out).
> If you insist and all agree the locks should be removed with this
> patch set, I'll update it of course.

Reading through this driver, IMHO it's clear that the original author
didn't have much idea about locking.

Your assumption that taking phydev->lock in vsc85xx_rgmii_set_skews()
protects phydev->interface is provably false, because:

static int vsc8584_config_init(struct phy_device *phydev)
{
...
        if (phy_interface_is_rgmii(phydev)) {
                ret = vsc85xx_rgmii_set_skews(phydev, VSC8572_RGMII_CNTL,
                                              VSC8572_RGMII_RX_DELAY_MASK,
                                              VSC8572_RGMII_TX_DELAY_MASK);

This accesses phydev->interface without holding phydev->lock,
before entering vsc85xx_rgmii_set_skews().

The second place that vsc85xx_rgmii_set_skews() is called from is
vsc85xx_default_config() which also accesses phydev->interface,
again without taking the phydev->lock.

So both paths into vsc85xx_rgmii_set_skews() have already read
phydev->interface without taking the lock. If this was what the
lock in vsc85xx_rgmii_set_skews() was protecting, then surely it
would need to protect those reads as well! It doesn't.

Also, with knowledge of phylib, I can say that this lock is
completely unnecessary when accessing phydev->interface in any
PHY driver .config_init method, which is the only place that
vsc85xx_rgmii_set_skews() is called from.


Having read the rest of the driver, it would appear that phydev->lock
is being abused to protect register accesses. This is evidenced by
the following, where I also set out why it's wrong:

vsc85xx_led_cntl_set()... which should be using phy_modify(), not
phy_read()..modify..phy_write(), which is open to races e.g. from
userspace MDIO access. phydev->lock doesn't solve anything there.

vsc85xx_edge_rate_cntl_set()... which correctly uses
phy_modify_paged() which itself will correctly prevent racy accesses
by taking the MDIO bus lock. It makes no accesses to anything else,
so phydev->lock here is entirely unnecessary.

vsc85xx_mac_if_set()... which is another case of racy access in the
same way as vsc85xx_led_cntl_set().

vsc8531_pre_init_seq_set() and vsc85xx_eee_init_seq_set()... both of
which IMHO show a complete misunderstanding for locking. At least
both of these functions are safe from other threads accessing the
bus because they correctly use phy_select_page()...phy_restore_page()
(which uses the MDIO bus lock to guarantee no other access will
happen.) BTW, I'm the author of phy_select_page()...phy_restore_page()
which were added to ensure that PHY drivers can _safely_ access
paged registers without fear of anything else disrupting accesses
to those paged registers, not even from userspace.

Essentially, taking phydev->lock offers absolutely zero protection
against another thread making accesses to the PHYs registers. The
*only* lock which prevents concurrent access to registers on devices
on a MDIO bus is the MDIO bus lock.

The only locking decision that I can see in this driver that is
correct is in phy_base_(read|write) which correctly demand that the
MDIO bus lock is held.


Oh my, things get even more "fun"...

vsc8574_config_pre_init() requires the MDIO bus lock to be held when
its called. This function uses request_firmware(), which can call out
 to userspace and then *block* waiting for userspace to respond. This
will block *all* access to any device on that MDIO bus until the
firmware request has been satisfied.

Sorry, but the locking in this driver is nothing but a mess.

I'm sorry that you're the one who's modifying the driver when we've
spotted this, but please can you add a patch which first removes
phydev->lock from vsc85xx_rgmii_set_skews() and then your patch on
top please?

At least that starts to reduce the amount of broken locking in this
driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

