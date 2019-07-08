Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F0F62B39
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404127AbfGHVxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:53:19 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34770 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730443AbfGHVxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:53:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so8954668plt.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eS5ZL7pQzSdoK+auqNncH7W1KhZ1UT6jI63IgeQOR7E=;
        b=cKlm+yPjOAwFg+nBOXUFCwKJhJKlLPHzQNsZzzt0DWNghjT+INH2nGIyXegzby3sO6
         2xapWlYo5SZPHqpEEcqHmiCffGlzkV0dcrc2v4Pr2zFW3Eu+oVkzBAYHqX/ok5yCtIE2
         C5w5tb08KTuHmgQz5uDHFD95eMsuMrXVO4/MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eS5ZL7pQzSdoK+auqNncH7W1KhZ1UT6jI63IgeQOR7E=;
        b=MdO/WaFkWXm7SUA9dGTulvNcYmpH2PGbTtSj2IxxANj67PmxHHAWHfdQuktv6Id3cq
         mw+u+1NhtaPYF3DaOqb482/HaPnc1tUWRfbxGNYZRxL2apCp+aQfSqFdqbWcPOOlmR+6
         9fuLd7FS5/AGGwgmKiLhkXsJEe/jwVb23v01ip89hKbL+tmjxJsMHd75YtjVWbNaJ3CB
         gd6AS4V77p7p38xaX4btX9BoU9HTMOFiAOlkASWlvxlvWh+OiWKireViVy+SpFUefn0k
         qBzaR1sMFmtn8txq+kZIoR2gILDpBdtEwMKxitJgAQWpPxjFOqLOXZkyzyBFnQTWd92H
         gCfw==
X-Gm-Message-State: APjAAAVnR+ybmY8Fpr0rKaIvGAN28MBE77+Cv85VjtId6v6EXltkuoB7
        qNefnGOb/vSAK1yEiYuh574NOA==
X-Google-Smtp-Source: APXvYqyIktIheMuTlFQu+LD04IMkd8xGgmsR+3nD0jlRvRIEijN7j4ML/RhJeyYC1EnDm70EHQIpTw==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr27879432plb.79.1562622797459;
        Mon, 08 Jul 2019 14:53:17 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm11352157pfn.177.2019.07.08.14.53.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 14:53:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, gospo@broadcom.com
Cc:     netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ilias.apalodimas@linaro.org
Subject: [PATCH net-next v2 1/4] bnxt_en: rename some xdp functions
Date:   Mon,  8 Jul 2019 17:53:01 -0400
Message-Id: <1562622784-29918-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
References: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
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

