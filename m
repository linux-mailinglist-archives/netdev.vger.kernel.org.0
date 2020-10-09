Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92067288B97
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388855AbgJIOiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:38:06 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:42369 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388888AbgJIOhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602254274; x=1633790274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FHI9pF1PqUVmJKyaV+8zX2DLW8NZ18t1BrTCAp6IIdc=;
  b=z92Hm5TCULqHl7va2PUU3MGV8SpsJ69i0qbOv/mgE5/PS4PaYqLKox2z
   HDj9k1X9Bv6/3HtTIgXNuXLg/wUatACat7eRR+7qmjyl7LEktRLD47XZt
   1CXHB3Sy5Cfwo5AYTRerclfQ7wlmgExEgL4Y1XNmZbxD5HZSsZFRH3dIa
   hFLrfUPJMwO10GD0pyWkLEybvcc8JM/JpbGP9W0apvecHOtqaMX4m2tOv
   V0y4wFenBfXCmQC+JdFIMbNqqK5JwcpnybYWNYpIGTFJyI2ADfh+WYQIh
   BQsYTjX7vwp6i5mfBJ8w5v+oJ6v+U8KQJT4hQeRNj+KY/pPQ/xvJWsTjA
   w==;
IronPort-SDR: 8AlHh46+rmyDbHjYyZ+Unim1SLAZ+VLmaDDur5Pfw/8CsIqzNtO+2aR3SZdYYwZcOiz7obQ/vC
 R/FuOEN/XbEJeuxaGBGNe2NG3LRIN27IHW7KYXOYnITZW81r3xzY0UJ3C7H6D2ylH18QNaKYEY
 lGzGqAq7gUUqBuO/IYb7owLDu/4NWC8eZrHciO2VT5ryyIgLlub0ikXIZOsj3pCaOSrq2UN3KE
 L2LKu7P0VA7J4a3/pd9AM7c91xGVZSXKhX72rx6IcTH2aP8nHMRgFnsR/qKMvE9vN/YR7pF/0m
 954=
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="94796531"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Oct 2020 07:37:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 9 Oct 2020 07:37:20 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 9 Oct 2020 07:37:51 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Fri, 9 Oct 2020 14:35:22 +0000
Message-ID: <20201009143530.2438738-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
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
index 3e62ce2ef8a5..95c82fce9959 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -485,6 +485,9 @@ struct net_bridge {
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

