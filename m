Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD592F5040
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbhAMQnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbhAMQnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:43:05 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48C2C0617B9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:38 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t30so2844153wrb.0
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChGB+JX2oknD3GU9F+oPlQzChiJ0MNf1JzMjKC1b9JA=;
        b=FWA9LG+nduuvOiPy7qbwmuuoFpDSfcuJf4CIGNPTHPKLag9L8f8PSQTVLTxEvNOFj3
         x8bvGUm2lcL53dta+xNOQCjwO1ELeQE/HHZqS4GtxSRUMcTtcDNKEwAoDJmSQB7QRy3E
         70yVJWp7JPSps93FHROwL6LzmD5bMZFIpA/kx05SsxrsWszuLKZ2EMBJoOSCgGZvI8hf
         SX5Qq+hB7tq6xeduYNRHnNpeSc5cZP1965GFGAUrPoz0ziBXBQnYIo3/IKMvsUz11lkq
         ZTxaMx4OYfKXDpFNweVVc83/V4U10Z9yXQ0WsfmNIzrQG5kmi52ZZ+B9HYe1yy1M+jNT
         nNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChGB+JX2oknD3GU9F+oPlQzChiJ0MNf1JzMjKC1b9JA=;
        b=rktRqRYmG5XjQTd7Qus8cof27Q1ft0Tg7z/umNFw0iUfop6mv6l2tksLM2R7FVNpEe
         f3Hf7L9WfhidP+Hoxt11imV62YBiOq/8cfbMgY788g5S5DSohlist4HaMlQLKqSkImxf
         Uo1SfowNPmfg2Fk4DNeVn7JP+EkFPUocyr+z3O96z+isNNXL7B4vxWYKdz2C3Uu2M61W
         +CHvOiBv8Hk5Bcw1GIJnbl+J3dBKttSd6MKDCOEI3AH8QZH9ye/ACWD8WAPYAOzdTIYq
         3a8n5Hd7AYmX0UCmMfTmm7ILvDwDuRnkWE9IZACHyAiq8OAg1XiUYhDGhur597LA0Kyc
         dulw==
X-Gm-Message-State: AOAM531qKLElktIouU8IcsKEknfikMmmDMV3iQ79DdQ4gHPnswmr/gpy
        YD1H89omdowevQU9/nzUxtZ08g==
X-Google-Smtp-Source: ABdhPJywdelEowDWx1FSsuuTEn4queRbCg3PPO/M7TSmewf0ox3Bs79CSgzIXCIW1qi25CRH72ECWg==
X-Received: by 2002:adf:f10f:: with SMTP id r15mr3593887wro.302.1610556097638;
        Wed, 13 Jan 2021 08:41:37 -0800 (PST)
Received: from dell.default ([91.110.221.229])
        by smtp.gmail.com with ESMTPSA id t16sm3836510wmi.3.2021.01.13.08.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 08:41:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 7/7] net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters
Date:   Wed, 13 Jan 2021 16:41:23 +0000
Message-Id: <20210113164123.1334116-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210113164123.1334116-1-lee.jones@linaro.org>
References: <20210113164123.1334116-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/toshiba/spider_net.c:263: warning: Function parameter or member 'hwdescr' not described in 'spider_net_get_descr_status'
 drivers/net/ethernet/toshiba/spider_net.c:263: warning: Excess function parameter 'descr' description in 'spider_net_get_descr_status'
 drivers/net/ethernet/toshiba/spider_net.c:554: warning: Function parameter or member 'netdev' not described in 'spider_net_get_multicast_hash'
 drivers/net/ethernet/toshiba/spider_net.c:902: warning: Function parameter or member 't' not described in 'spider_net_cleanup_tx_ring'
 drivers/net/ethernet/toshiba/spider_net.c:902: warning: Excess function parameter 'card' description in 'spider_net_cleanup_tx_ring'
 drivers/net/ethernet/toshiba/spider_net.c:1074: warning: Function parameter or member 'card' not described in 'spider_net_resync_head_ptr'
 drivers/net/ethernet/toshiba/spider_net.c:1234: warning: Function parameter or member 'napi' not described in 'spider_net_poll'
 drivers/net/ethernet/toshiba/spider_net.c:1234: warning: Excess function parameter 'netdev' description in 'spider_net_poll'
 drivers/net/ethernet/toshiba/spider_net.c:1278: warning: Function parameter or member 'p' not described in 'spider_net_set_mac'
 drivers/net/ethernet/toshiba/spider_net.c:1278: warning: Excess function parameter 'ptr' description in 'spider_net_set_mac'
 drivers/net/ethernet/toshiba/spider_net.c:1350: warning: Function parameter or member 'error_reg1' not described in 'spider_net_handle_error_irq'
 drivers/net/ethernet/toshiba/spider_net.c:1350: warning: Function parameter or member 'error_reg2' not described in 'spider_net_handle_error_irq'
 drivers/net/ethernet/toshiba/spider_net.c:1968: warning: Function parameter or member 't' not described in 'spider_net_link_phy'
 drivers/net/ethernet/toshiba/spider_net.c:1968: warning: Excess function parameter 'data' description in 'spider_net_link_phy'
 drivers/net/ethernet/toshiba/spider_net.c:2149: warning: Function parameter or member 'work' not described in 'spider_net_tx_timeout_task'
 drivers/net/ethernet/toshiba/spider_net.c:2149: warning: Excess function parameter 'data' description in 'spider_net_tx_timeout_task'
 drivers/net/ethernet/toshiba/spider_net.c:2182: warning: Function parameter or member 'txqueue' not described in 'spider_net_tx_timeout'

Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Utz Bacher <utz.bacher@de.ibm.com>
Cc: Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
Cc: netdev@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/toshiba/spider_net.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 5f5b33e6653b2..d5a75ef7e3ca9 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -254,7 +254,7 @@ spider_net_set_promisc(struct spider_net_card *card)
 
 /**
  * spider_net_get_descr_status -- returns the status of a descriptor
- * @descr: descriptor to look at
+ * @hwdescr: descriptor to look at
  *
  * returns the status as in the dmac_cmd_status field of the descriptor
  */
@@ -542,6 +542,7 @@ spider_net_alloc_rx_skbs(struct spider_net_card *card)
 
 /**
  * spider_net_get_multicast_hash - generates hash for multicast filter table
+ * @netdev: interface device structure
  * @addr: multicast address
  *
  * returns the hash value.
@@ -890,7 +891,7 @@ spider_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 /**
  * spider_net_cleanup_tx_ring - cleans up the TX ring
- * @card: card structure
+ * @t: timer context used to obtain the pointer to net card data structure
  *
  * spider_net_cleanup_tx_ring is called by either the tx_timer
  * or from the NAPI polling routine.
@@ -1063,6 +1064,7 @@ static void show_rx_chain(struct spider_net_card *card)
 
 /**
  * spider_net_resync_head_ptr - Advance head ptr past empty descrs
+ * @card: card structure
  *
  * If the driver fails to keep up and empty the queue, then the
  * hardware wil run out of room to put incoming packets. This
@@ -1220,7 +1222,7 @@ spider_net_decode_one_descr(struct spider_net_card *card)
 
 /**
  * spider_net_poll - NAPI poll function called by the stack to return packets
- * @netdev: interface device structure
+ * @napi: napi device structure
  * @budget: number of packets we can pass to the stack at most
  *
  * returns 0 if no more packets available to the driver/stack. Returns 1,
@@ -1268,7 +1270,7 @@ static int spider_net_poll(struct napi_struct *napi, int budget)
 /**
  * spider_net_set_mac - sets the MAC of an interface
  * @netdev: interface device structure
- * @ptr: pointer to new MAC address
+ * @p: pointer to new MAC address
  *
  * Returns 0 on success, <0 on failure. Currently, we don't support this
  * and will always return EOPNOTSUPP.
@@ -1340,6 +1342,8 @@ spider_net_link_reset(struct net_device *netdev)
  * spider_net_handle_error_irq - handles errors raised by an interrupt
  * @card: card structure
  * @status_reg: interrupt status register 0 (GHIINT0STS)
+ * @error_reg1: interrupt status register 1 (GHIINT1STS)
+ * @error_reg2: interrupt status register 2 (GHIINT2STS)
  *
  * spider_net_handle_error_irq treats or ignores all error conditions
  * found when an interrupt is presented
@@ -1961,8 +1965,7 @@ spider_net_open(struct net_device *netdev)
 
 /**
  * spider_net_link_phy
- * @data: used for pointer to card structure
- *
+ * @t: timer context used to obtain the pointer to net card data structure
  */
 static void spider_net_link_phy(struct timer_list *t)
 {
@@ -2140,7 +2143,7 @@ spider_net_stop(struct net_device *netdev)
 /**
  * spider_net_tx_timeout_task - task scheduled by the watchdog timeout
  * function (to be called not under interrupt status)
- * @data: data, is interface device structure
+ * @work: work context used to obtain the pointer to net card data structure
  *
  * called as task when tx hangs, resets interface (if interface is up)
  */
@@ -2174,6 +2177,7 @@ spider_net_tx_timeout_task(struct work_struct *work)
 /**
  * spider_net_tx_timeout - called when the tx timeout watchdog kicks in.
  * @netdev: interface device structure
+ * @txqueue: unused
  *
  * called, if tx hangs. Schedules a task that resets the interface
  */
-- 
2.25.1

