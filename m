Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7E9276237
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWUfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:35:53 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:63256 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgIWUfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 16:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600893353; x=1632429353;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=96o2kyTUN3EOP+hgk/NSYOfCdUmbZkLBvnl5ZuCj2oA=;
  b=VdC442rSl/BgmFUyvjzDdjtBlCwdRgpiyv+sXu09uo5EraDJJXPi/SKY
   JWfRfconRL2QLgfL3S91dLus0ujm7YlZtkZZOOU/5emDbqNkS5qs2Fa+Y
   Qefgq6eyfxq7cmwhmZT9dFNmJTWdd3ZJc4oiY1sw+XetDO3uqxdgtdygp
   alpNXxeOhumyn3d4/flWvaEbrk2TcNXX79SGQSTIKRjSgrzZ0h0SS5Q4M
   +q8oy6AT1MkLZGcYvlbD/ZyE2oFuVmZUz/xLRXDX6Ocy5q2tTjPTwnoci
   EHXDkIlDdFIdbVZzH80Ufqlg3JYo5btb5n7xg1iCfmwDQ2uos5g4gETtb
   A==;
IronPort-SDR: yGJfbMXjkwqXmPS/7b6pWPs9HLvrPzcQ2I6eTenNYNNQ52Wo59tmOXdQzaNjPGXqUwceW6fgAV
 nXy6pSxQ5+oOe7J0swGF9zP1bpFxwW4Kp1UPDv25taKu7nLd0PvKaYoXhdzar9jzUnwmGqmXHU
 0fKRBxmrtpLJrOPe/7i35OFNQu65pi5Dd0YhZyHa49imtfY3oerWlazYzpLDNHCehNMUM0PlyD
 VINXFOoPZtvjm/5BUNeVQ2D+rnXETLHkT3899NbY1gGr0bzZo6uKiM26fB2sls6kcfRyNoBs1D
 +ro=
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="92136643"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2020 13:35:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 13:35:11 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Sep 2020 13:35:31 -0700
Date:   Wed, 23 Sep 2020 22:35:30 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Message-ID: <20200923203530.lenv5jedwmtefwqu@soft-dev3.localdomain>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
 <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
 <20200923202231.vr5ll2yu4gztqzwj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200923202231.vr5ll2yu4gztqzwj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/23/2020 20:22, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, Sep 23, 2020 at 10:08:00PM +0200, Horatiu Vultur wrote:
> > The 09/23/2020 14:24, Vladimir Oltean wrote:
> > > +               if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP) {
> > > +                       struct sk_buff *clone;
> > > +
> > > +                       clone = skb_clone_sk(skb);
> > > +                       if (!clone) {
> > > +                               kfree_skb(skb);
> > > +                               return NETDEV_TX_OK;
> >
> > Why do you return NETDEV_TX_OK?
> > Because the frame is not sent yet.
> 
> I suppose I _could_ increment the tx_dropped counters, if that's what
> you mean.

Yeah, something like that I was thinking.

Also I am just thinking, not sure if it is correct but, can you return
NETDEV_TX_BUSY and not free the skb?

> 
> I was also going to request David to let me send a v2, because I want to
> replace the kfree_skb at the end of this function with a proper
> consume_skb, so that this won't appear as a false positive in the drop
> monitor.
> 
> Thanks,
> -Vladimir

-- 
/Horatiu
