Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C984311BB81
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfLKSPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:10 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42907 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbfLKSPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:09 -0500
Received: by mail-yb1-f196.google.com with SMTP id p137so9382063ybg.9;
        Wed, 11 Dec 2019 10:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kgDF2w6O3nDu8g61G01iPGlNB9u+FVWT+IsP+KnkKmI=;
        b=YuZKH1GFWnPkFVHbdbGshSWz8a4TCHbnyx9+R7LCbXubU2gRYoMPLbhAaESPno1wlq
         ANAMbCb+7ngGEGFYAXH/TdCxzqDrOZP4ycRJ3KOVMeKEz7EpvB3cJrv7sZOJV2NcnOvc
         I3BDh7KcCa4Tmkz4r0b8p1ZwN5JpAvdHYrMBjmw6vSY6yP3kZLSBK8dldaP3j6stVE4V
         MkT1d0nAF/dQDdX9bvHUsJZLIRzV08IleT2ZCD5G3/2tqKuwHdBtFQFmTe+u2IXv4PON
         axYqUlAGyN0c/rvKtvtt/zPGmxJV6w2V7T4Sta76Mq8DQR4Z+s/JPBG11QSLAT/L1b+7
         ShLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kgDF2w6O3nDu8g61G01iPGlNB9u+FVWT+IsP+KnkKmI=;
        b=hSd261OS5mTjCqxQ/7L5YfDVdp3+Huu1VbU5KdjoM5FwETeoJ0hwUrJbg/vuxQdj3z
         rIJN2gUHSSyNNNT2r6eOpCEpX/fniIaVn6xrP32HVJpxfLc+tAydGKYzAtnmY13X3VYR
         p2I8qrZDflCNz9OZL+lS/NHOCWDw2RDu85hNgjz+RcEExyMm4whIouxNZxDN3SOdzi9q
         bsVTflhy3A+XIyumvbCzDV1pXqWxAFSlgTJH1R/XNGws0PSmnHzXmxvCJ/n34vxbKmH3
         NVKJFzqs3R42fF918Q/o1BNX9nYGzacfr+3hzrslEG3M5w4Z1W10YlQIqIwxXJApr82j
         5mqg==
X-Gm-Message-State: APjAAAWqY0ni86oJsn5VPLlGG+54vupZ+hVqT8exet+JCEVRaIUDBPrQ
        T2JxttA4fAitu0qFKm4bc2nuEipeO2sOPQ==
X-Google-Smtp-Source: APXvYqxlrEcrqVt7QmnrpvKkejGbiLkMVd//CIsBPsEoZ3ImcIYfYhoTks7oULchwTLJNvp8DMXpYg==
X-Received: by 2002:a25:401:: with SMTP id 1mr994636ybe.348.1576088107045;
        Wed, 11 Dec 2019 10:15:07 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id u11sm1294752ywb.67.2019.12.11.10.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:06 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/23] staging: qlge: Fix CHECK: Alignment should match open parenthesis
Date:   Wed, 11 Dec 2019 12:12:31 -0600
Message-Id: <27ec7ee0a3ba8c1ad946077aacfcc6e40b98c106.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Alignment should match open parenthesis in qlge_dbg.c,
qlge_ethtool.c, qlge_main.c, and qlge_mpi.c. Also made changes to
the following lines:

WARNING: quoted string split across lines
FILE: drivers/staging/qlge/qlge_main.c:81

WARNING: quoted string split across lines
FILE: drivers/staging/qlge/qlge_main.c:87

WARNING: quoted string split across lines
FILE: drivers/staging/qlge/qlge_main.c:3528

WARNING: quoted string split across lines
FILE: drivers/staging/qlge/qlge_main.c:3536

CHECK: spaces preferred around that '*' (ctx:VxV)
drivers/staging/qlge/qlge_main.c:4102

I made these changes due to touching these lines in the original fix

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c     |   8 +-
 drivers/staging/qlge/qlge_ethtool.c |  34 +++--
 drivers/staging/qlge/qlge_main.c    | 184 +++++++++++++---------------
 drivers/staging/qlge/qlge_mpi.c     |  21 ++--
 4 files changed, 117 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index c82a38c1b770..ed55ec3e6ea1 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -144,7 +144,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	/* The XAUI needs to be read out per port */
 	status = ql_read_other_func_serdes_reg(qdev,
-			XG_SERDES_XAUI_HSS_PCS_START, &temp);
+					       XG_SERDES_XAUI_HSS_PCS_START,
+					       &temp);
 	if (status)
 		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
 
@@ -480,7 +481,8 @@ static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 *buf)
 	int status;
 
 	for (i = 0; i < MPI_CORE_SH_REGS_CNT; i++, buf++) {
-		status = ql_write_mpi_reg(qdev, RISC_124,
+		status = ql_write_mpi_reg(qdev,
+					  RISC_124,
 				(SHADOW_OFFSET | i << SHADOW_REG_SHIFT));
 		if (status)
 			goto end;
@@ -1106,7 +1108,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 				+ sizeof(mpi_coredump->nic_routing_words),
 				"Routing Words");
 	status = ql_get_routing_entries(qdev,
-			&mpi_coredump->nic_routing_words[0]);
+					&mpi_coredump->nic_routing_words[0]);
 	if (status)
 		goto err;
 
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 792b4d754ab8..f1654671ce80 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -196,8 +196,7 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 	 */
 	cqicb = (struct cqicb *)&qdev->rx_ring[qdev->rss_ring_count];
 	if (le16_to_cpu(cqicb->irq_delay) != qdev->tx_coalesce_usecs ||
-		le16_to_cpu(cqicb->pkt_delay) !=
-				qdev->tx_max_coalesced_frames) {
+	    le16_to_cpu(cqicb->pkt_delay) != qdev->tx_max_coalesced_frames) {
 		for (i = qdev->rss_ring_count; i < qdev->rx_ring_count; i++) {
 			rx_ring = &qdev->rx_ring[i];
 			cqicb = (struct cqicb *)rx_ring;
@@ -206,7 +205,7 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 			    cpu_to_le16(qdev->tx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
 			status = ql_write_cfg(qdev, cqicb, sizeof(*cqicb),
-						CFG_LCQ, rx_ring->cq_id);
+					      CFG_LCQ, rx_ring->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -218,8 +217,7 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 	/* Update the inbound (RSS) handler queues if they changed. */
 	cqicb = (struct cqicb *)&qdev->rx_ring[0];
 	if (le16_to_cpu(cqicb->irq_delay) != qdev->rx_coalesce_usecs ||
-		le16_to_cpu(cqicb->pkt_delay) !=
-					qdev->rx_max_coalesced_frames) {
+	    le16_to_cpu(cqicb->pkt_delay) != qdev->rx_max_coalesced_frames) {
 		for (i = 0; i < qdev->rss_ring_count; i++, rx_ring++) {
 			rx_ring = &qdev->rx_ring[i];
 			cqicb = (struct cqicb *)rx_ring;
@@ -228,7 +226,7 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 			    cpu_to_le16(qdev->rx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
 			status = ql_write_cfg(qdev, cqicb, sizeof(*cqicb),
-						CFG_LCQ, rx_ring->cq_id);
+					      CFG_LCQ, rx_ring->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -339,8 +337,8 @@ static void ql_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 	case ETH_SS_STATS:
 		for (index = 0; index < QLGE_STATS_LEN; index++) {
 			memcpy(buf + index * ETH_GSTRING_LEN,
-				ql_gstrings_stats[index].stat_string,
-				ETH_GSTRING_LEN);
+			       ql_gstrings_stats[index].stat_string,
+			       ETH_GSTRING_LEN);
 		}
 		break;
 	}
@@ -432,7 +430,7 @@ static void ql_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 	/* WOL is only supported for mezz card. */
 	if (ssys_dev == QLGE_MEZZ_SSYS_ID_068 ||
-			ssys_dev == QLGE_MEZZ_SSYS_ID_180) {
+	    ssys_dev == QLGE_MEZZ_SSYS_ID_180) {
 		wol->supported = WAKE_MAGIC;
 		wol->wolopts = qdev->wol;
 	}
@@ -445,9 +443,9 @@ static int ql_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 	/* WOL is only supported for mezz card. */
 	if (ssys_dev != QLGE_MEZZ_SSYS_ID_068 &&
-			ssys_dev != QLGE_MEZZ_SSYS_ID_180) {
+	    ssys_dev != QLGE_MEZZ_SSYS_ID_180) {
 		netif_info(qdev, drv, qdev->ndev,
-				"WOL is only supported for mezz card\n");
+			   "WOL is only supported for mezz card\n");
 		return -EOPNOTSUPP;
 	}
 	if (wol->wolopts & ~WAKE_MAGIC)
@@ -507,7 +505,7 @@ static void ql_stop_loopback(struct ql_adapter *qdev)
 }
 
 static void ql_create_lb_frame(struct sk_buff *skb,
-					unsigned int frame_size)
+			       unsigned int frame_size)
 {
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &= ~1;
@@ -517,13 +515,13 @@ static void ql_create_lb_frame(struct sk_buff *skb,
 }
 
 void ql_check_lb_frame(struct ql_adapter *qdev,
-					struct sk_buff *skb)
+		       struct sk_buff *skb)
 {
 	unsigned int frame_size = skb->len;
 
 	if ((*(skb->data + 3) == 0xFF) &&
-		(*(skb->data + frame_size / 2 + 10) == 0xBE) &&
-		(*(skb->data + frame_size / 2 + 12) == 0xAF)) {
+	    (*(skb->data + frame_size / 2 + 10) == 0xBE) &&
+	    (*(skb->data + frame_size / 2 + 12) == 0xAF)) {
 			atomic_dec(&qdev->lb_count);
 			return;
 	}
@@ -567,7 +565,7 @@ static int ql_loopback_test(struct ql_adapter *qdev, u64 *data)
 }
 
 static void ql_self_test(struct net_device *ndev,
-				struct ethtool_test *eth_test, u64 *data)
+			 struct ethtool_test *eth_test, u64 *data)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
@@ -673,7 +671,7 @@ static int ql_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
 }
 
 static void ql_get_pauseparam(struct net_device *netdev,
-			struct ethtool_pauseparam *pause)
+			      struct ethtool_pauseparam *pause)
 {
 	struct ql_adapter *qdev = netdev_priv(netdev);
 
@@ -685,7 +683,7 @@ static void ql_get_pauseparam(struct net_device *netdev,
 }
 
 static int ql_set_pauseparam(struct net_device *netdev,
-			struct ethtool_pauseparam *pause)
+			     struct ethtool_pauseparam *pause)
 {
 	struct ql_adapter *qdev = netdev_priv(netdev);
 	int status = 0;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index b2f826822a51..0a0e50f8e26c 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -77,14 +77,12 @@ MODULE_PARM_DESC(qlge_irq_type, "0 = MSI-X, 1 = MSI, 2 = Legacy.");
 static int qlge_mpi_coredump;
 module_param(qlge_mpi_coredump, int, 0);
 MODULE_PARM_DESC(qlge_mpi_coredump,
-		"Option to enable MPI firmware dump. "
-		"Default is OFF - Do Not allocate memory. ");
+		 "Option to enable MPI firmware dump. Default is OFF - Do Not allocate memory. ");
 
 static int qlge_force_coredump;
 module_param(qlge_force_coredump, int, 0);
 MODULE_PARM_DESC(qlge_force_coredump,
-		"Option to allow force of firmware core dump. "
-		"Default is OFF - Do not allow.");
+		 "Option to allow force of firmware core dump. Default is OFF - Do not allow.");
 
 static const struct pci_device_id qlge_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, QLGE_DEVICE_ID_8012)},
@@ -270,36 +268,34 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 		{
 			status =
 			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+					    MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   MAC_ADDR_ADR | MAC_ADDR_RS | type); /* type */
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 			if (status)
 				goto exit;
 			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   MAC_ADDR_ADR | MAC_ADDR_RS | type); /* type */
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 			if (status)
 				goto exit;
 			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
 			if (type == MAC_ADDR_TYPE_CAM_MAC) {
 				status =
 				    ql_wait_reg_rdy(qdev,
-					MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+						    MAC_ADDR_IDX, MAC_ADDR_MW,
+						    0);
 				if (status)
 					goto exit;
 				ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
@@ -343,7 +339,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 
 			status =
 				ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) |
@@ -352,7 +348,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			ql_write32(qdev, MAC_ADDR_DATA, lower);
 			status =
 				ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) |
@@ -362,7 +358,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			ql_write32(qdev, MAC_ADDR_DATA, upper);
 			status =
 				ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+						MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			break;
@@ -375,8 +371,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			    (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
 			    (addr[5]);
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
@@ -384,8 +379,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 				   type);	/* type */
 			ql_write32(qdev, MAC_ADDR_DATA, lower);
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset++) | /* offset */
@@ -393,8 +387,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 				   type);	/* type */
 			ql_write32(qdev, MAC_ADDR_DATA, upper);
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, (offset) |	/* offset */
@@ -423,8 +416,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 			 * That's bit-27 we're talking about.
 			 */
 			status =
-			    ql_wait_reg_rdy(qdev,
-				MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+			    ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 			if (status)
 				goto exit;
 			ql_write32(qdev, MAC_ADDR_IDX, offset |	/* offset */
@@ -467,7 +459,8 @@ static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
 	if (status)
 		return status;
 	status = ql_set_mac_addr_reg(qdev, (u8 *) addr,
-			MAC_ADDR_TYPE_CAM_MAC, qdev->func * MAX_CQ);
+				     MAC_ADDR_TYPE_CAM_MAC,
+				     qdev->func * MAX_CQ);
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		netif_err(qdev, ifup, qdev->ndev,
@@ -672,14 +665,14 @@ static int ql_read_flash_word(struct ql_adapter *qdev, int offset, __le32 *data)
 	int status = 0;
 	/* wait for reg to come ready */
 	status = ql_wait_reg_rdy(qdev,
-			FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+				 FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* set up for reg read */
 	ql_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
 	/* wait for reg to come ready */
 	status = ql_wait_reg_rdy(qdev,
-			FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+				 FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* This data is stored on flash as an array of
@@ -721,8 +714,9 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 	}
 
 	status = ql_validate_flash(qdev,
-			sizeof(struct flash_params_8000) / sizeof(u16),
-			"8000");
+				   sizeof(struct flash_params_8000) /
+				   sizeof(u16),
+				   "8000");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
@@ -734,12 +728,12 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 	 */
 	if (qdev->flash.flash_params_8000.data_type1 == 2)
 		memcpy(mac_addr,
-			qdev->flash.flash_params_8000.mac_addr1,
-			qdev->ndev->addr_len);
+		       qdev->flash.flash_params_8000.mac_addr1,
+		       qdev->ndev->addr_len);
 	else
 		memcpy(mac_addr,
-			qdev->flash.flash_params_8000.mac_addr,
-			qdev->ndev->addr_len);
+		       qdev->flash.flash_params_8000.mac_addr,
+		       qdev->ndev->addr_len);
 
 	if (!is_valid_ether_addr(mac_addr)) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid MAC address.\n");
@@ -748,8 +742,8 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 	}
 
 	memcpy(qdev->ndev->dev_addr,
-		mac_addr,
-		qdev->ndev->addr_len);
+	       mac_addr,
+	       qdev->ndev->addr_len);
 
 exit:
 	ql_sem_unlock(qdev, SEM_FLASH_MASK);
@@ -784,8 +778,9 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 	}
 
 	status = ql_validate_flash(qdev,
-			sizeof(struct flash_params_8012) / sizeof(u16),
-			"8012");
+				   sizeof(struct flash_params_8012) /
+				   sizeof(u16),
+				   "8012");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
@@ -798,8 +793,8 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 	}
 
 	memcpy(qdev->ndev->dev_addr,
-		qdev->flash.flash_params_8012.mac_addr,
-		qdev->ndev->addr_len);
+	       qdev->flash.flash_params_8012.mac_addr,
+	       qdev->ndev->addr_len);
 
 exit:
 	ql_sem_unlock(qdev, SEM_FLASH_MASK);
@@ -815,7 +810,7 @@ static int ql_write_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 data)
 	int status;
 	/* wait for reg to come ready */
 	status = ql_wait_reg_rdy(qdev,
-			XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		return status;
 	/* write the data to the data reg */
@@ -834,14 +829,14 @@ int ql_read_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
 	int status = 0;
 	/* wait for reg to come ready */
 	status = ql_wait_reg_rdy(qdev,
-			XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* set up for reg read */
 	ql_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
 	/* wait for reg to come ready */
 	status = ql_wait_reg_rdy(qdev,
-			XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* get the data */
@@ -1436,10 +1431,9 @@ static void ql_update_mac_hdr_len(struct ql_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
-					struct rx_ring *rx_ring,
-					struct ib_mac_iocb_rsp *ib_mac_rsp,
-					u32 length,
-					u16 vlan_id)
+				       struct rx_ring *rx_ring,
+				       struct ib_mac_iocb_rsp *ib_mac_rsp,
+				       u32 length, u16 vlan_id)
 {
 	struct sk_buff *skb;
 	struct qlge_bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
@@ -1483,10 +1477,9 @@ static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void ql_process_mac_rx_page(struct ql_adapter *qdev,
-					struct rx_ring *rx_ring,
-					struct ib_mac_iocb_rsp *ib_mac_rsp,
-					u32 length,
-					u16 vlan_id)
+				   struct rx_ring *rx_ring,
+				   struct ib_mac_iocb_rsp *ib_mac_rsp,
+				   u32 length, u16 vlan_id)
 {
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
@@ -1528,8 +1521,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 		     "%d bytes of headers and data in large. Chain page to new skb and pull tail.\n",
 		     length);
 	skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
-				lbq_desc->p.pg_chunk.offset + hlen,
-				length - hlen);
+			   lbq_desc->p.pg_chunk.offset + hlen, length - hlen);
 	skb->len += length - hlen;
 	skb->data_len += length - hlen;
 	skb->truesize += length - hlen;
@@ -1540,7 +1532,7 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 	skb_checksum_none_assert(skb);
 
 	if ((ndev->features & NETIF_F_RXCSUM) &&
-		!(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
+	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1576,10 +1568,9 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
-					struct rx_ring *rx_ring,
-					struct ib_mac_iocb_rsp *ib_mac_rsp,
-					u32 length,
-					u16 vlan_id)
+				  struct rx_ring *rx_ring,
+				  struct ib_mac_iocb_rsp *ib_mac_rsp,
+				  u32 length, u16 vlan_id)
 {
 	struct qlge_bq_desc *sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 	struct net_device *ndev = qdev->ndev;
@@ -1648,7 +1639,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 	 * csum or frame errors.
 	 */
 	if ((ndev->features & NETIF_F_RXCSUM) &&
-		!(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
+	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1779,8 +1770,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 				     "Chaining page at offset = %d, for %d bytes  to skb.\n",
 				     lbq_desc->p.pg_chunk.offset, length);
 			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
-						lbq_desc->p.pg_chunk.offset,
-						length);
+					   lbq_desc->p.pg_chunk.offset, length);
 			skb->len += length;
 			skb->data_len += length;
 			skb->truesize += length;
@@ -1804,10 +1794,9 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 				     "%d bytes of headers and data in large. Chain page to new skb and pull tail.\n",
 				     length);
-			skb_fill_page_desc(skb, 0,
-						lbq_desc->p.pg_chunk.page,
-						lbq_desc->p.pg_chunk.offset,
-						length);
+			skb_fill_page_desc(skb, 0, lbq_desc->p.pg_chunk.page,
+					   lbq_desc->p.pg_chunk.offset,
+					   length);
 			skb->len += length;
 			skb->data_len += length;
 			skb->truesize += length;
@@ -1857,9 +1846,8 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 				     "Adding page %d to skb for %d bytes.\n",
 				     i, size);
 			skb_fill_page_desc(skb, i,
-						lbq_desc->p.pg_chunk.page,
-						lbq_desc->p.pg_chunk.offset,
-						size);
+					   lbq_desc->p.pg_chunk.page,
+					   lbq_desc->p.pg_chunk.offset, size);
 			skb->len += size;
 			skb->data_len += size;
 			skb->truesize += size;
@@ -1875,9 +1863,9 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
-				   struct rx_ring *rx_ring,
-				   struct ib_mac_iocb_rsp *ib_mac_rsp,
-				   u16 vlan_id)
+					 struct rx_ring *rx_ring,
+					 struct ib_mac_iocb_rsp *ib_mac_rsp,
+					 u16 vlan_id)
 {
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
@@ -1938,7 +1926,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 	 * csum or frame errors.
 	 */
 	if ((ndev->features & NETIF_F_RXCSUM) &&
-		!(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
+	    !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK)) {
 		/* TCP frame. */
 		if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) {
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1970,8 +1958,8 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 
 /* Process an inbound completion from an rx ring. */
 static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
-					struct rx_ring *rx_ring,
-					struct ib_mac_iocb_rsp *ib_mac_rsp)
+					    struct rx_ring *rx_ring,
+					    struct ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u16 vlan_id = ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) &&
@@ -1986,34 +1974,34 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 		 * separate buffers.
 		 */
 		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
-						vlan_id);
+					     vlan_id);
 	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS) {
 		/* The data fit in a single small buffer.
 		 * Allocate a new skb, copy the data and
 		 * return the buffer to the free pool.
 		 */
-		ql_process_mac_rx_skb(qdev, rx_ring, ib_mac_rsp,
-						length, vlan_id);
+		ql_process_mac_rx_skb(qdev, rx_ring, ib_mac_rsp, length,
+				      vlan_id);
 	} else if ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) &&
 		!(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK) &&
 		(ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T)) {
 		/* TCP packet in a page chunk that's been checksummed.
 		 * Tack it on to our GRO skb and let it go.
 		 */
-		ql_process_mac_rx_gro_page(qdev, rx_ring, ib_mac_rsp,
-						length, vlan_id);
+		ql_process_mac_rx_gro_page(qdev, rx_ring, ib_mac_rsp, length,
+					   vlan_id);
 	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) {
 		/* Non-TCP packet in a page chunk. Allocate an
 		 * skb, tack it on frags, and send it up.
 		 */
-		ql_process_mac_rx_page(qdev, rx_ring, ib_mac_rsp,
-						length, vlan_id);
+		ql_process_mac_rx_page(qdev, rx_ring, ib_mac_rsp, length,
+				       vlan_id);
 	} else {
 		/* Non-TCP/UDP large frames that span multiple buffers
 		 * can be processed corrrectly by the split frame logic.
 		 */
 		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
-						vlan_id);
+					     vlan_id);
 	}
 
 	return (unsigned long)length;
@@ -2230,8 +2218,8 @@ static int ql_napi_poll_msix(struct napi_struct *napi, int budget)
 		 * it's not empty then service it.
 		 */
 		if ((ctx->irq_mask & (1 << trx_ring->cq_id)) &&
-			(ql_read_sh_reg(trx_ring->prod_idx_sh_reg) !=
-					trx_ring->cnsmr_idx)) {
+		    (ql_read_sh_reg(trx_ring->prod_idx_sh_reg) !=
+		     trx_ring->cnsmr_idx)) {
 			netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
 				     "%s: Servicing TX completion ring %d.\n",
 				     __func__, trx_ring->cq_id);
@@ -2305,7 +2293,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 }
 
 static int qlge_set_features(struct net_device *ndev,
-	netdev_features_t features)
+			     netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
 	int err;
@@ -2448,7 +2436,7 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	 * Check MPI processor activity.
 	 */
 	if ((var & STS_PI) &&
-		(ql_read32(qdev, INTR_MASK) & INTR_MASK_PI)) {
+	    (ql_read32(qdev, INTR_MASK) & INTR_MASK_PI)) {
 		/*
 		 * We've got an async event or mailbox completion.
 		 * Handle it and clear the source of the interrupt.
@@ -2457,7 +2445,7 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 			  "Got MPI processor interrupt.\n");
 		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work_on(smp_processor_id(),
-				qdev->workqueue, &qdev->mpi_work, 0);
+				      qdev->workqueue, &qdev->mpi_work, 0);
 		work_done++;
 	}
 
@@ -3531,19 +3519,17 @@ static int ql_route_initialize(struct ql_adapter *qdev)
 		return status;
 
 	status = ql_set_routing_reg(qdev, RT_IDX_IP_CSUM_ERR_SLOT,
-						RT_IDX_IP_CSUM_ERR, 1);
+				    RT_IDX_IP_CSUM_ERR, 1);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
-			"Failed to init routing register "
-			"for IP CSUM error packets.\n");
+			  "Failed to init routing register for IP CSUM error packets.\n");
 		goto exit;
 	}
 	status = ql_set_routing_reg(qdev, RT_IDX_TCP_UDP_CSUM_ERR_SLOT,
-						RT_IDX_TU_CSUM_ERR, 1);
+				    RT_IDX_TU_CSUM_ERR, 1);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
-			"Failed to init routing register "
-			"for TCP/UDP CSUM error packets.\n");
+			  "Failed to init routing register for TCP/UDP CSUM error packets.\n");
 		goto exit;
 	}
 	status = ql_set_routing_reg(qdev, RT_IDX_BCAST_SLOT, RT_IDX_BCAST, 1);
@@ -3557,7 +3543,7 @@ static int ql_route_initialize(struct ql_adapter *qdev)
 	 */
 	if (qdev->rss_ring_count > 1) {
 		status = ql_set_routing_reg(qdev, RT_IDX_RSS_MATCH_SLOT,
-					RT_IDX_RSS_MATCH, 1);
+					    RT_IDX_RSS_MATCH, 1);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init routing register for MATCH RSS packets.\n");
@@ -3655,7 +3641,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 
 	/* Default WOL is enable on Mezz cards */
 	if (qdev->pdev->subsystem_device == 0x0068 ||
-			qdev->pdev->subsystem_device == 0x0180)
+	    qdev->pdev->subsystem_device == 0x0180)
 		qdev->wol = WAKE_MAGIC;
 
 	/* Start up the rx queues. */
@@ -3882,7 +3868,7 @@ static int ql_adapter_up(struct ql_adapter *qdev)
 	 * link is up the turn on the carrier.
 	 */
 	if ((ql_read32(qdev, STS) & qdev->port_init) &&
-			(ql_read32(qdev, STS) & qdev->port_link_up))
+	    (ql_read32(qdev, STS) & qdev->port_link_up))
 		ql_link_on(qdev);
 	/* Restore rx mode. */
 	clear_bit(QL_ALLMULTI, &qdev->flags);
@@ -4109,7 +4095,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 		return -EINVAL;
 
 	queue_delayed_work(qdev->workqueue,
-			&qdev->mpi_port_cfg_work, 3*HZ);
+			   &qdev->mpi_port_cfg_work, 3 * HZ);
 
 	ndev->mtu = new_mtu;
 
@@ -4268,7 +4254,8 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 	if (status)
 		return status;
 	status = ql_set_mac_addr_reg(qdev, (u8 *) ndev->dev_addr,
-			MAC_ADDR_TYPE_CAM_MAC, qdev->func * MAX_CQ);
+				     MAC_ADDR_TYPE_CAM_MAC,
+				     qdev->func * MAX_CQ);
 	if (status)
 		netif_err(qdev, hw, qdev->ndev, "Failed to load MAC address.\n");
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
@@ -4335,7 +4322,7 @@ static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
 	u32 nic_func1, nic_func2;
 
 	status = ql_read_mpi_reg(qdev, MPI_TEST_FUNC_PORT_CFG,
-			&temp);
+				 &temp);
 	if (status)
 		return status;
 
@@ -4583,7 +4570,8 @@ static int qlge_probe(struct pci_dev *pdev,
 	int err = 0;
 
 	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
-			min(MAX_CPUS, netif_get_num_default_rss_queues()));
+				 min(MAX_CPUS,
+				     netif_get_num_default_rss_queues()));
 	if (!ndev)
 		return -ENOMEM;
 
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 843b32240a73..bb03b2fa7233 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -134,7 +134,7 @@ static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	for (i = 0; i < mbcp->out_count; i++) {
 		status =
 		    ql_read_mpi_reg(qdev, qdev->mailbox_out + i,
-				     &mbcp->mbox_out[i]);
+				    &mbcp->mbox_out[i]);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev, "Failed mailbox read.\n");
 			break;
@@ -184,7 +184,7 @@ static int ql_exec_mb_cmd(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 */
 	for (i = 0; i < mbcp->in_count; i++) {
 		status = ql_write_mpi_reg(qdev, qdev->mailbox_in + i,
-						mbcp->mbox_in[i]);
+					  mbcp->mbox_in[i]);
 		if (status)
 			goto end;
 	}
@@ -293,7 +293,7 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 */
 		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work(qdev->workqueue,
-				&qdev->mpi_port_cfg_work, 0);
+				   &qdev->mpi_port_cfg_work, 0);
 	}
 
 	ql_link_on(qdev);
@@ -745,7 +745,7 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev)
 }
 
 static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
-	u32 size)
+			  u32 size)
 {
 	int status = 0;
 	struct mbox_params mbc;
@@ -779,14 +779,14 @@ static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
 
 /* Issue a mailbox command to dump RISC RAM. */
 int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf,
-		u32 ram_addr, int word_count)
+			  u32 ram_addr, int word_count)
 {
 	int status;
 	char *my_buf;
 	dma_addr_t buf_dma;
 
 	my_buf = pci_alloc_consistent(qdev->pdev, word_count * sizeof(u32),
-					&buf_dma);
+				      &buf_dma);
 	if (!my_buf)
 		return -EIO;
 
@@ -795,7 +795,7 @@ int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf,
 		memcpy(buf, my_buf, word_count * sizeof(u32));
 
 	pci_free_consistent(qdev->pdev, word_count * sizeof(u32), my_buf,
-				buf_dma);
+			    buf_dma);
 	return status;
 }
 
@@ -918,7 +918,7 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 		 */
 		wait_time =
 			wait_for_completion_timeout(&qdev->ide_completion,
-							wait_time);
+						    wait_time);
 		if (!wait_time) {
 			netif_err(qdev, drv, qdev->ndev, "IDC Timeout.\n");
 			break;
@@ -1125,8 +1125,7 @@ void ql_mpi_port_cfg_work(struct work_struct *work)
 	}
 
 	if (qdev->link_config & CFG_JUMBO_FRAME_SIZE &&
-			qdev->max_frame_size ==
-			CFG_DEFAULT_MAX_FRAME_SIZE)
+	    qdev->max_frame_size == CFG_DEFAULT_MAX_FRAME_SIZE)
 		goto end;
 
 	qdev->link_config |=	CFG_JUMBO_FRAME_SIZE;
@@ -1273,7 +1272,7 @@ void ql_mpi_reset_work(struct work_struct *work)
 		netif_err(qdev, drv, qdev->ndev, "Core is dumped!\n");
 		qdev->core_is_dumped = 1;
 		queue_delayed_work(qdev->workqueue,
-			&qdev->mpi_core_to_log, 5 * HZ);
+				   &qdev->mpi_core_to_log, 5 * HZ);
 	}
 	ql_soft_reset_mpi_risc(qdev);
 }
-- 
2.20.1

