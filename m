Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653151DE2B1
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgEVJMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:33 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:37818 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgEVJMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138751; x=1621674751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GvDP1jeWzoAtKjy0oUKjkaS/bC1Kc93lrVGudId69Ns=;
  b=vRUCUs5pOlNQ5FvbVMYS+BQL5GzK1VxsPb16cXvWjpv9hZ6H3BAxmSAP
   U3heX+Sl7OQaDTw4KL11RMGt9lcJg99g04ayDLtLG6jrOG/eKJ1TTFhPk
   +kOL6hUhZXNNWFntvhbnSJaJxEX302gxscPmIcV3ErbBK6YUcHKGOV61F
   M=;
IronPort-SDR: c2rgdS1yiSbpNg3HOWMYZ/Htk9Wowi+hsKyVB71mEGdseuVHPWaD8dnOx1Rvwo0YEZrPc42KVl
 WM0jA4Aubb+Q==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="31733719"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 May 2020 09:12:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 32828A26E9;
        Fri, 22 May 2020 09:12:30 +0000 (UTC)
Received: from EX13D10UWB003.ant.amazon.com (10.43.161.106) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB003.ant.amazon.com (10.43.161.106) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:12:11 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:12:06 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 12/14] net: ena: cosmetic: fix spacing issues
Date:   Fri, 22 May 2020 12:09:03 +0300
Message-ID: <1590138545-501-13-git-send-email-akiyano@amazon.com>
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

