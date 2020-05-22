Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BC31DE2AE
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgEVJMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:16 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46766 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgEVJMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138734; x=1621674734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=9Hplk5XqJ777B7SvdTBtvthRf5ByvVV2NJDEXBJOZ+s=;
  b=Vw4l0y+6+hUAEsFSzMXSzExoDnPM/TnD5Zb5/sWJf/XXrFmSTc4dc8DT
   YXbF7c/tW5PclucUhyf8rxX7l4fbAG54s2LXSzufK2+knWlwh1xBnvKM6
   6W8IJq/C+MD00NfELyLYUUxjctDqqMuYFGSJUDC1fxEVSPNKSKNWSywoU
   k=;
IronPort-SDR: 3En+xWtk7KWoL8ccARo2oX5fCya+1n99/HYjQjYMgNhUe7koXPN+UxTtpfNp0szDXpRy/CUahU
 Rmd2RzkD4SzA==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="33055217"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 May 2020 09:12:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id D75F4A1D39;
        Fri, 22 May 2020 09:12:09 +0000 (UTC)
Received: from EX13D02UWB003.ant.amazon.com (10.43.161.48) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:56 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB003.ant.amazon.com (10.43.161.48) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:55 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:52 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 09/14] net: ena: cosmetic: fix line break issues
Date:   Fri, 22 May 2020 12:09:00 +0300
Message-ID: <1590138545-501-10-git-send-email-akiyano@amazon.com>
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

1. Join unnecessarily broken short lines in ena_com.c ena_netdev.c
2. Fix Indentations of broken lines

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c    |  8 +++-----
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 13 ++++++-------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index d47821655d61..a513d71576bd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -375,7 +375,7 @@ static int ena_com_init_io_sq(struct ena_com_dev *ena_dev,
 		io_sq->bounce_buf_ctrl.next_to_use = 0;
 
 		size = io_sq->bounce_buf_ctrl.buffer_size *
-			 io_sq->bounce_buf_ctrl.buffers_num;
+			io_sq->bounce_buf_ctrl.buffers_num;
 
 		dev_node = dev_to_node(ena_dev->dmadev);
 		set_dev_node(ena_dev->dmadev, ctx->numa_node);
@@ -699,8 +699,7 @@ static int ena_com_config_llq_info(struct ena_com_dev *ena_dev,
 		/* The desc list entry size should be whole multiply of 8
 		 * This requirement comes from __iowrite64_copy()
 		 */
-		pr_err("illegal entry size %d\n",
-		       llq_info->desc_list_entry_size);
+		pr_err("illegal entry size %d\n", llq_info->desc_list_entry_size);
 		return -EINVAL;
 	}
 
@@ -2045,8 +2044,7 @@ void ena_com_aenq_intr_handler(struct ena_com_dev *dev, void *data)
 
 	/* write the aenq doorbell after all AENQ descriptors were read */
 	mb();
-	writel_relaxed((u32)aenq->head,
-		       dev->reg_bar + ENA_REGS_AENQ_HEAD_DB_OFF);
+	writel_relaxed((u32)aenq->head, dev->reg_bar + ENA_REGS_AENQ_HEAD_DB_OFF);
 }
 
 int ena_com_dev_reset(struct ena_com_dev *ena_dev,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 0349e0305608..148d13cdd1bf 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2242,7 +2242,7 @@ static int ena_rss_configure(struct ena_adapter *adapter)
 		rc = ena_rss_init_default(adapter);
 		if (rc && (rc != -EOPNOTSUPP)) {
 			netif_err(adapter, ifup, adapter->netdev,
-					"Failed to init RSS rc: %d\n", rc);
+				  "Failed to init RSS rc: %d\n", rc);
 			return rc;
 		}
 	}
@@ -2315,7 +2315,7 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	if (rc) {
 		netif_err(adapter, ifup, adapter->netdev,
 			  "Failed to create I/O TX queue num %d rc: %d\n",
-			   qid, rc);
+			  qid, rc);
 		return rc;
 	}
 
@@ -2464,7 +2464,7 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 	 * ones due to past queue allocation failures.
 	 */
 	set_io_rings_size(adapter, adapter->requested_tx_ring_size,
-			adapter->requested_rx_ring_size);
+			  adapter->requested_rx_ring_size);
 
 	while (1) {
 		if (ena_xdp_present(adapter)) {
@@ -2505,7 +2505,7 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 		if (rc != -ENOMEM) {
 			netif_err(adapter, ifup, adapter->netdev,
 				  "Queue creation failed with error code %d\n",
-				   rc);
+				  rc);
 			return rc;
 		}
 
@@ -2528,7 +2528,7 @@ static int create_queues_with_size_backoff(struct ena_adapter *adapter)
 			new_rx_ring_size = cur_rx_ring_size / 2;
 
 		if (new_tx_ring_size < ENA_MIN_RING_SIZE ||
-				new_rx_ring_size < ENA_MIN_RING_SIZE) {
+		    new_rx_ring_size < ENA_MIN_RING_SIZE) {
 			netif_err(adapter, ifup, adapter->netdev,
 				  "Queue creation failed with the smallest possible queue size of %d for both queues. Not retrying with smaller queues\n",
 				  ENA_MIN_RING_SIZE);
@@ -3087,8 +3087,7 @@ static u16 ena_select_queue(struct net_device *dev, struct sk_buff *skb,
 	return qid;
 }
 
-static void ena_config_host_info(struct ena_com_dev *ena_dev,
-				 struct pci_dev *pdev)
+static void ena_config_host_info(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 {
 	struct ena_admin_host_info *host_info;
 	int rc;
-- 
2.23.1

