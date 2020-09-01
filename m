Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D34E2589FC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgIAIBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgIAIBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:01:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BA1C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:01:09 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1Dy-0000jk-1f; Tue, 01 Sep 2020 10:01:02 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1Dx-0005PP-Ev; Tue, 01 Sep 2020 10:01:01 +0200
Date:   Tue, 1 Sep 2020 10:01:01 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 5/5] net: phy: smsc: LAN8710/LAN8720: remove
 PHY_RST_AFTER_CLK_EN flag
Message-ID: <20200901080101.yxwnf4l3q26vq2qi@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-6-m.felsch@pengutronix.de>
 <20200831141121.GF2403519@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831141121.GF2403519@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:00:01 up 290 days, 23:18, 278 users,  load average: 0.07, 0.10,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 20-08-31 16:11, Andrew Lunn wrote:
> On Mon, Aug 31, 2020 at 03:48:36PM +0200, Marco Felsch wrote:
> > Don't reset the phy without respect to the phy-state-machine because
> > this breaks the phy IRQ mode. We can archive the same behaviour if the
> > refclk in is specified.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  drivers/net/phy/smsc.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> > index b98a7845681f..67adf11ef958 100644
> > --- a/drivers/net/phy/smsc.c
> > +++ b/drivers/net/phy/smsc.c
> > @@ -337,7 +337,6 @@ static struct phy_driver smsc_phy_driver[] = {
> >  	.name		= "SMSC LAN8710/LAN8720",
> >  
> >  	/* PHY_BASIC_FEATURES */
> > -	.flags		= PHY_RST_AFTER_CLK_EN,
> >  
> >  	.probe		= smsc_phy_probe,
> 
> Hi Marco
> 
> There are two PHYs using PHY_RST_AFTER_CLK_EN. What about the other
> one?

I think that they are broken too but I can't verify this therefore I
left them out.

Regards,
  Marco

> 
> 	Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
