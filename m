Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369362A6029
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgKDJGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729007AbgKDJGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 04:06:39 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01461C040203
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 01:06:39 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h62so1594241wme.3
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 01:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x/23In7GphBjuvLzsFPzeVbxW1AkJoC7VMLuq9ClVEg=;
        b=YiTypI8hZJMKh9sJmaRi+HggGPKXrCVi8Zu3qoOl9kAypEC44nS3VpgKl3xbzREdyZ
         wfzHIsbs5c8WghTROvmLFtBQldqLIdaPixDKKmGXQMzCzH3DsnplE0PdACjD41pSynpL
         JN9oaLaiescMESIiZ1sdG85mnee6jGVqVVZLF9oLC58tvmS7C06vyoFuCz0bKihAZ/fd
         xJeS3uq+I2VvPb0B+y62Rx3H/GtEBiO4eFy9wrt5dba5KTYI3UJB/LPeckZECimjm40/
         +xmzeoOWt2rR2d2Srid3vuCeAcQ2aWMnk8j4FibtOnSxwAzpV0unN7ZPF9FcnjZmJdOt
         /YRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x/23In7GphBjuvLzsFPzeVbxW1AkJoC7VMLuq9ClVEg=;
        b=mHlqIKpcPfuVCtTH2jzMOG8kc/wvEnN+MXMHvp6v+y9jy930mB2jbTfi4d2lPNzyW4
         v2nTRqGznzO4VyoVywTNLPJpSPvC7vEE9vjCjgxvMLzVw/SSmNBj5wT48+ECVCWPQVwo
         I9anlVZNIaYBvjSxp5nqSoxegwRv1AeQk602J5e+mVggfEBzYEVI5ftOtOztwLHHU1ei
         PpNnMoiLZt1sLMO/oX5uFWaNPH/uzEwkn71O7wrqeq9qzGgxLGcm2qd+qfBn7Ic6WQp4
         erLocrJikGLrqcAPR8wvmtc5ml1xIaG1biJcY0HlZKS3Rb7bn9samF2uJWGmZ6i9R4cl
         YvmA==
X-Gm-Message-State: AOAM533mYAvtRERoKFSwrHPXEC/Fbe8Wrnwf1ooc1OYYPOB5deK0Yiw/
        MmqiUDhqmMawHTZK6/R+frVv9Q==
X-Google-Smtp-Source: ABdhPJwlkdu+Vqx5xsQ3QhGy+QHBeYuiPfQ8/LYaV54nnmwGfoK2ltW77cXk6AUAu/xw/u3S5vS+7Q==
X-Received: by 2002:a1c:1b8f:: with SMTP id b137mr3312243wmb.61.1604480797705;
        Wed, 04 Nov 2020 01:06:37 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm1607823wrc.76.2020.11.04.01.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 01:06:36 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org
Subject: [PATCH 11/12] net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters
Date:   Wed,  4 Nov 2020 09:06:09 +0000
Message-Id: <20201104090610.1446616-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201104090610.1446616-1-lee.jones@linaro.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
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

