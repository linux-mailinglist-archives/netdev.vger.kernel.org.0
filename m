Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53977473064
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbhLMP0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:26:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:59632 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbhLMP0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:26:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639409183; x=1670945183;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ryug1bVR3itCcTo+/NCw0RmB2Bhud42INAPy6OLzOeg=;
  b=Ihs5M/iXTi7OsuF9EQXBC7plWp2AAiHFYrq3+Z+s2tn4/r5mq3BTSTTX
   IcKXI5vIIhC0ItlV7bS1GVQD2hu1nrmKIbb7B4mope+smBYcI+FUIEstg
   zGEiFtjhZmWTTqf/s6J5jseMXDWAz9xJSeoCkVpV2zScLDxtKJuuyNhlu
   Fp/wraoEG1z0EfTtKOuLcpQql1uU/mtDLlzimPVk8CPHbhRHvex+Mk5n+
   j567zZ75hNsuV41J+9/UyLaia3rdCbKN1yjEuyKvV0/trs3o7EnK014Oj
   qnJrH3vf9CTl65JJRA77NflWhx4VcgrZ4Kn1grKgXWGs+2nPYwobjZfFn
   w==;
IronPort-SDR: 5iOVefQ3cbTdHXr4NHxdhWvPOJK0GKSCglZQrkhfsjf0Ol5Ymk15DHsss5hT87YPRylG51c4kd
 kUm9qq43I2AQprrVFz1bhldRUbdH+1A8P7hQVrHkl+xmM2mYnb9gzmYYM83olDTcUdeAwT+REU
 YZWxoLWqbC17tvV72bVlJLwWnIO6UluRncWgMZurBaRLl552MM6zgA8pAlWGx3khTUA8XXE5TM
 ltyVdJCyPnmznts33zrH2/N+oBGkIaMs7unUpZDImEVcoCozfA6bjPbWC0T10zPXQGOi18tyqu
 i/6JyAeAVxTPSX+W7ArEcNrL
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="147044768"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 08:26:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 08:26:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 13 Dec 2021 08:26:21 -0700
Date:   Mon, 13 Dec 2021 16:28:24 +0100
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
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Message-ID: <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211213142907.7s74smjudcecpgik@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/13/2021 14:29, Vladimir Oltean wrote:
> 
> On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > > They are independent of each other. You deduce the interface on which
> > > the notifier was emitted using switchdev_notifier_info_to_dev() and act
> > > upon it, if lan966x_netdevice_check() is true. The notifier handling
> > > code itself is stateless, all the state is per port / per switch.
> > > If you register one notifier handler per switch, lan966x_netdevice_check()
> > > would return true for each notifier handler instance, and you would
> > > handle each event twice, would you not?
> >
> > That is correct, I will get the event twice which is a problem in the
> > lan966x. The function lan966x_netdevice_check should be per instance, in
> > this way each instance can filter the events.
> > The reason why I am putting the notifier_block inside lan966x is to be
> > able to get to the instance of lan966x even if I get a event that is not
> > for lan966x port.
> 
> That isn't a problem, every netdevice notifier still sees all events.

Yes, that is correct.
Sorry maybe I am still confused, but some things are still not right.

So lets say there are two lan966x instances(A and B) and each one has 2
ports(ethA0, ethA1, ethB0, ethB1).
So with the current behaviour, if for example ethA0 is added in vlan
100, then we get two callbacks for each lan966x instance(A and B) because
each of them registered. And because of lan966x_netdevice_check() is true
for ethA0 will do twice the work.
And you propose to have a singleton notifier so we get only 1 callback
and will be fine for this case. But if you add for example the bridge in
vlan 200 then I will never be able to get to the lan966x instance which
is needed in this case.

That is why if the lan966x_netdevice_check would be per instance, then
we can filter like before, we still get call twice but then we filter for
each instance. We get the lan966x instance from notifier_block and then
we can check if the port netdev_ops is the same as the lan966x
netdev_ops.

And in the other case we will still be able to get to the lan966x instance
in case the bridge is added in a vlan.

> DSA intercepts a lot of events which aren't directly emitted for its own
> interfaces. You don't gain much by having one more, if anything.
> 
> > > notifier handlers should be registered as singletons, like other drivers
> > > do.
> >
> > It looks like not all the other driver register them as singletone. For
> > example: prestera, mlx5, sparx5. (I just have done a git grep for
> > register_switchdev_notifier, I have not looked in details at the
> > implementation).
> 
> Not all driver writers may have realized that it is an issue that needs
> to be thought of.

-- 
/Horatiu
