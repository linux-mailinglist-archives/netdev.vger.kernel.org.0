Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D49472F1C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbhLMOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:24:56 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:11339 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhLMOYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639405495; x=1670941495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xVjIPdWu7m5dnX0mH30EyhJ46ijDhYrSTTC6UkEG31U=;
  b=EmYETNZO97TBzz1dxFjVOTK0rLyCNjtSLsIyNJougLD0bdaHOEYhfVVK
   WERuxLQDu+WRJgfoFugmVRd/asNzfigQ7O1J6bi5Ex9XM9Tbt19I6w5vq
   JQrZxXCkTD9uitQiJn20m2kfuvw5TpX17GifoC/zREu/T9URRVa/SFnVz
   LiSpdVo0TgmxrMp9zoC5h2oTNTpuyDo5KmUP8aBqlqvaF/1+NDAnQ8sZT
   T+HjrhUYyoV4oTTBYFptbGbta/gOUQREU1oPrJ/+U0/2Ul3lF+AemknVd
   Hy0eqoKc3Dsx4nYEyYmrM7enrWHlMvYtFaRQ0li9hXmLb5xSDLICqxDQ+
   g==;
IronPort-SDR: dwhRaJU1O2YJCBekBOdiq8tkz9JLwQGAFlLweYm1rz9MNBA3twFJ0vrhFbTo1n4+/iaSQIuMWQ
 JJdmlDeTFXj0Xc3CkCMQB23kLwhXaEwDaGQK4XVlPCPFwTHIqRG0T9gxDYIdvAdv9udib6+rOm
 MVK8DpC0KSlKp4XDRwvVlX5Sepy3bKV1H/uxn1ItvzdIjkCTlh2oGHxKhYnwCufxYSx+2BOwXT
 WRWw7cOF8WHlgZeIW27sF+uxllLUywj9q6DziNdWi6fwWrP2YbAV1EKpEoHd1M2myN1xA5gvZD
 UIUwTTu4gEQuFNb9LQ41eX9s
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="139575822"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 07:24:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 07:24:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 13 Dec 2021 07:24:54 -0700
Date:   Mon, 13 Dec 2021 15:26:56 +0100
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
Message-ID: <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211213134319.dp6b3or24pl3p4en@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/13/2021 13:43, Vladimir Oltean wrote:
> 
> On Mon, Dec 13, 2021 at 11:25:29AM +0100, Horatiu Vultur wrote:
> > The 12/09/2021 17:43, Horatiu Vultur wrote:
> > > > > +int lan966x_register_notifier_blocks(struct lan966x *lan966x)
> > > > > +{
> > > > > +     int err;
> > > > > +
> > > > > +     lan966x->netdevice_nb.notifier_call = lan966x_netdevice_event;
> > > > > +     err = register_netdevice_notifier(&lan966x->netdevice_nb);
> > > > > +     if (err)
> > > > > +             return err;
> > > > > +
> > > > > +     lan966x->switchdev_nb.notifier_call = lan966x_switchdev_event;
> > > > > +     err = register_switchdev_notifier(&lan966x->switchdev_nb);
> > > > > +     if (err)
> > > > > +             goto err_switchdev_nb;
> > > > > +
> > > > > +     lan966x->switchdev_blocking_nb.notifier_call = lan966x_switchdev_blocking_event;
> > > > > +     err = register_switchdev_blocking_notifier(&lan966x->switchdev_blocking_nb);
> > > > > +     if (err)
> > > > > +             goto err_switchdev_blocking_nb;
> > > > > +
> > > > > +     lan966x_owq = alloc_ordered_workqueue("lan966x_order", 0);
> > > > > +     if (!lan966x_owq) {
> > > > > +             err = -ENOMEM;
> > > > > +             goto err_switchdev_blocking_nb;
> > > > > +     }
> > > >
> > > > These should be singleton objects, otherwise things get problematic if
> > > > you have more than one switch device instantiated in the system.
> > >
> > > Yes, I will update this.
> >
> > Actually I think they need to be part of lan966x.
> > Because we want each lan966x instance to be independent of each other.
> > This is not seen in this version but is more clear in the next version
> > (v4).
> 
> They are independent of each other. You deduce the interface on which
> the notifier was emitted using switchdev_notifier_info_to_dev() and act
> upon it, if lan966x_netdevice_check() is true. The notifier handling
> code itself is stateless, all the state is per port / per switch.
> If you register one notifier handler per switch, lan966x_netdevice_check()
> would return true for each notifier handler instance, and you would
> handle each event twice, would you not?

That is correct, I will get the event twice which is a problem in the
lan966x. The function lan966x_netdevice_check should be per instance, in
this way each instance can filter the events.
The reason why I am putting the notifier_block inside lan966x is to be
able to get to the instance of lan966x even if I get a event that is not
for lan966x port.

> notifier handlers should be registered as singletons, like other drivers
> do.

It looks like not all the other driver register them as singletone. For
example: prestera, mlx5, sparx5. (I just have done a git grep for
register_switchdev_notifier, I have not looked in details at the
implementation).


-- 
/Horatiu
