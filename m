Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB639FB9C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhFHQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:04:16 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:35145 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhFHQEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168138; x=1654704138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9+Ly0GnO3qaXmh9bxY9H7MvuozgcNAmIpe/0zv/LhGY=;
  b=nN7EEeQwr2YC2bBdNNIUUhZN/JlYZDNcWxmn/8ppeUjlI8uVavIMDOvA
   x7bU0x7gP3bOyKXa8paUBTZTvWtRtfmn71bVxzF0Gj7/tThm40ECptbrS
   j0h64YAmxvCHgbyNRXmnTXfxAigQusbMXttMnNsQ6yMQccPTcUJ+cdRYw
   A=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="129862181"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 08 Jun 2021 16:02:11 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id B65A8A2090;
        Tue,  8 Jun 2021 16:02:09 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.147) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:02:01 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>
Subject: [Patch v1 net-next 02/10] net: ena: Remove unused code
Date:   Tue, 8 Jun 2021 19:01:10 +0300
Message-ID: <20210608160118.3767932-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.147]
X-ClientProxiedBy: EX13D24UWA004.ant.amazon.com (10.43.160.233) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ENA_DEFAULT_MIN_RX_BUFF_ALLOC_SIZE macro,
ena_xdp_queues_present() function and SUSPEND_RESUME enums aren't used
in the driver, and so not needed.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h |  2 --
 drivers/net/ethernet/amazon/ena/ena_netdev.h     | 11 -----------
 2 files changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
index 4164eacc5c28..f5ec35fa4c63 100644
--- a/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
+++ b/drivers/net/ethernet/amazon/ena/ena_admin_defs.h
@@ -1042,8 +1042,6 @@ enum ena_admin_aenq_group {
 };
 
 enum ena_admin_aenq_notification_syndrome {
-	ENA_ADMIN_SUSPEND                           = 0,
-	ENA_ADMIN_RESUME                            = 1,
 	ENA_ADMIN_UPDATE_HINTS                      = 2,
 };
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 21758707a929..834348fcdf3c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -55,12 +55,6 @@
 #define ENA_TX_WAKEUP_THRESH		(MAX_SKB_FRAGS + 2)
 #define ENA_DEFAULT_RX_COPYBREAK	(256 - NET_IP_ALIGN)
 
-/* limit the buffer size to 600 bytes to handle MTU changes from very
- * small to very large, in which case the number of buffers per packet
- * could exceed ENA_PKT_MAX_BUFS
- */
-#define ENA_DEFAULT_MIN_RX_BUFF_ALLOC_SIZE 600
-
 #define ENA_MIN_MTU		128
 
 #define ENA_NAME_MAX_LEN	20
@@ -417,11 +411,6 @@ enum ena_xdp_errors_t {
 	ENA_XDP_NO_ENOUGH_QUEUES,
 };
 
-static inline bool ena_xdp_queues_present(struct ena_adapter *adapter)
-{
-	return adapter->xdp_first_ring != 0;
-}
-
 static inline bool ena_xdp_present(struct ena_adapter *adapter)
 {
 	return !!adapter->xdp_bpf_prog;
-- 
2.25.1

