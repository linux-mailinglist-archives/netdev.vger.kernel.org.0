Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6072CEDD0
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgLDMM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:12:28 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:52246 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730186AbgLDMM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:12:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607083947; x=1638619947;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VNTxgNlhmdci3718NwQdTNBSex6doRGzHzqUc8GkY+U=;
  b=mPEmEtIjU3sZJPPhk0urTM5GxMhDZ3XMR9oRzmO7wvr0gCEZGa9B853A
   7jlfg9Xf0+FCLD9ByDN8v5qAvgYJfpWvvD+C16xGSmZeGYEos8uU0F/dd
   zHibC4+wWsZD/CFbYMvvkYEJnhiVeqVIU38b8DN0CS5lQg2dcxx00Ou3X
   U=;
X-IronPort-AV: E=Sophos;i="5.78,392,1599523200"; 
   d="scan'208";a="900598281"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 04 Dec 2020 12:11:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id DB03EA5CD4;
        Fri,  4 Dec 2020 12:11:46 +0000 (UTC)
Received: from EX13D02UWC003.ant.amazon.com (10.43.162.199) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC003.ant.amazon.com (10.43.162.199) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 4 Dec 2020 12:11:41 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.14) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 4 Dec 2020 12:11:37 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH V4 net-next 4/9] net: ena: fix coding style nits
Date:   Fri, 4 Dec 2020 14:11:10 +0200
Message-ID: <1607083875-32134-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
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

