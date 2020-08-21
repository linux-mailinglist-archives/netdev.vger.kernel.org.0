Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0D224CEF9
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgHUHUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgHUHSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB47C0612EE
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y3so1011912wrl.4
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQsNrWwf/ZW8gaxjcAMMQn6N+xNCFvfy7jf13HJfroU=;
        b=yYPmeaYlf77Eco7ToFMsauBAB+z3GOXABMa1aYo9e0glej4CQQm6u1zbOWuZZZM9Kd
         BdvMLY+7FSAQ/a/Q/uZ03eqDa/3mbR6PUv7kwWiXs9Unf3QNIPxmnwJUrT8IcjvueiDI
         ol1xM/r3Jr5U06k0bBSos2u+7/TUo9XAsiSuzUgDhlePPSumHl5m03cigIZra8RbBxGJ
         SzmMVHfLxtF/4gC3i9iYiBD2wnf2AKpZkmT+toBUceiJu7aThe8w42ceMhK7OYDq3Ylh
         V2sVd32F5syhUtMJbtpj/fXRjUbzaCuwZXi9Gqf5bNiWuzBd9RkKv+4xg2FFJtUGjtbr
         ZJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQsNrWwf/ZW8gaxjcAMMQn6N+xNCFvfy7jf13HJfroU=;
        b=IKclOSUqln0RagREpevoh/ukRC5YXAMnUXcNqZ8uk4aJiAeQXQRQw6zPjNdS1skUGX
         pITI6udXllbJ0q4TrEwWkpY5cUVpqLq3R7hcwxOObNX2S+esjzZWyobpUbhTUNSAdrXk
         V5PAG4YvrpA/Fw+hPnQ35OLqPQ0E07DGl0KtpaIgoHGAsJ8cQSaJLoPf8zzByXtUrl1W
         8ILpETr3uH3Djf2NFeQIFqQZd1oK062e1j45a16YdTpYc626DXH+7bpHWcuuSP3zNdQ7
         RX1iu58Q9iRTftx7httbUbZQzy10qbFdoMRhs5SHojJY4V+SCTGUviHLChi73UehF9iz
         gjHA==
X-Gm-Message-State: AOAM530A/dMnpLcwxJq/1bqTn6OYQbahbGq8NRu4vvnsITwQ3JloylEs
        xDIHO3NOX2SgggYIzf4pL2wf1Q==
X-Google-Smtp-Source: ABdhPJyQiG+rdngczj4CztmEapm4tMCBuyfk1aOyoz08pAjfQibYcoVQU4TBNy7V2IBDF1K8bOl+Kw==
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr1435558wru.341.1597994241834;
        Fri, 21 Aug 2020 00:17:21 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 27/32] wireless: ath: wil6210: txrx: Demote obvious abuse of kernel-doc
Date:   Fri, 21 Aug 2020 08:16:39 +0100
Message-Id: <20200821071644.109970-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
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
 drivers/net/wireless/ath/wil6210/txrx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 080e5aa60bea4..becf8c6e80bb6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -249,7 +249,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct wil_ring *vring)
 	vring->ctx = NULL;
 }
 
-/**
+/*
  * Allocate one skb for Rx VRING
  *
  * Safe to call from IRQ
@@ -295,7 +295,7 @@ static int wil_vring_alloc_skb(struct wil6210_priv *wil, struct wil_ring *vring,
 	return 0;
 }
 
-/**
+/*
  * Adds radiotap header
  *
  * Any error indicated as "Bad FCS"
@@ -432,7 +432,7 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 	return cid;
 }
 
-/**
+/*
  * reap 1 frame from @swhead
  *
  * Rx descriptor copied to skb->cb
@@ -597,7 +597,7 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	return skb;
 }
 
-/**
+/*
  * allocate and fill up to @count buffers in rx ring
  * buffers posted at @swtail
  * Note: we have a single RX queue for servicing all VIFs, but we
@@ -1002,7 +1002,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	wil_netif_rx(skb, ndev, cid, stats, true);
 }
 
-/**
+/*
  * Proceed all completed skb's from Rx VRING
  *
  * Safe to call from NAPI poll, i.e. softirq with interrupts enabled
@@ -1629,7 +1629,7 @@ void wil_tx_desc_set_nr_frags(struct vring_tx_desc *d, int nr_frags)
 	d->mac.d[2] |= (nr_frags << MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 }
 
-/**
+/*
  * Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * @tso_desc_type is a descriptor type for TSO: 0 - a header, 1 - first data,
@@ -1660,7 +1660,7 @@ static void wil_tx_desc_offload_setup_tso(struct vring_tx_desc *d,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_PSEUDO_HEADER_CALC_EN_POS);
 }
 
-/**
+/*
  * Sets the descriptor @d up for csum. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * Returns the protocol: 0 - not TCP, 1 - TCPv4, 2 - TCPv6.
@@ -2216,7 +2216,7 @@ static int wil_tx_ring(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	return rc;
 }
 
-/**
+/*
  * Check status of tx vrings and stop/wake net queues if needed
  * It will start/stop net queues of a specific VIF net_device.
  *
@@ -2419,7 +2419,7 @@ void wil_tx_latency_calc(struct wil6210_priv *wil, struct sk_buff *skb,
 		sta->stats.tx_latency_max_us = skb_time_us;
 }
 
-/**
+/*
  * Clean up transmitted skb's from the Tx VRING
  *
  * Return number of descriptors cleared
@@ -2460,7 +2460,7 @@ int wil_tx_complete(struct wil6210_vif *vif, int ringid)
 	while (!wil_ring_is_empty(vring)) {
 		int new_swtail;
 		struct wil_ctx *ctx = &vring->ctx[vring->swtail];
-		/**
+		/*
 		 * For the fragmented skb, HW will set DU bit only for the
 		 * last fragment. look for it.
 		 * In TSO the first DU will include hdr desc
-- 
2.25.1

