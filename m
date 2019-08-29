Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7FFA1A55
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfH2MoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:44:17 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:58559 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfH2MoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:44:17 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: lY0CxR/McGUhBSICEiy7hnK36/2ng1LYaiSkC0NETV0WT7Xf7IaQRTOVLvtettWQYJgf7WjI4o
 1qHWfXBGfH+TYpzJPH1hBHcCAmDkOWPVqbCQpBDq9Pxjmoj5hJPymPZdJBlZIsGrbpVQ8EYTtY
 G3crneKa07iG7uGAweln8dMlJsLlFokAtHBDwrr26SlVwk3nTRlVfbgYcxw7iyrBvt1J36mzkz
 SCS7RaMJeEyNbwOJiM3ksdjpEkheF9fDHJ88OFFSG8j7BBbD1CorRh+tsIMshmBvZKL7wOqDu6
 ioA=
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="44161978"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2019 05:44:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 05:44:14 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 29 Aug 2019 05:44:15 -0700
Date:   Thu, 29 Aug 2019 14:44:14 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <andrew@lunn.ch>,
        <allan.nielsen@microchip.com>, <ivecera@redhat.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
 <20190829121811.GI2312@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190829121811.GI2312@nanopsycho>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/29/2019 14:18, Jiri Pirko wrote:
> External E-Mail
> 
> 
> Thu, Aug 29, 2019 at 12:56:54PM CEST, horatiu.vultur@microchip.com wrote:
> >The 08/29/2019 11:51, Jiri Pirko wrote:
> >> External E-Mail
> >> 
> >> 
> >> Thu, Aug 29, 2019 at 11:22:28AM CEST, horatiu.vultur@microchip.com wrote:
> >> >Add the SWITCHDEV_ATTR_ID_PORT_PROMISCUITY switchdev notification type,
> >> >used to indicate whenever the dev promiscuity counter is changed.
> >> >
> >> >The notification doesn't use any switchdev_attr attribute because in the
> >> >notifier callbacks is it possible to get the dev and read directly
> >> >the promiscuity value.
> >> >
> >> >Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> >> >---
> >> > include/net/switchdev.h | 1 +
> >> > net/core/dev.c          | 9 +++++++++
> >> > 2 files changed, 10 insertions(+)
> >> >
> >> >diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> >> >index aee86a1..14b1617 100644
> >> >--- a/include/net/switchdev.h
> >> >+++ b/include/net/switchdev.h
> >> >@@ -40,6 +40,7 @@ enum switchdev_attr_id {
> >> > 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
> >> > 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
> >> > 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
> >> >+	SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
> >> > };
> >> > 
> >> > struct switchdev_attr {
> >> >diff --git a/net/core/dev.c b/net/core/dev.c
> >> >index 49589ed..40c74f2 100644
> >> >--- a/net/core/dev.c
> >> >+++ b/net/core/dev.c
> >> >@@ -142,6 +142,7 @@
> >> > #include <linux/net_namespace.h>
> >> > #include <linux/indirect_call_wrapper.h>
> >> > #include <net/devlink.h>
> >> >+#include <net/switchdev.h>
> >> > 
> >> > #include "net-sysfs.h"
> >> > 
> >> >@@ -7377,6 +7378,11 @@ static void dev_change_rx_flags(struct net_device *dev, int flags)
> >> > static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
> >> > {
> >> > 	unsigned int old_flags = dev->flags;
> >> >+	struct switchdev_attr attr = {
> >> >+		.orig_dev = dev,
> >> >+		.id = SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
> >> >+		.flags = SWITCHDEV_F_DEFER,
> >> 
> >
> >Hi Jiri,
> >
> >> NACK
> >> 
> >> This is invalid usecase for switchdev infra. Switchdev is there for
> >> bridge offload purposes only.
> >> 
> >> For promiscuity changes, the infrastructure is already present in the
> >> code. See __dev_notify_flags(). it calls:
> >> call_netdevice_notifiers_info(NETDEV_CHANGE, &change_info.info)
> >> and you can actually see the changed flag in ".flags_changed".
> >Yes, you are right. But in case the port is part of a bridge and then
> >enable promisc mode by a user space application(tpcdump) then the drivers
> 
> If the promisc is on, it is on. Why do you need to know who enabled it?
When a port is added to a bridge, then the port gets in promisc mode.
But in our case the HW has bridge capabilities so it is not required to
set the port in promisc mode.
But if someone else requires the port to be in promisc mode (tcpdump or
any other application) then I would like to set the port in promisc
mode.
In previous emails Andrew came with the suggestion to look at
dev->promiscuity and check if the port is a bridge port. Using this
information I could see when to add the port in promisc mode. He also
suggested to add a new switchdev call(maybe I missunderstood him, or I
have done it at the wrong place) in case there are no callbacks in the
driver to get this information.
> 
> Or do you want to use this to ask driver to ask hw to trap packets to
> kernel? If yes, I don't think it is correct. If you want to "steal" some
> packets from the hw forwarding datapath, use TC action "trap".
No, I just wanted to know when to update the HW to set the port in
promisc mode.

> 
> 
> >will not be notified. The reason is that the dev->flags will still be the
> >same(because IFF_PROMISC was already set) and only promiscuity will be
> >changed.
> >
> >One fix could be to call __dev_notify_flags() no matter when the
> >promisc is enable or disabled.
> >
> >> 
> >> You just have to register netdev notifier block in your driver. Grep
> >> for: register_netdevice_notifier
> >> 
> >> 
> >> >+	};
> >> > 	kuid_t uid;
> >> > 	kgid_t gid;
> >> > 
> >> >@@ -7419,6 +7425,9 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
> >> > 	}
> >> > 	if (notify)
> >> > 		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
> >> >+
> >> >+	switchdev_port_attr_set(dev, &attr);
> >> >+
> >> > 	return 0;
> >> > }
> >> > 
> >> >-- 
> >> >2.7.4
> >> >
> >> 
> >
> >-- 
> >/Horatiu
> 

-- 
/Horatiu
