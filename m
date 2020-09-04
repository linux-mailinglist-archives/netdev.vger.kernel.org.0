Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC625D484
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbgIDJTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 05:19:09 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:43022 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgIDJTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 05:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599211147; x=1630747147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TlHaHc/zEULpiySGcyA3zFXAZbTghhNCxWyQSG0iZwY=;
  b=hJt8cp/kIE55f7/p0i+RO4rgd0JOFGUrqHOX18rGUotAk56ZnYRyVPls
   l7W9jqdwn8lVvNnJJB0/SMyBg6TEi/oTxxVGeEuOqT3eGoTz2SIXWdxDc
   lkaXVoqU0qVHL/wpv5EGbQTMx/uP9TGUv9VammK8aPXiaKTP7YpXn/qZg
   Y782sFzyKI+denAr87kaA2Y6Dz7MTPAVkk3MCgz25SRM7FkjnzsaU0ijZ
   YRyiBEfUNEpEbQXC3wuzlywNuAJvSVpCxwy8TOXfJfLh2WUNnrDwusM0L
   ltRBIQ9E2jC8DxwCF8i+OhJJ4Xp1wU2C3i30VckxvgRvyahm/c+709i47
   w==;
IronPort-SDR: 94rIDS2CUDAJWr3KkBCBE06lhEScvdgnVg9znPlWS3ttzJxiX70iHluy2089E7Ep9L8BqDgwqe
 jzHWJcTAfJ/24G9g19HMJeZNEaWjl0Sfa5drFFAGQjM9VJC+oEWujiI51iDAfzvKyQAn6Lqabf
 A0ULrrHuucW8QwcS8QiaaNAWreM19nptjJdI+B7ESuEzRq3V7uRVvCUWB63kLN0gzAl3BedsWl
 OjzKUAD9N/neUb5DFzn8phCRjG10CqC3NLAO0AteI0oAVB9CGiQ3267EQGHOYevzBHT91Jb4V3
 kpM=
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="89829014"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Sep 2020 02:19:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 02:19:02 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Sep 2020 02:18:59 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH RFC 2/7] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Fri, 4 Sep 2020 09:15:22 +0000
Message-ID: <20200904091527.669109-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to include or exclude the CFM
protocol according to 802.1Q section 12.14.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 net/bridge/Kconfig      | 11 +++++++++++
 net/bridge/br_device.c  |  3 +++
 net/bridge/br_private.h |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index 80879196560c..3c8ded7d3e84 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -73,3 +73,14 @@ config BRIDGE_MRP
 	  Say N to exclude this support and reduce the binary size.
 
 	  If unsure, say N.
+
+config BRIDGE_CFM
+	bool "CFM protocol"
+	depends on BRIDGE
+	help
+	  If you say Y here, then the Ethernet bridge will be able to run CFM
+	  protocol according to 802.1Q section 12.14
+
+	  Say N to exclude this support and reduce the binary size.
+
+	  If unsure, say N.
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index a9232db03108..d12f5626a4b1 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -476,6 +476,9 @@ void br_dev_setup(struct net_device *dev)
 	INIT_LIST_HEAD(&br->ftype_list);
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	INIT_LIST_HEAD(&br->mrp_list);
+#endif
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+	INIT_LIST_HEAD(&br->mep_list);
 #endif
 	spin_lock_init(&br->hash_lock);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e67c6d9e8bea..6294a3e51a33 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -445,6 +445,9 @@ struct net_bridge {
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	struct list_head		mrp_list;
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+	struct list_head		mep_list;
+#endif
 };
 
 struct br_input_skb_cb {
-- 
2.28.0

