Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CEE479AD3
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbhLRMxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:53:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:40723 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhLRMxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:53:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639832019; x=1671368019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fh/aoEvgoHYBFD2qQbz4oegNPmzp5XJ49otKKVSzSHE=;
  b=BjhT1Rukl7tw9Ym7sviR9/5iUookujPFXStVUDD5IQl2OGWERjD6+Wd5
   GeuHZnyMurdMUnKylUonkDg9p0fcu7vr6cdyBLT4l+UwANA/kY7a7IWk/
   FrPpG13WdBcAS9XACY6oRXfGkzMUSx7rhRNoN3lwtKg3rgEOalSqPfK+y
   yYuZzrv1OTWKCwblgzpNHkNq3SKEMdmvFyqsyir8cQJz4IedHalQLKj6A
   D1HYwmYRxVAmyI9wThOss88/zE6idcqXP0SZkBwQ/2juBoKPHFTVGWcRq
   Pw3SBTgll2RUHAzYFheY9efJuRUEhT5O9148nI6a2ndTiI+klexH16oJR
   Q==;
IronPort-SDR: 0hxB7X/glAqiPC0PqSd5lGewiS6g2OXJRy70wPhaDLB6O47RA2EWJcqIbxEmzaf7WUSF1s6deo
 kItIfd5TNHsteZ77snbry6wTUqywq9h9XG2vUA7YJuJrU58IhRxLOQf+CXW4o+TZ/+q2vv8Yko
 kKhtfreauNBiN378BBKjhApTWVnpoJ6ioBPt36d/WNmmtsJ50X9m1Ck1dCfbOmOXVtB701hYYN
 ZPoMP5Pva8FjmAHpIS6rpfaxqFp+bLZ6ZtSigjc3O19mRHoU4DDXSauFn1WyuFzxM978YbrGpC
 BprzJp+7o/gqKOce3q6WHMh9
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="155970807"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 05:53:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 05:53:38 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 18 Dec 2021 05:53:38 -0700
Date:   Sat, 18 Dec 2021 13:55:43 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 8/9] net: lan966x: Extend switchdev bridge
 flags
Message-ID: <20211218125543.anb7fapwpywwsryx@soft-dev3-1.localhost>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-9-horatiu.vultur@microchip.com>
 <20211217174000.febeewxdio6dbmb6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211217174000.febeewxdio6dbmb6@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/17/2021 17:40, Vladimir Oltean wrote:
> 
> On Fri, Dec 17, 2021 at 04:53:52PM +0100, Horatiu Vultur wrote:
> > Currently allow a port to be part or not of the multicast flooding mask.
> > By implementing the switchdev calls SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
> > and SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  .../microchip/lan966x/lan966x_switchdev.c     | 34 +++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > index cef9e690fb82..af227b33cb3f 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> > @@ -9,6 +9,34 @@ static struct notifier_block lan966x_netdevice_nb __read_mostly;
> >  static struct notifier_block lan966x_switchdev_nb __read_mostly;
> >  static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly;
> >
> > +static void lan966x_port_bridge_flags(struct lan966x_port *port,
> > +                                   struct switchdev_brport_flags flags)
> > +{
> > +     u32 val = lan_rd(port->lan966x, ANA_PGID(PGID_MC));
> > +
> > +     val = ANA_PGID_PGID_GET(val);
> 
> Ideally you'd want to read PGID_MC only if you know that BR_MCAST_FLOOD
> is the flag getting changed. Otherwise you'd have to refactor this when
> you add support for more brport flags.

I can see your point. I will refactor this now, such that when new flags
are added this should not be changed.

> 
> > +
> > +     if (flags.mask & BR_MCAST_FLOOD) {
> > +             if (flags.val & BR_MCAST_FLOOD)
> > +                     val |= BIT(port->chip_port);
> > +             else
> > +                     val &= ~BIT(port->chip_port);
> > +     }
> > +
> > +     lan_rmw(ANA_PGID_PGID_SET(val),
> > +             ANA_PGID_PGID,
> > +             port->lan966x, ANA_PGID(PGID_MC));
> > +}
> > +
> > +static int lan966x_port_pre_bridge_flags(struct lan966x_port *port,
> > +                                      struct switchdev_brport_flags flags)
> > +{
> > +     if (flags.mask & ~BR_MCAST_FLOOD)
> > +             return -EINVAL;
> > +
> > +     return 0;
> > +}
> > +
> >  static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> >  {
> >       int i;
> > @@ -67,6 +95,12 @@ static int lan966x_port_attr_set(struct net_device *dev, const void *ctx,
> >               return 0;
> >
> >       switch (attr->id) {
> > +     case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> > +             lan966x_port_bridge_flags(port, attr->u.brport_flags);
> > +             break;
> > +     case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
> > +             err = lan966x_port_pre_bridge_flags(port, attr->u.brport_flags);
> > +             break;
> >       case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> >               lan966x_port_stp_state_set(port, attr->u.stp_state);
> >               break;
> > --
> > 2.33.0
> >

-- 
/Horatiu
