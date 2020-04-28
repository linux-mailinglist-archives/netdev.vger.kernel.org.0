Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8551C1BB77A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgD1H14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:56 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11727 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgD1H1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058873; x=1619594873;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TRPJJx5wL8iDEhG0/EipHn76JSEJqEwwsHFNx8GYx0=;
  b=UfCpCdOTilffNTBfFfPiEU8KF7z5K2AZtwodOGp8+B6/roRodwaqgOv0
   29Y217J8aIyRBTaJfpgcFDwgrYe/hH5nRLbYGoLZ/1bqDXQzBozd28dwq
   N5a5MJQ0rvj1qrOlYLNzCN4ASChEvBvSNfVLkkswrGLnwCnt/8F0l6gQ9
   Y=;
IronPort-SDR: RxkMWIP2ONJDsXAx3aUounI4zpGoDudnPS1AYEHWCucYJv9qRUEope+XVDMv3xiBR05DH6R8+B
 4s/pk+WSvzgg==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="31563146"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Apr 2020 07:27:52 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 1BF0FA15F2;
        Tue, 28 Apr 2020 07:27:52 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 700B781F79; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 12/13] net: ena: cosmetic: remove unnecessary spaces and tabs in ena_com.h macros
Date:   Tue, 28 Apr 2020 07:27:25 +0000
Message-ID: <20200428072726.22247-13-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200428072726.22247-1-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The macros in ena_com.h have inconsistent spaces between
the macro name and it's value.

This commit sets all the macros to have a single space between
the name and value.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 94986cdc0b1a..b3a4b53b6a86 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -54,9 +54,9 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#define ENA_MAX_NUM_IO_QUEUES		128U
+#define ENA_MAX_NUM_IO_QUEUES 128U
 /* We need to queues for each IO (on for Tx and one for Rx) */
-#define ENA_TOTAL_NUM_QUEUES		(2 * (ENA_MAX_NUM_IO_QUEUES))
+#define ENA_TOTAL_NUM_QUEUES (2 * (ENA_MAX_NUM_IO_QUEUES))
 
 #define ENA_MAX_HANDLERS 256
 
@@ -73,13 +73,13 @@
 /*****************************************************************************/
 /* ENA adaptive interrupt moderation settings */
 
-#define ENA_INTR_INITIAL_TX_INTERVAL_USECS		64
-#define ENA_INTR_INITIAL_RX_INTERVAL_USECS		0
-#define ENA_DEFAULT_INTR_DELAY_RESOLUTION		1
+#define ENA_INTR_INITIAL_TX_INTERVAL_USECS 64
+#define ENA_INTR_INITIAL_RX_INTERVAL_USECS 0
+#define ENA_DEFAULT_INTR_DELAY_RESOLUTION 1
 
-#define ENA_HW_HINTS_NO_TIMEOUT				0xFFFF
+#define ENA_HW_HINTS_NO_TIMEOUT	0xFFFF
 
-#define ENA_FEATURE_MAX_QUEUE_EXT_VER	1
+#define ENA_FEATURE_MAX_QUEUE_EXT_VER 1
 
 struct ena_llq_configurations {
 	enum ena_admin_llq_header_location llq_header_location;
-- 
2.24.1.AMZN

