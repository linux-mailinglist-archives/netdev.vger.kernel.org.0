Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27912CC82E
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgLBUnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:43:22 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:23143 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388555AbgLBUnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606941779; x=1638477779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VNTxgNlhmdci3718NwQdTNBSex6doRGzHzqUc8GkY+U=;
  b=B45eDBfkneYxKmNftRp0B7ylSETwHsig3aARBnRFWpTQUpBtygrlXQGy
   GbiMadSFuW3YIYp4WqSxYB4dcYyzepHTuHESHKCQ0LrxSO9Km5SHxjVh2
   ZCVPjDOHFN4G8uOOkr61Uan7jesXqX2SVlh42uYio+Ol+xW+H2DeojSeD
   k=;
X-IronPort-AV: E=Sophos;i="5.78,387,1599523200"; 
   d="scan'208";a="70182038"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 02 Dec 2020 20:03:53 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 1FD71A07D7;
        Wed,  2 Dec 2020 20:03:51 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:51 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 2 Dec 2020 20:03:51 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.23) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 2 Dec 2020 20:03:48 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH V3 net-next 4/9] net: ena: fix coding style nits
Date:   Wed, 2 Dec 2020 22:03:25 +0200
Message-ID: <1606939410-26718-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

This commit fixes two nits, but it does not generate any change to binary
because of the optimization of gcc.

  - use `count` instead of `channels->combined_count`
  - change return type from `int` to `bool`

Also add spaces and change macro order in OR assignment to make the code
easier to read.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 5 +++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index 85daeac219ec..c3be751e7379 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -578,6 +578,7 @@ int ena_com_rx_pkt(struct ena_com_io_cq *io_cq,
 	ena_com_rx_set_flags(io_cq, ena_rx_ctx, cdesc);
 
 	ena_rx_ctx->descs = nb_hw_desc;
+
 	return 0;
 }
 
@@ -602,8 +603,8 @@ int ena_com_add_single_rx_desc(struct ena_com_io_sq *io_sq,
 
 	desc->ctrl = ENA_ETH_IO_RX_DESC_FIRST_MASK |
 		     ENA_ETH_IO_RX_DESC_LAST_MASK |
-		     (io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK) |
-		     ENA_ETH_IO_RX_DESC_COMP_REQ_MASK;
+		     ENA_ETH_IO_RX_DESC_COMP_REQ_MASK |
+		     (io_sq->phase & ENA_ETH_IO_RX_DESC_PHASE_MASK);
 
 	desc->req_id = req_id;
 
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 6cdd9efe8df3..2ad44ae74cf6 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -839,7 +839,7 @@ static int ena_set_channels(struct net_device *netdev,
 	/* The check for max value is already done in ethtool */
 	if (count < ENA_MIN_NUM_IO_QUEUES ||
 	    (ena_xdp_present(adapter) &&
-	    !ena_xdp_legal_queue_count(adapter, channels->combined_count)))
+	    !ena_xdp_legal_queue_count(adapter, count)))
 		return -EINVAL;
 
 	return ena_update_queue_count(adapter, count);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 30eb686749dc..c39f41711c31 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -433,8 +433,8 @@ static inline bool ena_xdp_present_ring(struct ena_ring *ring)
 	return !!ring->xdp_bpf_prog;
 }
 
-static inline int ena_xdp_legal_queue_count(struct ena_adapter *adapter,
-					    u32 queues)
+static inline bool ena_xdp_legal_queue_count(struct ena_adapter *adapter,
+					     u32 queues)
 {
 	return 2 * queues <= adapter->max_num_io_queues;
 }
-- 
2.23.3

