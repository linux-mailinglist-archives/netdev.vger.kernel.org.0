Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92C628BA37
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403788AbgJLOGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:06:54 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:23625 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391134AbgJLOGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602511611; x=1634047611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zWZu/J+2GtqLXi/hJ0UqkXZyyU+K1LeGHUouivHYB+c=;
  b=l1wP7C5Zf3oSiVyU6GEyFd8DIApBWhvmNdFIsRx0X10Jda1yreBk3kG4
   xib3hAK18oOwwJ13xN6ekFkZJLQUL9JLLsbID5Y1oPlbCaVb7bcA9oEPH
   YzI88b6gGocsUg8wrs5g3ZSTmSBa7gpaQ3uvWxMzqwOZ1CNcz7IGtJxMe
   4l/B+MxV3t2bQJLIcfzyGVGa6remzmu1rHTUxp45iZWLbhxkftrbOWgp9
   jOUztzLtvgngRYW7Gwzdi0sS9z43Rcr2OOmfsG7OJLPXjZ+qt1bNrD8H6
   R1YfHWU0kIMmjGlY9vwgUNpRCEeovQfKhliH07cYBhqIV3M+ItfX9424l
   A==;
IronPort-SDR: YDbQjeJ9T5hVtfVHVceaQqyKHUj8oMNg7VurLMnnmLayLqkdtu8V7uPZL0iAi0A2K6MYJd8o1/
 7z7OPNr+XFKI5IKz+oUTpkyK6Iz7qTrpfLD6ck1Vms89WiO9Hu6IOlL+pjwnkYLqQasO8wDvA9
 eb+7ATn7NtUzdLxoUQ95jzXMSS+Ky/HJWX+eDnn/s1sLBVcZ2gLOKYDmf2lGyhQEkVj+Ut9OAo
 uFADSRmqCk5eDFB0eZGlT7ErsZb944rN63WEYHc/mnNNvOsQaR7tSWPFiFBfUgSMrqBEwiYj/0
 UuQ=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="29560827"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 07:06:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 07:06:26 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 12 Oct 2020 07:06:24 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Mon, 12 Oct 2020 14:04:20 +0000
Message-ID: <20201012140428.2549163-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to include or exclude the CFM
protocol according to 802.1Q section 12.14.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
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
index 206c4ba51cd2..2a3b316f32eb 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -476,6 +476,9 @@ void br_dev_setup(struct net_device *dev)
 	INIT_HLIST_HEAD(&br->frame_type_list);
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	INIT_LIST_HEAD(&br->mrp_list);
+#endif
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+	INIT_HLIST_HEAD(&br->mep_list);
 #endif
 	spin_lock_init(&br->hash_lock);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2fe8b88d090e..90ead48fa762 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -484,6 +484,9 @@ struct net_bridge {
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	struct list_head		mrp_list;
 #endif
+#if IS_ENABLED(CONFIG_BRIDGE_CFM)
+	struct hlist_head		mep_list;
+#endif
 };
 
 struct br_input_skb_cb {
-- 
2.28.0

