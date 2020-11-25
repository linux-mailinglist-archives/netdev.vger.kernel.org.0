Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164762C4B14
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgKYWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:52:34 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:33080 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgKYWwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:52:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606344754; x=1637880754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jvy+d+KHprj5eCEb6aBAroaDuzgvAl3m1CpSuJf7HWM=;
  b=Q697gPrmZcDMUmNmGFvt/TiU3Ls7Aj1gJIHHQyHyRj5owfMUFyD0Ou88
   2Wc9Y9xKuPGPrNpSwwY5mtQd9PmHPtyDC89TFK1/37in/SKJta2i+D7U9
   2rNRED0MIEen3Sk2mxK4qEranon1LSqUppHXrfNI/gp9SBzwiCnHaBEVk
   I=;
X-IronPort-AV: E=Sophos;i="5.78,370,1599523200"; 
   d="scan'208";a="91017864"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-55156cd4.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 25 Nov 2020 22:52:26 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-55156cd4.us-west-2.amazon.com (Postfix) with ESMTPS id EF672A1E00;
        Wed, 25 Nov 2020 22:52:25 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:15 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 25 Nov 2020 22:52:15 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.33) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 25 Nov 2020 22:52:10 +0000
From:   <akiyano@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH V1 net-next 4/9] net: ena: fix coding style nits
Date:   Thu, 26 Nov 2020 00:51:43 +0200
Message-ID: <1606344708-11100-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
References: <1606344708-11100-1-git-send-email-akiyano@amazon.com>
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

