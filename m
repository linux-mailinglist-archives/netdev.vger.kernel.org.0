Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959E927FD8C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732013AbgJAKjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:39:48 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:57700 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:39:48 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2020 06:39:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548787; x=1633084787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hy/X4MWlgIswHAuMy/xndHrV6UV0/kJxBVphfflqOAM=;
  b=R3fCD11VV7+ZVBHsAaGw0aSAjXQaLEOmNHLbcM5TPb6LL8k6RgydtACy
   +ltoPhNQXEMWbCjiNPH//WqhqeCY7y0QReL1YjxWNNRFEvOglfrPm4qcg
   BHhRQm/B+3JN7dQhn9egRetFCOlexTi1fFqm7MFZh0HSkJa1SQUMtjY6F
   VK+6AQ3q10oPHihMcOM4gJO2bWYfsv+1leT6y67dtiSpuGcPzxLM26KLP
   0+QRc//fjHreOn8fZsUNkw38QgiZOUyJKHlp9dKYjiWAZE/L4vIvz/4el
   4d0tmu0RWMFn/ntEKlH3ZaTG0k7kAfXc4En6LAbcvsLzjWyZ2DVog8ltO
   g==;
IronPort-SDR: jL1SAslHADupuHTzddd9uQaB8HDaeNfYbyRVjeD8kJR/6t9lteO0hKwFT/JyksYkpsgMndv53u
 qSPFwg5wb2ettm8cF6bQm8EEpmc2Qz/5s0qNhDzVHV3Ix/8a3fjg7xNMrDuBCFgKCvSZATGZrE
 jAzONqF7+RNL1HfiVazSBmrfXlQHeqIyBb/UO5TcAr4EwzNyswi65w6eLY5cMyNCKeUhhu9Rth
 hSO2PL1uJBoGe2A5S3MvpH+6ExUid7Ym6wV3KNwwYQLn1yHjtYj370Mr66kS6CTCDjQ6Unc4NK
 e9Q=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="91069515"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:32:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:15 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:13 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 02/11] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Thu, 1 Oct 2020 10:30:10 +0000
Message-ID: <20201001103019.1342470-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it possible to include or exclude the CFM
protocol according to 802.1Q section 12.14.

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
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
index 747f6f08f439..c7b0e91547f6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -492,6 +492,9 @@ struct net_bridge {
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

