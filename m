Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F08950B593
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446873AbiDVKxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446657AbiDVKxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:53:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A0A54F9E;
        Fri, 22 Apr 2022 03:50:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m14so10485323wrb.6;
        Fri, 22 Apr 2022 03:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:subject:message-id:mime-version:content-disposition;
        bh=L84X8CuUzjpYHYAmqdlCoA1OF5iswKBt+26VeYta7UA=;
        b=AVUTWi7oPD1EQyMI+4WczCy9CpR0h1bxwqTe3DAHkd2HhrWQAcjaNAzPxA914SL1f4
         PpVxZnbQOl+ci8vhFRf/ofDJ772IihMfoi+wcNW1I+vuh8K1FSLDxdX0UMekPJXm50Jj
         5k7AGAZpvECQWS8vmM01B7bJOMsJFbivcrSuUGRSGteAhZa5xfW63HJA6sKEk2PGRmgh
         IXqtDdICiZRQz1ZFl7dvsZWCfHUqdyXC0rZrx5YXLfDhIMSHuuq6MPyfdUj24Ak6vCvb
         HAXLelNQjUn9Z52jIhkyWTElqFcyeQ2Zcgw+/FbZofafHZtXDSxge90kNBH3hU5gZH6z
         /kAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition;
        bh=L84X8CuUzjpYHYAmqdlCoA1OF5iswKBt+26VeYta7UA=;
        b=iravh9WReX2n249LZSpV7S8CSFcB12JyFyb1mRYryWTfuIK0v6WEAWzYmdFqd+m+q0
         /PmxPNT10SmKmkl7qSTOPxFoSpWNBAmpxdCRIhveeO1DoJDA+v2Sp9D5O3wY23LlW+0Z
         zL2AcGvxpMKjmHMuSoBeDQ/q/Xnahy/1HnlrQDewbGMZNwTGd5VyOnWTYcC9B27MWdOJ
         ZUKYSAW4EbNMLIuC3ytsoUHpKTRnIffSicXaF3Q+ShQM27ihcrJLC/FTxnUPN/+ul1Mp
         VSPsKPlBpB8LlwGhPumyqny21NQqnXGfxmQGrgHHqaiZie8KEhjrPeWPmS2AZW4hnXay
         hQ6g==
X-Gm-Message-State: AOAM5320GEmQORcma6cFVpJ+wf7On+Day75UDBxhjU+oTEwqmg8UCI51
        HODddfXVVCsg8+FV1ejeg0Q=
X-Google-Smtp-Source: ABdhPJx8lr1QbnAFf2gjuYNXHdH1L6RcAhqVnXR/TUKD2d/e6E/lNd96MHq2jP7/RvfqdQLO3cEuRQ==
X-Received: by 2002:adf:dd0e:0:b0:20a:c689:f44a with SMTP id a14-20020adfdd0e000000b0020ac689f44amr3205106wrm.40.1650624656931;
        Fri, 22 Apr 2022 03:50:56 -0700 (PDT)
Received: from kali-h6 ([105.161.29.141])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm1316155wmb.47.2022.04.22.03.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:50:56 -0700 (PDT)
From:   Lungash <denizlungash@gmail.com>
X-Google-Original-From: Lungash <denzlungash@gmail.com>
Date:   Fri, 22 Apr 2022 11:51:04 +0300
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, outreachy@lists.linux.dev
Subject: [PATCH] staging: qlge: Fix line wrapping
Message-ID: <YmJseHLyoAJWOGpc@kali-h6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes line wrapping following kernel coding style.

Task on TODO list

* fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
  qlge_set_multicast_list()).

Signed-off-by: Lungash <denzlungash@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 235 ++++++++++++++-----------------
 1 file changed, 107 insertions(+), 128 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 113a3efd12e9..309db00e0b22 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -499,77 +499,57 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
 
 	switch (mask) {
 	case RT_IDX_CAM_HIT:
-		{
-			value = RT_IDX_DST_CAM_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_CAM_HIT_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_CAM_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_CAM_HIT_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_VALID:	/* Promiscuous Mode frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_PROMISCUOUS_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_PROMISCUOUS_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_ERR:	/* Pass up MAC,IP,TCP/UDP error frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_ALL_ERR_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_ALL_ERR_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_IP_CSUM_ERR: /* Pass up IP CSUM error frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q | /* dest */
-				RT_IDX_TYPE_NICQ | /* type */
-				(RT_IDX_IP_CSUM_ERR_SLOT <<
-				RT_IDX_IDX_SHIFT); /* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q | /* dest */
+			RT_IDX_TYPE_NICQ | /* type */
+			(RT_IDX_IP_CSUM_ERR_SLOT <<
+			RT_IDX_IDX_SHIFT); /* index */
+		break;
 	case RT_IDX_TU_CSUM_ERR: /* Pass up TCP/UDP CSUM error frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q | /* dest */
-				RT_IDX_TYPE_NICQ | /* type */
-				(RT_IDX_TCP_UDP_CSUM_ERR_SLOT <<
-				RT_IDX_IDX_SHIFT); /* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q | /* dest */
+			RT_IDX_TYPE_NICQ | /* type */
+			(RT_IDX_TCP_UDP_CSUM_ERR_SLOT <<
+			RT_IDX_IDX_SHIFT); /* index */
+		break;
 	case RT_IDX_BCAST:	/* Pass up Broadcast frames to default Q. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_BCAST_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_BCAST_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_MCAST:	/* Pass up All Multicast frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_ALLMULTI_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_ALLMULTI_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_MCAST_MATCH:	/* Pass up matched Multicast frames. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_MCAST_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_MCAST_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case RT_IDX_RSS_MATCH:	/* Pass up matched RSS frames. */
-		{
-			value = RT_IDX_DST_RSS |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (RT_IDX_RSS_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_RSS |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(RT_IDX_RSS_MATCH_SLOT << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	case 0:		/* Clear the E-bit on an entry. */
-		{
-			value = RT_IDX_DST_DFLT_Q |	/* dest */
-			    RT_IDX_TYPE_NICQ |	/* type */
-			    (index << RT_IDX_IDX_SHIFT);/* index */
-			break;
-		}
+		value = RT_IDX_DST_DFLT_Q |	/* dest */
+			RT_IDX_TYPE_NICQ |	/* type */
+			(index << RT_IDX_IDX_SHIFT);/* index */
+		break;
 	default:
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Mask type %d not yet supported.\n", mask);
@@ -599,14 +579,16 @@ static void qlge_disable_interrupts(struct qlge_adapter *qdev)
 	qlge_write32(qdev, INTR_EN, (INTR_EN_EI << 16));
 }
 
-static void qlge_enable_completion_interrupt(struct qlge_adapter *qdev, u32 intr)
+static void qlge_enable_completion_interrupt(struct qlge_adapter *qdev,
+					     u32 intr)
 {
 	struct intr_context *ctx = &qdev->intr_context[intr];
 
 	qlge_write32(qdev, INTR_EN, ctx->intr_en_mask);
 }
 
-static void qlge_disable_completion_interrupt(struct qlge_adapter *qdev, u32 intr)
+static void qlge_disable_completion_interrupt(struct qlge_adapter *qdev,
+					      u32 intr)
 {
 	struct intr_context *ctx = &qdev->intr_context[intr];
 
@@ -621,7 +603,8 @@ static void qlge_enable_all_completion_interrupts(struct qlge_adapter *qdev)
 		qlge_enable_completion_interrupt(qdev, i);
 }
 
-static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size, const char *str)
+static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size,
+			       const char *str)
 {
 	int status, i;
 	u16 csum = 0;
@@ -643,7 +626,8 @@ static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size, const char *
 	return csum;
 }
 
-static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *data)
+static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset,
+				__le32 *data)
 {
 	int status = 0;
 	/* wait for reg to come ready */
@@ -696,10 +680,8 @@ static int qlge_get_8000_flash_params(struct qlge_adapter *qdev)
 		}
 	}
 
-	status = qlge_validate_flash(qdev,
-				     sizeof(struct flash_params_8000) /
-				   sizeof(u16),
-				   "8000");
+	status = qlge_validate_flash(qdev, sizeof(struct flash_params_8000) /
+				     sizeof(u16), "8000");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
@@ -757,10 +739,8 @@ static int qlge_get_8012_flash_params(struct qlge_adapter *qdev)
 		}
 	}
 
-	status = qlge_validate_flash(qdev,
-				     sizeof(struct flash_params_8012) /
-				       sizeof(u16),
-				     "8012");
+	status = qlge_validate_flash(qdev, sizeof(struct flash_params_8012) /
+				     sizeof(u16), "8012");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
@@ -928,8 +908,8 @@ static int qlge_8012_port_initialize(struct qlge_adapter *qdev)
 		goto end;
 
 	/* Turn on jumbo. */
-	status =
-	    qlge_write_xgmac_reg(qdev, MAC_TX_PARAMS, MAC_TX_PARAMS_JUMBO | (0x2580 << 16));
+	status = qlge_write_xgmac_reg(qdev, MAC_TX_PARAMS,
+				      MAC_TX_PARAMS_JUMBO | (0x2580 << 16));
 	if (status)
 		goto end;
 	status =
@@ -1520,10 +1500,9 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
 			   (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
-			struct iphdr *iph =
-				(struct iphdr *)((u8 *)addr + hlen);
-			if (!(iph->frag_off &
-			      htons(IP_MF | IP_OFFSET))) {
+			struct iphdr *iph = (struct iphdr *)((u8 *)addr + hlen);
+
+			if (!(iph->frag_off & htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1763,7 +1742,8 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 			skb = netdev_alloc_skb(qdev->ndev, length);
 			if (!skb) {
-				netif_printk(qdev, probe, KERN_DEBUG, qdev->ndev,
+				netif_printk(qdev, probe, KERN_DEBUG,
+					     qdev->ndev,
 					     "No skb available, drop the packet.\n");
 				return NULL;
 			}
@@ -1835,8 +1815,8 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			length -= size;
 			i++;
 		} while (length > 0);
-		qlge_update_mac_hdr_len(qdev, ib_mac_rsp, lbq_desc->p.pg_chunk.va,
-					&hlen);
+		qlge_update_mac_hdr_len(qdev, ib_mac_rsp,
+					lbq_desc->p.pg_chunk.va, &hlen);
 		__pskb_pull_tail(skb, hlen);
 	}
 	return skb;
@@ -2447,7 +2427,8 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	return work_done ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static int qlge_tso(struct sk_buff *skb, struct qlge_ob_mac_tso_iocb_req *mac_iocb_ptr)
+static int qlge_tso(struct sk_buff *skb,
+		    struct qlge_ob_mac_tso_iocb_req *mac_iocb_ptr)
 {
 	if (skb_is_gso(skb)) {
 		int err;
@@ -2683,9 +2664,10 @@ static void qlge_free_tx_resources(struct qlge_adapter *qdev,
 static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
 				   struct tx_ring *tx_ring)
 {
-	tx_ring->wq_base =
-		dma_alloc_coherent(&qdev->pdev->dev, tx_ring->wq_size,
-				   &tx_ring->wq_base_dma, GFP_ATOMIC);
+	tx_ring->wq_base = dma_alloc_coherent(&qdev->pdev->dev,
+					      tx_ring->wq_size,
+					      &tx_ring->wq_base_dma,
+					      GFP_ATOMIC);
 
 	if (!tx_ring->wq_base ||
 	    tx_ring->wq_base_dma & WQ_ADDR_ALIGN)
@@ -2707,15 +2689,15 @@ static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
 	return -ENOMEM;
 }
 
-static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_lbq_buffers(struct qlge_adapter *qdev,
+				  struct rx_ring *rx_ring)
 {
 	struct qlge_bq *lbq = &rx_ring->lbq;
 	unsigned int last_offset;
 
 	last_offset = qlge_lbq_block_size(qdev) - qdev->lbq_buf_size;
 	while (lbq->next_to_clean != lbq->next_to_use) {
-		struct qlge_bq_desc *lbq_desc =
-			&lbq->queue[lbq->next_to_clean];
+		struct qlge_bq_desc *lbq_desc = &lbq->queue[lbq->next_to_clean];
 
 		if (lbq_desc->p.pg_chunk.offset == last_offset)
 			dma_unmap_page(&qdev->pdev->dev, lbq_desc->dma_addr,
@@ -2734,7 +2716,8 @@ static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_
 	}
 }
 
-static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_sbq_buffers(struct qlge_adapter *qdev,
+				  struct rx_ring *rx_ring)
 {
 	int i;
 
@@ -2854,9 +2837,10 @@ static int qlge_alloc_rx_resources(struct qlge_adapter *qdev,
 	/*
 	 * Allocate the completion queue for this rx_ring.
 	 */
-	rx_ring->cq_base =
-		dma_alloc_coherent(&qdev->pdev->dev, rx_ring->cq_size,
-				   &rx_ring->cq_base_dma, GFP_ATOMIC);
+	rx_ring->cq_base = dma_alloc_coherent(&qdev->pdev->dev,
+					      rx_ring->cq_size,
+					      &rx_ring->cq_base_dma,
+					      GFP_ATOMIC);
 
 	if (!rx_ring->cq_base) {
 		netif_err(qdev, ifup, qdev->ndev, "rx_ring alloc failed.\n");
@@ -2952,8 +2936,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
 	u64 shadow_reg_dma = qdev->rx_ring_shadow_reg_dma +
 		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
-	void __iomem *doorbell_area =
-		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
+	void __iomem *doorbell_area = qdev->doorbell_area +
+		(DB_PAGE_SIZE * (128 + rx_ring->cq_id));
 	int err = 0;
 	u64 tmp;
 	__le64 *base_indirect_ptr;
@@ -3061,8 +3045,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
 static int qlge_start_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring)
 {
 	struct wqicb *wqicb = (struct wqicb *)tx_ring;
-	void __iomem *doorbell_area =
-		qdev->doorbell_area + (DB_PAGE_SIZE * tx_ring->wq_id);
+	void __iomem *doorbell_area = qdev->doorbell_area +
+		(DB_PAGE_SIZE * tx_ring->wq_id);
 	void *shadow_reg = qdev->tx_ring_shadow_reg_area +
 		(tx_ring->wq_id * sizeof(u64));
 	u64 shadow_reg_dma = qdev->tx_ring_shadow_reg_dma +
@@ -3268,16 +3252,13 @@ static void qlge_resolve_queues_to_irqs(struct qlge_adapter *qdev)
 			 * We set up each vectors enable/disable/read bits so
 			 * there's no bit/mask calculations in the critical path.
 			 */
-			intr_context->intr_en_mask =
-				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+			intr_context->intr_en_mask = INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
 				INTR_EN_TYPE_ENABLE | INTR_EN_IHD_MASK | INTR_EN_IHD
 				| i;
-			intr_context->intr_dis_mask =
-				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+			intr_context->intr_dis_mask = INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
 				INTR_EN_TYPE_DISABLE | INTR_EN_IHD_MASK |
 				INTR_EN_IHD | i;
-			intr_context->intr_read_mask =
-				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+			intr_context->intr_read_mask = INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
 				INTR_EN_TYPE_READ | INTR_EN_IHD_MASK | INTR_EN_IHD |
 				i;
 			if (i == 0) {
@@ -3309,10 +3290,9 @@ static void qlge_resolve_queues_to_irqs(struct qlge_adapter *qdev)
 		 * We set up each vectors enable/disable/read bits so
 		 * there's no bit/mask calculations in the critical path.
 		 */
-		intr_context->intr_en_mask =
-			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_ENABLE;
-		intr_context->intr_dis_mask =
-			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+		intr_context->intr_en_mask = INTR_EN_TYPE_MASK |
+			INTR_EN_INTR_MASK | INTR_EN_TYPE_ENABLE;
+		intr_context->intr_dis_mask = INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
 			INTR_EN_TYPE_DISABLE;
 		if (test_bit(QL_LEGACY_ENABLED, &qdev->flags)) {
 			/* Experience shows that when using INTx interrupts,
@@ -3324,8 +3304,8 @@ static void qlge_resolve_queues_to_irqs(struct qlge_adapter *qdev)
 				INTR_EN_EI;
 			intr_context->intr_dis_mask |= INTR_EN_EI << 16;
 		}
-		intr_context->intr_read_mask =
-			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_READ;
+		intr_context->intr_read_mask = INTR_EN_TYPE_MASK |
+			INTR_EN_INTR_MASK | INTR_EN_TYPE_READ;
 		/*
 		 * Single interrupt means one handler for all rings.
 		 */
@@ -3434,8 +3414,7 @@ static int qlge_start_rss(struct qlge_adapter *qdev)
 	memset((void *)ricb, 0, sizeof(*ricb));
 
 	ricb->base_cq = RSS_L4K;
-	ricb->flags =
-		(RSS_L6K | RSS_LI | RSS_LB | RSS_LM | RSS_RT4 | RSS_RT6);
+	ricb->flags = (RSS_L6K | RSS_LI | RSS_LB | RSS_LM | RSS_RT4 | RSS_RT6);
 	ricb->mask = cpu_to_le16((u16)(0x3ff));
 
 	/*
@@ -4127,8 +4106,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	 */
 	if (ndev->flags & IFF_PROMISC) {
 		if (!test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_PROMISCUOUS_SLOT,
+						 RT_IDX_VALID, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set promiscuous mode.\n");
 			} else {
@@ -4137,8 +4116,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 0)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_PROMISCUOUS_SLOT,
+						 RT_IDX_VALID, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear promiscuous mode.\n");
 			} else {
@@ -4154,8 +4133,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	if ((ndev->flags & IFF_ALLMULTI) ||
 	    (netdev_mc_count(ndev) > MAX_MULTICAST_ENTRIES)) {
 		if (!test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 1)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_ALLMULTI_SLOT,
+						 RT_IDX_MCAST, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set all-multi mode.\n");
 			} else {
@@ -4164,8 +4143,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (qlge_set_routing_reg
-			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 0)) {
+			if (qlge_set_routing_reg(qdev, RT_IDX_ALLMULTI_SLOT,
+						 RT_IDX_MCAST, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear all-multi mode.\n");
 			} else {
@@ -4190,8 +4169,8 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 			i++;
 		}
 		qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
-		if (qlge_set_routing_reg
-		    (qdev, RT_IDX_MCAST_MATCH_SLOT, RT_IDX_MCAST_MATCH, 1)) {
+		if (qlge_set_routing_reg(qdev, RT_IDX_MCAST_MATCH_SLOT,
+					 RT_IDX_MCAST_MATCH, 1)) {
 			netif_err(qdev, hw, qdev->ndev,
 				  "Failed to set multicast match mode.\n");
 		} else {
@@ -4235,8 +4214,8 @@ static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 
 static void qlge_asic_reset_work(struct work_struct *work)
 {
-	struct qlge_adapter *qdev =
-		container_of(work, struct qlge_adapter, asic_reset_work.work);
+	struct qlge_adapter *qdev = container_of(work, struct qlge_adapter,
+						 asic_reset_work.work);
 	int status;
 
 	rtnl_lock();
@@ -4407,8 +4386,8 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	/* Set PCIe reset type for EEH to fundamental. */
 	pdev->needs_freset = 1;
 	pci_save_state(pdev);
-	qdev->reg_base =
-		ioremap(pci_resource_start(pdev, 1), pci_resource_len(pdev, 1));
+	qdev->reg_base = ioremap(pci_resource_start(pdev, 1),
+				 pci_resource_len(pdev, 1));
 	if (!qdev->reg_base) {
 		dev_err(&pdev->dev, "Register mapping failed.\n");
 		err = -ENOMEM;
@@ -4416,8 +4395,8 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	}
 
 	qdev->doorbell_area_size = pci_resource_len(pdev, 3);
-	qdev->doorbell_area =
-		ioremap(pci_resource_start(pdev, 3), pci_resource_len(pdev, 3));
+	qdev->doorbell_area = ioremap(pci_resource_start(pdev, 3),
+				      pci_resource_len(pdev, 3));
 	if (!qdev->doorbell_area) {
 		dev_err(&pdev->dev, "Doorbell register mapping failed.\n");
 		err = -ENOMEM;
-- 
2.35.1


