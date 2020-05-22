Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F41DE2AD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbgEVJMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:13216 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbgEVJMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138732; x=1621674732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=fOlTOOGFlofxas/8r1CKLdAh4vnUnuVvtskBHxi4x0s=;
  b=OVORRAS3onbdBg36M/eDa3Xy1PTeObW3oZGj1qaZZNHwdGpKCzIdUDxo
   INRh3dfN9/L/Qjx2vW9fRLjaauHknSGbuvNQwksldZCmGb3hur1Ce0vom
   wJKerhl8sfYRq4Y4pne9p9fE0L+OGYTHmczWBxD0qnf/AuPQazNRME0UW
   o=;
IronPort-SDR: eisTEFsojuRFMBWnq2m4ps4CiOmvHlWY3pFtOmhOf4AYMJd8D2JkSEziaDfORmIeyDiII+fs1q
 hsaiPIg+t9zQ==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="45268725"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 22 May 2020 09:12:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 54EA2C0600;
        Fri, 22 May 2020 09:12:11 +0000 (UTC)
Received: from EX13D02UWB002.ant.amazon.com (10.43.161.160) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB002.ant.amazon.com (10.43.161.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:00 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:56 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 10/14] net: ena: cosmetic: remove unnecessary code
Date:   Fri, 22 May 2020 12:09:01 +0300
Message-ID: <1590138545-501-11-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
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

