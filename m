Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745C92C55F3
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390565AbgKZNjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390543AbgKZNjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:39:09 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC865C0617A7
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:08 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 23so2176256wrc.8
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x/23In7GphBjuvLzsFPzeVbxW1AkJoC7VMLuq9ClVEg=;
        b=UEZU7070gAWrlkVS/SYDGQ+9C95/de63HCNZ65/cX/5BWpx/6BcM7agMCTUeKx/06w
         69/AsA5jdtT3qRFfxI6HF+jy5/obbKLu0FOteMDf9qbcZnraymJGR5vzEq/tg8lERYOf
         wmfr2Gev2IkGxLru4olxTDfHTQ9DQB1eztZliBIUoQj+dVsnduLoyv8SCulplTL7Pg3C
         5/tA2LWbNxRbXYQZRAfREtCjyc7da6PPF+w9uL2dKRlfzd4sw1De4odDvMiRHblF82FI
         4Id0tHmnrwkdwLpcZ91rH635Ti5iYzvsOAgvUyAiYQd6caMi4BfYa3o6NMZ99CfGwZ96
         zeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x/23In7GphBjuvLzsFPzeVbxW1AkJoC7VMLuq9ClVEg=;
        b=jzQ0ZGg1wL4gU/gIcFsJLsK4XD19cgvf5XEN1b+/yhtNTXYKWtnYEnycK8ayaIYaY5
         lzS3G6DfQ2KOuKKUEvriK2INr/xB2GXZofSekZ9v/IKZtexHEOkiLvMfzFuIAGghzE5I
         CyVf4k6yvKxwTzsBDeGFWwOx3PNBtgAHfrHbwnhDbgjtePJ3bqM6nvXxQqM0Fm3CLBb0
         HB1DuoQPAigABIoCdmb5/R0FgxlQNe8I4051O/+OM3Mc00zKafvJdEGh1HgdfVenXbuJ
         XYHu3IwmHKz2caZvF+Kebug0PLshvtbh//zooSPEKkSaygIo4ko7lsY54chPkmMBnroI
         hVNw==
X-Gm-Message-State: AOAM5318P5SAzHt8lGEelu+MGIizBAUCpIwm5xIrYLvGecKvj81wCr2M
        4RuJQyDUKxsEdrM4uBHXg3K+VwSDp7SbE1vC
X-Google-Smtp-Source: ABdhPJxSopU6jVkoXk+6uS11exgwGi6kmMxE34CJKNAI1nyYQxx9mod7s9FvAbxeTyST+kFeTclXAQ==
X-Received: by 2002:a5d:4349:: with SMTP id u9mr3805104wrr.319.1606397947553;
        Thu, 26 Nov 2020 05:39:07 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id s133sm7035825wmf.38.2020.11.26.05.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:39:06 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Utz Bacher <utz.bacher@de.ibm.com>,
        Jens Osterkamp <Jens.Osterkamp@de.ibm.com>,
        netdev@vger.kernel.org
Subject: [PATCH 7/8] net: ethernet: toshiba: spider_net: Document a whole bunch of function parameters
Date:   Thu, 26 Nov 2020 13:38:52 +0000
Message-Id: <20201126133853.3213268-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133853.3213268-1-lee.jones@linaro.org>
References: <20201126133853.3213268-1-lee.jones@linaro.org>
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

