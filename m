Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265DD263E43
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgIJHO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgIJG6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:58:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77263C06134E
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a17so5415816wrn.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nMutSp2j8lDpsARJd2bf3g5RNBU3idpv78njSHIfOe8=;
        b=QljOQg6ahzpYjtb0kGIGCOo64fMNlgB1cVe0SNBFGpY0ii1cbB3Sr9cenvrboi77Lw
         NdZv76OAyTL9u0uR8KeiUdB4cpaDuUc6xZ5ptiP+22K4CrnOIWTJru2o4coGISsMHlzp
         xlXIZjbRN6Cv6VSxWiU1CzA4o5hIl9/GmU02bF4MuCrSNoRgJSZhyAJcjHELXnhMiDEW
         hXfucooZSwn7SGDOyzf9EGqSR3/upMRcxev7uYgIS/9wijrOb2ycLY0PhSLqnmr5hHnt
         qLLjlITbCTXR/9+w3D+m0FCcu1PrwNWOzisEJiqeclHGTyBnS3DQwDj12DMBJyaxVvOu
         hm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nMutSp2j8lDpsARJd2bf3g5RNBU3idpv78njSHIfOe8=;
        b=V1WchD7l1ZE5UZa99t5C3C4YYZ/Y0et9rN6yFcp4i23tPpYE0B2fqTDpagmEA1vb5g
         f81OMrDEsA+euoW1H5mGIHsxJuhlgKNtaKsqbMP4Xi2D+UDJY5EqNTs0p6ZWUSnPhf5X
         pHz19bJuUfiKL9RRFH0xGhi+XJfY5oyl4htxhtrmK9mc43GDoCX24z+dW2ztGcfEQ+Fq
         adWRuzbq/DJ2f/GNhV4RhRcysQgDJ6oq/djj9fnBZ6qLvBPCMq6/5Kw24xzNs13ajQ4a
         6yi4EFF3ORgRa4gyYmDq/YcaUskUSIKhWd9quihFj0GcdG2N1KYwbEsYqzLXXL8LOsfl
         HszQ==
X-Gm-Message-State: AOAM530DQQ8iGbXkzLl1lY87EQS1vwUGY+zecX1sIv1Qh0MRkb+TdzDY
        5eIbcGbMktxssxCnFlrxhVEhHA==
X-Google-Smtp-Source: ABdhPJxezyb1HS3XFxzcfbbIQd/MatQOfGqknEyXcbxMZIDF2Fv0wwqEmHgQBEDTOHmpkq+4ePJrUw==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr6648574wrs.388.1599720914289;
        Wed, 09 Sep 2020 23:55:14 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:13 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 18/29] wil6210: txrx: Demote obvious abuse of kernel-doc
Date:   Thu, 10 Sep 2020 07:54:20 +0100
Message-Id: <20200910065431.657636-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of these headers provide any parameter documentation.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/txrx.c:259: warning: Function parameter or member 'wil' not described in 'wil_vring_alloc_skb'
 drivers/net/wireless/ath/wil6210/txrx.c:259: warning: Function parameter or member 'vring' not described in 'wil_vring_alloc_skb'
 drivers/net/wireless/ath/wil6210/txrx.c:259: warning: Function parameter or member 'i' not described in 'wil_vring_alloc_skb'
 drivers/net/wireless/ath/wil6210/txrx.c:259: warning: Function parameter or member 'headroom' not described in 'wil_vring_alloc_skb'
 drivers/net/wireless/ath/wil6210/txrx.c:309: warning: Function parameter or member 'wil' not described in 'wil_rx_add_radiotap_header'
 drivers/net/wireless/ath/wil6210/txrx.c:309: warning: Function parameter or member 'skb' not described in 'wil_rx_add_radiotap_header'
 drivers/net/wireless/ath/wil6210/txrx.c:444: warning: Function parameter or member 'wil' not described in 'wil_vring_reap_rx'
 drivers/net/wireless/ath/wil6210/txrx.c:444: warning: Function parameter or member 'vring' not described in 'wil_vring_reap_rx'
 drivers/net/wireless/ath/wil6210/txrx.c:610: warning: Function parameter or member 'wil' not described in 'wil_rx_refill'
 drivers/net/wireless/ath/wil6210/txrx.c:610: warning: Function parameter or member 'count' not described in 'wil_rx_refill'
 drivers/net/wireless/ath/wil6210/txrx.c:1011: warning: Function parameter or member 'wil' not described in 'wil_rx_handle'
 drivers/net/wireless/ath/wil6210/txrx.c:1011: warning: Function parameter or member 'quota' not described in 'wil_rx_handle'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'd' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'skb' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'tso_desc_type' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'is_ipv4' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'tcp_hdr_len' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1643: warning: Function parameter or member 'skb_net_hdr_len' not described in 'wil_tx_desc_offload_setup_tso'
 drivers/net/wireless/ath/wil6210/txrx.c:1674: warning: Function parameter or member 'd' not described in 'wil_tx_desc_offload_setup'
 drivers/net/wireless/ath/wil6210/txrx.c:1674: warning: Function parameter or member 'skb' not described in 'wil_tx_desc_offload_setup'
 drivers/net/wireless/ath/wil6210/txrx.c:2240: warning: Function parameter or member 'wil' not described in '__wil_update_net_queues'
 drivers/net/wireless/ath/wil6210/txrx.c:2240: warning: Function parameter or member 'vif' not described in '__wil_update_net_queues'
 drivers/net/wireless/ath/wil6210/txrx.c:2240: warning: Function parameter or member 'ring' not described in '__wil_update_net_queues'
 drivers/net/wireless/ath/wil6210/txrx.c:2240: warning: Function parameter or member 'check_stop' not described in '__wil_update_net_queues'
 drivers/net/wireless/ath/wil6210/txrx.c:2430: warning: Function parameter or member 'vif' not described in 'wil_tx_complete'
 drivers/net/wireless/ath/wil6210/txrx.c:2430: warning: Function parameter or member 'ringid' not described in 'wil_tx_complete'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 30 +++++++++----------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 080e5aa60bea4..cc830c795b33c 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -249,8 +249,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct wil_ring *vring)
 	vring->ctx = NULL;
 }
 
-/**
- * Allocate one skb for Rx VRING
+/* Allocate one skb for Rx VRING
  *
  * Safe to call from IRQ
  */
@@ -295,8 +294,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct wil_ring *vring,
 	return 0;
 }
 
-/**
- * Adds radiotap header
+/* Adds radiotap header
  *
  * Any error indicated as "Bad FCS"
  *
@@ -432,8 +430,7 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 	return cid;
 }
 
-/**
- * reap 1 frame from @swhead
+/* reap 1 frame from @swhead
  *
  * Rx descriptor copied to skb->cb
  *
@@ -597,8 +594,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	return skb;
 }
 
-/**
- * allocate and fill up to @count buffers in rx ring
+/* allocate and fill up to @count buffers in rx ring
  * buffers posted at @swtail
  * Note: we have a single RX queue for servicing all VIFs, but we
  * allocate skbs with headroom according to main interface only. This
@@ -1002,8 +998,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	wil_netif_rx(skb, ndev, cid, stats, true);
 }
 
-/**
- * Proceed all completed skb's from Rx VRING
+/* Proceed all completed skb's from Rx VRING
  *
  * Safe to call from NAPI poll, i.e. softirq with interrupts enabled
  */
@@ -1629,8 +1624,7 @@ void wil_tx_desc_set_nr_frags(struct vring_tx_desc *d, int nr_frags)
 	d->mac.d[2] |= (nr_frags << MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 }
 
-/**
- * Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
+/* Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * @tso_desc_type is a descriptor type for TSO: 0 - a header, 1 - first data,
  * 2 - middle, 3 - last descriptor.
@@ -1660,8 +1654,7 @@ static void wil_tx_desc_offload_setup_tso(struct vring_tx_desc *d,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
 }
 
-/**
- * Sets the descriptor @d up for csum. The corresponding
+/* Sets the descriptor @d up for csum. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
  * Note, if d==NULL, the function only returns the protocol result.
@@ -2216,8 +2209,7 @@ static int wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	return rc;
 }
 
-/**
- * Check status of tx vrings and stop/wake net queues if needed
+/* Check status of tx vrings and stop/wake net queues if needed
  * It will start/stop net queues of a specific VIF net_device.
  *
  * This function does one of two checks:
@@ -2419,8 +2411,7 @@ void wil_tx_latency_calc(struct wil6210_priv *wil, struct sk_buff *skb,
 		sta->stats.tx_latency_max_us = skb_time_us;
 }
 
-/**
- * Clean up transmitted skb's from the Tx VRING
+/* Clean up transmitted skb's from the Tx VRING
  *
  * Return number of descriptors cleared
  *
@@ -2460,8 +2451,7 @@ int wil_tx_complete(struct wil6210_vif *vif, int ringid)
 	while (!wil_ring_is_empty(vring)) {
 		int new_swtail;
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
-		/**
-		 * For the fragmented skb, HW will set DU bit only for the
+		/* For the fragmented skb, HW will set DU bit only for the
 		 * last fragment. look for it.
 		 * In TSO the first DU will include hdr desc
 		 */
-- 
2.25.1

