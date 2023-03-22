Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8036C57AE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbjCVUdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjCVUcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:32:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301CF7E890;
        Wed, 22 Mar 2023 13:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RJnBW7Rh8QHDpl6FjPdpBVUEip/zc++dsEAKM1kRrBw=; b=mFOD+byEDdZRCFsFpab3t6wdps
        XMW6h51In6/KAHPJXHnuP/ZIV510iszkMq9PRQZLoPYU7khYGaDDvE1QJ7zWEPiVYJ3/6RAGJ22uz
        of2uBxTy5jhun46AcWetymwJ6iB3jC7PzXD1iSFFLQwd+MU1zv07FnzhdoUeu/opMW6DdAVVyoUJt
        RzXTnslu4qGZEsRGs4pNDX4XG1A0zQufuvx/GZHqNTbw3lPp8lvipbHymE290WzAoFQ/5iSUzn8v9
        V3129x0VUN/QSjqCaN1EprEQ6l6OM7Evb+etWxNFJ5BZNN6XehFeG2919Pd5uYr2eMu3x5lyo0C4B
        /fbvG0OQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35878)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pf4yu-0003sW-Mz; Wed, 22 Mar 2023 20:22:48 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pf4yt-0000ew-Oo; Wed, 22 Mar 2023 20:22:47 +0000
Date:   Wed, 22 Mar 2023 20:22:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
 <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 09:17:02PM +0100, Andrew Lunn wrote:
> On Wed, Mar 22, 2023 at 08:13:51PM +0000, Russell King (Oracle) wrote:
> > On Wed, Mar 22, 2023 at 07:57:19PM +0100, Andrew Lunn wrote:
> > > > +static struct fwnode_handle *mv88e6xxx_port_get_fwnode(struct dsa_switch *ds,
> > > > +						       int port,
> > > > +						       struct fwnode_handle *h)
> > > > +{
> > > > +	struct mv88e6xxx_chip *chip = ds->priv;
> > > > +	struct device_node *np, *phy_node;
> > > > +	int speed, duplex, err;
> > > > +	phy_interface_t mode;
> > > > +	struct dsa_port *dp;
> > > > +	unsigned long caps;
> > > > +
> > > > +	dp = dsa_to_port(ds, port);
> > > > +	if (dsa_port_is_user(dp))
> > > > +		return h;
> > > > +
> > > > +	/* No DT? Eh? */
> > > > +	np = to_of_node(h);
> > > > +	if (!np)
> > > > +		return h;
> > > 
> > > I've not looked at the big picture yet, but you can have a simple
> > > switch setup without DT. I have a couple of amd64 boards which use
> > > platform data. The user ports all have internal PHYs, and the CPU port
> > > defaults to 1G, it might even be strapped that way.
> > 
> > Are you suggesting that we should generate some swnode description of
> > the max interface mode and speed if we are missing a DT node?
> > 
> > I'm not seeing any port specific data in the mv88e6xxx platform data.
> 
> No, i'm just pointing out that not have DT is not an error, and can
> happen. I just wanted to make sure you are not assuming there is
> always DT.

What I'm trying to find out is what you think the behaviour should be
in this case. Are you suggesting we should fall back to what we do now
which is let the driver do it internally without phylink.

The problem is that if we don't go down the phylink route for everything
then we /can't/ convert mv88e6xxx to phylink_pcs, because the "serdes"
stuff will be gone, and the absence of phylink will mean those won't be
called e.g. to power up the serdes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
