Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BFF2D31C1
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbgLHSJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:09:43 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:43894 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbgLHSJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:09:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607450982; x=1638986982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ch0FH9QIiYJnDZCGr9RJnFAvrOwdMJykHVaG/+SHBW8=;
  b=CsGXAqf5mIzpyPf24PlfUqdU07Zhmc/rOsjItUE9flSVdPpNA3/qWsU3
   SIqSNFE9wbaHJrxlgAhsOx8JElTFfsjfZGLRXP19jfZO7JOX53UUJzSmY
   e4XbLHFK+f++kuE6iFafrbLFw2U15K4E2ilnfNqSp1bneT8lZaw0ONsr+
   A=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="901492243"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 08 Dec 2020 18:09:01 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 76E2DA1CE2;
        Tue,  8 Dec 2020 18:04:01 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.144) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:03:52 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        David Woodhouse <dwmw@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Bshara Saeed <saeedb@amazon.com>, Matt Wilson <msw@amazon.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Nafea Bshara <nafea@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        Ali Saidi <alisaidi@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Samih Jubran <sameehj@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH net-next v5 4/9] net: ena: fix coding style nits
Date:   Tue, 8 Dec 2020 20:02:03 +0200
Message-ID: <20201208180208.26111-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208180208.26111-1-shayagr@amazon.com>
References: <20201208180208.26111-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes two nits, but it does not generate any change to binary
because of the optimization of gcc.

  - use `count` instead of `channels->combined_count`
  - change return type from `int` to `bool`

Also add spaces and change macro order in OR assignment to make the code
easier to read.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
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
2.17.1

