Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D608511612F
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 09:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfLHIm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 03:42:29 -0500
Received: from mx.sdf.org ([205.166.94.20]:61901 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfLHIm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 03:42:29 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 03:42:29 EST
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id xB88doVu023749
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits) verified NO);
        Sun, 8 Dec 2019 08:39:50 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id xB88do1u024931;
        Sun, 8 Dec 2019 08:39:50 GMT
Date:   Sun, 8 Dec 2019 08:39:50 GMT
From:   George Spelvin <lkml@sdf.org>
Message-Id: <201912080839.xB88do1u024931@sdf.org>
To:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH 4/4] b44: Spacing cleanups
Cc:     hauke@hauke-m.de, lkml@sdf.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor stuff (space before tab) noticed during preceding work.

Signed-off-by: George Spelvin <lkml@sdf.org>
---
 drivers/net/ethernet/broadcom/b44.c | 34 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 90e25a1f284f..103afc2e2957 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -727,8 +727,8 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 
 	if (bp->flags & B44_FLAG_RX_RING_HACK)
 		b44_sync_dma_desc_for_device(bp->sdev, bp->rx_ring_dma,
-			                    dest_idx * sizeof(*dp),
-			                    DMA_BIDIRECTIONAL);
+					     dest_idx * sizeof(*dp),
+					     DMA_BIDIRECTIONAL);
 
 	return RX_PKT_BUF_SZ;
 }
@@ -755,8 +755,8 @@ static void b44_recycle_rx(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 
 	if (bp->flags & B44_FLAG_RX_RING_HACK)
 		b44_sync_dma_desc_for_cpu(bp->sdev, bp->rx_ring_dma,
-			                 src_idx * sizeof(*src_desc),
-			                 DMA_BIDIRECTIONAL);
+					  src_idx * sizeof(*src_desc),
+					  DMA_BIDIRECTIONAL);
 
 	ctrl = src_desc->ctrl;
 	if (dest_idx == (B44_RX_RING_SIZE - 1))
@@ -1037,8 +1037,8 @@ static netdev_tx_t b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (bp->flags & B44_FLAG_TX_RING_HACK)
 		b44_sync_dma_desc_for_device(bp->sdev, bp->tx_ring_dma,
-			                    entry * sizeof(bp->tx_ring[0]),
-			                    DMA_TO_DEVICE);
+					     entry * sizeof(bp->tx_ring[0]),
+					     DMA_TO_DEVICE);
 
 	entry = NEXT_TX(entry);
 
@@ -1573,8 +1573,8 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen0 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  B44_ETHIPV4UDP_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE, B44_PATTERN_BASE);
-   	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE, B44_PMASK_BASE);
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE, B44_PATTERN_BASE);
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE, B44_PMASK_BASE);
 
 	/* Raw ethernet II magic packet pattern - pattern 1 */
 	memset(pwol_pattern, 0, B44_PATTERN_SIZE);
@@ -1582,9 +1582,9 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen1 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  ETH_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
 		       B44_PATTERN_BASE + B44_PATTERN_SIZE);
-  	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
 		       B44_PMASK_BASE + B44_PMASK_SIZE);
 
 	/* Ipv6 magic packet pattern - pattern 2 */
@@ -1593,9 +1593,9 @@ static void b44_setup_pseudo_magicp(struct b44 *bp)
 	plen2 = b44_magic_pattern(bp->dev->dev_addr, pwol_pattern, pwol_mask,
 				  B44_ETHIPV6UDP_HLEN);
 
-   	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
+	bwfilter_table(bp, pwol_pattern, B44_PATTERN_SIZE,
 		       B44_PATTERN_BASE + B44_PATTERN_SIZE + B44_PATTERN_SIZE);
-  	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
+	bwfilter_table(bp, pwol_mask, B44_PMASK_SIZE,
 		       B44_PMASK_BASE + B44_PMASK_SIZE + B44_PMASK_SIZE);
 
 	kfree(pwol_pattern);
@@ -1648,9 +1648,9 @@ static void b44_setup_wol(struct b44 *bp)
 		val = br32(bp, B44_DEVCTRL);
 		bw32(bp, B44_DEVCTRL, val | DEVCTRL_MPM | DEVCTRL_PFE);
 
- 	} else {
- 		b44_setup_pseudo_magicp(bp);
- 	}
+	} else {
+		b44_setup_pseudo_magicp(bp);
+	}
 	b44_setup_wol_pci(bp);
 }
 
@@ -1774,8 +1774,8 @@ static void __b44_set_rx_mode(struct net_device *dev)
 			__b44_cam_write(bp, zero, i);
 
 		bw32(bp, B44_RXCONFIG, val);
-        	val = br32(bp, B44_CAM_CTRL);
-	        bw32(bp, B44_CAM_CTRL, val | CAM_CTRL_ENABLE);
+		val = br32(bp, B44_CAM_CTRL);
+		bw32(bp, B44_CAM_CTRL, val | CAM_CTRL_ENABLE);
 	}
 }
 
-- 
2.24.0
