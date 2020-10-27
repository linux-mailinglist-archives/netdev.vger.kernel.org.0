Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5529A8F2
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896831AbgJ0KEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:04:33 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:34880 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896236AbgJ0KEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:04:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1603793071; x=1635329071;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPqTgibgbIoCFDYZdgCNuNWAh9nm0hqB0zY9m4kalGI=;
  b=BNZlfm7NV8TQlINNxrLx6TxIVHim4oCjyplC734PemVhu0fV+XnP1dgp
   1BEuqAm+k08eEJpCoRBTVPKgWdgwRNhytOhP6eWYioLBorXTpftM0i6Ww
   HqjWn5K+6nHGi34IvUW6q4KA09R4ml7+FALgEqDGdAxMoMXH2WaCALeJT
   nCBW17RDJzo4iCQNULEFOeHUx7wUxgCV/K6dLMVVyXVEfPfWe0boI4awY
   7z1gRLcSKKseU7y5v5V93Z+aPBSO2fDlrjPvUY4IWkpcfNtq0uwZGdKFo
   QwUM8+PnIwUTk//+RIo76jzRZD4QZkHfamNvDYON7sOHyndTHmpQL5kG7
   Q==;
IronPort-SDR: Zn9XCAC4r69CihoqgM/2cKaQmIcvt7XNKbZa77I1DXlSWtM+jg8TL9HfhzOrXfx0HtGxEMCq+g
 nzy3SPN/EPbR6loETe6MSlybXz5+k59p3LtMpAEKGxRx3u9k1wTT1uH6jaHuMXvbAkNFLcUnl8
 UYSpHnY7dxBaRi+rDowbpimQMUGQG3bilkojDBEAKPG3d8fy5W6ZwNxb4RBfCOnVAWYngwIInH
 S5iD1DAIgmvrA0Xf8pz/DInG7A3uPWgAr6K9iX7zxtbsBEJD6o8SvYoPV20ERF5gCAOHij+Nrw
 v90=
X-IronPort-AV: E=Sophos;i="5.77,423,1596524400"; 
   d="scan'208";a="94040352"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2020 03:04:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 03:04:18 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 27 Oct 2020 03:04:16 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v7 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Tue, 27 Oct 2020 10:02:43 +0000
Message-ID: <20201027100251.3241719-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
References: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
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
index 15c6445fa998..9b5d62744acc 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -457,6 +457,9 @@ void br_dev_setup(struct net_device *dev)
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

