Return-Path: <netdev+bounces-1919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34BC26FF86A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE194281861
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E081E8F63;
	Thu, 11 May 2023 17:31:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A092068B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 17:31:08 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1268640C1;
	Thu, 11 May 2023 10:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+3MeGD4e+zpTZm4qDwhrhx/AMIAONPMrTTkRjCrQwwA=; b=wPhJHkv6R+rjiJGI0cDi92rsxN
	0dmmlqZzFR6KpV7LrZ724rqU/7TSYLzUrbSR8Badw5GPQNsXFFkFzEP7VcolyRHqYKkDNmcmRLBVr
	YzSnXHnd9i7SNPdqyZYUJndYEZlDxSY6Xiy7LzEWXKldMnz0dP8wXQEhkkUjrZOu1Aa01w6Wj6mm6
	o5kwGXXSPO08myLrgcYRn3Xdcyfn51Kc16YYytB/0VNAiFJrH+iLwdqP6To46vjLffLJIRyhS4vz6
	YnRNb9/TL3yII7sVhIYiYyzfMoUaei4KV9FAWqComQ+xCUDfTg999BX9xE/3kepIMcChV6H/63xBb
	JEWcXePQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37684)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pxA83-00072F-LC; Thu, 11 May 2023 18:30:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pxA81-0004CA-K6; Thu, 11 May 2023 18:30:57 +0100
Date: Thu, 11 May 2023 18:30:57 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <ZF0mUeKjdvZNG44q@shell.armlinux.org.uk>
References: <cover.1683756691.git.daniel@makrotopia.org>
 <55c11fd9-54cf-4460-a10c-52ff62b46a4c@lunn.ch>
 <ZF0iiDIZQzR8vMvm@pidgin.makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF0iiDIZQzR8vMvm@pidgin.makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 07:14:48PM +0200, Daniel Golle wrote:
> On Thu, May 11, 2023 at 02:28:15AM +0200, Andrew Lunn wrote:
> > On Thu, May 11, 2023 at 12:53:22AM +0200, Daniel Golle wrote:
> > > Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
> > > The PHYs can operate with Clause-22 and Clause-45 MDIO.
> > > 
> > > When using Clause-45 it is desireable to avoid rate-adapter mode and
> > > rather have the MAC interface mode follow the PHY speed. The PHYs
> > > support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.
> > 
> > I don't see what clause-45 has to do with this. The driver knows that
> > both C22 and C45 addresses spaces exists in the hardware. It can do
> > reads/writes on both. If the bus master does not support C45, C45 over
> > C22 will be performed by the core.
> 
> My understanding is/was that switching the SerDes interface mode is only
> intended with Clause-45 PHYs, derived from this comment and code:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/phy/phylink.c#n1661

It's only because:

1) Clause 22 PHYs haven't done this.
2) There is currently no way to know what set of interfaces a PHY would
   make use of - and that affects what ethtool linkmodes are possible.

What you point to is nothing more than a hack to make Clause 45 PHYs
work with the code that we currently have.

To sort this properly, we need PHY drivers to tell phylink what
interfaces they are going to switch between once they have been
attached to the network interface. This is what these patches in my
net-queue branch are doing:

net: phy: add possible interfaces
net: phy: marvell10g: fill in possible_interfaces
net: phy: bcm84881: fill in possible_interfaces
net: phylink: split out PHY validation from phylink_bringup_phy()
net: phylink: validate only used interfaces for c45 PHYs

Why only C45 PHYs again? Because the two PHY drivers that I've added
support for "possible_interfaces" to are both C45. There's no reason
we can't make that work for C22 PHYs as well.

We could probably make it work for C22 PHYs out of the box by setting
the appropriate bit for the supplied interface in "possible_interfaces"
inside phy_attach_direct() after the call to phy_init_hw() if
"possible_interfaces" is still empty, which means that if a PHY driver
isn't updated to setup "possible_interfaces" then we get basically
whatever interface mode we're attaching with there.

There may be a problem if phy_attach_direct() gets called with
PHY_INTERFACE_MODE_NA (which I believe is possible with DSA.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

