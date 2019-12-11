Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4311BB7F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfLKSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:17:16 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46570 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730723AbfLKSPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:11 -0500
Received: by mail-yb1-f194.google.com with SMTP id v15so9365300ybp.13;
        Wed, 11 Dec 2019 10:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MtEWtxJnG7S8oz7nqSCzQW+Oc5y9HSkM4LHKA9BlAd8=;
        b=SZxlyakLoDY64LbkteZAkrFCGlvhLBaVPZfUZ+M9Fe9j5N698Xl9DqRqRCJRUHLEQN
         czZwVke0hN27h6340KG/b9Id/Pp3pFC24M8irkT0Zugc4Oa8Ymazu7OHAWu6tLINGn5L
         AzXW8yX31PjQAUoBZZZVLHcE6XEFjORx4Eh65E3+B/KuNQrQ4VW2GwCDulkLvxQpw2Sr
         +ZLM6LE4f4DYRAmNOLwWpL+7HIiA6d0Mo13nAB6cd5aDZUy2SX+xFtQOowlERujQlQ7O
         rFFTf8MvlO9tbKXPf6VzxZlO7pm+FYphBdikJScelpphCZ9FQVXgg8hwu+HReCXrg2/y
         bUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MtEWtxJnG7S8oz7nqSCzQW+Oc5y9HSkM4LHKA9BlAd8=;
        b=SF4EUwCRsUsT0IYmwgM3ufyGVSQEccZZ1o9WPBua6dlTgk7pWH3vtffhA2fiuKxX62
         yqal1tdNsp0xtZiuBxMlav+ULsSAzkcKswKhuj/dUoj9xx8zRUrVZx7UFmatgkGKhR0K
         TH/LXC2EB2SeCIvalInVd6VrJaumx1y2mU4qbV8gQJeF08cZNZ0E4fgYk3+84+0c2h3k
         Wr5u/7LVuZmuYFIbF5xuA2Cn8jVKJrw3dgyHxWzAuWsAENfgsE/gvpHp6PG8rHUxixwI
         nAYA+TK9srB2Kyd8M3bXb05+6epone5qf3Nii/Zz3DWuJwGBLuHQiLXfI0IR/deBsy8q
         3OwA==
X-Gm-Message-State: APjAAAWqTSZIyrI4Mf2xffnK83MxsjyZJVQVptQfUehWU6hFnLtPeYQd
        0HVM8wB4v4isDj7U5bnSs/SRs1irVCKJqg==
X-Google-Smtp-Source: APXvYqyYaAEmhRuIXfPi49uSmKIeH9mBg1AY9/NWnhxB/gguuu66pVmg5Q/T3RA6Dg5SiHBEm41YSg==
X-Received: by 2002:a25:d1d0:: with SMTP id i199mr921717ybg.131.1576088110103;
        Wed, 11 Dec 2019 10:15:10 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id p62sm1262686ywb.98.2019.12.11.10.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:09 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/23] staging: qlge: Fix WARNING: Missing a blank line after declarations
Date:   Wed, 11 Dec 2019 12:12:33 -0600
Message-Id: <815a27ebb89b7a08e616fddbe0583eabd3c4401b.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: Missing a blank line after declarations in the following
files:
qlge.h
qlge_dbg.c
qlge_main.c
qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h      |  2 +-
 drivers/staging/qlge/qlge_dbg.c  | 10 +++++-----
 drivers/staging/qlge/qlge_main.c | 26 +++++++++++++-------------
 drivers/staging/qlge/qlge_mpi.c  | 12 ++++++------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 89502a8300f6..d45c53a053c2 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2227,7 +2227,7 @@ static inline void ql_write_db_reg_relaxed(u32 val, void __iomem *addr)
 static inline u32 ql_read_sh_reg(__le32  *addr)
 {
 	u32 reg;
-	
+
 	reg =  le32_to_cpu(*addr);
 	rmb();
 	return reg;
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index cbca38c602bc..71fce1f850c7 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -499,7 +499,7 @@ static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
 			   u32 offset, u32 count)
 {
 	int i, status = 0;
-	
+
 	for (i = 0; i < count; i++, buf++) {
 		status = ql_read_mpi_reg(qdev, offset + i, buf);
 		if (status)
@@ -1353,7 +1353,7 @@ static void ql_dump_intr_states(struct ql_adapter *qdev)
 {
 	int i;
 	u32 value;
-	
+
 	for (i = 0; i < qdev->intr_count; i++) {
 		ql_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
 		value = ql_read32(qdev, INTR_EN);
@@ -1439,7 +1439,7 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 {
 	int i;
 	u32 value;
-	
+
 	i = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (i)
 		return;
@@ -1590,7 +1590,7 @@ void ql_dump_stat(struct ql_adapter *qdev)
 void ql_dump_qdev(struct ql_adapter *qdev)
 {
 	int i;
-	
+
 	DUMP_QDEV_FIELD(qdev, "%lx", flags);
 	DUMP_QDEV_FIELD(qdev, "%p", vlgrp);
 	DUMP_QDEV_FIELD(qdev, "%p", pdev);
@@ -1676,7 +1676,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 void ql_dump_ricb(struct ricb *ricb)
 {
 	int i;
-	
+
 	pr_err("===================== Dumping ricb ===============\n");
 	pr_err("Dumping ricb stuff...\n");
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 80c0fb4746d5..34786e2c0247 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -143,7 +143,7 @@ static int ql_sem_trylock(struct ql_adapter *qdev, u32 sem_mask)
 int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
 {
 	unsigned int wait_count = 30;
-	
+
 	do {
 		if (!ql_sem_trylock(qdev, sem_mask))
 			return 0;
@@ -1211,7 +1211,7 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 			  struct tx_ring_desc *tx_ring_desc, int mapped)
 {
 	int i;
-	
+
 	for (i = 0; i < mapped; i++) {
 		if (i == 0 || (i == 7 && mapped > 7)) {
 			/*
@@ -1292,7 +1292,7 @@ static int ql_map_send(struct ql_adapter *qdev,
 	 */
 	for (frag_idx = 0; frag_idx < frag_cnt; frag_idx++, map_idx++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_idx];
-		
+
 		tbd++;
 		if (frag_idx == 6 && frag_cnt > 7) {
 			/* Let's tack on an sglist.
@@ -1652,7 +1652,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *) skb->data;
-			
+
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -1822,7 +1822,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		 *          eventually be in trouble.
 		 */
 		int size, i = 0;
-		
+
 		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		pci_unmap_single(qdev->pdev, sbq_desc->dma_addr,
 				 SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
@@ -1941,7 +1941,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 		/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *) skb->data;
-			
+
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2397,7 +2397,7 @@ static void qlge_restore_vlan(struct ql_adapter *qdev)
 static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
 	struct rx_ring *rx_ring = dev_id;
-	
+
 	napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
 }
@@ -2504,7 +2504,7 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_LSO;
 		if (likely(l3_proto == htons(ETH_P_IP))) {
 			struct iphdr *iph = ip_hdr(skb);
-			
+
 			iph->check = 0;
 			mac_iocb_ptr->flags1 |= OB_MAC_TSO_IOCB_IP4;
 			tcp_hdr(skb)->check = ~csum_tcpudp_magic(iph->saddr,
@@ -2529,7 +2529,7 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 	int len;
 	struct iphdr *iph = ip_hdr(skb);
 	__sum16 *check;
-	
+
 	mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
 	mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
 	mac_iocb_ptr->net_trans_offset =
@@ -4274,7 +4274,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 static void qlge_tx_timeout(struct net_device *ndev)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
-	
+
 	ql_queue_asic_error(qdev);
 }
 
@@ -4283,7 +4283,7 @@ static void ql_asic_reset_work(struct work_struct *work)
 	struct ql_adapter *qdev =
 	    container_of(work, struct ql_adapter, asic_reset_work.work);
 	int status;
-	
+
 	rtnl_lock();
 	status = ql_adapter_down(qdev);
 	if (status)
@@ -4355,7 +4355,7 @@ static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
 static int ql_get_board_info(struct ql_adapter *qdev)
 {
 	int status;
-	
+
 	qdev->func =
 	    (ql_read32(qdev, STS) & STS_FUNC_ID_MASK) >> STS_FUNC_ID_SHIFT;
 	if (qdev->func > 3)
@@ -4664,7 +4664,7 @@ static void qlge_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
 	struct ql_adapter *qdev = netdev_priv(ndev);
-	
+
 	del_timer_sync(&qdev->timer);
 	ql_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index ecd72f4fcdd5..22ebd6cb8525 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -91,7 +91,7 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
 int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
 {
 	int status;
-	
+
 	status = ql_write_mpi_reg(qdev, 0x00001010, 1);
 	return status;
 }
@@ -238,7 +238,7 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 {
 	int status;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
-	
+
 	mbcp->out_count = 4;
 	status = ql_get_mb_sts(qdev, mbcp);
 	if (status) {
@@ -257,7 +257,7 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
-	
+
 	mbcp->out_count = 2;
 
 	status = ql_get_mb_sts(qdev, mbcp);
@@ -356,7 +356,7 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
 	else {
 		int i;
-		
+
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN detected.\n");
 		for (i = 0; i < mbcp->out_count; i++)
 			netif_err(qdev, drv, qdev->ndev, "mbox_out[%d] = 0x%.08x.\n",
@@ -916,7 +916,7 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 	int status = -ETIMEDOUT;
 	long wait_time = 1 * HZ;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
-	
+
 	do {
 		/* Wait here for the command to complete
 		 * via the IDC process.
@@ -1101,7 +1101,7 @@ int ql_wait_fifo_empty(struct ql_adapter *qdev)
 static int ql_set_port_cfg(struct ql_adapter *qdev)
 {
 	int status;
-	
+
 	status = ql_mb_set_port_cfg(qdev);
 	if (status)
 		return status;
-- 
2.20.1

