Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64363327D
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfFCOoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:09 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:31012 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbfFCOoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573047; x=1591109047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/PkLjWoL9U9q15ZxG+S6p0RYHTgFIBUMBkLDVxbnoz8=;
  b=EkB/zPPZrX4XJBfM8APOgAK/NN6LLBrdjgfmFCPO6X6RMuiccr9ASaUe
   IhQn7+DsAukw1QaOyfzp6UPSsXXKcKs2KSJgXW7XIXgWB0ZSDTZrTC/bN
   mja+FVSmRQiW4YhMhYcH5KbF47OV+04TkU+LUeeGpXxgIxVMrF4lUatH/
   E=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="768739003"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 03 Jun 2019 14:44:06 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 20B30A22FE;
        Mon,  3 Jun 2019 14:44:05 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:51 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:51 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:48 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 05/11] net: ena: add newline at the end of pr_err prints
Date:   Mon, 3 Jun 2019 17:43:23 +0300
Message-ID: <20190603144329.16366-6-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Some pr_err prints lacked '\n' in the end. Added where missing.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 935e8fa8d..139b31549 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -115,7 +115,7 @@ static int ena_com_admin_init_sq(struct ena_com_admin_queue *queue)
 					 GFP_KERNEL);
 
 	if (!sq->entries) {
-		pr_err("memory allocation failed");
+		pr_err("memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -137,7 +137,7 @@ static int ena_com_admin_init_cq(struct ena_com_admin_queue *queue)
 					 GFP_KERNEL);
 
 	if (!cq->entries) {
-		pr_err("memory allocation failed");
+		pr_err("memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -160,7 +160,7 @@ static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
 					   GFP_KERNEL);
 
 	if (!aenq->entries) {
-		pr_err("memory allocation failed");
+		pr_err("memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -285,7 +285,7 @@ static inline int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
 
 	queue->comp_ctx = devm_kzalloc(queue->q_dmadev, size, GFP_KERNEL);
 	if (unlikely(!queue->comp_ctx)) {
-		pr_err("memory allocation failed");
+		pr_err("memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -356,7 +356,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		}
 
 		if (!io_sq->desc_addr.virt_addr) {
-			pr_err("memory allocation failed");
+			pr_err("memory allocation failed\n");
 			return -ENOMEM;
 		}
 	}
@@ -382,7 +382,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 				devm_kzalloc(ena_dev->dmadev, size, GFP_KERNEL);
 
 		if (!io_sq->bounce_buf_ctrl.base_buffer) {
-			pr_err("bounce buffer memory allocation failed");
+			pr_err("bounce buffer memory allocation failed\n");
 			return -ENOMEM;
 		}
 
@@ -440,7 +440,7 @@ static int ena_com_init_io_cq(struct ena_com_dev *ena_dev,
 	}
 
 	if (!io_cq->cdesc_addr.virt_addr) {
-		pr_err("memory allocation failed");
+		pr_err("memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -829,7 +829,7 @@ static u32 ena_com_reg_bar_read32(struct ena_com_dev *ena_dev, u16 offset)
 	}
 
 	if (read_resp->reg_off != offset) {
-		pr_err("Read failure: wrong offset provided");
+		pr_err("Read failure: wrong offset provided\n");
 		ret = ENA_MMIO_READ_TIMEOUT;
 	} else {
 		ret = read_resp->reg_val;
-- 
2.17.1

