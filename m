Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9987E11A0BB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLKBse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:48:34 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40101 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfLKBsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:48:32 -0500
Received: by mail-yb1-f195.google.com with SMTP id n3so8417990ybm.7;
        Tue, 10 Dec 2019 17:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cU58sZ4sbQAKiWOd5v6f8T+jWWHbsFeiJQ7ohI9LuSQ=;
        b=HDaePdt0sEGHcwEjOCq1ZoQS9mNwbsVtyBRN3oH9GZnFg5f0yYhugnkGtOFu17dlFu
         fZE72HIlVGtucMeLQqor56q0IyNgi67VKP+dWeWrLhZfZpGcfGjQjYulKWnVtkpurha3
         1Q3UMG1T245qlrmwAERd1DpaNZ8lNBjDsrlQAymp5KXARRTs7o5FhoONfDSJIn7cg94H
         Oty01hMZpu+3Y9o0YdYD4yFGsejHiNOTcbgsTsGHbumP8OUi/HtifWO5scbQ1aOUnam6
         22HjzG3OsTvK8xcCVDeWbErAUh/eFGqV1Znw88KwukmzWJrzG32PnAEql8nSMQJWtx+p
         6Sbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cU58sZ4sbQAKiWOd5v6f8T+jWWHbsFeiJQ7ohI9LuSQ=;
        b=f7dtZGf/Jc+tAZDzz9OhFkaGje82uvjRTFgd2pxu7g0gq8Xw0JGk3w0yXdMet0lBeT
         ba3sN5cGPWMItKiJ8KYrXStL0yXkBt8+UWE1otw/14m0jBywYu0v7pwxXpq75hBDLD2Y
         q90q8d2ZbopTSHwud5I/ghgAqAd9v2FT7qZRvESLUm5djEOjFLBWCjcrtRNYdQRMCJUt
         LcLpDiOiRH102SX89O8NqD2IeYUcG8juU0s1uBVR1igTQ9AhGpgUADwVqmj6NWiER7xT
         4P0V4n0KCfgttNk331DPviEJCfUwImpDoD4clmNfa8d5k+UFcQD4jLPzx+6wuUyULTet
         3eYw==
X-Gm-Message-State: APjAAAV7nB0Xt5WYMG3rq2TP1BBQ6EQhNzcOHpPlHCQLJ1ucc2lmDBw0
        H1YH97qT/ezVdkr/9W7E9R1Ja/c803dkgg==
X-Google-Smtp-Source: APXvYqzJOGxX6koMNg1ErzGXUSGB/Nfj2ICGyHIdoY5aYc56b6kyohsAxwSSOVy47bnz/wK5t4VcQw==
X-Received: by 2002:a5b:806:: with SMTP id x6mr872789ybp.273.1576028909698;
        Tue, 10 Dec 2019 17:48:29 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:686c:487d:5a96:6c85])
        by smtp.gmail.com with ESMTPSA id g5sm232571ywk.46.2019.12.10.17.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 17:48:29 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: Fix multiple WARNING and CHECK relating to formatting
Date:   Tue, 10 Dec 2019 19:47:59 -0600
Message-Id: <20191211014759.4749-1-schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CHECK: Please don't use multiple blank lines
CHECK: Blank lines aren't necessary before a close brace '}'
CHECK: Blank lines aren't necessary after an open brace '{'
WARNING: Missing a blank line after declarations
CHECK: No space is necessary after a cast
CHECK: braces {} should be used on all arms of this statement
CHECK: Unbalanced braces around else statement
WARNING: please, no space before tabs
CHECK: spaces preferred around that '/' (ctx:VxV)
CHECK: spaces preferred around that '+' (ctx:VxV)
CHECK: spaces preferred around that '%' (ctx:VxV)
CHECK: spaces preferred around that '|' (ctx:VxV)
CHECK: spaces preferred around that '*' (ctx:VxV)
WARNING: Unnecessary space before function pointer arguments
WARNING: please, no spaces at the start of a line
WARNING: Block comments use a trailing */ on a separate line
ERROR: trailing whitespace

In files qlge.h, qlge_dbg.c, qlge_ethtool.c, qlge_main.c, and qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h         |  45 ++++++-------
 drivers/staging/qlge/qlge_dbg.c     |  41 ++++++-----
 drivers/staging/qlge/qlge_ethtool.c |  20 ++++--
 drivers/staging/qlge/qlge_main.c    | 101 ++++++++++++++--------------
 drivers/staging/qlge/qlge_mpi.c     |  37 +++++-----
 5 files changed, 125 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 57884aac308f..b64ab54f01c2 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -16,8 +16,8 @@
 /*
  * General definitions...
  */
-#define DRV_NAME  	"qlge"
-#define DRV_STRING 	"QLogic 10 Gigabit PCI-E Ethernet Driver "
+#define DRV_NAME	"qlge"
+#define DRV_STRING	"QLogic 10 Gigabit PCI-E Ethernet Driver "
 #define DRV_VERSION	"1.00.00.35"
 
 #define WQ_ADDR_ALIGN	0x3	/* 4 byte alignment */
@@ -59,11 +59,10 @@
 #define MAX_CQ 128
 #define DFLT_COALESCE_WAIT 100	/* 100 usec wait for coalescing */
 #define MAX_INTER_FRAME_WAIT 10	/* 10 usec max interframe-wait for coalescing */
-#define DFLT_INTER_FRAME_WAIT (MAX_INTER_FRAME_WAIT/2)
+#define DFLT_INTER_FRAME_WAIT (MAX_INTER_FRAME_WAIT / 2)
 #define UDELAY_COUNT 3
 #define UDELAY_DELAY 100
 
-
 #define TX_DESC_PER_IOCB 8
 
 #if ((MAX_SKB_FRAGS - TX_DESC_PER_IOCB) + 2) > 0
@@ -120,7 +119,6 @@ enum {
  * Processor Address Register (PROC_ADDR) bit definitions.
  */
 enum {
-
 	/* Misc. stuff */
 	MAILBOX_COUNT = 16,
 	MAILBOX_TIMEOUT = 5,
@@ -1078,11 +1076,11 @@ struct tx_buf_desc {
  * IOCB Definitions...
  */
 
-#define OPCODE_OB_MAC_IOCB 			0x01
+#define OPCODE_OB_MAC_IOCB		0x01
 #define OPCODE_OB_MAC_TSO_IOCB		0x02
-#define OPCODE_IB_MAC_IOCB			0x20
-#define OPCODE_IB_MPI_IOCB			0x21
-#define OPCODE_IB_AE_IOCB			0x3f
+#define OPCODE_IB_MAC_IOCB		0x20
+#define OPCODE_IB_MPI_IOCB		0x21
+#define OPCODE_IB_AE_IOCB		0x3f
 
 struct ob_mac_iocb_req {
 	u8 opcode;
@@ -1174,15 +1172,15 @@ struct ib_mac_iocb_rsp {
 	u8 flags1;
 #define IB_MAC_IOCB_RSP_OI	0x01	/* Override intr delay */
 #define IB_MAC_IOCB_RSP_I	0x02	/* Disable Intr Generation */
-#define IB_MAC_CSUM_ERR_MASK 0x1c	/* A mask to use for csum errs */
+#define IB_MAC_CSUM_ERR_MASK	0x1c	/* A mask to use for csum errs */
 #define IB_MAC_IOCB_RSP_TE	0x04	/* Checksum error */
 #define IB_MAC_IOCB_RSP_NU	0x08	/* No checksum rcvd */
 #define IB_MAC_IOCB_RSP_IE	0x10	/* IPv4 checksum error */
 #define IB_MAC_IOCB_RSP_M_MASK	0x60	/* Multicast info */
 #define IB_MAC_IOCB_RSP_M_NONE	0x00	/* Not mcast frame */
 #define IB_MAC_IOCB_RSP_M_HASH	0x20	/* HASH mcast frame */
-#define IB_MAC_IOCB_RSP_M_REG 	0x40	/* Registered mcast frame */
-#define IB_MAC_IOCB_RSP_M_PROM 	0x60	/* Promiscuous mcast frame */
+#define IB_MAC_IOCB_RSP_M_REG	0x40	/* Registered mcast frame */
+#define IB_MAC_IOCB_RSP_M_PROM	0x60	/* Promiscuous mcast frame */
 #define IB_MAC_IOCB_RSP_B	0x80	/* Broadcast frame */
 	u8 flags2;
 #define IB_MAC_IOCB_RSP_P	0x01	/* Promiscuous frame */
@@ -1202,8 +1200,8 @@ struct ib_mac_iocb_rsp {
 #define IB_MAC_IOCB_RSP_M_NONE	0x00	/* No RSS match */
 #define IB_MAC_IOCB_RSP_M_IPV4	0x04	/* IPv4 RSS match */
 #define IB_MAC_IOCB_RSP_M_IPV6	0x02	/* IPv6 RSS match */
-#define IB_MAC_IOCB_RSP_M_TCP_V4 	0x05	/* TCP with IPv4 */
-#define IB_MAC_IOCB_RSP_M_TCP_V6 	0x03	/* TCP with IPv6 */
+#define IB_MAC_IOCB_RSP_M_TCP_V4	0x05	/* TCP with IPv4 */
+#define IB_MAC_IOCB_RSP_M_TCP_V6	0x03	/* TCP with IPv6 */
 #define IB_MAC_IOCB_RSP_V4	0x08	/* IPV4 */
 #define IB_MAC_IOCB_RSP_V6	0x10	/* IPV6 */
 #define IB_MAC_IOCB_RSP_IH	0x20	/* Split after IP header */
@@ -1240,10 +1238,10 @@ struct ib_ae_iocb_rsp {
 #define SOFT_ECC_ERROR_EVENT       0x07
 #define MGMT_ERR_EVENT             0x08
 #define TEN_GIG_MAC_EVENT          0x09
-#define GPI0_H2L_EVENT       	0x10
-#define GPI0_L2H_EVENT       	0x20
-#define GPI1_H2L_EVENT       	0x11
-#define GPI1_L2H_EVENT       	0x21
+#define GPI0_H2L_EVENT		0x10
+#define GPI0_L2H_EVENT		0x20
+#define GPI1_H2L_EVENT		0x11
+#define GPI1_L2H_EVENT		0x21
 #define PCI_ERR_ANON_BUF_RD        0x40
 	u8 q_id;
 	__le32 reserved[15];
@@ -1368,7 +1366,7 @@ struct tx_ring_desc {
 	struct tx_ring_desc *next;
 };
 
-#define QL_TXQ_IDX(qdev, skb) (smp_processor_id()%(qdev->tx_ring_count))
+#define QL_TXQ_IDX(qdev, skb) (smp_processor_id() % (qdev->tx_ring_count))
 
 struct tx_ring {
 	/*
@@ -1763,7 +1761,6 @@ struct ql_nic_misc {
 };
 
 struct ql_reg_dump {
-
 	/* segment 0 */
 	struct mpi_coredump_global_header mpi_global_header;
 
@@ -1793,7 +1790,7 @@ struct ql_reg_dump {
 
 	/* segment 34 */
 	struct mpi_coredump_segment_header ets_seg_hdr;
-	u32 ets[8+2];
+	u32 ets[8 + 2];
 };
 
 struct ql_mpi_coredump {
@@ -2060,9 +2057,8 @@ enum {
 };
 
 struct nic_operations {
-
-	int (*get_flash) (struct ql_adapter *);
-	int (*port_initialize) (struct ql_adapter *);
+	int (*get_flash)(struct ql_adapter *);
+	int (*port_initialize)(struct ql_adapter *);
 };
 
 /*
@@ -2228,6 +2224,7 @@ static inline void ql_write_db_reg_relaxed(u32 val, void __iomem *addr)
 static inline u32 ql_read_sh_reg(__le32  *addr)
 {
 	u32 reg;
+
 	reg =  le32_to_cpu(*addr);
 	rmb();
 	return reg;
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index aac20db565fa..1ec045a97ba4 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -142,7 +142,6 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	u32 *direct_ptr, temp;
 	u32 *indirect_ptr;
 
-
 	/* The XAUI needs to be read out per port */
 	status = ql_read_other_func_serdes_reg(qdev,
 			XG_SERDES_XAUI_HSS_PCS_START, &temp);
@@ -297,7 +296,6 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
 				   xfi_direct_valid, xfi_indirect_valid);
 
-
 	/* Get XAUI_XFI_HSS_PLL register block. */
 	if (qdev->func & 1) {
 		direct_ptr =
@@ -499,6 +497,7 @@ static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
 			   u32 offset, u32 count)
 {
 	int i, status = 0;
+
 	for (i = 0; i < count; i++, buf++) {
 		status = ql_read_mpi_reg(qdev, offset + i, buf);
 		if (status)
@@ -552,7 +551,6 @@ static int ql_get_probe_dump(struct ql_adapter *qdev, unsigned int *buf)
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_FC_CLOCK,
 			   PRB_MX_ADDR_VALID_FC_MOD, buf);
 	return 0;
-
 }
 
 /* Read out the routing index registers */
@@ -610,7 +608,6 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 
 	for (type = 0; type < MAC_ADDR_TYPE_COUNT; type++) {
 		switch (type) {
-
 		case 0: /* CAM */
 			initial_val |= MAC_ADDR_ADR;
 			max_index = MAC_ADDR_MAX_CAM_ENTRIES;
@@ -1204,7 +1201,6 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 err:
 	ql_sem_unlock(qdev, SEM_PROC_REG_MASK); /* does flush too */
 	return status;
-
 }
 
 static void ql_get_core_dump(struct ql_adapter *qdev)
@@ -1227,7 +1223,6 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 {
 	int i, status;
 
-
 	memset(&(mpi_coredump->mpi_global_header), 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
@@ -1238,7 +1233,6 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
 		sizeof(mpi_coredump->mpi_global_header.id_string));
 
-
 	/* segment 16 */
 	ql_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
 				     MISC_NIC_INFO_SEG_NUM,
@@ -1354,6 +1348,7 @@ static void ql_dump_intr_states(struct ql_adapter *qdev)
 {
 	int i;
 	u32 value;
+
 	for (i = 0; i < qdev->intr_count; i++) {
 		ql_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
 		value = ql_read32(qdev, INTR_EN);
@@ -1439,6 +1434,7 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 {
 	int i;
 	u32 value;
+
 	i = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (i)
 		return;
@@ -1589,6 +1585,7 @@ void ql_dump_stat(struct ql_adapter *qdev)
 void ql_dump_qdev(struct ql_adapter *qdev)
 {
 	int i;
+
 	DUMP_QDEV_FIELD(qdev, "%lx", flags);
 	DUMP_QDEV_FIELD(qdev, "%p", vlgrp);
 	DUMP_QDEV_FIELD(qdev, "%p", pdev);
@@ -1642,9 +1639,9 @@ void ql_dump_wqicb(struct wqicb *wqicb)
 	       le16_to_cpu(wqicb->cq_id_rss));
 	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
 	pr_err("wqicb->wq_addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(wqicb->addr));
+	       (unsigned long long)le64_to_cpu(wqicb->addr));
 	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(wqicb->cnsmr_idx_addr));
+	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
 }
 
 void ql_dump_tx_ring(struct tx_ring *tx_ring)
@@ -1655,7 +1652,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 	       tx_ring->wq_id);
 	pr_err("tx_ring->base = %p\n", tx_ring->wq_base);
 	pr_err("tx_ring->base_dma = 0x%llx\n",
-	       (unsigned long long) tx_ring->wq_base_dma);
+	       (unsigned long long)tx_ring->wq_base_dma);
 	pr_err("tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
 	       tx_ring->cnsmr_idx_sh_reg,
 	       tx_ring->cnsmr_idx_sh_reg
@@ -1674,6 +1671,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 void ql_dump_ricb(struct ricb *ricb)
 {
 	int i;
+
 	pr_err("===================== Dumping ricb ===============\n");
 	pr_err("Dumping ricb stuff...\n");
 
@@ -1708,21 +1706,21 @@ void ql_dump_cqicb(struct cqicb *cqicb)
 	pr_err("cqicb->flags = %x\n", cqicb->flags);
 	pr_err("cqicb->len = %d\n", le16_to_cpu(cqicb->len));
 	pr_err("cqicb->addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(cqicb->addr));
+	       (unsigned long long)le64_to_cpu(cqicb->addr));
 	pr_err("cqicb->prod_idx_addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(cqicb->prod_idx_addr));
+	       (unsigned long long)le64_to_cpu(cqicb->prod_idx_addr));
 	pr_err("cqicb->pkt_delay = 0x%.04x\n",
 	       le16_to_cpu(cqicb->pkt_delay));
 	pr_err("cqicb->irq_delay = 0x%.04x\n",
 	       le16_to_cpu(cqicb->irq_delay));
 	pr_err("cqicb->lbq_addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(cqicb->lbq_addr));
+	       (unsigned long long)le64_to_cpu(cqicb->lbq_addr));
 	pr_err("cqicb->lbq_buf_size = 0x%.04x\n",
 	       le16_to_cpu(cqicb->lbq_buf_size));
 	pr_err("cqicb->lbq_len = 0x%.04x\n",
 	       le16_to_cpu(cqicb->lbq_len));
 	pr_err("cqicb->sbq_addr = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(cqicb->sbq_addr));
+	       (unsigned long long)le64_to_cpu(cqicb->sbq_addr));
 	pr_err("cqicb->sbq_buf_size = 0x%.04x\n",
 	       le16_to_cpu(cqicb->sbq_buf_size));
 	pr_err("cqicb->sbq_len = 0x%.04x\n",
@@ -1750,7 +1748,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->cqicb = %p\n", &rx_ring->cqicb);
 	pr_err("rx_ring->cq_base = %p\n", rx_ring->cq_base);
 	pr_err("rx_ring->cq_base_dma = %llx\n",
-	       (unsigned long long) rx_ring->cq_base_dma);
+	       (unsigned long long)rx_ring->cq_base_dma);
 	pr_err("rx_ring->cq_size = %d\n", rx_ring->cq_size);
 	pr_err("rx_ring->cq_len = %d\n", rx_ring->cq_len);
 	pr_err("rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
@@ -1758,7 +1756,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	       rx_ring->prod_idx_sh_reg
 			? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
 	pr_err("rx_ring->prod_idx_sh_reg_dma = %llx\n",
-	       (unsigned long long) rx_ring->prod_idx_sh_reg_dma);
+	       (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
 	pr_err("rx_ring->cnsmr_idx_db_reg = %p\n",
 	       rx_ring->cnsmr_idx_db_reg);
 	pr_err("rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
@@ -1835,7 +1833,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 {
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
@@ -1843,7 +1841,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 	       tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
@@ -1851,13 +1849,12 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 	       tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
 	       tbd->len & TX_DESC_C ? "C" : ".",
 	       tbd->len & TX_DESC_E ? "E" : ".");
-
 }
 
 void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
@@ -1982,7 +1979,7 @@ void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 	pr_err("data_len	= %d\n",
 	       le32_to_cpu(ib_mac_rsp->data_len));
 	pr_err("data_addr    = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(ib_mac_rsp->data_addr));
+	       (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
 	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
 		pr_err("rss    = %x\n",
 		       le32_to_cpu(ib_mac_rsp->rss));
@@ -1999,7 +1996,7 @@ void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 		pr_err("hdr length	= %d\n",
 		       le32_to_cpu(ib_mac_rsp->hdr_len));
 		pr_err("hdr addr    = 0x%llx\n",
-		       (unsigned long long) le64_to_cpu(ib_mac_rsp->hdr_addr));
+		       (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
 	}
 }
 #endif
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index ea7bc6f2dde2..72cac987ffdf 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -32,7 +32,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 
-
 #include "qlge.h"
 
 struct ql_stats {
@@ -179,6 +178,7 @@ static const struct ql_stats ql_gstrings_stats[] = {
 static const char ql_gstrings_test[][ETH_GSTRING_LEN] = {
 	"Loopback test  (offline)"
 };
+
 #define QLGE_TEST_LEN (sizeof(ql_gstrings_test) / ETH_GSTRING_LEN)
 #define QLGE_STATS_LEN ARRAY_SIZE(ql_gstrings_stats)
 #define QLGE_RCV_MAC_ERR_STATS	7
@@ -262,8 +262,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -276,8 +277,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -293,8 +295,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -307,8 +310,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 				  "Error reading status register 0x%.04x.\n",
 				  i);
 			goto end;
-		} else
+		} else {
 			*iter = data;
+		}
 		iter++;
 	}
 
@@ -319,8 +323,9 @@ static void ql_update_stats(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Error reading status register 0x%.04x.\n", i);
 		goto end;
-	} else
+	} else {
 		*iter = data;
+	}
 end:
 	ql_sem_unlock(qdev, qdev->xg_sem_mask);
 quit:
@@ -491,8 +496,9 @@ static int ql_start_loopback(struct ql_adapter *qdev)
 	if (netif_carrier_ok(qdev->ndev)) {
 		set_bit(QL_LB_LINK_UP, &qdev->flags);
 		netif_carrier_off(qdev->ndev);
-	} else
+	} else {
 		clear_bit(QL_LB_LINK_UP, &qdev->flags);
+	}
 	qdev->link_config |= CFG_LOOPBACK_PCS;
 	return ql_mb_set_port_cfg(qdev);
 }
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 29861f01ca26..16484c95963f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -52,16 +52,16 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 static const u32 default_msg =
-    NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
+	NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK |
 /* NETIF_MSG_TIMER |	*/
-    NETIF_MSG_IFDOWN |
-    NETIF_MSG_IFUP |
-    NETIF_MSG_RX_ERR |
-    NETIF_MSG_TX_ERR |
+	NETIF_MSG_IFDOWN |
+	NETIF_MSG_IFUP |
+	NETIF_MSG_RX_ERR |
+	NETIF_MSG_TX_ERR |
 /*  NETIF_MSG_TX_QUEUED | */
 /*  NETIF_MSG_INTR | NETIF_MSG_TX_DONE | NETIF_MSG_RX_STATUS | */
-/* NETIF_MSG_PKTDATA | */
-    NETIF_MSG_HW | NETIF_MSG_WOL | 0;
+/*  NETIF_MSG_PKTDATA | */
+	NETIF_MSG_HW | NETIF_MSG_WOL | 0;
 
 static int debug = -1;	/* defaults above */
 module_param(debug, int, 0664);
@@ -145,6 +145,7 @@ static int ql_sem_trylock(struct ql_adapter *qdev, u32 sem_mask)
 int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
 {
 	unsigned int wait_count = 30;
+
 	do {
 		if (!ql_sem_trylock(qdev, sem_mask))
 			return 0;
@@ -207,7 +208,6 @@ static int ql_wait_cfg(struct ql_adapter *qdev, u32 bit)
 	return -ETIMEDOUT;
 }
 
-
 /* Used to issue init control blocks to hw. Maps control block,
  * sets address, triggers download, waits for completion.
  */
@@ -241,8 +241,8 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 		goto exit;
 	}
 
-	ql_write32(qdev, ICB_L, (u32) map);
-	ql_write32(qdev, ICB_H, (u32) (map >> 32));
+	ql_write32(qdev, ICB_L, (u32)map);
+	ql_write32(qdev, ICB_H, (u32)(map >> 32));
 
 	mask = CFG_Q_MASK | (bit << 16);
 	value = bit | (q_id << CFG_Q_SHIFT);
@@ -417,7 +417,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		}
 	case MAC_ADDR_TYPE_VLAN:
 		{
-			u32 enable_bit = *((u32 *) &addr[0]);
+			u32 enable_bit = *((u32 *)&addr[0]);
 			/* For VLAN, the addr actually holds a bit that
 			 * either enables or disables the vlan id we are
 			 * addressing. It's either MAC_ADDR_E on or off.
@@ -467,7 +467,7 @@ static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
 	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *) addr,
+	status = ql_set_mac_addr_reg(qdev, (u8 *)addr,
 			MAC_ADDR_TYPE_CAM_MAC, qdev->func * MAX_CQ);
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
@@ -713,7 +713,7 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 
 	size = sizeof(struct flash_params_8000) / sizeof(u32);
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -775,13 +775,12 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 		return -ETIMEDOUT;
 
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i+offset, p);
+		status = ql_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
 			goto exit;
 		}
-
 	}
 
 	status = ql_validate_flash(qdev,
@@ -866,7 +865,7 @@ int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data)
 	if (status)
 		goto exit;
 
-	*data = (u64) lo | ((u64) hi << 32);
+	*data = (u64)lo | ((u64)hi << 32);
 
 exit:
 	return status;
@@ -1216,6 +1215,7 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 			  struct tx_ring_desc *tx_ring_desc, int mapped)
 {
 	int i;
+
 	for (i = 0; i < mapped; i++) {
 		if (i == 0 || (i == 7 && mapped > 7)) {
 			/*
@@ -1248,7 +1248,6 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 						     maplen), PCI_DMA_TODEVICE);
 		}
 	}
-
 }
 
 /* Map the buffers for this transmit.  This will return
@@ -1296,6 +1295,7 @@ static int ql_map_send(struct ql_adapter *qdev,
 	 */
 	for (frag_idx = 0; frag_idx < frag_cnt; frag_idx++, map_idx++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_idx];
+
 		tbd++;
 		if (frag_idx == 6 && frag_cnt > 7) {
 			/* Let's tack on an sglist.
@@ -1361,7 +1361,6 @@ static int ql_map_send(struct ql_adapter *qdev,
 		dma_unmap_addr_set(&tx_ring_desc->map[map_idx], mapaddr, map);
 		dma_unmap_len_set(&tx_ring_desc->map[map_idx], maplen,
 				  skb_frag_size(frag));
-
 	}
 	/* Save the number of segments we've mapped. */
 	tx_ring_desc->map_cnt = map_idx;
@@ -1553,7 +1552,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 			struct iphdr *iph =
 				(struct iphdr *)((u8 *)addr + hlen);
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1658,9 +1657,10 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
-			struct iphdr *iph = (struct iphdr *) skb->data;
+			struct iphdr *iph = (struct iphdr *)skb->data;
+
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1830,6 +1830,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		 *          eventually be in trouble.
 		 */
 		int size, i = 0;
+
 		sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 		pci_unmap_single(qdev->pdev, sbq_desc->dma_addr,
 				 SMALL_BUF_MAP_SIZE, PCI_DMA_FROMDEVICE);
@@ -1948,9 +1949,10 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 		/* Unfragmented ipv4 UDP frame. */
-			struct iphdr *iph = (struct iphdr *) skb->data;
+			struct iphdr *iph = (struct iphdr *)skb->data;
+
 			if (!(iph->frag_off &
-				htons(IP_MF|IP_OFFSET))) {
+				htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 					     "TCP checksum done!\n");
@@ -2129,7 +2131,6 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 	struct tx_ring *tx_ring;
 	/* While there are entries in the completion queue. */
 	while (prod != rx_ring->cnsmr_idx) {
-
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
 			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
@@ -2137,7 +2138,6 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 		net_rsp = (struct ob_mac_iocb_rsp *)rx_ring->curr_entry;
 		rmb();
 		switch (net_rsp->opcode) {
-
 		case OPCODE_OB_MAC_TSO_IOCB:
 		case OPCODE_OB_MAC_IOCB:
 			ql_process_mac_tx_intr(qdev, net_rsp);
@@ -2176,7 +2176,6 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 
 	/* While there are entries in the completion queue. */
 	while (prod != rx_ring->cnsmr_idx) {
-
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
 			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
@@ -2328,7 +2327,7 @@ static int __qlge_vlan_rx_add_vid(struct ql_adapter *qdev, u16 vid)
 	u32 enable_bit = MAC_ADDR_E;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *) &enable_bit,
+	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
 				  MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
@@ -2359,7 +2358,7 @@ static int __qlge_vlan_rx_kill_vid(struct ql_adapter *qdev, u16 vid)
 	u32 enable_bit = 0;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *) &enable_bit,
+	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
 				  MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
@@ -2404,6 +2403,7 @@ static void qlge_restore_vlan(struct ql_adapter *qdev)
 static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 {
 	struct rx_ring *rx_ring = dev_id;
+
 	napi_schedule(&rx_ring->napi);
 	return IRQ_HANDLED;
 }
@@ -2488,7 +2488,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 
 static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 {
-
 	if (skb_is_gso(skb)) {
 		int err;
 		__be16 l3_proto = vlan_get_protocol(skb);
@@ -2499,7 +2498,7 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 
 		mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
 		mac_iocb_ptr->flags3 |= OB_MAC_TSO_IOCB_IC;
-		mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
+		mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 		mac_iocb_ptr->total_hdrs_len =
 		    cpu_to_le16(skb_transport_offset(skb) + tcp_hdrlen(skb));
 		mac_iocb_ptr->net_trans_offset =
@@ -2510,6 +2509,7 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_LSO;
 		if (likely(l3_proto == htons(ETH_P_IP))) {
 			struct iphdr *iph = ip_hdr(skb);
+
 			iph->check = 0;
 			mac_iocb_ptr->flags1 |= OB_MAC_TSO_IOCB_IP4;
 			tcp_hdr(skb)->check = ~csum_tcpudp_magic(iph->saddr,
@@ -2534,8 +2534,9 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 	int len;
 	struct iphdr *iph = ip_hdr(skb);
 	__sum16 *check;
+
 	mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
-	mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
+	mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 	mac_iocb_ptr->net_trans_offset =
 		cpu_to_le16(skb_network_offset(skb) |
 		skb_transport_offset(skb) << OB_MAC_TRANSPORT_HDR_SHIFT);
@@ -2566,7 +2567,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	struct ql_adapter *qdev = netdev_priv(ndev);
 	int tso;
 	struct tx_ring *tx_ring;
-	u32 tx_ring_idx = (u32) skb->queue_mapping;
+	u32 tx_ring_idx = (u32)skb->queue_mapping;
 
 	tx_ring = &qdev->tx_ring[tx_ring_idx];
 
@@ -2593,7 +2594,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	mac_iocb_ptr->txq_idx = tx_ring_idx;
 	tx_ring_desc->skb = skb;
 
-	mac_iocb_ptr->frame_len = cpu_to_le16((u16) skb->len);
+	mac_iocb_ptr->frame_len = cpu_to_le16((u16)skb->len);
 
 	if (skb_vlan_tag_present(skb)) {
 		netif_printk(qdev, tx_queued, KERN_DEBUG, qdev->ndev,
@@ -2641,7 +2642,6 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-
 static void ql_free_shadow_space(struct ql_adapter *qdev)
 {
 	if (qdev->rx_ring_shadow_reg_area) {
@@ -2894,7 +2894,6 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 				 struct rx_ring *rx_ring)
 {
-
 	/*
 	 * Allocate the completion queue for this rx_ring.
 	 */
@@ -3017,7 +3016,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
 
 	/* PCI doorbell mem area + 0x00 for consumer index register */
-	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *) doorbell_area;
+	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *)doorbell_area;
 	rx_ring->cnsmr_idx = 0;
 	rx_ring->curr_entry = rx_ring->cq_base;
 
@@ -3117,7 +3116,7 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	 * Assign doorbell registers for this tx_ring.
 	 */
 	/* TX PCI doorbell mem area for tx producer index */
-	tx_ring->prod_idx_db_reg = (u32 __iomem *) doorbell_area;
+	tx_ring->prod_idx_db_reg = (u32 __iomem *)doorbell_area;
 	tx_ring->prod_idx = 0;
 	/* TX PCI doorbell mem area + 0x04 */
 	tx_ring->valid_db_reg = doorbell_area + 0x04;
@@ -3140,7 +3139,7 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	ql_init_tx_ring(qdev, tx_ring);
 
 	err = ql_write_cfg(qdev, wqicb, sizeof(*wqicb), CFG_LRQ,
-			   (u16) tx_ring->wq_id);
+			   (u16)tx_ring->wq_id);
 	if (err) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load tx_ring.\n");
 		return err;
@@ -3268,7 +3267,8 @@ static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
 		 */
 		ctx->irq_mask = (1 << qdev->rx_ring[vect].cq_id);
 		/* Add the TX ring(s) serviced by this vector
-		 * to the mask. */
+		 * to the mask.
+		 */
 		for (j = 0; j < tx_rings_per_vector; j++) {
 			ctx->irq_mask |=
 			(1 << qdev->rx_ring[qdev->rss_ring_count +
@@ -3472,7 +3472,7 @@ static int ql_start_rss(struct ql_adapter *qdev)
 	struct ricb *ricb = &qdev->ricb;
 	int status = 0;
 	int i;
-	u8 *hash_id = (u8 *) ricb->hash_cq_id;
+	u8 *hash_id = (u8 *)ricb->hash_cq_id;
 
 	memset((void *)ricb, 0, sizeof(*ricb));
 
@@ -3803,10 +3803,11 @@ static int ql_wol(struct ql_adapter *qdev)
 				  "Failed to set magic packet on %s.\n",
 				  qdev->ndev->name);
 			return status;
-		} else
+		} else {
 			netif_info(qdev, drv, qdev->ndev,
 				   "Enabled magic packet successfully on %s.\n",
 				   qdev->ndev->name);
+		}
 
 		wol |= MB_WOL_MAGIC_PKT;
 	}
@@ -3825,7 +3826,6 @@ static int ql_wol(struct ql_adapter *qdev)
 
 static void ql_cancel_all_work_sync(struct ql_adapter *qdev)
 {
-
 	/* Don't kill the reset worker thread if we
 	 * are in the process of recovery.
 	 */
@@ -4111,7 +4111,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 		return -EINVAL;
 
 	queue_delayed_work(qdev->workqueue,
-			&qdev->mpi_port_cfg_work, 3*HZ);
+			&qdev->mpi_port_cfg_work, 3 * HZ);
 
 	ndev->mtu = new_mtu;
 
@@ -4232,7 +4232,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 			goto exit;
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
-			if (ql_set_mac_addr_reg(qdev, (u8 *) ha->addr,
+			if (ql_set_mac_addr_reg(qdev, (u8 *)ha->addr,
 						MAC_ADDR_TYPE_MULTI_MAC, i)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to loadmulticast address.\n");
@@ -4269,7 +4269,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *) ndev->dev_addr,
+	status = ql_set_mac_addr_reg(qdev, (u8 *)ndev->dev_addr,
 			MAC_ADDR_TYPE_CAM_MAC, qdev->func * MAX_CQ);
 	if (status)
 		netif_err(qdev, hw, qdev->ndev, "Failed to load MAC address.\n");
@@ -4280,6 +4280,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 static void qlge_tx_timeout(struct net_device *ndev)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	ql_queue_asic_error(qdev);
 }
 
@@ -4288,6 +4289,7 @@ static void ql_asic_reset_work(struct work_struct *work)
 	struct ql_adapter *qdev =
 	    container_of(work, struct ql_adapter, asic_reset_work.work);
 	int status;
+
 	rtnl_lock();
 	status = ql_adapter_down(qdev);
 	if (status)
@@ -4359,6 +4361,7 @@ static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
 static int ql_get_board_info(struct ql_adapter *qdev)
 {
 	int status;
+
 	qdev->func =
 	    (ql_read32(qdev, STS) & STS_FUNC_ID_MASK) >> STS_FUNC_ID_SHIFT;
 	if (qdev->func > 3)
@@ -4573,7 +4576,7 @@ static void ql_timer(struct timer_list *t)
 		return;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 }
 
 static int qlge_probe(struct pci_dev *pdev,
@@ -4644,7 +4647,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	 * the bus goes dead
 	 */
 	timer_setup(&qdev->timer, ql_timer, TIMER_DEFERRABLE);
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	ql_link_off(qdev);
 	ql_display_dev_info(ndev);
 	atomic_set(&qdev->lb_count, 0);
@@ -4777,7 +4780,7 @@ static void qlge_io_resume(struct pci_dev *pdev)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Device was not running prior to EEH.\n");
 	}
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 }
 
@@ -4839,7 +4842,7 @@ static int qlge_resume(struct pci_dev *pdev)
 			return err;
 	}
 
-	mod_timer(&qdev->timer, jiffies + (5*HZ));
+	mod_timer(&qdev->timer, jiffies + (5 * HZ));
 	netif_device_attach(ndev);
 
 	return 0;
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 9e422bbbb6ab..700847c2f332 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -91,6 +91,7 @@ int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
 int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
 {
 	int status;
+
 	status = ql_write_mpi_reg(qdev, 0x00001010, 1);
 	return status;
 }
@@ -121,7 +122,6 @@ int ql_own_firmware(struct ql_adapter *qdev)
 		return 1;
 
 	return 0;
-
 }
 
 static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
@@ -237,17 +237,19 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 {
 	int status;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
+
 	mbcp->out_count = 4;
 	status = ql_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Could not read MPI, resetting RISC!\n");
 		ql_queue_fw_error(qdev);
-	} else
+	} else {
 		/* Wake up the sleeping mpi_idc_work thread that is
 		 * waiting for this event.
 		 */
 		complete(&qdev->ide_completion);
+	}
 
 	return status;
 }
@@ -255,6 +257,7 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
+
 	mbcp->out_count = 2;
 
 	status = ql_get_mb_sts(qdev, mbcp);
@@ -276,8 +279,9 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
 			return;
-		} else
+		} else {
 			clear_bit(QL_CAM_RT_SET, &qdev->flags);
+		}
 	}
 
 	/* Queue up a worker to check the frame
@@ -349,15 +353,15 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	mbcp->out_count = 6;
 
 	status = ql_get_mb_sts(qdev, mbcp);
-	if (status)
+	if (status) {
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
-	else {
+	} else {
 		int i;
+
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN detected.\n");
 		for (i = 0; i < mbcp->out_count; i++)
 			netif_err(qdev, drv, qdev->ndev, "mbox_out[%d] = 0x%.08x.\n",
 				  i, mbcp->mbox_out[i]);
-
 	}
 
 	return status;
@@ -388,7 +392,8 @@ static void ql_init_fw_done(struct ql_adapter *qdev, struct mbox_params *mbcp)
  *  This can get called iteratively from the mpi_work thread
  *  when events arrive via an interrupt.
  *  It also gets called when a mailbox command is polling for
- *  it's completion. */
+ *  it's completion.
+ */
 static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
@@ -405,7 +410,6 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	}
 
 	switch (mbcp->mbox_out[0]) {
-
 	/* This case is only active when we arrive here
 	 * as a result of issuing a mailbox command to
 	 * the firmware.
@@ -519,7 +523,7 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * changed when a mailbox command is waiting
 	 * for a response and an AEN arrives and
 	 * is handled.
-	 * */
+	 */
 	mbcp->out_count = orig_count;
 	return status;
 }
@@ -544,7 +548,6 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	if (status)
 		goto end;
 
-
 	/* If we're generating a system error, then there's nothing
 	 * to wait for.
 	 */
@@ -555,7 +558,8 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * here because some AEN might arrive while
 	 * we're waiting for the mailbox command to
 	 * complete. If more than 5 seconds expire we can
-	 * assume something is wrong. */
+	 * assume something is wrong.
+	 */
 	count = jiffies + HZ * MAILBOX_TIMEOUT;
 	do {
 		/* Wait for the interrupt to come in. */
@@ -730,7 +734,6 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev)
 	mbcp->mbox_in[1] = qdev->link_config;
 	mbcp->mbox_in[2] = qdev->max_frame_size;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -768,7 +771,6 @@ static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
 	mbcp->mbox_in[7] = LSW(MSD(req_dma));
 	mbcp->mbox_in[8] = MSW(addr);
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -850,7 +852,6 @@ int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol)
 	mbcp->mbox_in[0] = MB_CMD_SET_WOL_MODE;
 	mbcp->mbox_in[1] = wol;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -916,6 +917,7 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 	int status = -ETIMEDOUT;
 	long wait_time = 1 * HZ;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
+
 	do {
 		/* Wait here for the command to complete
 		 * via the IDC process.
@@ -965,7 +967,6 @@ int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config)
 	mbcp->mbox_in[0] = MB_CMD_SET_LED_CFG;
 	mbcp->mbox_in[1] = led_config;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -1000,8 +1001,9 @@ int ql_mb_get_led_cfg(struct ql_adapter *qdev)
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed to get LED Configuration.\n");
 		status = -EIO;
-	} else
+	} else {
 		qdev->led_config = mbcp->mbox_out[1];
+	}
 
 	return status;
 }
@@ -1101,6 +1103,7 @@ int ql_wait_fifo_empty(struct ql_adapter *qdev)
 static int ql_set_port_cfg(struct ql_adapter *qdev)
 {
 	int status;
+
 	status = ql_mb_set_port_cfg(qdev);
 	if (status)
 		return status;
@@ -1181,7 +1184,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 		/* Signal the resulting link up AEN
 		 * that the frame routing and mac addr
 		 * needs to be set.
-		 * */
+		 */
 		set_bit(QL_CAM_RT_SET, &qdev->flags);
 		/* Do ACK if required */
 		if (timeout) {
-- 
2.20.1

