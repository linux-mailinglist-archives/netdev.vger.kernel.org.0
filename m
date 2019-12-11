Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19BC11BB6D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfLKSPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:20 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44039 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbfLKSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:19 -0500
Received: by mail-yb1-f194.google.com with SMTP id j6so9369552ybc.11;
        Wed, 11 Dec 2019 10:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jq5BF21JB1bKRBuVJB9xpZT7JfngHos0/bWnep+7l/0=;
        b=OUveX752j5qjDhKiIhdaFtubkfKsG4SPpQs3PnEyo0esWZtty0pRSG6VZ9p6VTeYvk
         1M4xL87066Ho36AJW0bjdEX+e1id6NDILwCguf50pSGg70BNWYADgDMAgodR35EknPWX
         Fs0KK+ZeN9Yi9Z43+/AnabmgbplEr9+hqUECpXNtn/gCLWYd/43KfIrgNjOLv8a+y/PU
         btBtuoFGle6wuPCOJRNKVz2EBVCu68UuqP/6PhCwFkOLcrRJLF19ni0SDjAgs9nx6ikG
         7THIYXHdSdDvCi1FwFk01/4RDCmTUk2hK6oMIGHBUN/uJV0kdgJH7y94A0BoTco2bpBb
         ljOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jq5BF21JB1bKRBuVJB9xpZT7JfngHos0/bWnep+7l/0=;
        b=Yx7SN7A0w0C422ElXhnApyNvFI9g98W1WvZBERRrzrlgLJOTczf9Ux0vGs/7rGy2Dq
         cg3AIDsk5niOMqP439RN6GiXzzdem5g4PHn02KR4SeCMA3Ym2h+HST96jyF9aoRiONB7
         VPZxHS3soMZdhJoo0aGbyamB9UfnvKE0xWpqHaFsar9xpsD+JMA7tMVQZIsklvs/ezwA
         Qzu6UZRzGLZIHwNtr3DSbmZgSTEhLxlIJG5cFARBrIuwMubEU8ar8WJgMAj1zNBwJgRb
         MBmp9VnlqLBrkRiiJ5/i1de6fZu2LpL7OkO4Q09yZoqed7HbJGaOovRgpo+PPOlmGdJA
         CO1Q==
X-Gm-Message-State: APjAAAVkJBT744hKGPEYLrM1jfWOWH+sxBx18Zras+IqqdVo5zpRVt3n
        zf7foG/U67X2RQifToHvzMOrT/kgIaZrhw==
X-Google-Smtp-Source: APXvYqzFk5uEoKvaP8kWCq4CRDNqIbGj08lIeh3IgEyP1zKcyv5f0dRjv0hReCJpTEiNkw/4ogisqw==
X-Received: by 2002:a25:cc48:: with SMTP id l69mr1002048ybf.212.1576088117834;
        Wed, 11 Dec 2019 10:15:17 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id m16sm1273776ywa.90.2019.12.11.10.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:17 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/23] staging: qlge: Fix CHECK: No space is necessary after a cast
Date:   Wed, 11 Dec 2019 12:12:38 -0600
Message-Id: <f1132d4b57fa4283e3c346ea9aaa866e2184dbef.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: No space is necessary after a cast in qlge_dbg.c and
qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c  | 28 +++++++++++------------
 drivers/staging/qlge/qlge_main.c | 38 ++++++++++++++++----------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index f8b2f105592f..3324f0650286 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1640,9 +1640,9 @@ void ql_dump_wqicb(struct wqicb *wqicb)
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
@@ -1653,7 +1653,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 	       tx_ring->wq_id);
 	pr_err("tx_ring->base = %p\n", tx_ring->wq_base);
 	pr_err("tx_ring->base_dma = 0x%llx\n",
-	       (unsigned long long) tx_ring->wq_base_dma);
+	       (unsigned long long)tx_ring->wq_base_dma);
 	pr_err("tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
 	       tx_ring->cnsmr_idx_sh_reg,
 	       tx_ring->cnsmr_idx_sh_reg
@@ -1707,21 +1707,21 @@ void ql_dump_cqicb(struct cqicb *cqicb)
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
@@ -1749,7 +1749,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	pr_err("rx_ring->cqicb = %p\n", &rx_ring->cqicb);
 	pr_err("rx_ring->cq_base = %p\n", rx_ring->cq_base);
 	pr_err("rx_ring->cq_base_dma = %llx\n",
-	       (unsigned long long) rx_ring->cq_base_dma);
+	       (unsigned long long)rx_ring->cq_base_dma);
 	pr_err("rx_ring->cq_size = %d\n", rx_ring->cq_size);
 	pr_err("rx_ring->cq_len = %d\n", rx_ring->cq_len);
 	pr_err("rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
@@ -1757,7 +1757,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	       rx_ring->prod_idx_sh_reg
 			? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
 	pr_err("rx_ring->prod_idx_sh_reg_dma = %llx\n",
-	       (unsigned long long) rx_ring->prod_idx_sh_reg_dma);
+	       (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
 	pr_err("rx_ring->cnsmr_idx_db_reg = %p\n",
 	       rx_ring->cnsmr_idx_db_reg);
 	pr_err("rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
@@ -1834,7 +1834,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 {
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
@@ -1842,7 +1842,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 	       tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
@@ -1850,7 +1850,7 @@ void ql_dump_tx_desc(struct tx_buf_desc *tbd)
 	       tbd->len & TX_DESC_E ? "E" : ".");
 	tbd++;
 	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
+	       le64_to_cpu((u64)tbd->addr));
 	pr_err("tbd->len   = %d\n",
 	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
 	pr_err("tbd->flags = %s %s\n",
@@ -1980,7 +1980,7 @@ void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 	pr_err("data_len	= %d\n",
 	       le32_to_cpu(ib_mac_rsp->data_len));
 	pr_err("data_addr    = 0x%llx\n",
-	       (unsigned long long) le64_to_cpu(ib_mac_rsp->data_addr));
+	       (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
 	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
 		pr_err("rss    = %x\n",
 		       le32_to_cpu(ib_mac_rsp->rss));
@@ -1997,7 +1997,7 @@ void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 		pr_err("hdr length	= %d\n",
 		       le32_to_cpu(ib_mac_rsp->hdr_len));
 		pr_err("hdr addr    = 0x%llx\n",
-		       (unsigned long long) le64_to_cpu(ib_mac_rsp->hdr_addr));
+		       (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
 	}
 }
 #endif
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index a103d491bbb1..4dc4edbb2de5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -239,8 +239,8 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 		goto exit;
 	}
 
-	ql_write32(qdev, ICB_L, (u32) map);
-	ql_write32(qdev, ICB_H, (u32) (map >> 32));
+	ql_write32(qdev, ICB_L, (u32)map);
+	ql_write32(qdev, ICB_H, (u32)(map >> 32));
 
 	mask = CFG_Q_MASK | (bit << 16);
 	value = bit | (q_id << CFG_Q_SHIFT);
@@ -410,7 +410,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		}
 	case MAC_ADDR_TYPE_VLAN:
 		{
-			u32 enable_bit = *((u32 *) &addr[0]);
+			u32 enable_bit = *((u32 *)&addr[0]);
 			/* For VLAN, the addr actually holds a bit that
 			 * either enables or disables the vlan id we are
 			 * addressing. It's either MAC_ADDR_E on or off.
@@ -459,7 +459,7 @@ static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
 	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *) addr,
+	status = ql_set_mac_addr_reg(qdev, (u8 *)addr,
 				     MAC_ADDR_TYPE_CAM_MAC,
 				     qdev->func * MAX_CQ);
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
@@ -860,7 +860,7 @@ int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data)
 	if (status)
 		goto exit;
 
-	*data = (u64) lo | ((u64) hi << 32);
+	*data = (u64)lo | ((u64)hi << 32);
 
 exit:
 	return status;
@@ -1648,7 +1648,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
-			struct iphdr *iph = (struct iphdr *) skb->data;
+			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
@@ -1937,7 +1937,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
 				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 		/* Unfragmented ipv4 UDP frame. */
-			struct iphdr *iph = (struct iphdr *) skb->data;
+			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
 				htons(IP_MF|IP_OFFSET))) {
@@ -2315,7 +2315,7 @@ static int __qlge_vlan_rx_add_vid(struct ql_adapter *qdev, u16 vid)
 	u32 enable_bit = MAC_ADDR_E;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *) &enable_bit,
+	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
 				  MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
@@ -2346,7 +2346,7 @@ static int __qlge_vlan_rx_kill_vid(struct ql_adapter *qdev, u16 vid)
 	u32 enable_bit = 0;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *) &enable_bit,
+	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
 				  MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
@@ -2486,7 +2486,7 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 
 		mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
 		mac_iocb_ptr->flags3 |= OB_MAC_TSO_IOCB_IC;
-		mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
+		mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 		mac_iocb_ptr->total_hdrs_len =
 		    cpu_to_le16(skb_transport_offset(skb) + tcp_hdrlen(skb));
 		mac_iocb_ptr->net_trans_offset =
@@ -2524,7 +2524,7 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 	__sum16 *check;
 
 	mac_iocb_ptr->opcode = OPCODE_OB_MAC_TSO_IOCB;
-	mac_iocb_ptr->frame_len = cpu_to_le32((u32) skb->len);
+	mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 	mac_iocb_ptr->net_trans_offset =
 		cpu_to_le16(skb_network_offset(skb) |
 		skb_transport_offset(skb) << OB_MAC_TRANSPORT_HDR_SHIFT);
@@ -2555,7 +2555,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	struct ql_adapter *qdev = netdev_priv(ndev);
 	int tso;
 	struct tx_ring *tx_ring;
-	u32 tx_ring_idx = (u32) skb->queue_mapping;
+	u32 tx_ring_idx = (u32)skb->queue_mapping;
 
 	tx_ring = &qdev->tx_ring[tx_ring_idx];
 
@@ -2582,7 +2582,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	mac_iocb_ptr->txq_idx = tx_ring_idx;
 	tx_ring_desc->skb = skb;
 
-	mac_iocb_ptr->frame_len = cpu_to_le16((u16) skb->len);
+	mac_iocb_ptr->frame_len = cpu_to_le16((u16)skb->len);
 
 	if (skb_vlan_tag_present(skb)) {
 		netif_printk(qdev, tx_queued, KERN_DEBUG, qdev->ndev,
@@ -3004,7 +3004,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	rx_ring->sbq.base_indirect_dma = shadow_reg_dma;
 
 	/* PCI doorbell mem area + 0x00 for consumer index register */
-	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *) doorbell_area;
+	rx_ring->cnsmr_idx_db_reg = (u32 __iomem *)doorbell_area;
 	rx_ring->cnsmr_idx = 0;
 	rx_ring->curr_entry = rx_ring->cq_base;
 
@@ -3104,7 +3104,7 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	 * Assign doorbell registers for this tx_ring.
 	 */
 	/* TX PCI doorbell mem area for tx producer index */
-	tx_ring->prod_idx_db_reg = (u32 __iomem *) doorbell_area;
+	tx_ring->prod_idx_db_reg = (u32 __iomem *)doorbell_area;
 	tx_ring->prod_idx = 0;
 	/* TX PCI doorbell mem area + 0x04 */
 	tx_ring->valid_db_reg = doorbell_area + 0x04;
@@ -3127,7 +3127,7 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	ql_init_tx_ring(qdev, tx_ring);
 
 	err = ql_write_cfg(qdev, wqicb, sizeof(*wqicb), CFG_LRQ,
-			   (u16) tx_ring->wq_id);
+			   (u16)tx_ring->wq_id);
 	if (err) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load tx_ring.\n");
 		return err;
@@ -3459,7 +3459,7 @@ static int ql_start_rss(struct ql_adapter *qdev)
 	struct ricb *ricb = &qdev->ricb;
 	int status = 0;
 	int i;
-	u8 *hash_id = (u8 *) ricb->hash_cq_id;
+	u8 *hash_id = (u8 *)ricb->hash_cq_id;
 
 	memset((void *)ricb, 0, sizeof(*ricb));
 
@@ -4215,7 +4215,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 			goto exit;
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
-			if (ql_set_mac_addr_reg(qdev, (u8 *) ha->addr,
+			if (ql_set_mac_addr_reg(qdev, (u8 *)ha->addr,
 						MAC_ADDR_TYPE_MULTI_MAC, i)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to loadmulticast address.\n");
@@ -4252,7 +4252,7 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *) ndev->dev_addr,
+	status = ql_set_mac_addr_reg(qdev, (u8 *)ndev->dev_addr,
 				     MAC_ADDR_TYPE_CAM_MAC,
 				     qdev->func * MAX_CQ);
 	if (status)
-- 
2.20.1

