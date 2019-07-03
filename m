Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6165E592
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGCNd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:33:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33488 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCNd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:33:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so2952943wme.0
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=najnrFSUOiRPDT9JGpMV8VDNAnZWvge58GNEpe5/HJY=;
        b=LOL4f5wfARvpLV/aAFWHy3iCNYdIbI5TP9bG6IqgNfVXejMd7O7LhfgD40DsNmAOTn
         uC9gPyyfjlHCLGKsqdpaqGYLNKJwEIqzrYJpZvXlRWx4sngln5+VsaS/1UAnEatxchxV
         aw2H5XWC7vrIrTeXBMSWum0CZfxFNQQYK9TZF3n2l9fudVtja7jPM9BpGRgUcNHjmL5s
         cXvjcmvq8C18buThiDeBpQUNtzpHpyvFvk9UnLx8bdTIbelHcd3XKKFszlDD34feLZSy
         vW8vKSwmv2OW6wsMT/+OtM2sRNcOilejJdU/oHq5MplNMeUDB2MXhlz4oi0/CaE9kV8U
         0Yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=najnrFSUOiRPDT9JGpMV8VDNAnZWvge58GNEpe5/HJY=;
        b=AB97hPQrwVQooo+mFtpcwUTVQv5QHjsTb+48oiAlahDEUrMMzpmV9rvaUeY8qVtxmX
         cADGea69oerV/YOLMwV8BwzbKPqWjSFF4qm92DWCPInDxoaxmeGikisCm4ArJUsJG2k0
         QFpTj2bFBTuK+xuxHln7YdjbKFG6jFtRaGlER7f58Tviq0bM0rj6a/t5tMqxcYXbtGhQ
         VPOgh3XJUeAKh0H/0uJQudbo4+7zLJygLW/FCaZSyWBthgHvkqVWHOb0wN6zjDLbTrTx
         xy2R5dfKv/g57QrpvF10JYfWr6Z86q9PeQoTjYoz8dQ9Ge0Lz6FViYhk2B/c4SHkD78l
         RY6g==
X-Gm-Message-State: APjAAAUOZlhZUU1asOoGTKbLARSdbexQwJsDoLz795VgFD8EWyd+BTC/
        l3wXnkDmvICkNtH9StQEjMoyIg==
X-Google-Smtp-Source: APXvYqzTlVQXYnEhWiQoiU8lGvOuoiLleZdK/cdPvzguXRH5aE0TAuTwCBDyQSnUQEGdW2a3Kshebg==
X-Received: by 2002:a1c:e356:: with SMTP id a83mr8510016wmh.38.1562160833597;
        Wed, 03 Jul 2019 06:33:53 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id x11sm1510323wmi.26.2019.07.03.06.33.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 06:33:52 -0700 (PDT)
Date:   Wed, 3 Jul 2019 15:33:52 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 07/15] ethtool: support for netlink
 notifications
Message-ID: <20190703133352.GY2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dcac81783de8686edefa262a1db75f9e961b123.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:50:14PM CEST, mkubecek@suse.cz wrote:
>Add infrastructure for ethtool netlink notifications. There is only one
>multicast group "monitor" which is used to notify userspace about changes
>and actions performed. Notification messages (types using suffix _NTF)
>share the format with replies to GET requests.
>
>Notifications are supposed to be broadcasted on every configuration change,
>whether it is done using the netlink interface or ioctl one. Netlink SET
>requests only trigger a notification if some data is actually changed.
>
>To trigger an ethtool notification, both ethtool netlink and external code
>use ethtool_notify() helper. This helper requires RTNL to be held and may
>sleep. Handlers sending messages for specific notification message types
>are registered in ethnl_notify_handlers array. As notifications can be
>triggered from other code, ethnl_ok flag is used to prevent an attempt to
>send notification before genetlink family is registered.
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
>---
> include/linux/ethtool_netlink.h      |  5 ++++
> include/linux/netdevice.h            | 12 ++++++++++
> include/uapi/linux/ethtool_netlink.h |  2 ++
> net/ethtool/netlink.c                | 35 ++++++++++++++++++++++++++++
> 4 files changed, 54 insertions(+)
>
>diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
>index 0412adb4f42f..2a15e64a16f3 100644
>--- a/include/linux/ethtool_netlink.h
>+++ b/include/linux/ethtool_netlink.h
>@@ -5,5 +5,10 @@
> 
> #include <uapi/linux/ethtool_netlink.h>
> #include <linux/ethtool.h>
>+#include <linux/netdevice.h>
>+
>+enum ethtool_multicast_groups {
>+	ETHNL_MCGRP_MONITOR,
>+};
> 
> #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index 88292953aa6f..c57d9917fd50 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -4350,6 +4350,18 @@ struct netdev_notifier_bonding_info {
> void netdev_bonding_info_change(struct net_device *dev,
> 				struct netdev_bonding_info *bonding_info);
> 
>+#if IS_ENABLED(CONFIG_ETHTOOL_NETLINK)
>+void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
>+		    unsigned int cmd, u32 req_mask, const void *data);
>+#else
>+static inline void ethtool_notify(struct net_device *dev,
>+				  struct netlink_ext_ack *extack,
>+				  unsigned int cmd, u32 req_mask,
>+				  const void *data)
>+{
>+}
>+#endif
>+
> static inline
> struct sk_buff *skb_gso_segment(struct sk_buff *skb, netdev_features_t features)
> {
>diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
>index 805f314f4454..8938a1f09057 100644
>--- a/include/uapi/linux/ethtool_netlink.h
>+++ b/include/uapi/linux/ethtool_netlink.h
>@@ -91,4 +91,6 @@ enum {
> #define ETHTOOL_GENL_NAME "ethtool"
> #define ETHTOOL_GENL_VERSION 1
> 
>+#define ETHTOOL_MCGRP_MONITOR_NAME "monitor"
>+
> #endif /* _UAPI_LINUX_ETHTOOL_NETLINK_H_ */
>diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
>index e13f29bbd625..a7a0bfe1818c 100644
>--- a/net/ethtool/netlink.c
>+++ b/net/ethtool/netlink.c
>@@ -6,6 +6,8 @@
> 
> static struct genl_family ethtool_genl_family;
> 
>+static bool ethnl_ok __read_mostly;
>+
> static const struct nla_policy dflt_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
> 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
> 	[ETHTOOL_A_HEADER_DEV_INDEX]	= { .type = NLA_U32 },
>@@ -176,11 +178,41 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
> 	return NULL;
> }
> 
>+/* notifications */
>+
>+typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
>+				       struct netlink_ext_ack *extack,
>+				       unsigned int cmd, u32 req_mask,
>+				       const void *data);
>+
>+static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
>+};
>+
>+void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
>+		    unsigned int cmd, u32 req_mask, const void *data)

What's "req_mask" ?


>+{
>+	if (unlikely(!ethnl_ok))
>+		return;
>+	ASSERT_RTNL();
>+
>+	if (likely(cmd < ARRAY_SIZE(ethnl_notify_handlers) &&
>+		   ethnl_notify_handlers[cmd]))

How it could be null?


>+		ethnl_notify_handlers[cmd](dev, extack, cmd, req_mask, data);
>+	else
>+		WARN_ONCE(1, "notification %u not implemented (dev=%s, req_mask=0x%x)\n",
>+			  cmd, netdev_name(dev), req_mask);
>+}
>+EXPORT_SYMBOL(ethtool_notify);
>+
> /* genetlink setup */
> 
> static const struct genl_ops ethtool_genl_ops[] = {
> };
> 
>+static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
>+	[ETHNL_MCGRP_MONITOR] = { .name = ETHTOOL_MCGRP_MONITOR_NAME },
>+};
>+
> static struct genl_family ethtool_genl_family = {
> 	.name		= ETHTOOL_GENL_NAME,
> 	.version	= ETHTOOL_GENL_VERSION,
>@@ -188,6 +220,8 @@ static struct genl_family ethtool_genl_family = {
> 	.parallel_ops	= true,
> 	.ops		= ethtool_genl_ops,
> 	.n_ops		= ARRAY_SIZE(ethtool_genl_ops),
>+	.mcgrps		= ethtool_nl_mcgrps,
>+	.n_mcgrps	= ARRAY_SIZE(ethtool_nl_mcgrps),
> };
> 
> /* module setup */
>@@ -199,6 +233,7 @@ static int __init ethnl_init(void)
> 	ret = genl_register_family(&ethtool_genl_family);
> 	if (WARN(ret < 0, "ethtool: genetlink family registration failed"))
> 		return ret;
>+	ethnl_ok = true;
> 
> 	return 0;
> }
>-- 
>2.22.0
>
