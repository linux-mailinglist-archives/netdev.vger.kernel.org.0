Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049DC158C3E
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgBKJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:58:29 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43746 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbgBKJ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 04:58:28 -0500
Received: by mail-pl1-f196.google.com with SMTP id p11so4061906plq.10;
        Tue, 11 Feb 2020 01:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oDYnBEZd/3hdA6X4VhVRHbAjKUJ0MDM6lOD9+y++Vi8=;
        b=fA41pMH6FdB/1PGQtZQzCGkt96Ei5uG2O/lVjt//Fm5Ng2iifnWjjMi9jNE+eB375m
         vX/uZSggKkD4XQvbcLhD+y+8ma+UdcEX9eQG+WyhaNUOW0e7kSTJZj2JQ8Hm8qWo6pYj
         9wGePWgwZdRUQJj8HKgYA7exeXRjqk2B/Xt1fEW35icDbXJ0HMIOW/qibEPaYbwJLSoE
         15dt+QAC+Nncv9WkV0AsVnmE9EvCXYCPqNwWN7q2VHkAbLYvqjXsx7Vk7Bz69Jso/6Tq
         n4hiNacCoFXNWKslg2OyJFHsehYN3a5fmvocMHANDyvvMSS6UBk69xle4cFymxMDgh3t
         e6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oDYnBEZd/3hdA6X4VhVRHbAjKUJ0MDM6lOD9+y++Vi8=;
        b=ZIwwEyXNBkfk5jMdKCW+kkj9On83xE4SK9c7JZna4FVylsjWzBKzd8Z14mE31glg6M
         gEhCdlUmn1ZFyythEpkiWYJ1y39audAhxo7AQ1YUxsbu24sX9bldhBpjxGgpdte1XiU4
         Rl/eyLqFPXPZkxLOg193OMS4sfi8msFgZ9tQPYuL8Aa/5GtLIzRnbHKjlEHLBB1NcbLw
         f3BGOxlCZL/RcCcFohUNu/3Lyrs9fr/H386+X4xvFatZuQoukyWTE5ba34hSNGCH/1P6
         x2hc8tVWuvW1hEsPM4vaKQavo2btHyVmdPmZ/bfoBX8QBFc35V9aXEPBuOhlKVjcWB6B
         zEpw==
X-Gm-Message-State: APjAAAW4LN/JsUQ4agI8+4eWWDKkP/wIILxFegVYcIzekAs3Ro47SmhV
        lKSBQsQM/s4QOK8U2Sbi+Ro=
X-Google-Smtp-Source: APXvYqwU7yw+DMuQQI3h3Pr9SWIYNE3F+EBWzEQayilJdAFS2ekO7jN9BPSrTSW3DqZ560SJMtABjA==
X-Received: by 2002:a17:902:8bc3:: with SMTP id r3mr17713048plo.220.1581415107634;
        Tue, 11 Feb 2020 01:58:27 -0800 (PST)
Received: from localhost.localdomain ([27.59.175.249])
        by smtp.googlemail.com with ESMTPSA id i2sm2351854pjs.21.2020.02.11.01.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 01:58:27 -0800 (PST)
From:   Mohana Datta Yelugoti <ymdatta.work@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     ymdatta.work@gmail.com, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_main.c: fix style issues
Date:   Tue, 11 Feb 2020 15:28:13 +0530
Message-Id: <20200211095813.11426-1-ymdatta.work@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <ymdatta.work@gmail.com>
References: <ymdatta.work@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: Missing a blank line after
declarations" generated from checkpatch.pl by adding
a blank line after declarations.

Signed-off-by: Mohana Datta Yelugoti <ymdatta.work@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 86b9b7314a40..c712e1af90de 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -143,6 +143,7 @@ static int ql_sem_trylock(struct ql_adapter *qdev, u32 sem_mask)
 int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
 {
 	unsigned int wait_count = 30;
+
 	do {
 		if (!ql_sem_trylock(qdev, sem_mask))
 			return 0;
@@ -1210,6 +1211,7 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 			  struct tx_ring_desc *tx_ring_desc, int mapped)
 {
 	int i;
+
 	for (i = 0; i < mapped; i++) {
 		if (i == 0 || (i == 7 && mapped > 7)) {
 			/*
@@ -1290,6 +1292,7 @@ static int ql_map_send(struct ql_adapter *qdev,
 	 */
 	for (frag_idx = 0; frag_idx < frag_cnt; frag_idx++, map_idx++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_idx];
+
 		tbd++;
 		if (frag_idx == 6 && frag_cnt > 7) {
 			/* Let's tack on an sglist.
@@ -1649,6 +1652,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *) skb->data;
+
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1818,6 +1822,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		 *          eventually be in trouble.
 		 */
 		int size, i = 0;
+
 		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		pci_unmap_single(qdev->pdev, sbq_desc->dma_addr,
 				 SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
@@ -1936,6 +1941,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 		/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *) skb->data;
+
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2391,6 +2397,7 @@ static void qlge_restore_vlan(struct ql_adapter *qdev)
 static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
 	struct rx_ring *rx_ring = dev_id;
+
 	napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
 }
@@ -2497,6 +2504,7 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_LSO;
 		if (likely(l3_proto == htons(ETH_P_IP))) {
 			struct iphdr *iph = ip_hdr(skb);
+
 			iph->check = 0;
 			mac_iocb_ptr->flags1 |= OB_MAC_TSO_IOCB_IP4;
 			tcp_hdr(skb)->check = ~csum_tcpudp_magic(iph->saddr,
@@ -2521,6 +2529,7 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 	int len;
 	struct iphdr *iph = ip_hdr(skb);
 	__sum16 *check;
+
 	mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
 	mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
 	mac_iocb_ptr->net_trans_offset =
@@ -4265,6 +4274,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	ql_queue_asic_error(qdev);
 }
 
@@ -4273,6 +4283,7 @@ static void ql_asic_reset_work(struct work_struct *work)
 	struct ql_adapter *qdev =
 	    container_of(work, struct ql_adapter, asic_reset_work.work);
 	int status;
+
 	rtnl_lock();
 	status = ql_adapter_down(qdev);
 	if (status)
@@ -4344,6 +4355,7 @@ static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
 static int ql_get_board_info(struct ql_adapter *qdev)
 {
 	int status;
+
 	qdev->func =
 	    (ql_read32(qdev, STS) & STS_FUNC_ID_MASK) >> STS_FUNC_ID_SHIFT;
 	if (qdev->func > 3)
@@ -4652,6 +4664,7 @@ static void qlge_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	del_timer_sync(&qdev->timer);
 	ql_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
-- 
2.17.1

