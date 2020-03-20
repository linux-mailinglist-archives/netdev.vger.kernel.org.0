Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0549D18CC23
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCTLFC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 07:05:02 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55131 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgCTLFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:05:01 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id BB551E0015;
        Fri, 20 Mar 2020 11:04:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com> <20200319211649.10136-2-olteanv@gmail.com> <20200320100925.GB16662@lunn.ch> <CA+h21hrvsfwspGE6z37p-fwso3oD0pXijh+fZZfEEUEv6bySHQ@mail.gmail.com>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum rgmii_rx_clock_delay to rgmii_clock_delay
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <158470229183.43774.8932556125293087780@kwain>
Date:   Fri, 20 Mar 2020 12:04:53 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Quoting Vladimir Oltean (2020-03-20 11:38:05)
> On Fri, 20 Mar 2020 at 12:09, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Thu, Mar 19, 2020 at 11:16:46PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > There is nothing RX-specific about these clock skew values. So remove
> > > "RX" from the name in preparation for the next patch where TX delays are
> > > also going to be configured.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---
> > >  drivers/net/phy/mscc/mscc.h      | 18 +++++++++---------
> > >  drivers/net/phy/mscc/mscc_main.c |  2 +-
> > >  2 files changed, 10 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> > > index 29ccb2c9c095..56feb14838f3 100644
> > > --- a/drivers/net/phy/mscc/mscc.h
> > > +++ b/drivers/net/phy/mscc/mscc.h
> > > @@ -12,15 +12,15 @@
> > >  #include "mscc_macsec.h"
> > >  #endif
> > >
> > > -enum rgmii_rx_clock_delay {
> > > -     RGMII_RX_CLK_DELAY_0_2_NS = 0,
> > > -     RGMII_RX_CLK_DELAY_0_8_NS = 1,
> > > -     RGMII_RX_CLK_DELAY_1_1_NS = 2,
> > > -     RGMII_RX_CLK_DELAY_1_7_NS = 3,
> > > -     RGMII_RX_CLK_DELAY_2_0_NS = 4,
> > > -     RGMII_RX_CLK_DELAY_2_3_NS = 5,
> > > -     RGMII_RX_CLK_DELAY_2_6_NS = 6,
> > > -     RGMII_RX_CLK_DELAY_3_4_NS = 7
> > > +enum rgmii_clock_delay {
> > > +     RGMII_CLK_DELAY_0_2_NS = 0,
> > > +     RGMII_CLK_DELAY_0_8_NS = 1,
> > > +     RGMII_CLK_DELAY_1_1_NS = 2,
> > > +     RGMII_CLK_DELAY_1_7_NS = 3,
> > > +     RGMII_CLK_DELAY_2_0_NS = 4,
> > > +     RGMII_CLK_DELAY_2_3_NS = 5,
> > > +     RGMII_CLK_DELAY_2_6_NS = 6,
> > > +     RGMII_CLK_DELAY_3_4_NS = 7
> > >  };
> >
> > Can this be shared?
> >
> > https://www.spinics.net/lists/netdev/msg638747.html
> >
> > Looks to be the same values?
> >
> > Can some of the implementation be consolidated?

> - That patch is writing to MSCC_PHY_RGMII_SETTINGS (defined to 18).
> This one is writing to MSCC_PHY_RGMII_CNTL (defined to 20). And since
> I have no documentation to understand why, I'm back to square 1.

These are two different registers, using similar values. I guess the
register was moved around as those PHYs are from the same family; but
I'm not sure if it's correct to consolidate it as we do not know for
sure. (Practically speaking the same values are used, so why not).

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
