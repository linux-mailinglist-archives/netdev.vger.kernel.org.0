Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5C19005A
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCWVaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:30:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36581 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgCWVaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:30:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id i13so8179536pfe.3
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 14:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=xmqjdSqo18rjh5aNt0lOqUAN9ZpktpoyALPsosQmDnU=;
        b=smW6IJ7KqjARusYTKV49yom69HT5SGVusbOMxFUiDvIAXDDq8YZhSZwBsEH7v4x65c
         RiX7HjxT97wxTuIFxNRlBjMp9hnAmVuQMoK4XTLyeO9K2gx1J+pXtUxRCE2yNQG8uxfo
         rvMS6P7XqsiSKE2OHkTBD/ltqkA6uw8Ljo763s1YquxB/zwt+gWKgxavcEa4q43z0npI
         AJKGScC87Yh4xNbUiURJweB5DiE8itRqhRGFPP52XmoOM5ouzWVck7E7UtI6lzyMzs4o
         oqlB3NlEr73pmwA05h8EgxOilZZxn6UC3G+jvfO2RCEf9xwV9ufpougRPC29KAQnC3iD
         3HFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=xmqjdSqo18rjh5aNt0lOqUAN9ZpktpoyALPsosQmDnU=;
        b=qOkMvxfemp1ebbkylr68BXMJR+98QO+n+DmYUgWD2aYcQbx2vIMxeT2y4TR81AuIxe
         yv/4ucF0v5D2CbDyEUsn96+kP/E4WBCYbOKQWT22sdhN+3gOLilN0dJaCtIn9KGB/USb
         dAO2nOt+0A7RP20G4Vf5ZAEtdYsmIvNGrXgjDJGMIsxTXdBnNs3c8xxya6pOtIZ8ctSN
         A5m7m36aNidqE5ox6Hj0de5wkoxfau5mdJUbfYpxSmG+HQgKyQ+jWlzdeQGx9ajHpSfT
         STYvmcJWvlak4Wd7UBahn9FPGuSbGXMKQa2PYmxwPVPU0Igk2CK8awJ5UxxpL0suLcwt
         OPGw==
X-Gm-Message-State: ANhLgQ3m8nAeuTw5BdFMYn0RAbmhJWkrAiZCBUk9Wen90ImEIgri1zQF
        yYYcRrTTwLoewA91++48Mt0=
X-Google-Smtp-Source: ADFU+vtwdSIvKCuujB20B5jzZSwGZM8XCCYzSK6ViV4nsfJBGUGLPBy7t3l1oWPyt8R78yhSeY4/aQ==
X-Received: by 2002:a63:fc52:: with SMTP id r18mr22868230pgk.96.1584999036170;
        Mon, 23 Mar 2020 14:30:36 -0700 (PDT)
Received: from edge-z.localdomain (38-218-137-216.mtaonline.net. [216.137.218.38])
        by smtp.gmail.com with ESMTPSA id j21sm5847988pff.39.2020.03.23.14.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 14:30:35 -0700 (PDT)
Date:   Mon, 23 Mar 2020 13:31:10 -0800
From:   Logan Magee <mageelog@gmail.com>
To:     dave@thedillows.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] net: typhoon: Add required whitespace after keywords
Message-ID: <20200323213110.urobtmwfw6q6e3hc@edge-z.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch found a lack of appropriate whitespace after certain keywords
as per the style guide. Add it in.

Signed-off-by: Logan Magee <mageelog@gmail.com>
---
 drivers/net/ethernet/3com/typhoon.c | 282 ++++++++++++++--------------
 drivers/net/ethernet/3com/typhoon.h |   4 +-
 2 files changed, 143 insertions(+), 143 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 14fce6658106..6975886f2b6f 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -311,7 +311,7 @@ enum state_values {
  * cannot pass a read, so this forces current writes to post.
  */
 #define typhoon_post_pci_writes(x) \
-	do { if(likely(use_mmio)) ioread32(x+TYPHOON_REG_HEARTBEAT); } while(0)
+	do { if (likely(use_mmio)) ioread32(x+TYPHOON_REG_HEARTBEAT); } while (0)
 
 /* We'll wait up to six seconds for a reset, and half a second normally.
  */
@@ -381,7 +381,7 @@ typhoon_reset(void __iomem *ioaddr, int wait_type)
 	int i, err = 0;
 	int timeout;
 
-	if(wait_type == WaitNoSleep)
+	if (wait_type == WaitNoSleep)
 		timeout = TYPHOON_RESET_TIMEOUT_NOSLEEP;
 	else
 		timeout = TYPHOON_RESET_TIMEOUT_SLEEP;
@@ -394,13 +394,13 @@ typhoon_reset(void __iomem *ioaddr, int wait_type)
 	udelay(1);
 	iowrite32(TYPHOON_RESET_NONE, ioaddr + TYPHOON_REG_SOFT_RESET);
 
-	if(wait_type != NoWait) {
-		for(i = 0; i < timeout; i++) {
-			if(ioread32(ioaddr + TYPHOON_REG_STATUS) ==
+	if (wait_type != NoWait) {
+		for (i = 0; i < timeout; i++) {
+			if (ioread32(ioaddr + TYPHOON_REG_STATUS) ==
 			   TYPHOON_STATUS_WAITING_FOR_HOST)
 				goto out;
 
-			if(wait_type == WaitSleep)
+			if (wait_type == WaitSleep)
 				schedule_timeout_uninterruptible(1);
 			else
 				udelay(TYPHOON_UDELAY);
@@ -423,7 +423,7 @@ typhoon_reset(void __iomem *ioaddr, int wait_type)
 	 * which should be enough (I've see it work well at 100us, but still
 	 * saw occasional problems.)
 	 */
-	if(wait_type == WaitSleep)
+	if (wait_type == WaitSleep)
 		msleep(5);
 	else
 		udelay(500);
@@ -435,8 +435,8 @@ typhoon_wait_status(void __iomem *ioaddr, u32 wait_value)
 {
 	int i, err = 0;
 
-	for(i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
-		if(ioread32(ioaddr + TYPHOON_REG_STATUS) == wait_value)
+	for (i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
+		if (ioread32(ioaddr + TYPHOON_REG_STATUS) == wait_value)
 			goto out;
 		udelay(TYPHOON_UDELAY);
 	}
@@ -450,7 +450,7 @@ typhoon_wait_status(void __iomem *ioaddr, u32 wait_value)
 static inline void
 typhoon_media_status(struct net_device *dev, struct resp_desc *resp)
 {
-	if(resp->parm1 & TYPHOON_MEDIA_STAT_NO_LINK)
+	if (resp->parm1 & TYPHOON_MEDIA_STAT_NO_LINK)
 		netif_carrier_off(dev);
 	else
 		netif_carrier_on(dev);
@@ -466,7 +466,7 @@ typhoon_hello(struct typhoon *tp)
 	 * card in a long while. If the lock is held, then we're in the
 	 * process of issuing a command, so we don't need to respond.
 	 */
-	if(spin_trylock(&tp->command_lock)) {
+	if (spin_trylock(&tp->command_lock)) {
 		cmd = (struct cmd_desc *)(ring->ringBase + ring->lastWrite);
 		typhoon_inc_cmd_index(&ring->lastWrite, 1);
 
@@ -490,32 +490,32 @@ typhoon_process_response(struct typhoon *tp, int resp_size,
 
 	cleared = le32_to_cpu(indexes->respCleared);
 	ready = le32_to_cpu(indexes->respReady);
-	while(cleared != ready) {
+	while (cleared != ready) {
 		resp = (struct resp_desc *)(base + cleared);
 		count = resp->numDesc + 1;
-		if(resp_save && resp->seqNo) {
-			if(count > resp_size) {
+		if (resp_save && resp->seqNo) {
+			if (count > resp_size) {
 				resp_save->flags = TYPHOON_RESP_ERROR;
 				goto cleanup;
 			}
 
 			wrap_len = 0;
 			len = count * sizeof(*resp);
-			if(unlikely(cleared + len > RESPONSE_RING_SIZE)) {
+			if (unlikely(cleared + len > RESPONSE_RING_SIZE)) {
 				wrap_len = cleared + len - RESPONSE_RING_SIZE;
 				len = RESPONSE_RING_SIZE - cleared;
 			}
 
 			memcpy(resp_save, resp, len);
-			if(unlikely(wrap_len)) {
+			if (unlikely(wrap_len)) {
 				resp_save += len / sizeof(*resp);
 				memcpy(resp_save, base, wrap_len);
 			}
 
 			resp_save = NULL;
-		} else if(resp->cmd == TYPHOON_CMD_READ_MEDIA_STATUS) {
+		} else if (resp->cmd == TYPHOON_CMD_READ_MEDIA_STATUS) {
 			typhoon_media_status(tp->dev, resp);
-		} else if(resp->cmd == TYPHOON_CMD_HELLO_RESP) {
+		} else if (resp->cmd == TYPHOON_CMD_HELLO_RESP) {
 			typhoon_hello(tp);
 		} else {
 			netdev_err(tp->dev,
@@ -589,19 +589,19 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 	freeCmd = typhoon_num_free_cmd(tp);
 	freeResp = typhoon_num_free_resp(tp);
 
-	if(freeCmd < num_cmd || freeResp < num_resp) {
+	if (freeCmd < num_cmd || freeResp < num_resp) {
 		netdev_err(tp->dev, "no descs for cmd, had (needed) %d (%d) cmd, %d (%d) resp\n",
 			   freeCmd, num_cmd, freeResp, num_resp);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	if(cmd->flags & TYPHOON_CMD_RESPOND) {
+	if (cmd->flags & TYPHOON_CMD_RESPOND) {
 		/* If we're expecting a response, but the caller hasn't given
 		 * us a place to put it, we'll provide one.
 		 */
 		tp->awaiting_resp = 1;
-		if(resp == NULL) {
+		if (resp == NULL) {
 			resp = &local_resp;
 			num_resp = 1;
 		}
@@ -609,13 +609,13 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 
 	wrap_len = 0;
 	len = num_cmd * sizeof(*cmd);
-	if(unlikely(ring->lastWrite + len > COMMAND_RING_SIZE)) {
+	if (unlikely(ring->lastWrite + len > COMMAND_RING_SIZE)) {
 		wrap_len = ring->lastWrite + len - COMMAND_RING_SIZE;
 		len = COMMAND_RING_SIZE - ring->lastWrite;
 	}
 
 	memcpy(ring->ringBase + ring->lastWrite, cmd, len);
-	if(unlikely(wrap_len)) {
+	if (unlikely(wrap_len)) {
 		struct cmd_desc *wrap_ptr = cmd;
 		wrap_ptr += len / sizeof(*cmd);
 		memcpy(ring->ringBase, wrap_ptr, wrap_len);
@@ -629,7 +629,7 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 	iowrite32(ring->lastWrite, tp->ioaddr + TYPHOON_REG_CMD_READY);
 	typhoon_post_pci_writes(tp->ioaddr);
 
-	if((cmd->flags & TYPHOON_CMD_RESPOND) == 0)
+	if ((cmd->flags & TYPHOON_CMD_RESPOND) == 0)
 		goto out;
 
 	/* Ugh. We'll be here about 8ms, spinning our thumbs, unable to
@@ -649,14 +649,14 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 	 * wait here.
 	 */
 	got_resp = 0;
-	for(i = 0; i < TYPHOON_WAIT_TIMEOUT && !got_resp; i++) {
-		if(indexes->respCleared != indexes->respReady)
+	for (i = 0; i < TYPHOON_WAIT_TIMEOUT && !got_resp; i++) {
+		if (indexes->respCleared != indexes->respReady)
 			got_resp = typhoon_process_response(tp, num_resp,
 								resp);
 		udelay(TYPHOON_UDELAY);
 	}
 
-	if(!got_resp) {
+	if (!got_resp) {
 		err = -ETIMEDOUT;
 		goto out;
 	}
@@ -664,11 +664,11 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 	/* Collect the error response even if we don't care about the
 	 * rest of the response
 	 */
-	if(resp->flags & TYPHOON_RESP_ERROR)
+	if (resp->flags & TYPHOON_RESP_ERROR)
 		err = -EIO;
 
 out:
-	if(tp->awaiting_resp) {
+	if (tp->awaiting_resp) {
 		tp->awaiting_resp = 0;
 		smp_wmb();
 
@@ -679,7 +679,7 @@ typhoon_issue_command(struct typhoon *tp, int num_cmd, struct cmd_desc *cmd,
 		 * time. So, check for it, and interrupt ourselves if this
 		 * is the case.
 		 */
-		if(indexes->respCleared != indexes->respReady)
+		if (indexes->respCleared != indexes->respReady)
 			iowrite32(1, tp->ioaddr + TYPHOON_REG_SELF_INTERRUPT);
 	}
 
@@ -749,7 +749,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 	 * between marking the queue awake and updating the cleared index.
 	 * Just loop and it will appear. This comes from the acenic driver.
 	 */
-	while(unlikely(typhoon_num_free_tx(txRing) < (numDesc + 2)))
+	while (unlikely(typhoon_num_free_tx(txRing) < (numDesc + 2)))
 		smp_rmb();
 
 	first_txd = (struct tx_desc *) (txRing->ringBase + txRing->lastWrite);
@@ -761,7 +761,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 	first_txd->tx_addr = (u64)((unsigned long) skb);
 	first_txd->processFlags = 0;
 
-	if(skb->ip_summed == CHECKSUM_PARTIAL) {
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* The 3XP will figure out if this is UDP/TCP */
 		first_txd->processFlags |= TYPHOON_TX_PF_TCP_CHKSUM;
 		first_txd->processFlags |= TYPHOON_TX_PF_UDP_CHKSUM;
@@ -789,7 +789,7 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 	/* No need to worry about padding packet -- the firmware pads
 	 * it with zeros to ETH_ZLEN for us.
 	 */
-	if(skb_shinfo(skb)->nr_frags == 0) {
+	if (skb_shinfo(skb)->nr_frags == 0) {
 		skb_dma = pci_map_single(tp->tx_pdev, skb->data, skb->len,
 				       PCI_DMA_TODEVICE);
 		txd->flags = TYPHOON_FRAG_DESC | TYPHOON_DESC_VALID;
@@ -841,14 +841,14 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 	 */
 	numDesc = MAX_SKB_FRAGS + TSO_NUM_DESCRIPTORS + 1;
 
-	if(typhoon_num_free_tx(txRing) < (numDesc + 2)) {
+	if (typhoon_num_free_tx(txRing) < (numDesc + 2)) {
 		netif_stop_queue(dev);
 
 		/* A Tx complete IRQ could have gotten between, making
 		 * the ring free again. Only need to recheck here, since
 		 * Tx is serialized.
 		 */
-		if(typhoon_num_free_tx(txRing) >= (numDesc + 2))
+		if (typhoon_num_free_tx(txRing) >= (numDesc + 2))
 			netif_wake_queue(dev);
 	}
 
@@ -864,7 +864,7 @@ typhoon_set_rx_mode(struct net_device *dev)
 	__le16 filter;
 
 	filter = TYPHOON_RX_FILTER_DIRECTED | TYPHOON_RX_FILTER_BROADCAST;
-	if(dev->flags & IFF_PROMISC) {
+	if (dev->flags & IFF_PROMISC) {
 		filter |= TYPHOON_RX_FILTER_PROMISCOUS;
 	} else if ((netdev_mc_count(dev) > multicast_filter_limit) ||
 		  (dev->flags & IFF_ALLMULTI)) {
@@ -906,7 +906,7 @@ typhoon_do_get_stats(struct typhoon *tp)
 
 	INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_READ_STATS);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 7, xp_resp);
-	if(err < 0)
+	if (err < 0)
 		return err;
 
 	/* 3Com's Linux driver uses txMultipleCollisions as it's
@@ -954,10 +954,10 @@ typhoon_get_stats(struct net_device *dev)
 	struct net_device_stats *saved = &tp->stats_saved;
 
 	smp_rmb();
-	if(tp->card_state == Sleeping)
+	if (tp->card_state == Sleeping)
 		return saved;
 
-	if(typhoon_do_get_stats(tp) < 0) {
+	if (typhoon_do_get_stats(tp) < 0) {
 		netdev_err(dev, "error getting stats\n");
 		return saved;
 	}
@@ -974,12 +974,12 @@ typhoon_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 	struct resp_desc xp_resp[3];
 
 	smp_rmb();
-	if(tp->card_state == Sleeping) {
+	if (tp->card_state == Sleeping) {
 		strlcpy(info->fw_version, "Sleep image",
 			sizeof(info->fw_version));
 	} else {
 		INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_READ_VERSIONS);
-		if(typhoon_issue_command(tp, 1, &xp_cmd, 3, xp_resp) < 0) {
+		if (typhoon_issue_command(tp, 1, &xp_cmd, 3, xp_resp) < 0) {
 			strlcpy(info->fw_version, "Unknown runtime",
 				sizeof(info->fw_version));
 		} else {
@@ -1026,7 +1026,7 @@ typhoon_get_link_ksettings(struct net_device *dev,
 		break;
 	}
 
-	if(tp->capabilities & TYPHOON_FIBER) {
+	if (tp->capabilities & TYPHOON_FIBER) {
 		supported |= SUPPORTED_FIBRE;
 		advertising |= ADVERTISED_FIBRE;
 		cmd->base.port = PORT_FIBRE;
@@ -1043,7 +1043,7 @@ typhoon_get_link_ksettings(struct net_device *dev,
 	cmd->base.speed = tp->speed;
 	cmd->base.duplex = tp->duplex;
 	cmd->base.phy_address = 0;
-	if(tp->xcvr_select == TYPHOON_XCVR_AUTONEG)
+	if (tp->xcvr_select == TYPHOON_XCVR_AUTONEG)
 		cmd->base.autoneg = AUTONEG_ENABLE;
 	else
 		cmd->base.autoneg = AUTONEG_DISABLE;
@@ -1091,7 +1091,7 @@ typhoon_set_link_ksettings(struct net_device *dev,
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_XCVR_SELECT);
 	xp_cmd.parm1 = xcvr;
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto out;
 
 	tp->xcvr_select = xcvr;
@@ -1114,9 +1114,9 @@ typhoon_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 
 	wol->supported = WAKE_PHY | WAKE_MAGIC;
 	wol->wolopts = 0;
-	if(tp->wol_events & TYPHOON_WAKE_LINK_EVENT)
+	if (tp->wol_events & TYPHOON_WAKE_LINK_EVENT)
 		wol->wolopts |= WAKE_PHY;
-	if(tp->wol_events & TYPHOON_WAKE_MAGIC_PKT)
+	if (tp->wol_events & TYPHOON_WAKE_MAGIC_PKT)
 		wol->wolopts |= WAKE_MAGIC;
 	memset(&wol->sopass, 0, sizeof(wol->sopass));
 }
@@ -1126,13 +1126,13 @@ typhoon_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct typhoon *tp = netdev_priv(dev);
 
-	if(wol->wolopts & ~(WAKE_PHY | WAKE_MAGIC))
+	if (wol->wolopts & ~(WAKE_PHY | WAKE_MAGIC))
 		return -EINVAL;
 
 	tp->wol_events = 0;
-	if(wol->wolopts & WAKE_PHY)
+	if (wol->wolopts & WAKE_PHY)
 		tp->wol_events |= TYPHOON_WAKE_LINK_EVENT;
-	if(wol->wolopts & WAKE_MAGIC)
+	if (wol->wolopts & WAKE_MAGIC)
 		tp->wol_events |= TYPHOON_WAKE_MAGIC_PKT;
 
 	return 0;
@@ -1163,8 +1163,8 @@ typhoon_wait_interrupt(void __iomem *ioaddr)
 {
 	int i, err = 0;
 
-	for(i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
-		if(ioread32(ioaddr + TYPHOON_REG_INTR_STATUS) &
+	for (i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
+		if (ioread32(ioaddr + TYPHOON_REG_INTR_STATUS) &
 		   TYPHOON_INTR_BOOTCMD)
 			goto out;
 		udelay(TYPHOON_UDELAY);
@@ -1356,7 +1356,7 @@ typhoon_download_firmware(struct typhoon *tp)
 	 */
 	err = -ENOMEM;
 	dpage = pci_alloc_consistent(pdev, PAGE_SIZE, &dpage_dma);
-	if(!dpage) {
+	if (!dpage) {
 		netdev_err(tp->dev, "no DMA mem for firmware\n");
 		goto err_out;
 	}
@@ -1369,7 +1369,7 @@ typhoon_download_firmware(struct typhoon *tp)
 	       ioaddr + TYPHOON_REG_INTR_MASK);
 
 	err = -ETIMEDOUT;
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
 		netdev_err(tp->dev, "card ready timeout\n");
 		goto err_out_irq;
 	}
@@ -1398,16 +1398,16 @@ typhoon_download_firmware(struct typhoon *tp)
 	 * last write to the command register to post, so
 	 * we don't need a typhoon_post_pci_writes() after it.
 	 */
-	for(i = 0; i < numSections; i++) {
+	for (i = 0; i < numSections; i++) {
 		sHdr = (struct typhoon_section_header *) image_data;
 		image_data += sizeof(struct typhoon_section_header);
 		load_addr = le32_to_cpu(sHdr->startAddr);
 		section_len = le32_to_cpu(sHdr->len);
 
-		while(section_len) {
+		while (section_len) {
 			len = min_t(u32, section_len, PAGE_SIZE);
 
-			if(typhoon_wait_interrupt(ioaddr) < 0 ||
+			if (typhoon_wait_interrupt(ioaddr) < 0 ||
 			   ioread32(ioaddr + TYPHOON_REG_STATUS) !=
 			   TYPHOON_STATUS_WAITING_FOR_SEGMENT) {
 				netdev_err(tp->dev, "segment ready timeout\n");
@@ -1440,7 +1440,7 @@ typhoon_download_firmware(struct typhoon *tp)
 		}
 	}
 
-	if(typhoon_wait_interrupt(ioaddr) < 0 ||
+	if (typhoon_wait_interrupt(ioaddr) < 0 ||
 	   ioread32(ioaddr + TYPHOON_REG_STATUS) !=
 	   TYPHOON_STATUS_WAITING_FOR_SEGMENT) {
 		netdev_err(tp->dev, "final segment ready timeout\n");
@@ -1449,7 +1449,7 @@ typhoon_download_firmware(struct typhoon *tp)
 
 	iowrite32(TYPHOON_BOOTCMD_DNLD_COMPLETE, ioaddr + TYPHOON_REG_COMMAND);
 
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_BOOT) < 0) {
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_BOOT) < 0) {
 		netdev_err(tp->dev, "boot ready timeout, status 0x%0x\n",
 			   ioread32(ioaddr + TYPHOON_REG_STATUS));
 		goto err_out_irq;
@@ -1472,7 +1472,7 @@ typhoon_boot_3XP(struct typhoon *tp, u32 initial_status)
 {
 	void __iomem *ioaddr = tp->ioaddr;
 
-	if(typhoon_wait_status(ioaddr, initial_status) < 0) {
+	if (typhoon_wait_status(ioaddr, initial_status) < 0) {
 		netdev_err(tp->dev, "boot ready timeout\n");
 		goto out_timeout;
 	}
@@ -1483,7 +1483,7 @@ typhoon_boot_3XP(struct typhoon *tp, u32 initial_status)
 	iowrite32(TYPHOON_BOOTCMD_REG_BOOT_RECORD,
 				ioaddr + TYPHOON_REG_COMMAND);
 
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_RUNNING) < 0) {
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_RUNNING) < 0) {
 		netdev_err(tp->dev, "boot finish timeout (status 0x%x)\n",
 			   ioread32(ioaddr + TYPHOON_REG_STATUS));
 		goto out_timeout;
@@ -1513,17 +1513,17 @@ typhoon_clean_tx(struct typhoon *tp, struct transmit_ring *txRing,
 	int dma_len;
 	int type;
 
-	while(lastRead != le32_to_cpu(*index)) {
+	while (lastRead != le32_to_cpu(*index)) {
 		tx = (struct tx_desc *) (txRing->ringBase + lastRead);
 		type = tx->flags & TYPHOON_TYPE_MASK;
 
-		if(type == TYPHOON_TX_DESC) {
+		if (type == TYPHOON_TX_DESC) {
 			/* This tx_desc describes a packet.
 			 */
 			unsigned long ptr = tx->tx_addr;
 			struct sk_buff *skb = (struct sk_buff *) ptr;
 			dev_kfree_skb_irq(skb);
-		} else if(type == TYPHOON_FRAG_DESC) {
+		} else if (type == TYPHOON_FRAG_DESC) {
 			/* This tx_desc describes a memory mapping. Free it.
 			 */
 			skb_dma = (dma_addr_t) le32_to_cpu(tx->frag.addr);
@@ -1548,7 +1548,7 @@ typhoon_tx_complete(struct typhoon *tp, struct transmit_ring *txRing,
 
 	/* This will need changing if we start to use the Hi Tx ring. */
 	lastRead = typhoon_clean_tx(tp, txRing, index);
-	if(netif_queue_stopped(tp->dev) && typhoon_num_free(txRing->lastWrite,
+	if (netif_queue_stopped(tp->dev) && typhoon_num_free(txRing->lastWrite,
 				lastRead, TXLO_ENTRIES) > (numDesc + 2))
 		netif_wake_queue(tp->dev);
 
@@ -1564,7 +1564,7 @@ typhoon_recycle_rx_skb(struct typhoon *tp, u32 idx)
 	struct basic_ring *ring = &tp->rxBuffRing;
 	struct rx_free *r;
 
-	if((ring->lastWrite + sizeof(*r)) % (RXFREE_ENTRIES * sizeof(*r)) ==
+	if ((ring->lastWrite + sizeof(*r)) % (RXFREE_ENTRIES * sizeof(*r)) ==
 				le32_to_cpu(indexes->rxBuffCleared)) {
 		/* no room in ring, just drop the skb
 		 */
@@ -1595,12 +1595,12 @@ typhoon_alloc_rx_skb(struct typhoon *tp, u32 idx)
 
 	rxb->skb = NULL;
 
-	if((ring->lastWrite + sizeof(*r)) % (RXFREE_ENTRIES * sizeof(*r)) ==
+	if ((ring->lastWrite + sizeof(*r)) % (RXFREE_ENTRIES * sizeof(*r)) ==
 				le32_to_cpu(indexes->rxBuffCleared))
 		return -ENOMEM;
 
 	skb = netdev_alloc_skb(tp->dev, PKT_BUF_SZ);
-	if(!skb)
+	if (!skb)
 		return -ENOMEM;
 
 #if 0
@@ -1647,7 +1647,7 @@ typhoon_rx(struct typhoon *tp, struct basic_ring *rxRing, volatile __le32 * read
 	received = 0;
 	local_ready = le32_to_cpu(*ready);
 	rxaddr = le32_to_cpu(*cleared);
-	while(rxaddr != local_ready && budget > 0) {
+	while (rxaddr != local_ready && budget > 0) {
 		rx = (struct rx_desc *) (rxRing->ringBase + rxaddr);
 		idx = rx->addr;
 		rxb = &tp->rxbuffers[idx];
@@ -1656,14 +1656,14 @@ typhoon_rx(struct typhoon *tp, struct basic_ring *rxRing, volatile __le32 * read
 
 		typhoon_inc_rx_index(&rxaddr, 1);
 
-		if(rx->flags & TYPHOON_RX_ERROR) {
+		if (rx->flags & TYPHOON_RX_ERROR) {
 			typhoon_recycle_rx_skb(tp, idx);
 			continue;
 		}
 
 		pkt_len = le16_to_cpu(rx->frameLen);
 
-		if(pkt_len < rx_copybreak &&
+		if (pkt_len < rx_copybreak &&
 		   (new_skb = netdev_alloc_skb(tp->dev, pkt_len + 2)) != NULL) {
 			skb_reserve(new_skb, 2);
 			pci_dma_sync_single_for_cpu(tp->pdev, dma_addr,
@@ -1685,7 +1685,7 @@ typhoon_rx(struct typhoon *tp, struct basic_ring *rxRing, volatile __le32 * read
 		new_skb->protocol = eth_type_trans(new_skb, tp->dev);
 		csum_bits = rx->rxStatus & (TYPHOON_RX_IP_CHK_GOOD |
 			TYPHOON_RX_UDP_CHK_GOOD | TYPHOON_RX_TCP_CHK_GOOD);
-		if(csum_bits ==
+		if (csum_bits ==
 		   (TYPHOON_RX_IP_CHK_GOOD | TYPHOON_RX_TCP_CHK_GOOD) ||
 		   csum_bits ==
 		   (TYPHOON_RX_IP_CHK_GOOD | TYPHOON_RX_UDP_CHK_GOOD)) {
@@ -1711,11 +1711,11 @@ typhoon_fill_free_ring(struct typhoon *tp)
 {
 	u32 i;
 
-	for(i = 0; i < RXENT_ENTRIES; i++) {
+	for (i = 0; i < RXENT_ENTRIES; i++) {
 		struct rxbuff_ent *rxb = &tp->rxbuffers[i];
-		if(rxb->skb)
+		if (rxb->skb)
 			continue;
-		if(typhoon_alloc_rx_skb(tp, i) < 0)
+		if (typhoon_alloc_rx_skb(tp, i) < 0)
 			break;
 	}
 }
@@ -1728,25 +1728,25 @@ typhoon_poll(struct napi_struct *napi, int budget)
 	int work_done;
 
 	rmb();
-	if(!tp->awaiting_resp && indexes->respReady != indexes->respCleared)
+	if (!tp->awaiting_resp && indexes->respReady != indexes->respCleared)
 			typhoon_process_response(tp, 0, NULL);
 
-	if(le32_to_cpu(indexes->txLoCleared) != tp->txLoRing.lastRead)
+	if (le32_to_cpu(indexes->txLoCleared) != tp->txLoRing.lastRead)
 		typhoon_tx_complete(tp, &tp->txLoRing, &indexes->txLoCleared);
 
 	work_done = 0;
 
-	if(indexes->rxHiCleared != indexes->rxHiReady) {
+	if (indexes->rxHiCleared != indexes->rxHiReady) {
 		work_done += typhoon_rx(tp, &tp->rxHiRing, &indexes->rxHiReady,
 			   		&indexes->rxHiCleared, budget);
 	}
 
-	if(indexes->rxLoCleared != indexes->rxLoReady) {
+	if (indexes->rxLoCleared != indexes->rxLoReady) {
 		work_done += typhoon_rx(tp, &tp->rxLoRing, &indexes->rxLoReady,
 					&indexes->rxLoCleared, budget - work_done);
 	}
 
-	if(le32_to_cpu(indexes->rxBuffCleared) == tp->rxBuffRing.lastWrite) {
+	if (le32_to_cpu(indexes->rxBuffCleared) == tp->rxBuffRing.lastWrite) {
 		/* rxBuff ring is empty, try to fill it. */
 		typhoon_fill_free_ring(tp);
 	}
@@ -1770,7 +1770,7 @@ typhoon_interrupt(int irq, void *dev_instance)
 	u32 intr_status;
 
 	intr_status = ioread32(ioaddr + TYPHOON_REG_INTR_STATUS);
-	if(!(intr_status & TYPHOON_INTR_HOST_INT))
+	if (!(intr_status & TYPHOON_INTR_HOST_INT))
 		return IRQ_NONE;
 
 	iowrite32(intr_status, ioaddr + TYPHOON_REG_INTR_STATUS);
@@ -1790,9 +1790,9 @@ typhoon_free_rx_rings(struct typhoon *tp)
 {
 	u32 i;
 
-	for(i = 0; i < RXENT_ENTRIES; i++) {
+	for (i = 0; i < RXENT_ENTRIES; i++) {
 		struct rxbuff_ent *rxb = &tp->rxbuffers[i];
-		if(rxb->skb) {
+		if (rxb->skb) {
 			pci_unmap_single(tp->pdev, rxb->dma_addr, PKT_BUF_SZ,
 				       PCI_DMA_FROMDEVICE);
 			dev_kfree_skb(rxb->skb);
@@ -1812,7 +1812,7 @@ typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
 	INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_ENABLE_WAKE_EVENTS);
 	xp_cmd.parm1 = events;
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0) {
+	if (err < 0) {
 		netdev_err(tp->dev, "typhoon_sleep(): wake events cmd err %d\n",
 			   err);
 		return err;
@@ -1820,12 +1820,12 @@ typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_GOTO_SLEEP);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0) {
+	if (err < 0) {
 		netdev_err(tp->dev, "typhoon_sleep(): sleep cmd err %d\n", err);
 		return err;
 	}
 
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_SLEEPING) < 0)
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_SLEEPING) < 0)
 		return -ETIMEDOUT;
 
 	/* Since we cannot monitor the status of the link while sleeping,
@@ -1852,7 +1852,7 @@ typhoon_wakeup(struct typhoon *tp, int wait_type)
 	 * the old firmware pay for the reset.
 	 */
 	iowrite32(TYPHOON_BOOTCMD_WAKEUP, ioaddr + TYPHOON_REG_COMMAND);
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_HOST) < 0 ||
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_WAITING_FOR_HOST) < 0 ||
 			(tp->capabilities & TYPHOON_WAKEUP_NEEDS_RESET))
 		return typhoon_reset(ioaddr, wait_type);
 
@@ -1871,12 +1871,12 @@ typhoon_start_runtime(struct typhoon *tp)
 	typhoon_fill_free_ring(tp);
 
 	err = typhoon_download_firmware(tp);
-	if(err < 0) {
+	if (err < 0) {
 		netdev_err(tp->dev, "cannot load runtime on 3XP\n");
 		goto error_out;
 	}
 
-	if(typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_BOOT) < 0) {
+	if (typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_BOOT) < 0) {
 		netdev_err(tp->dev, "cannot boot 3XP\n");
 		err = -EIO;
 		goto error_out;
@@ -1885,14 +1885,14 @@ typhoon_start_runtime(struct typhoon *tp)
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_MAX_PKT_SIZE);
 	xp_cmd.parm1 = cpu_to_le16(PKT_BUF_SZ);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_MAC_ADDRESS);
 	xp_cmd.parm1 = cpu_to_le16(ntohs(*(__be16 *)&dev->dev_addr[0]));
 	xp_cmd.parm2 = cpu_to_le32(ntohl(*(__be32 *)&dev->dev_addr[2]));
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	/* Disable IRQ coalescing -- we can reenable it when 3Com gives
@@ -1901,38 +1901,38 @@ typhoon_start_runtime(struct typhoon *tp)
 	INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_IRQ_COALESCE_CTRL);
 	xp_cmd.parm1 = 0;
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_XCVR_SELECT);
 	xp_cmd.parm1 = tp->xcvr_select;
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_VLAN_TYPE_WRITE);
 	xp_cmd.parm1 = cpu_to_le16(ETH_P_8021Q);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_OFFLOAD_TASKS);
 	xp_cmd.parm2 = tp->offload;
 	xp_cmd.parm3 = tp->offload;
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	typhoon_set_rx_mode(dev);
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_TX_ENABLE);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	INIT_COMMAND_WITH_RESPONSE(&xp_cmd, TYPHOON_CMD_RX_ENABLE);
 	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
-	if(err < 0)
+	if (err < 0)
 		goto error_out;
 
 	tp->card_state = Running;
@@ -1972,13 +1972,13 @@ typhoon_stop_runtime(struct typhoon *tp, int wait_type)
 	/* Wait 1/2 sec for any outstanding transmits to occur
 	 * We'll cleanup after the reset if this times out.
 	 */
-	for(i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
-		if(indexes->txLoCleared == cpu_to_le32(txLo->lastWrite))
+	for (i = 0; i < TYPHOON_WAIT_TIMEOUT; i++) {
+		if (indexes->txLoCleared == cpu_to_le32(txLo->lastWrite))
 			break;
 		udelay(TYPHOON_UDELAY);
 	}
 
-	if(i == TYPHOON_WAIT_TIMEOUT)
+	if (i == TYPHOON_WAIT_TIMEOUT)
 		netdev_err(tp->dev, "halt timed out waiting for Tx to complete\n");
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_TX_DISABLE);
@@ -1995,16 +1995,16 @@ typhoon_stop_runtime(struct typhoon *tp, int wait_type)
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_HALT);
 	typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
 
-	if(typhoon_wait_status(ioaddr, TYPHOON_STATUS_HALTED) < 0)
+	if (typhoon_wait_status(ioaddr, TYPHOON_STATUS_HALTED) < 0)
 		netdev_err(tp->dev, "timed out waiting for 3XP to halt\n");
 
-	if(typhoon_reset(ioaddr, wait_type) < 0) {
+	if (typhoon_reset(ioaddr, wait_type) < 0) {
 		netdev_err(tp->dev, "unable to reset 3XP\n");
 		return -ETIMEDOUT;
 	}
 
 	/* cleanup any outstanding Tx packets */
-	if(indexes->txLoCleared != cpu_to_le32(txLo->lastWrite)) {
+	if (indexes->txLoCleared != cpu_to_le32(txLo->lastWrite)) {
 		indexes->txLoCleared = cpu_to_le32(txLo->lastWrite);
 		typhoon_clean_tx(tp, &tp->txLoRing, &indexes->txLoCleared);
 	}
@@ -2017,7 +2017,7 @@ typhoon_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct typhoon *tp = netdev_priv(dev);
 
-	if(typhoon_reset(tp->ioaddr, WaitNoSleep) < 0) {
+	if (typhoon_reset(tp->ioaddr, WaitNoSleep) < 0) {
 		netdev_warn(dev, "could not reset in tx timeout\n");
 		goto truly_dead;
 	}
@@ -2026,7 +2026,7 @@ typhoon_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	typhoon_clean_tx(tp, &tp->txLoRing, &tp->indexes->txLoCleared);
 	typhoon_free_rx_rings(tp);
 
-	if(typhoon_start_runtime(tp) < 0) {
+	if (typhoon_start_runtime(tp) < 0) {
 		netdev_err(dev, "could not start runtime in tx timeout\n");
 		goto truly_dead;
         }
@@ -2051,20 +2051,20 @@ typhoon_open(struct net_device *dev)
 		goto out;
 
 	err = typhoon_wakeup(tp, WaitSleep);
-	if(err < 0) {
+	if (err < 0) {
 		netdev_err(dev, "unable to wakeup device\n");
 		goto out_sleep;
 	}
 
 	err = request_irq(dev->irq, typhoon_interrupt, IRQF_SHARED,
 				dev->name, dev);
-	if(err < 0)
+	if (err < 0)
 		goto out_sleep;
 
 	napi_enable(&tp->napi);
 
 	err = typhoon_start_runtime(tp);
-	if(err < 0) {
+	if (err < 0) {
 		napi_disable(&tp->napi);
 		goto out_irq;
 	}
@@ -2076,13 +2076,13 @@ typhoon_open(struct net_device *dev)
 	free_irq(dev->irq, dev);
 
 out_sleep:
-	if(typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
+	if (typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
 		netdev_err(dev, "unable to reboot into sleep img\n");
 		typhoon_reset(tp->ioaddr, NoWait);
 		goto out;
 	}
 
-	if(typhoon_sleep(tp, PCI_D3hot, 0) < 0)
+	if (typhoon_sleep(tp, PCI_D3hot, 0) < 0)
 		netdev_err(dev, "unable to go back to sleep\n");
 
 out:
@@ -2097,7 +2097,7 @@ typhoon_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	napi_disable(&tp->napi);
 
-	if(typhoon_stop_runtime(tp, WaitSleep) < 0)
+	if (typhoon_stop_runtime(tp, WaitSleep) < 0)
 		netdev_err(dev, "unable to stop runtime\n");
 
 	/* Make sure there is no irq handler running on a different CPU. */
@@ -2106,10 +2106,10 @@ typhoon_close(struct net_device *dev)
 	typhoon_free_rx_rings(tp);
 	typhoon_init_rings(tp);
 
-	if(typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0)
+	if (typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0)
 		netdev_err(dev, "unable to boot sleep image\n");
 
-	if(typhoon_sleep(tp, PCI_D3hot, 0) < 0)
+	if (typhoon_sleep(tp, PCI_D3hot, 0) < 0)
 		netdev_err(dev, "unable to put card to sleep\n");
 
 	return 0;
@@ -2124,15 +2124,15 @@ typhoon_resume(struct pci_dev *pdev)
 
 	/* If we're down, resume when we are upped.
 	 */
-	if(!netif_running(dev))
+	if (!netif_running(dev))
 		return 0;
 
-	if(typhoon_wakeup(tp, WaitNoSleep) < 0) {
+	if (typhoon_wakeup(tp, WaitNoSleep) < 0) {
 		netdev_err(dev, "critical: could not wake up in resume\n");
 		goto reset;
 	}
 
-	if(typhoon_start_runtime(tp) < 0) {
+	if (typhoon_start_runtime(tp) < 0) {
 		netdev_err(dev, "critical: could not start runtime in resume\n");
 		goto reset;
 	}
@@ -2154,16 +2154,16 @@ typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	/* If we're down, we're already suspended.
 	 */
-	if(!netif_running(dev))
+	if (!netif_running(dev))
 		return 0;
 
 	/* TYPHOON_OFFLOAD_VLAN is always on now, so this doesn't work */
-	if(tp->wol_events & TYPHOON_WAKE_MAGIC_PKT)
+	if (tp->wol_events & TYPHOON_WAKE_MAGIC_PKT)
 		netdev_warn(dev, "cannot do WAKE_MAGIC with VLAN offloading\n");
 
 	netif_device_detach(dev);
 
-	if(typhoon_stop_runtime(tp, WaitNoSleep) < 0) {
+	if (typhoon_stop_runtime(tp, WaitNoSleep) < 0) {
 		netdev_err(dev, "unable to stop runtime\n");
 		goto need_resume;
 	}
@@ -2171,7 +2171,7 @@ typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
 	typhoon_free_rx_rings(tp);
 	typhoon_init_rings(tp);
 
-	if(typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
+	if (typhoon_boot_3XP(tp, TYPHOON_STATUS_WAITING_FOR_HOST) < 0) {
 		netdev_err(dev, "unable to boot sleep image\n");
 		goto need_resume;
 	}
@@ -2179,19 +2179,19 @@ typhoon_suspend(struct pci_dev *pdev, pm_message_t state)
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_MAC_ADDRESS);
 	xp_cmd.parm1 = cpu_to_le16(ntohs(*(__be16 *)&dev->dev_addr[0]));
 	xp_cmd.parm2 = cpu_to_le32(ntohl(*(__be32 *)&dev->dev_addr[2]));
-	if(typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL) < 0) {
+	if (typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL) < 0) {
 		netdev_err(dev, "unable to set mac address in suspend\n");
 		goto need_resume;
 	}
 
 	INIT_COMMAND_NO_RESPONSE(&xp_cmd, TYPHOON_CMD_SET_RX_FILTER);
 	xp_cmd.parm1 = TYPHOON_RX_FILTER_DIRECTED | TYPHOON_RX_FILTER_BROADCAST;
-	if(typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL) < 0) {
+	if (typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL) < 0) {
 		netdev_err(dev, "unable to set rx filter in suspend\n");
 		goto need_resume;
 	}
 
-	if(typhoon_sleep(tp, pci_choose_state(pdev, state), tp->wol_events) < 0) {
+	if (typhoon_sleep(tp, pci_choose_state(pdev, state), tp->wol_events) < 0) {
 		netdev_err(dev, "unable to put card to sleep\n");
 		goto need_resume;
 	}
@@ -2211,10 +2211,10 @@ typhoon_test_mmio(struct pci_dev *pdev)
 	int mode = 0;
 	u32 val;
 
-	if(!ioaddr)
+	if (!ioaddr)
 		goto out;
 
-	if(ioread32(ioaddr + TYPHOON_REG_STATUS) !=
+	if (ioread32(ioaddr + TYPHOON_REG_STATUS) !=
 				TYPHOON_STATUS_WAITING_FOR_HOST)
 		goto out_unmap;
 
@@ -2227,12 +2227,12 @@ typhoon_test_mmio(struct pci_dev *pdev)
 	 * The 50usec delay is arbitrary -- it could probably be smaller.
 	 */
 	val = ioread32(ioaddr + TYPHOON_REG_INTR_STATUS);
-	if((val & TYPHOON_INTR_SELF) == 0) {
+	if ((val & TYPHOON_INTR_SELF) == 0) {
 		iowrite32(1, ioaddr + TYPHOON_REG_SELF_INTERRUPT);
 		ioread32(ioaddr + TYPHOON_REG_INTR_STATUS);
 		udelay(50);
 		val = ioread32(ioaddr + TYPHOON_REG_INTR_STATUS);
-		if(val & TYPHOON_INTR_SELF)
+		if (val & TYPHOON_INTR_SELF)
 			mode = 1;
 	}
 
@@ -2245,7 +2245,7 @@ typhoon_test_mmio(struct pci_dev *pdev)
 	pci_iounmap(pdev, ioaddr);
 
 out:
-	if(!mode)
+	if (!mode)
 		pr_info("%s: falling back to port IO\n", pci_name(pdev));
 	return mode;
 }
@@ -2276,7 +2276,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	const char *err_msg;
 
 	dev = alloc_etherdev(sizeof(*tp));
-	if(dev == NULL) {
+	if (dev == NULL) {
 		err_msg = "unable to alloc new net device";
 		err = -ENOMEM;
 		goto error_out;
@@ -2284,55 +2284,55 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	err = pci_enable_device(pdev);
-	if(err < 0) {
+	if (err < 0) {
 		err_msg = "unable to enable device";
 		goto error_out_dev;
 	}
 
 	err = pci_set_mwi(pdev);
-	if(err < 0) {
+	if (err < 0) {
 		err_msg = "unable to set MWI";
 		goto error_out_disable;
 	}
 
 	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	if(err < 0) {
+	if (err < 0) {
 		err_msg = "No usable DMA configuration";
 		goto error_out_mwi;
 	}
 
 	/* sanity checks on IO and MMIO BARs
 	 */
-	if(!(pci_resource_flags(pdev, 0) & IORESOURCE_IO)) {
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_IO)) {
 		err_msg = "region #1 not a PCI IO resource, aborting";
 		err = -ENODEV;
 		goto error_out_mwi;
 	}
-	if(pci_resource_len(pdev, 0) < 128) {
+	if (pci_resource_len(pdev, 0) < 128) {
 		err_msg = "Invalid PCI IO region size, aborting";
 		err = -ENODEV;
 		goto error_out_mwi;
 	}
-	if(!(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
+	if (!(pci_resource_flags(pdev, 1) & IORESOURCE_MEM)) {
 		err_msg = "region #1 not a PCI MMIO resource, aborting";
 		err = -ENODEV;
 		goto error_out_mwi;
 	}
-	if(pci_resource_len(pdev, 1) < 128) {
+	if (pci_resource_len(pdev, 1) < 128) {
 		err_msg = "Invalid PCI MMIO region size, aborting";
 		err = -ENODEV;
 		goto error_out_mwi;
 	}
 
 	err = pci_request_regions(pdev, KBUILD_MODNAME);
-	if(err < 0) {
+	if (err < 0) {
 		err_msg = "could not request regions";
 		goto error_out_mwi;
 	}
 
 	/* map our registers
 	 */
-	if(use_mmio != 0 && use_mmio != 1)
+	if (use_mmio != 0 && use_mmio != 1)
 		use_mmio = typhoon_test_mmio(pdev);
 
 	ioaddr = pci_iomap(pdev, use_mmio, 128);
@@ -2346,7 +2346,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	shared = pci_alloc_consistent(pdev, sizeof(struct typhoon_shared),
 				      &shared_dma);
-	if(!shared) {
+	if (!shared) {
 		err_msg = "could not allocate DMA memory";
 		err = -ENOMEM;
 		goto error_out_remap;
@@ -2426,7 +2426,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * seem to need a little extra help to get started. Since we don't
 	 * know how to nudge it along, just kick it.
 	 */
-	if(xp_resp[0].numDesc != 0)
+	if (xp_resp[0].numDesc != 0)
 		tp->capabilities |= TYPHOON_WAKEUP_NEEDS_RESET;
 
 	err = typhoon_sleep(tp, PCI_D3hot, 0);
@@ -2471,14 +2471,14 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* xp_resp still contains the response to the READ_VERSIONS command.
 	 * For debugging, let the user know what version he has.
 	 */
-	if(xp_resp[0].numDesc == 0) {
+	if (xp_resp[0].numDesc == 0) {
 		/* This is the Typhoon 1.0 type Sleep Image, last 16 bits
 		 * of version is Month/Day of build.
 		 */
 		u16 monthday = le32_to_cpu(xp_resp[0].parm2) & 0xffff;
 		netdev_info(dev, "Typhoon 1.0 Sleep Image built %02u/%02u/2000\n",
 			    monthday >> 8, monthday & 0xff);
-	} else if(xp_resp[0].numDesc == 2) {
+	} else if (xp_resp[0].numDesc == 2) {
 		/* This is the Typhoon 1.1+ type Sleep Image
 		 */
 		u32 sleep_ver = le32_to_cpu(xp_resp[0].parm2);
diff --git a/drivers/net/ethernet/3com/typhoon.h b/drivers/net/ethernet/3com/typhoon.h
index 88187fc84aa3..2f634c64d5d1 100644
--- a/drivers/net/ethernet/3com/typhoon.h
+++ b/drivers/net/ethernet/3com/typhoon.h
@@ -366,7 +366,7 @@ struct resp_desc {
 		memset(_ptr, 0, sizeof(struct cmd_desc));		\
 		_ptr->flags = TYPHOON_CMD_DESC | TYPHOON_DESC_VALID;	\
 		_ptr->cmd = command;					\
-	} while(0)
+	} while (0)
 
 /* We set seqNo to 1 if we're expecting a response from this command */
 #define INIT_COMMAND_WITH_RESPONSE(x, command)				\
@@ -376,7 +376,7 @@ struct resp_desc {
 		_ptr->flags |= TYPHOON_DESC_VALID; 			\
 		_ptr->cmd = command;					\
 		_ptr->seqNo = 1;					\
-	} while(0)
+	} while (0)
 
 /* TYPHOON_CMD_SET_RX_FILTER filter bits (cmd.parm1)
  */
-- 
2.25.2

