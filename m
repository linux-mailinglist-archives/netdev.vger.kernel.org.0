Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088711DD6B9
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgEUTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:47 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:20175 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgEUTJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088185; x=1621624185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=fOlTOOGFlofxas/8r1CKLdAh4vnUnuVvtskBHxi4x0s=;
  b=qBqH9VAzDVatTxChEjT1B1+iRaEIaDGjqHLmJIGKlDbcJ2t/sR1jwJXH
   02aUVHiw+mdzHC+d3aySN7XeHMBXnFIy0Vkcb5r3zVrGgQlL09EzJ4eSa
   h/67Ocm5WsqVO+E5T+aaucFtL97M2pumlhXTIryZy1LfTneCLLkalzKRp
   I=;
IronPort-SDR: 1Clmff3ldNLRjX0/BP8DTDasJ0pGbYBI8KBwEUWifUBBXSkiHK7jFw3EqjqFMf2P6m70OxiaBS
 ynJ1PMZIpQaw==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="36851153"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 May 2020 19:09:45 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id A615CA23B3;
        Thu, 21 May 2020 19:09:44 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:15 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:14 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:09:11 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 11/15] net: ena: cosmetic: remove unnecessary code
Date:   Thu, 21 May 2020 22:08:30 +0300
Message-ID: <1590088114-381-12-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

1. Remove unused definition of DRV_MODULE_VERSION
2. Remove {} from single line-of-code ifs
3. Remove unnecessary comments from ena_get/set_coalesce()
4. Remove unnecessary extra spaces and newlines

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 11 +++--------
 drivers/net/ethernet/amazon/ena/ena_netdev.h  |  6 ------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index ca13efa13b63..e340b65af08c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -206,7 +206,7 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
-	return  adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
+	return adapter->num_io_queues * (ENA_STATS_ARRAY_TX + ENA_STATS_ARRAY_RX)
 		+ ENA_STATS_ARRAY_GLOBAL + ENA_STATS_ARRAY_ENA_COM;
 }
 
@@ -260,7 +260,6 @@ static void ena_get_strings(struct net_device *netdev, u32 sset, u8 *data)
 
 	for (i = 0; i < ENA_STATS_ARRAY_GLOBAL; i++) {
 		ena_stats = &ena_stats_global_strings[i];
-
 		memcpy(data, ena_stats->name, ETH_GSTRING_LEN);
 		data += ETH_GSTRING_LEN;
 	}
@@ -307,10 +306,8 @@ static int ena_get_coalesce(struct net_device *net_dev,
 	struct ena_adapter *adapter = netdev_priv(net_dev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 
-	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
-		/* the devie doesn't support interrupt moderation */
+	if (!ena_com_interrupt_moderation_supported(ena_dev))
 		return -EOPNOTSUPP;
-	}
 
 	coalesce->tx_coalesce_usecs =
 		ena_com_get_nonadaptive_moderation_interval_tx(ena_dev) *
@@ -355,10 +352,8 @@ static int ena_set_coalesce(struct net_device *net_dev,
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	int rc;
 
-	if (!ena_com_interrupt_moderation_supported(ena_dev)) {
-		/* the devie doesn't support interrupt moderation */
+	if (!ena_com_interrupt_moderation_supported(ena_dev))
 		return -EOPNOTSUPP;
-	}
 
 	rc = ena_com_update_nonadaptive_moderation_interval_tx(ena_dev,
 							       coalesce->tx_coalesce_usecs);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 680099afcccf..5320b916a36b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -50,12 +50,6 @@
 #define DRV_MODULE_GEN_SUBMINOR 0
 
 #define DRV_MODULE_NAME		"ena"
-#ifndef DRV_MODULE_GENERATION
-#define DRV_MODULE_GENERATION \
-	__stringify(DRV_MODULE_GEN_MAJOR) "."	\
-	__stringify(DRV_MODULE_GEN_MINOR) "."	\
-	__stringify(DRV_MODULE_GEN_SUBMINOR) "K"
-#endif
 
 #define DEVICE_NAME	"Elastic Network Adapter (ENA)"
 
-- 
2.23.1

