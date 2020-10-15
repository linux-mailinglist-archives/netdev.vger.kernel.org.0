Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0528F1B7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387493AbgJOMAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:00:03 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:43478 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbgJOL4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602762970; x=1634298970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPqTgibgbIoCFDYZdgCNuNWAh9nm0hqB0zY9m4kalGI=;
  b=cQ0DfoheH2Pin7tPzeO6OX9q+DxcYdrUo9bYrAuxPZ7EDAincs1yfQ+D
   JfvTm312Q9f1N5uzqdEYfdECoHGO5taQdDaEowdByBEIR6swUt6n+Ve6S
   b13VnmDVZv2BxIPbqP5Nw48pc3p1Po8LcZMgGjavObWcezRkJyAbn5usy
   qdcKjwjM2XJU5UzyaGyvbHDDEhl0EPtHrVQ8GcGKWGGyycjqDI6i4TS+g
   AdfGLHtJ/kko0tw0siN0opEQ8CvzjgxSqniASb3dndrHB392PDqGB+/Y+
   73ZphJoWHnqzLovdZcXf9WzRk+SzkpeUP5lwyyfEzFFaGTpH9DBwg9c0H
   g==;
IronPort-SDR: X8pw5eX/DL7huRFWUjVnc/MP6IABFxiK3bg52PaOcHh7DRSAR7v+FaU4Dvi0i4705P/v3UuRI1
 fDaDCXrSyF50c91JzdOK2pC3tnD+JUI6D0eVRIFKrSYO3VMTYjvPHyCXEwgElCRRS466Qmnxnz
 xSgqu1xIeVZksCRgY9IQWFhQbPn24Nj9cWa6yS9aT/Dix788mWuHzRv8p12Zqo6HgZMFrxaBzS
 ay6zkwfcGYyHUr8mH04hi5Csp3yJgJWctyBICXR+cnFcjvdhR+5M8wpcV98vBVUtrTsgTFT1np
 /YU=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="99627353"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:56:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:56:09 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 15 Oct 2020 04:56:07 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v6 02/10] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Date:   Thu, 15 Oct 2020 11:54:10 +0000
Message-ID: <20201015115418.2711454-3-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
References: <20201015115418.2711454-1-henrik.bjoernlund@microchip.com>
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

