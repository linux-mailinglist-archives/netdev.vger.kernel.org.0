Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10DE1DD6BB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgEUTJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:50 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:20175 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgEUTJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088189; x=1621624189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GvDP1jeWzoAtKjy0oUKjkaS/bC1Kc93lrVGudId69Ns=;
  b=uvmoiWfCcNz24eZMDguZEX4vCJT6MMNZnNY7t/wbrm+99AQViN93dwIx
   QuthlKYz+fI+NFAoHV7zwHgQhhDS6Zp6g5x+njOHozimbESK7S9WQ9D/6
   tp9uUxpatPCaq0TgR/szIAIjsxcv9+qjfYQLeIzGIw3XGl8tHbE7lE/s9
   Q=;
IronPort-SDR: T3mPbZu0zrp+TRDC/DPNzkGXr1anSpPJTNwWFi5d+IsKS+tdru3syIx1OEmrAyzZ6MUkO20gme
 iVqVajmUstUA==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="36851162"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 21 May 2020 19:09:49 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 034B7A2021;
        Thu, 21 May 2020 19:09:48 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:22 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:21 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:09:19 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 13/15] net: ena: cosmetic: fix spacing issues
Date:   Thu, 21 May 2020 22:08:32 +0300
Message-ID: <1590088114-381-14-git-send-email-akiyano@amazon.com>
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

1. Add leading and trailing spaces to several comments for better
   readability
2. Make tabs and spaces uniform in enum defines in ena_admin_defs.h

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h  | 6 +++---
 drivers/net/ethernet/amazon/ena/ena_common_defs.h | 2 +-
 drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h | 2 +-
 drivers/net/ethernet/amazon/ena/ena_regs_defs.h   | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 727836f638ad..336742f6e3c3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -768,8 +768,8 @@ enum ena_admin_os_type {
 	ENA_ADMIN_OS_DPDK                           = 3,
 	ENA_ADMIN_OS_FREEBSD                        = 4,
 	ENA_ADMIN_OS_IPXE                           = 5,
-	ENA_ADMIN_OS_ESXI			    = 6,
-	ENA_ADMIN_OS_GROUPS_NUM			    = 6,
+	ENA_ADMIN_OS_ESXI                           = 6,
+	ENA_ADMIN_OS_GROUPS_NUM                     = 6,
 };
 
 struct ena_admin_host_info {
@@ -1136,4 +1136,4 @@ struct ena_admin_ena_mmio_req_read_less_resp {
 /* aenq_link_change_desc */
 #define ENA_ADMIN_AENQ_LINK_CHANGE_DESC_LINK_STATUS_MASK    BIT(0)
 
-#endif /*_ENA_ADMIN_H_ */
+#endif /* _ENA_ADMIN_H_ */
diff --git a/drivers/net/ethernet/amazon/ena/ena_common_defs.h b/drivers/net/ethernet/amazon/ena/ena_common_defs.h
index 23beb7e7ed7b..8a8ded0de9ac 100644
--- a/drivers/net/ethernet/amazon/ena/ena_common_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_common_defs.h
@@ -45,4 +45,4 @@ struct ena_common_mem_addr {
 	u16 reserved16;
 };
 
-#endif /*_ENA_COMMON_H_ */
+#endif /* _ENA_COMMON_H_ */
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h b/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
index ee28fb067d8c..d105c9c56192 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h
@@ -414,4 +414,4 @@ struct ena_eth_io_numa_node_cfg_reg {
 #define ENA_ETH_IO_NUMA_NODE_CFG_REG_ENABLED_SHIFT          31
 #define ENA_ETH_IO_NUMA_NODE_CFG_REG_ENABLED_MASK           BIT(31)
 
-#endif /*_ENA_ETH_IO_H_ */
+#endif /* _ENA_ETH_IO_H_ */
diff --git a/drivers/net/ethernet/amazon/ena/ena_regs_defs.h b/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
index 04fcafcc059c..b514bb1b855d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_regs_defs.h
@@ -154,4 +154,4 @@ enum ena_regs_reset_reason_types {
 #define ENA_REGS_RSS_IND_ENTRY_UPDATE_CQ_IDX_SHIFT          16
 #define ENA_REGS_RSS_IND_ENTRY_UPDATE_CQ_IDX_MASK           0xffff0000
 
-#endif /*_ENA_REGS_H_ */
+#endif /* _ENA_REGS_H_ */
-- 
2.23.1

