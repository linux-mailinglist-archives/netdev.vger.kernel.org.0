Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47264C4CB2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbiBYRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiBYRlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:41:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45731D86FE
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cVR84+NrpKn1GCrMWXJOfEzw9at7fSoHO4f3kHfeqis=; b=sGzpfWeKKp6S/oKT5ZoeZNpCf7
        96XIQn7SG1a5PBdqxvbitARUepjdNezkFCmEI2yqFO7yaMefrYauPoEuH83xFK0s96NzCNuf9ufl6
        kkng6AOFzs6qPIuOlxYBaIfe5nExItWp91rDhumgn8Ri/dex7xfDAW4A01NCTxx7a9HzBwl0v/3WY
        CRoVGcC9uWu7YrKuOYay399OeOYPaDkaPi6HauvB5ugw0PD++UfsnQxMZmOMFGiE3MSglO6CN4xrb
        vrBMvGS0WCD8gsALlkZ9O5mbPJ+XWj8CSGP5m90c7QeJkHHM8p68CGP5PLyJZqYbqPuF0tUrziUKU
        oZf9JL8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57506)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNeZw-0005t3-3T; Fri, 25 Feb 2022 17:40:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNeZt-0003Hi-N5; Fri, 25 Feb 2022 17:40:25 +0000
Date:   Fri, 25 Feb 2022 17:40:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Further phylink changes (was: [PATCH net-next 1/4] net: dsa:
 ocelot: populate supported_interfaces)
Message-ID: <YhkUidpCbLjrdMAE@shell.armlinux.org.uk>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
 <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
 <20220225162530.cnt4da7zpo6gxl4z@skbuf>
 <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
 <20220225181653.00708f13@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220225181653.00708f13@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 06:16:53PM +0100, Marek Behún wrote:
> On Fri, 25 Feb 2022 16:31:52 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Fri, Feb 25, 2022 at 04:25:30PM +0000, Vladimir Oltean wrote:
> > > On Fri, Feb 25, 2022 at 04:19:25PM +0000, Russell King (Oracle) wrote:  
> > > > Populate the supported interfaces bitmap for the Ocelot DSA switches.
> > > > 
> > > > Since all sub-drivers only support a single interface mode, defined by
> > > > ocelot_port->phy_mode, we can handle this in the main driver code
> > > > without reference to the sub-driver.
> > > > 
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---  
> > > 
> > > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> > 
> > Brilliant, thanks.
> > 
> > This is the final driver in net-next that was making use of
> > phylink_set_pcs(), so once this series is merged, that function will
> > only be used by phylink internally. The next patch I have in the queue
> > is to remove that function.
> > 
> > Marek Behún will be very happy to see phylink_set_pcs() gone.
> 
> Yes, finally we can convert mv88e6xxx fully :)

... changing the subject line to show we've drifted off topic ...

Yes, once we've worked out what the PCS interface should look like in
order to deal with the 88E6393 errata workaround that needs to be run
each time the interface changes or whenever we "power up" the PCS.

I think that needs to be discussed, because I can see no clean and
clear solution that doesn't have some kind of down-side.

The existing pcs_enable/pcs_disable I have in my tree fits well with
the idea of changing a PCS, but not for being called every time we do
a major config when the PCS isn't being changed. To see what I mean,
would someone who didn't have the 6393 issue be happy with this
sequence on every major configuration, even when the PCS isn't being
changed:

	mac_prepare()
	pcs_disable()
	mac_config()
	pcs_enable()
	pcs_config()
	pcs_an_restart()
	mac_finish()

I thought about calling pcs_disable() pcs_prepare() but that then
throws out pcs_enable(), unless we do that after pcs_config() - but
what if pcs_enable() is used to clear the PDOWN bit of the PCS, or
other (possibly external) PCS power control that prevents its registers
being accessed.

I'm also thinking, having had another recent look at
mv88e6xxx_mac_config(), we would need to move this:

        if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
                /* In inband mode, the link may come up at any time while the
                 * link is not forced down. Force the link down while we
                 * reconfigure the interface mode.
                 */
                if (mode == MLO_AN_INBAND &&
                    p->interface != state->interface &&
                    chip->info->ops->port_set_link)
                        chip->info->ops->port_set_link(chip, port,
                                                       LINK_FORCED_DOWN);

into a mac_prepare() callback so it still happens prior to the PCS
being called - which will need to happen between mac_prepare() and
mac_config() for the errata. That means extending the mac_prepare()
and mac_finish() methods into DSA as well.

I do have a patch to add those additional callbacks to DSA, but I
currently have no code that makes use of them (so haven't sent it
yet.) See "net: dsa: add support for new phylink calls".

I think I would prefer at this point - to get the mt7530 changes
settled, which will then allow the phylink_helper_basex_speed()
helper to be removed, do a few further phylink/sfp code cleanups
(using %pe consistently in that code to print errors) and then wait
until the next kernel cycle before tackling mv88e6xxx.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
