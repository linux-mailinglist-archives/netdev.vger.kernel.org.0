Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88ED6DB1F8
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDGRon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDGRom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:44:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F27111D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=duiqLm69OxxKxu+8yAxxESi8eqa7R//4T6iLQITVVqg=; b=q43Kgt/X761EVM4Vdu8rA1jmTx
        K3tUX51G8CBZNQctqO4UNY2iTQn1ow2BCclDwY2SAIVWv/6NBG0O9wl5ISzHpvzVxJS7cYzAF11Lm
        OveiJfBYb57kUwnKA3SuQ/lyjYCkvtMG362NRjaW75vPmd2zKqobOOVSt01mCXWE5jqxkmly4C9Vw
        XHs0CW6PxMMJSUbjIG43eqGFzlC3iN9it16DkHYq/rHDvGLw4dWXkKYdP4Qt0IRSwTjm1oT/JMOFe
        9BBoRZdV3ueXrzvgxyKcuRsgaLjxFH+meh2k9To/ltO5SW+8AYoMf6momYdKOG+1rAt9jYjAIdz70
        ulmAlz8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59226)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pkq8N-0000BI-Ir; Fri, 07 Apr 2023 18:44:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pkq8K-0000Dy-F4; Fri, 07 Apr 2023 18:44:20 +0100
Date:   Fri, 7 Apr 2023 18:44:20 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:25:57PM +0200, Andrew Lunn wrote:
> Hi Russell
> 
> It looks like you were not Cc:ed.

Thanks Andrew.

It really would help if people Cc'd the right folk! Because they failed
to, sorry, this isn't going to be a reply that's threaded properly...

> > diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> > index d0e3f6e2db1d..8917f22f90d2 100644
> > --- a/drivers/net/dsa/microchip/ksz8795.c
> > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > @@ -1321,12 +1321,52 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
> >  			if (remote & KSZ8_PORT_FIBER_MODE)
> >  				p->fiber = 1;
> >  		}
> > -		if (p->fiber)
> > -			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
> > -				     PORT_FORCE_FLOW_CTRL, true);
> > -		else
> > -			ksz_port_cfg(dev, i, regs[P_STP_CTRL],
> > -				     PORT_FORCE_FLOW_CTRL, false);
> > +	}
> > +}
> > +
> > +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> > +			      unsigned int mode, phy_interface_t interface,
> > +			      struct phy_device *phydev, int speed, int duplex,
> > +			      bool tx_pause, bool rx_pause)
> > +{
> > +	struct dsa_switch *ds = dev->ds;
> > +	struct ksz_port *p;
> > +	u8 ctrl = 0;
> > +
> > +	p = &dev->ports[port];
> > +
> > +	if (dsa_upstream_port(ds, port)) {
> > +		u8 mask = SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
> > +			SW_FLOW_CTRL | SW_10_MBIT;
> > +
> > +		if (duplex) {
> > +			if (tx_pause && rx_pause)
> > +				ctrl |= SW_FLOW_CTRL;
> > +		} else {
> > +			ctrl |= SW_HALF_DUPLEX;
> > +			if (tx_pause && rx_pause)
> > +				ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> > +		}
> > +
> > +		if (speed == SPEED_10)
> > +			ctrl |= SW_10_MBIT;
> > +
> > +		ksz_rmw8(dev, REG_SW_CTRL_4, mask, ctrl);
> > +
> > +		p->phydev.speed = speed;
> > +	} else {
> > +		const u16 *regs = dev->info->regs;
> > +
> > +		if (duplex) {
> > +			if (tx_pause && rx_pause)
> > +				ctrl |= PORT_FORCE_FLOW_CTRL;
> > +		} else {
> > +			if (tx_pause && rx_pause)
> > +				ctrl |= PORT_BACK_PRESSURE;
> > +		}
> > +
> > +		ksz_rmw8(dev, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
> > +			 PORT_BACK_PRESSURE, ctrl);

So, I guess the idea here is to enable some form of flow control when
both tx and rx pause are enabled.

Here's a bunch of questions I would like answered before I give a tag:

1) It looks like the device only supports symmetric pause?
2) If yes, are you *not* providing MAC_ASYM_PAUSE in the MAC
   capabilities? If not, why not?
3) If yes, then please do as others do and use tx_pause || rx_pause
   here.

Lastly, a more general question for ethtool/network folk - as for half
duplex and back pressure, is that a recognised facility for the MAC
to control via the ethtool pause parameter API?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
