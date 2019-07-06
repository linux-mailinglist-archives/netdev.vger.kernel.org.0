Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299E860F4F
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 09:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGFHgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 03:36:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36807 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfGFHgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 03:36:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so5636957plt.3
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 00:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eS5ZL7pQzSdoK+auqNncH7W1KhZ1UT6jI63IgeQOR7E=;
        b=G0cBSy3ClZhqIPWYh6NCNnw8B5PUffhuU15h6jILaJSOOkattr2usEH/QF5uqs2NMG
         XyPBwMduBZzE85LASPdZ+KsGlmf2dRLtAYhSKJXb9j+LQUGJlxxiNSQ0ixVn9mUd1czw
         SZiozoe1oKax68gZw5GB7XSPKggLfu5rLX3B4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eS5ZL7pQzSdoK+auqNncH7W1KhZ1UT6jI63IgeQOR7E=;
        b=mdTWd7kbflhtynJrjpcBwOR0tTroU/9NEomKO4ZWuR3pJm6eqNorgUSsH33d3QMphy
         ztZ6X6KEgsdWL+hcscIlN6pdzR6v+QYeVJfzsVOc4PJviXrqUMMOD1+DcpE74KmBx5aP
         YkNjJB2CnZmQgc7rrpWMHZPWQR4WBWsFzGKjq84uIT6/SSx5FYPCJ/r2+AnHtp/UjFna
         i8QVrzZRnO8+x3MlTk+iGnJiHl8KjJFN4y+lneJZm9rMdSEnffSc6kgPX8ZJmVscNBFP
         Lz2znzXPOpwjAAYyGESYMHE0gvYxfw+PfX2qJn/bOkuMWl4Twn0r5Rri1V50le7bL4Tj
         wOOQ==
X-Gm-Message-State: APjAAAXS6iR8ZmRFEZh2Xcex5vvpnaYrNL6GAzT3SixuI0Dn5cI+nkiq
        HszIwJtS7XlMqKa3/YUV9Mp98A==
X-Google-Smtp-Source: APXvYqy/Fkm6Wl91Y1QZtXBsaBKW6jGrTzm40WzWm/v1a64lXsEiweopFWUXuBGQ6iGPJ/+kIk5qQQ==
X-Received: by 2002:a17:902:145:: with SMTP id 63mr10413507plb.55.1562398606108;
        Sat, 06 Jul 2019 00:36:46 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm1520144pfc.162.2019.07.06.00.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Jul 2019 00:36:45 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: [PATCH net-next 1/4] bnxt_en: rename some xdp functions
Date:   Sat,  6 Jul 2019 03:36:15 -0400
Message-Id: <1562398578-26020-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Gospodarek <gospo@broadcom.com>

Renaming bnxt_xmit_xdp to __bnxt_xmit_xdp to get ready for XDP_REDIRECT
support and reduce confusion/namespace collision.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c     | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h     | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index a6c7baf..21a0431 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2799,7 +2799,7 @@ static int bnxt_run_loopback(struct bnxt *bp)
 		dev_kfree_skb(skb);
 		return -EIO;
 	}
-	bnxt_xmit_xdp(bp, txr, map, pkt_size, 0);
+	__bnxt_xmit_xdp(bp, txr, map, pkt_size, 0);
 
 	/* Sync BD data before updating doorbell */
 	wmb();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 0184ef6..4bc9595 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -19,8 +19,8 @@
 #include "bnxt.h"
 #include "bnxt_xdp.h"
 
-void bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
-		   dma_addr_t mapping, u32 len, u16 rx_prod)
+void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+		     dma_addr_t mapping, u32 len, u16 rx_prod)
 {
 	struct bnxt_sw_tx_bd *tx_buf;
 	struct tx_bd *txbd;
@@ -132,8 +132,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		*event = BNXT_TX_EVENT;
 		dma_sync_single_for_device(&pdev->dev, mapping + offset, *len,
 					   bp->rx_dir);
-		bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
-			      NEXT_RX(rxr->rx_prod));
+		__bnxt_xmit_xdp(bp, txr, mapping + offset, *len,
+				NEXT_RX(rxr->rx_prod));
 		bnxt_reuse_rx_data(rxr, cons, page);
 		return true;
 	default:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 414b748..b36087b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -10,8 +10,8 @@
 #ifndef BNXT_XDP_H
 #define BNXT_XDP_H
 
-void bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
-		   dma_addr_t mapping, u32 len, u16 rx_prod);
+void __bnxt_xmit_xdp(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
+		     dma_addr_t mapping, u32 len, u16 rx_prod);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 struct page *page, u8 **data_ptr, unsigned int *len,
-- 
2.5.1

