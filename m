Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD33A19E2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfH2MSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:18:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38367 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727320AbfH2MSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:18:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id o184so3628872wme.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pFWLKMGVr3USsr0a1cWm+DfSSpAfEVTSRCcxqOxrU7I=;
        b=wmtgKbFmXIVzs79+qMDp0xCzdOv8uq28M4avUrOGEYSn/W+dSFiqQbF9ogfUOoKHqn
         2J0T4FfqNpP8v3my/Wr4FmY0rI+FisIHK30ccr5XS/L2BPwQDKDYtVc9CUQa7Bz7o0by
         Kr2kUMXXSWVMASAKsTv6W358JnLNitrYIi9eliUV+yU1BEWnvBjOH8DgZwox3JSAVIMH
         nkreeicyyLO0/BbL1xc7BTNLquY90pmSuIIyqe+qpW0cPxN/hvuxeMOZ6JeAdP3ltpTP
         zZp0nVPM9j6oqwJVT2D9Gl22+M0NdHvidANEaVAi0CAKJyalJ+IJFUIMTrLvM9jY7NbS
         MTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pFWLKMGVr3USsr0a1cWm+DfSSpAfEVTSRCcxqOxrU7I=;
        b=lUp78M39lGQy1TymScVlUhwULL/77XBAmozzFAxN6psVnEKxvB2nEIhRcgF0MLmZ6h
         ljDXg1cy/4IgyvJdPK5DqztGreh7QobtJjhIEiIV4YhNAjnUBuEgdjcBZ7CV4bNOsK+i
         eedOwVef/x50rjpQsWiKNcgbZ7gGSnlt0SvnvWYOQfZpYKKBo9O9LeLSEOOFWrwpvc+c
         QFagRiV5DREnaYtZURcAzZnY8Bxo65FhUJPyI/nVMIqLUi4ByDnZmu3MdcxlQSy9z7RA
         vLXV2d9L/45YDmweOo3S8T1s88lyPo9mhWsEuigyxKhJUiz4uJnU+igkRVATlOSJILcE
         6DNw==
X-Gm-Message-State: APjAAAVTHGcu82F0oTb8twy9dL4sVnO2scno8qWw4J9Ito3W4HjFIumd
        2vzzF/7Lyqx0ltQDdcLDDbsvhA==
X-Google-Smtp-Source: APXvYqy7Ec8bHc8q+5nwy+bHjwCusSCjNoIgVIc1Dc5ySNw35xIAKkjMFK2gPtqpvtymYbmodq2kJQ==
X-Received: by 2002:a05:600c:254c:: with SMTP id e12mr10949332wma.72.1567081092640;
        Thu, 29 Aug 2019 05:18:12 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id a17sm2726450wmm.47.2019.08.29.05.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 05:18:12 -0700 (PDT)
Date:   Thu, 29 Aug 2019 14:18:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, andrew@lunn.ch, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829121811.GI2312@nanopsycho>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 29, 2019 at 12:56:54PM CEST, horatiu.vultur@microchip.com wrote:
>The 08/29/2019 11:51, Jiri Pirko wrote:
>> External E-Mail
>> 
>> 
>> Thu, Aug 29, 2019 at 11:22:28AM CEST, horatiu.vultur@microchip.com wrote:
>> >Add the SWITCHDEV_ATTR_ID_PORT_PROMISCUITY switchdev notification type,
>> >used to indicate whenever the dev promiscuity counter is changed.
>> >
>> >The notification doesn't use any switchdev_attr attribute because in the
>> >notifier callbacks is it possible to get the dev and read directly
>> >the promiscuity value.
>> >
>> >Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>> >---
>> > include/net/switchdev.h | 1 +
>> > net/core/dev.c          | 9 +++++++++
>> > 2 files changed, 10 insertions(+)
>> >
>> >diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>> >index aee86a1..14b1617 100644
>> >--- a/include/net/switchdev.h
>> >+++ b/include/net/switchdev.h
>> >@@ -40,6 +40,7 @@ enum switchdev_attr_id {
>> > 	SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING,
>> > 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
>> > 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
>> >+	SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
>> > };
>> > 
>> > struct switchdev_attr {
>> >diff --git a/net/core/dev.c b/net/core/dev.c
>> >index 49589ed..40c74f2 100644
>> >--- a/net/core/dev.c
>> >+++ b/net/core/dev.c
>> >@@ -142,6 +142,7 @@
>> > #include <linux/net_namespace.h>
>> > #include <linux/indirect_call_wrapper.h>
>> > #include <net/devlink.h>
>> >+#include <net/switchdev.h>
>> > 
>> > #include "net-sysfs.h"
>> > 
>> >@@ -7377,6 +7378,11 @@ static void dev_change_rx_flags(struct net_device *dev, int flags)
>> > static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
>> > {
>> > 	unsigned int old_flags = dev->flags;
>> >+	struct switchdev_attr attr = {
>> >+		.orig_dev = dev,
>> >+		.id = SWITCHDEV_ATTR_ID_PORT_PROMISCUITY,
>> >+		.flags = SWITCHDEV_F_DEFER,
>> 
>
>Hi Jiri,
>
>> NACK
>> 
>> This is invalid usecase for switchdev infra. Switchdev is there for
>> bridge offload purposes only.
>> 
>> For promiscuity changes, the infrastructure is already present in the
>> code. See __dev_notify_flags(). it calls:
>> call_netdevice_notifiers_info(NETDEV_CHANGE, &change_info.info)
>> and you can actually see the changed flag in ".flags_changed".
>Yes, you are right. But in case the port is part of a bridge and then
>enable promisc mode by a user space application(tpcdump) then the drivers

If the promisc is on, it is on. Why do you need to know who enabled it?

Or do you want to use this to ask driver to ask hw to trap packets to
kernel? If yes, I don't think it is correct. If you want to "steal" some
packets from the hw forwarding datapath, use TC action "trap".


>will not be notified. The reason is that the dev->flags will still be the
>same(because IFF_PROMISC was already set) and only promiscuity will be
>changed.
>
>One fix could be to call __dev_notify_flags() no matter when the
>promisc is enable or disabled.
>
>> 
>> You just have to register netdev notifier block in your driver. Grep
>> for: register_netdevice_notifier
>> 
>> 
>> >+	};
>> > 	kuid_t uid;
>> > 	kgid_t gid;
>> > 
>> >@@ -7419,6 +7425,9 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
>> > 	}
>> > 	if (notify)
>> > 		__dev_notify_flags(dev, old_flags, IFF_PROMISC);
>> >+
>> >+	switchdev_port_attr_set(dev, &attr);
>> >+
>> > 	return 0;
>> > }
>> > 
>> >-- 
>> >2.7.4
>> >
>> 
>
>-- 
>/Horatiu
