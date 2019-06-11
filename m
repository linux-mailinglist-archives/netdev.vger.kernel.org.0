Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28F43CA98
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbfFKL7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:59:02 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:61281 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404408AbfFKL7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560254338; x=1591790338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=j6GrMqHFVrB2/Wt1YPIVj7eGSbKjmokgCEE6VtFSu9M=;
  b=KQXIfhqL+lrKaSuq5jCGfwlyVnRgltZyXUjunEVlZ4nHsFoGPj9/lMwj
   ZYclM956k2KF9rJeX3ytxU0sYH5oiAB/VwlloGIBlANwff+O+Vz0HcgRo
   eGQjm98DdwstOcifS3kSThDiPkF3cBnJyiB1DjRXcS4qsqDnoTPthvpt+
   o=;
X-IronPort-AV: E=Sophos;i="5.60,579,1549929600"; 
   d="scan'208";a="400222698"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 11 Jun 2019 11:58:57 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 8ADE5A2060;
        Tue, 11 Jun 2019 11:58:57 +0000 (UTC)
Received: from EX13D02UWC002.ant.amazon.com (10.43.162.6) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:42 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC002.ant.amazon.com (10.43.162.6) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 11 Jun 2019 11:58:41 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.81) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Tue, 11 Jun 2019 11:58:38 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net 6/7] net: ena: remove inline keyword from functions in *.c
Date:   Tue, 11 Jun 2019 14:58:10 +0300
Message-ID: <20190611115811.2819-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611115811.2819-1-sameehj@amazon.com>
References: <20190611115811.2819-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Let the compiler decide if the function should be inline in *.c files

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     |  6 ++---
 drivers/net/ethernet/amazon/ena/ena_eth_com.c | 26 +++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 16 ++++++------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 9efb4be97..56781609c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -91,7 +91,7 @@ struct ena_com_stats_ctx {
 	struct ena_admin_acq_get_stats_resp get_resp;
 };
 
-static inline int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
+static int ena_com_mem_addr_set(struct ena_com_dev *ena_dev,
 				       struct ena_common_mem_addr *ena_addr,
 				       dma_addr_t addr)
 {
@@ -190,7 +190,7 @@ static int ena_com_admin_init_aenq(struct ena_com_dev *dev,
 	return 0;
 }
 
-static inline void comp_ctxt_release(struct ena_com_admin_queue *queue,
+static void comp_ctxt_release(struct ena_com_admin_queue *queue,
 				     struct ena_comp_ctx *comp_ctx)
 {
 	comp_ctx->occupied = false;
@@ -277,7 +277,7 @@ static struct ena_comp_ctx *__ena_com_submit_admin_cmd(struct ena_com_admin_queu
 	return comp_ctx;
 }
 
-static inline int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
+static int ena_com_init_comp_ctxt(struct ena_com_admin_queue *queue)
 {
 	size_t size = queue->q_depth * sizeof(struct ena_comp_ctx);
 	struct ena_comp_ctx *comp_ctx;
diff --git a/drivers/net/ethernet/amazon/ena/ena_eth_com.c b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
index cad2b5728..38046bf0f 100644
--- a/drivers/net/ethernet/amazon/ena/ena_eth_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_eth_com.c
@@ -32,7 +32,7 @@
 
 #include "ena_eth_com.h"
 
-static inline struct ena_eth_io_rx_cdesc_base *ena_com_get_next_rx_cdesc(
+static struct ena_eth_io_rx_cdesc_base *ena_com_get_next_rx_cdesc(
 	struct ena_com_io_cq *io_cq)
 {
 	struct ena_eth_io_rx_cdesc_base *cdesc;
@@ -59,7 +59,7 @@ static inline struct ena_eth_io_rx_cdesc_base *ena_com_get_next_rx_cdesc(
 	return cdesc;
 }
 
-static inline void *get_sq_desc_regular_queue(struct ena_com_io_sq *io_sq)
+static void *get_sq_desc_regular_queue(struct ena_com_io_sq *io_sq)
 {
 	u16 tail_masked;
 	u32 offset;
@@ -71,7 +71,7 @@ static inline void *get_sq_desc_regular_queue(struct ena_com_io_sq *io_sq)
 	return (void *)((uintptr_t)io_sq->desc_addr.virt_addr + offset);
 }
 
-static inline int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
+static int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq,
 						     u8 *bounce_buffer)
 {
 	struct ena_com_llq_info *llq_info = &io_sq->llq_info;
@@ -111,7 +111,7 @@ static inline int ena_com_write_bounce_buffer_to_dev(struct ena_com_io_sq *io_sq
 	return 0;
 }
 
-static inline int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
+static int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
 						 u8 *header_src,
 						 u16 header_len)
 {
@@ -142,7 +142,7 @@ static inline int ena_com_write_header_to_bounce(struct ena_com_io_sq *io_sq,
 	return 0;
 }
 
-static inline void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
+static void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
 {
 	struct ena_com_llq_pkt_ctrl *pkt_ctrl = &io_sq->llq_buf_ctrl;
 	u8 *bounce_buffer;
@@ -162,7 +162,7 @@ static inline void *get_sq_desc_llq(struct ena_com_io_sq *io_sq)
 	return sq_desc;
 }
 
-static inline int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
+static int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 {
 	struct ena_com_llq_pkt_ctrl *pkt_ctrl = &io_sq->llq_buf_ctrl;
 	struct ena_com_llq_info *llq_info = &io_sq->llq_info;
@@ -189,7 +189,7 @@ static inline int ena_com_close_bounce_buffer(struct ena_com_io_sq *io_sq)
 	return 0;
 }
 
-static inline void *get_sq_desc(struct ena_com_io_sq *io_sq)
+static void *get_sq_desc(struct ena_com_io_sq *io_sq)
 {
 	if (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
 		return get_sq_desc_llq(io_sq);
@@ -197,7 +197,7 @@ static inline void *get_sq_desc(struct ena_com_io_sq *io_sq)
 	return get_sq_desc_regular_queue(io_sq);
 }
 
-static inline int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
+static int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 {
 	struct ena_com_llq_pkt_ctrl *pkt_ctrl = &io_sq->llq_buf_ctrl;
 	struct ena_com_llq_info *llq_info = &io_sq->llq_info;
@@ -225,7 +225,7 @@ static inline int ena_com_sq_update_llq_tail(struct ena_com_io_sq *io_sq)
 	return 0;
 }
 
-static inline int ena_com_sq_update_tail(struct ena_com_io_sq *io_sq)
+static int ena_com_sq_update_tail(struct ena_com_io_sq *io_sq)
 {
 	if (io_sq->mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
 		return ena_com_sq_update_llq_tail(io_sq);
@@ -239,7 +239,7 @@ static inline int ena_com_sq_update_tail(struct ena_com_io_sq *io_sq)
 	return 0;
 }
 
-static inline struct ena_eth_io_rx_cdesc_base *
+static struct ena_eth_io_rx_cdesc_base *
 	ena_com_rx_cdesc_idx_to_ptr(struct ena_com_io_cq *io_cq, u16 idx)
 {
 	idx &= (io_cq->q_depth - 1);
@@ -248,7 +248,7 @@ static inline struct ena_eth_io_rx_cdesc_base *
 		idx * io_cq->cdesc_entry_size_in_bytes);
 }
 
-static inline u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
+static u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 					   u16 *first_cdesc_idx)
 {
 	struct ena_eth_io_rx_cdesc_base *cdesc;
@@ -285,7 +285,7 @@ static inline u16 ena_com_cdesc_rx_pkt_get(struct ena_com_io_cq *io_cq,
 	return count;
 }
 
-static inline int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
+static int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io_sq,
 							struct ena_com_tx_ctx *ena_tx_ctx)
 {
 	struct ena_eth_io_tx_meta_desc *meta_desc = NULL;
@@ -334,7 +334,7 @@ static inline int ena_com_create_and_store_tx_meta_desc(struct ena_com_io_sq *io
 	return ena_com_sq_update_tail(io_sq);
 }
 
-static inline void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
+static void ena_com_rx_set_flags(struct ena_com_rx_ctx *ena_rx_ctx,
 					struct ena_eth_io_rx_cdesc_base *cdesc)
 {
 	ena_rx_ctx->l3_proto = cdesc->status &
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 602862bc1..b7865ee1d 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -326,7 +326,7 @@ static void ena_free_all_io_tx_resources(struct ena_adapter *adapter)
 		ena_free_tx_resources(adapter, i);
 }
 
-static inline int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
+static int validate_rx_req_id(struct ena_ring *rx_ring, u16 req_id)
 {
 	if (likely(req_id < rx_ring->ring_size))
 		return 0;
@@ -460,7 +460,7 @@ static void ena_free_all_io_rx_resources(struct ena_adapter *adapter)
 		ena_free_rx_resources(adapter, i);
 }
 
-static inline int ena_alloc_rx_page(struct ena_ring *rx_ring,
+static int ena_alloc_rx_page(struct ena_ring *rx_ring,
 				    struct ena_rx_buffer *rx_info, gfp_t gfp)
 {
 	struct ena_com_buf *ena_buf;
@@ -620,7 +620,7 @@ static void ena_free_all_rx_bufs(struct ena_adapter *adapter)
 		ena_free_rx_bufs(adapter, i);
 }
 
-static inline void ena_unmap_tx_skb(struct ena_ring *tx_ring,
+static void ena_unmap_tx_skb(struct ena_ring *tx_ring,
 				    struct ena_tx_buffer *tx_info)
 {
 	struct ena_com_buf *ena_buf;
@@ -955,7 +955,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
  * @ena_rx_ctx: received packet context/metadata
  * @skb: skb currently being received and modified
  */
-static inline void ena_rx_checksum(struct ena_ring *rx_ring,
+static void ena_rx_checksum(struct ena_ring *rx_ring,
 				   struct ena_com_rx_ctx *ena_rx_ctx,
 				   struct sk_buff *skb)
 {
@@ -1155,7 +1155,7 @@ error:
 	return 0;
 }
 
-inline void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
+void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
 				       struct ena_ring *tx_ring)
 {
 	/* We apply adaptive moderation on Rx path only.
@@ -1174,7 +1174,7 @@ inline void ena_adjust_intr_moderation(struct ena_ring *rx_ring,
 	rx_ring->per_napi_bytes = 0;
 }
 
-static inline void ena_unmask_interrupt(struct ena_ring *tx_ring,
+static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
 	struct ena_eth_io_intr_reg intr_reg;
@@ -1194,7 +1194,7 @@ static inline void ena_unmask_interrupt(struct ena_ring *tx_ring,
 	ena_com_unmask_intr(rx_ring->ena_com_io_cq, &intr_reg);
 }
 
-static inline void ena_update_ring_numa_node(struct ena_ring *tx_ring,
+static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
 					     struct ena_ring *rx_ring)
 {
 	int cpu = get_cpu();
@@ -3337,7 +3337,7 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 	pci_release_selected_regions(pdev, release_bars);
 }
 
-static inline void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
+static void set_default_llq_configurations(struct ena_llq_configurations *llq_config)
 {
 	llq_config->llq_header_location = ENA_ADMIN_INLINE_HEADER;
 	llq_config->llq_ring_entry_size = ENA_ADMIN_LIST_ENTRY_SIZE_128B;
-- 
2.17.1

