Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504A33A295B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJKcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbhFJKcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:32:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F92FC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:30:13 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHwq-0003px-Ap; Thu, 10 Jun 2021 12:30:04 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrHwp-0002SC-Ru; Thu, 10 Jun 2021 12:30:03 +0200
Date:   Thu, 10 Jun 2021 12:30:03 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 3/9] net: phy: micrel: use consistent
 indention after define
Message-ID: <20210610103003.n5jgeppvf4aod5hw@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-4-o.rempel@pengutronix.de>
 <20210526222448.zjpw3olck75332px@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210526222448.zjpw3olck75332px@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:27:39 up 190 days, 34 min, 40 users,  load average: 0.01, 0.03,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 01:24:48AM +0300, Vladimir Oltean wrote:
> On Wed, May 26, 2021 at 06:30:31AM +0200, Oleksij Rempel wrote:
> > This patch changes the indention to one space between "#define" and the
> 
> indention
> /ɪnˈdɛnʃ(ə)n/
> noun
> noun: indention; plural noun: indentions
> 
>     archaic term for indentation.
> 
> Interesting, I learned something new.
> 
> Also, technically it's alignment not indentation.

ok, changed :)

> > macro.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/phy/micrel.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > index a14a00328fa3..227d88db7d27 100644
> > --- a/drivers/net/phy/micrel.c
> > +++ b/drivers/net/phy/micrel.c
> > @@ -38,15 +38,15 @@
> >  
> >  /* general Interrupt control/status reg in vendor specific block. */
> >  #define MII_KSZPHY_INTCS			0x1B
> > -#define	KSZPHY_INTCS_JABBER			BIT(15)
> > -#define	KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
> > -#define	KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
> > -#define	KSZPHY_INTCS_PARELLEL			BIT(12)
> > -#define	KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
> > -#define	KSZPHY_INTCS_LINK_DOWN			BIT(10)
> > -#define	KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
> > -#define	KSZPHY_INTCS_LINK_UP			BIT(8)
> > -#define	KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
> > +#define KSZPHY_INTCS_JABBER			BIT(15)
> > +#define KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
> > +#define KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
> > +#define KSZPHY_INTCS_PARELLEL			BIT(12)
> > +#define KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
> > +#define KSZPHY_INTCS_LINK_DOWN			BIT(10)
> > +#define KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
> > +#define KSZPHY_INTCS_LINK_UP			BIT(8)
> > +#define KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
> >  						KSZPHY_INTCS_LINK_DOWN)
> >  #define	KSZPHY_INTCS_LINK_DOWN_STATUS		BIT(2)
> >  #define	KSZPHY_INTCS_LINK_UP_STATUS		BIT(0)
> 
> You left these aligned using tabs.

done.

> > @@ -54,11 +54,11 @@
> >  						 KSZPHY_INTCS_LINK_UP_STATUS)
> >  
> >  /* PHY Control 1 */
> > -#define	MII_KSZPHY_CTRL_1			0x1e
> > +#define MII_KSZPHY_CTRL_1			0x1e
> >  
> >  /* PHY Control 2 / PHY Control (if no PHY Control 1) */
> > -#define	MII_KSZPHY_CTRL_2			0x1f
> > -#define	MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
> > +#define MII_KSZPHY_CTRL_2			0x1f
> > +#define MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
> >  /* bitmap of PHY register to set interrupt mode */
> >  #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
> >  #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
> > -- 
> > 2.29.2
> > 
> 
> And the last column of these macros at the end is aligned with spaces
> unlike everything else:
> 
> /* Write/read to/from extended registers */
> #define MII_KSZPHY_EXTREG                       0x0b
> #define KSZPHY_EXTREG_WRITE                     0x8000
> 
> #define MII_KSZPHY_EXTREG_WRITE                 0x0c
> #define MII_KSZPHY_EXTREG_READ                  0x0d
> 
> /* Extended registers */
> #define MII_KSZPHY_CLK_CONTROL_PAD_SKEW         0x104
> #define MII_KSZPHY_RX_DATA_PAD_SKEW             0x105
> #define MII_KSZPHY_TX_DATA_PAD_SKEW             0x106
> 
> I guess if you're going to send this patch you might as well refactor it all.

Ok, done.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
