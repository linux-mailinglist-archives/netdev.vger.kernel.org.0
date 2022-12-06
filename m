Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD0664475C
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiLFPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiLFPDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:03:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA402CDC9;
        Tue,  6 Dec 2022 06:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aOu3hcI2HuAA6JdI2YrAKpOHbakqeDHTAxD/ZZJJ0bc=; b=UNS+SWcy5CTU8YNCqy0hroPSbB
        QWdBiYIYEOndB9iaeGHfIW5AQINGFgE03FIPcnZrWwCr444dIXeVCuYL3BpCYsGVjnd0vUIISqyDZ
        nYPH8Qc0+qLWMjnidPclIIdtPHstye1LENG9PnAyrtcuDkd8f/Baklm28G5dXeMGmZmg0NRjeWTtw
        PKf8Z9xYc2wfaIPlOdAGdspDi3PzPMnuHJdp5/2jJI7z4Qyvzv7x54xn6+KiBU2+k01pIKye7AHof
        1VEOkr/L/DqLs3YzsRhdIa6MdzymTh7Tu4dECx6xQfXV1Dgb9LSXy0YSoz24KcrFo+a5Sa/eKwQjs
        VVFsezXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35602)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p2ZNa-00082b-Ah; Tue, 06 Dec 2022 14:57:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p2ZNY-0008Hm-9U; Tue, 06 Dec 2022 14:57:04 +0000
Date:   Tue, 6 Dec 2022 14:57:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the
 onsemi NCN26000 10BASE-T1S PHY
Message-ID: <Y49YQOOhAslQQ9zt@shell.armlinux.org.uk>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
 <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
 <Y49IBR8ByMQH6oVt@lunn.ch>
 <Y49THkXZdLBR6Mxv@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49THkXZdLBR6Mxv@gvm01>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 03:35:10PM +0100, Piergiorgio Beruto wrote:
> On Tue, Dec 06, 2022 at 02:47:49PM +0100, Andrew Lunn wrote:
> > > +static int ncn26000_read_status(struct phy_device *phydev)
> > > +{
> > > +	// The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
> > > +	// the PHY is up. It further reports the logical AND of the link status
> > > +	// and the PLCA status in the BMSR_LSTATUS bit. Thus, report the link
> > > +	// status by testing the appropriate BMSR bit according to the module's
> > > +	// parameter configuration.
> > > +	const int lstatus_flag = link_status_plca ?
> > > +		BMSR_LSTATUS : NCN26000_BMSR_LINK_STATUS_BIT;
> > > +
> > > +	int ret;
> > > +
> > > +	ret = phy_read(phydev, MII_BMSR);
> > > +	if (unlikely(ret < 0))
> > > +		return ret;
> > > +
> > > +	// update link status
> > > +	phydev->link = (ret & lstatus_flag) ? 1 : 0;
> > 
> > What about the latching behaviour of LSTATUS?
> See further down.
> 
> > 
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/phy_device.c#L2289
> > 
> > > +
> > > +	// handle more IRQs here
> > 
> > You are not in an IRQ handler...
> Right, this is just a left-over when I moved the code from the ISR to
> this functions. Fixed.
> 
> > You should also be setting speed and duplex. I don't think they are
> > guaranteed to have any specific value if you don't set them.
> Ah, I got that before, but I removed it after comment from Russell
> asking me not to do this. Testing on my HW, this seems to work, although
> I'm not sure whether this is correct or it is working 'by chance' ?

I asked you to get rid of them in the config function, which was
setting them to "unknown" values. I thought I explained why it was
wrong to set them there - but again...

If you force the values in the config function, then when userspace
does a read-modify-write of the settings via ethtool, you will end
up wiping out the PHYs link settings, despite maybe nothing having
actually been changed. It is also incorrect to set them in the
config function, because those writes to those variables can race
with users reading them - the only place they should be set by a
PHY driver is in the .read_status method.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
