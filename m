Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A97D1925
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731851AbfJITmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:42:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39043 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJITmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:42:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so4474845wrj.6;
        Wed, 09 Oct 2019 12:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xoxulzaRyQscCaDwFnb4tf9qTGZ4dgmiLRI8H9N5w10=;
        b=rYi9ESLX6zBUsE6NTnojGWjF5pvy/ML2823+WCyQukzz7I3j8k+xzTvM/tsSPw9+5Q
         JPpEscK1w/AuFsVLbIRjs3a7yqMTLU4h7wT0jgPpNNK31TUmpkFp3uco6Z7FCYvHEWzK
         3UfojMJMwFWm5bKEoiw1ZeUom4hi5ZCPD+teHzVFV+0Ls7iUmW/M3br14KJQzCiwP0Jc
         hOe2M1Q5hn2RYmTIyDL4u+0f8VXM3NhQxO1eofGT80AvBhR6HhQUVv5zEFWJ1PonXQaG
         /jyC9UcfQAV+8WAlNF6Cbl62A5QtZvT17VGpIBssZh9B9nNyMJela1XCwz1nAT3zgk+C
         fZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xoxulzaRyQscCaDwFnb4tf9qTGZ4dgmiLRI8H9N5w10=;
        b=dWeQ2RoAgYlTNj+QBMmKP8MxiqtIjyOaDNJqQe+IkZ5h1bDbdNO5nFWmbkGTjfM4Uz
         uLqxO59jQ5GrO3uTsFIS+/QVENLFhZdY0Zqy/6T7gO4PZUwSBM4ixzWgrCmqhxOPqztH
         MiADPbe6QtX+Ke6VjICSlOZVrYdpEYvYDT2Nl+P8XZ89q23IJkotN+Co0P1in7Sacqvq
         u+luImN5UXHw/8/yPPH/3hO2gS1hzVIovDmo42DsjG4lr3+vahk4MoD3r44+drz4P9iy
         xsAY1pMjc2nJqoQGvrzzbQmbNwg+3KrWZMj2N7LlLP72H3zpfIA8fjtqQLqoCbcGxlVs
         qK/A==
X-Gm-Message-State: APjAAAWfAwGjlA1OXlwhGf7dwmREhqk0v2VN/fKYXrsrGyq8PtVN/jqR
        svWrrbPBpAQW5l95ufCQrDA0SAZL2uTzgJI=
X-Google-Smtp-Source: APXvYqzcoDCKwU4qxutELYS4JgSQPSVUBPfHv/SLrCkaQ2lxyRP2AlwJZwOuEI6XiXdFi2LgZ6UpTg==
X-Received: by 2002:adf:a109:: with SMTP id o9mr4147787wro.96.1570650166340;
        Wed, 09 Oct 2019 12:42:46 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-13-201.as13285.net. [2.102.13.201])
        by smtp.googlemail.com with ESMTPSA id r65sm4102871wmr.9.2019.10.09.12.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 12:42:45 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     grekh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] staging: qlge: fix "alignment should match open parenthesis" checks
Date:   Wed,  9 Oct 2019 20:42:35 +0100
Message-Id: <20191009194235.5603-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix "alignment should mactch open parenthesis" checks
 issued by checkpatch.pl tool:
"CHECK: Alignment should match open parenthesis".

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 127 ++++++++++++++++----------------
 1 file changed, 64 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 086f067fd899..c57d7e722974 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -26,7 +26,7 @@ static u32 ql_read_other_func_reg(struct ql_adapter *qdev,
 
 /* Write a NIC register from the alternate function. */
 static int ql_write_other_func_reg(struct ql_adapter *qdev,
-					u32 reg, u32 reg_val)
+				   u32 reg, u32 reg_val)
 {
 	u32 register_to_read;
 	int status = 0;
@@ -41,7 +41,7 @@ static int ql_write_other_func_reg(struct ql_adapter *qdev,
 }
 
 static int ql_wait_other_func_reg_rdy(struct ql_adapter *qdev, u32 reg,
-					u32 bit, u32 err_bit)
+				      u32 bit, u32 err_bit)
 {
 	u32 temp;
 	int count = 10;
@@ -61,13 +61,13 @@ static int ql_wait_other_func_reg_rdy(struct ql_adapter *qdev, u32 reg,
 }
 
 static int ql_read_other_func_serdes_reg(struct ql_adapter *qdev, u32 reg,
-							u32 *data)
+					 u32 *data)
 {
 	int status;
 
 	/* wait for reg to come ready */
 	status = ql_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
-						XG_SERDES_ADDR_RDY, 0);
+					    XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
@@ -76,7 +76,7 @@ static int ql_read_other_func_serdes_reg(struct ql_adapter *qdev, u32 reg,
 
 	/* wait for reg to come ready */
 	status = ql_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
-						XG_SERDES_ADDR_RDY, 0);
+					    XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
@@ -111,7 +111,7 @@ static int ql_read_serdes_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
 }
 
 static void ql_get_both_serdes(struct ql_adapter *qdev, u32 addr,
-			u32 *direct_ptr, u32 *indirect_ptr,
+			       u32 *direct_ptr, u32 *indirect_ptr,
 			unsigned int direct_valid, unsigned int indirect_valid)
 {
 	unsigned int status;
@@ -133,7 +133,7 @@ static void ql_get_both_serdes(struct ql_adapter *qdev, u32 addr,
 }
 
 static int ql_get_serdes_regs(struct ql_adapter *qdev,
-				struct ql_mpi_coredump *mpi_coredump)
+			      struct ql_mpi_coredump *mpi_coredump)
 {
 	int status;
 	unsigned int xfi_direct_valid, xfi_indirect_valid, xaui_direct_valid;
@@ -146,7 +146,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	/* The XAUI needs to be read out per port */
 	status = ql_read_other_func_serdes_reg(qdev,
-			XG_SERDES_XAUI_HSS_PCS_START, &temp);
+					       XG_SERDES_XAUI_HSS_PCS_START,
+					       &temp);
 	if (status)
 		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
 
@@ -203,7 +204,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0; i <= 0x000000034; i += 4, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xaui_direct_valid, xaui_indirect_valid);
+				   xaui_direct_valid, xaui_indirect_valid);
 
 	/* Get XAUI_HSS_PCS register block. */
 	if (qdev->func & 1) {
@@ -220,7 +221,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0x800; i <= 0x880; i += 4, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xaui_direct_valid, xaui_indirect_valid);
+				   xaui_direct_valid, xaui_indirect_valid);
 
 	/* Get XAUI_XFI_AN register block. */
 	if (qdev->func & 1) {
@@ -233,7 +234,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0x1000; i <= 0x1034; i += 4, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_TRAIN register block. */
 	if (qdev->func & 1) {
@@ -248,7 +249,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0x1050; i <= 0x107c; i += 4, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_PCS register block. */
 	if (qdev->func & 1) {
@@ -265,7 +266,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0x1800; i <= 0x1838; i += 4, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_TX register block. */
 	if (qdev->func & 1) {
@@ -280,7 +281,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 	for (i = 0x1c00; i <= 0x1c1f; i++, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_RX register block. */
 	if (qdev->func & 1) {
@@ -296,7 +297,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 
 	for (i = 0x1c40; i <= 0x1c5f; i++, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 
 
 	/* Get XAUI_XFI_HSS_PLL register block. */
@@ -313,18 +314,18 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 	for (i = 0x1e00; i <= 0x1e1f; i++, direct_ptr++, indirect_ptr++)
 		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-					xfi_direct_valid, xfi_indirect_valid);
+				   xfi_direct_valid, xfi_indirect_valid);
 	return 0;
 }
 
 static int ql_read_other_func_xgmac_reg(struct ql_adapter *qdev, u32 reg,
-							u32 *data)
+					u32 *data)
 {
 	int status = 0;
 
 	/* wait for reg to come ready */
 	status = ql_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
-						XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+					    XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 
@@ -333,7 +334,7 @@ static int ql_read_other_func_xgmac_reg(struct ql_adapter *qdev, u32 reg,
 
 	/* wait for reg to come ready */
 	status = ql_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
-						XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+					    XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 
@@ -347,7 +348,7 @@ static int ql_read_other_func_xgmac_reg(struct ql_adapter *qdev, u32 reg,
  * skipping unused locations.
  */
 static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
-					unsigned int other_function)
+			     unsigned int other_function)
 {
 	int status = 0;
 	int i;
@@ -357,17 +358,17 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 		 * serveral locations that are non-responsive to reads.
 		 */
 		if ((i == 0x00000114) ||
-			(i == 0x00000118) ||
-			(i == 0x0000013c) ||
-			(i == 0x00000140) ||
-			(i > 0x00000150 && i < 0x000001fc) ||
-			(i > 0x00000278 && i < 0x000002a0) ||
-			(i > 0x000002c0 && i < 0x000002cf) ||
-			(i > 0x000002dc && i < 0x000002f0) ||
-			(i > 0x000003c8 && i < 0x00000400) ||
-			(i > 0x00000400 && i < 0x00000410) ||
-			(i > 0x00000410 && i < 0x00000420) ||
-			(i > 0x00000420 && i < 0x00000430) ||
+		    (i == 0x00000118) ||
+		    (i == 0x0000013c) ||
+		    (i == 0x00000140) ||
+		    (i > 0x00000150 && i < 0x000001fc) ||
+		    (i > 0x00000278 && i < 0x000002a0) ||
+		    (i > 0x000002c0 && i < 0x000002cf) ||
+		    (i > 0x000002dc && i < 0x000002f0) ||
+		    (i > 0x000003c8 && i < 0x00000400) ||
+		    (i > 0x00000400 && i < 0x00000410) ||
+		    (i > 0x00000410 && i < 0x00000420) ||
+		    (i > 0x00000420 && i < 0x00000430) ||
 			(i > 0x00000430 && i < 0x00000440) ||
 			(i > 0x00000440 && i < 0x00000450) ||
 			(i > 0x00000450 && i < 0x00000500) ||
@@ -410,7 +411,7 @@ static void ql_get_intr_states(struct ql_adapter *qdev, u32 *buf)
 
 	for (i = 0; i < qdev->rx_ring_count; i++, buf++) {
 		ql_write32(qdev, INTR_EN,
-				qdev->intr_context[i].intr_read_mask);
+			   qdev->intr_context[i].intr_read_mask);
 		*buf = ql_read32(qdev, INTR_EN);
 	}
 }
@@ -426,7 +427,7 @@ static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
 
 	for (i = 0; i < 16; i++) {
 		status = ql_get_mac_addr_reg(qdev,
-					MAC_ADDR_TYPE_CAM_MAC, i, value);
+					     MAC_ADDR_TYPE_CAM_MAC, i, value);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Failed read of mac index register\n");
@@ -438,7 +439,7 @@ static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
 	}
 	for (i = 0; i < 32; i++) {
 		status = ql_get_mac_addr_reg(qdev,
-					MAC_ADDR_TYPE_MULTI_MAC, i, value);
+					     MAC_ADDR_TYPE_MULTI_MAC, i, value);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Failed read of mac index register\n");
@@ -497,7 +498,7 @@ static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 *buf)
 
 /* Read the MPI Processor core registers */
 static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
-				u32 offset, u32 count)
+			   u32 offset, u32 count)
 {
 	int i, status = 0;
 	for (i = 0; i < count; i++, buf++) {
@@ -510,7 +511,7 @@ static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
 
 /* Read the ASIC probe dump */
 static unsigned int *ql_get_probe(struct ql_adapter *qdev, u32 clock,
-					u32 valid, u32 *buf)
+				  u32 valid, u32 *buf)
 {
 	u32 module, mux_sel, probe, lo_val, hi_val;
 
@@ -545,13 +546,13 @@ static int ql_get_probe_dump(struct ql_adapter *qdev, unsigned int *buf)
 	/* First we have to enable the probe mux */
 	ql_write_mpi_reg(qdev, MPI_TEST_FUNC_PRB_CTL, MPI_TEST_FUNC_PRB_EN);
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_SYS_CLOCK,
-			PRB_MX_ADDR_VALID_SYS_MOD, buf);
+			   PRB_MX_ADDR_VALID_SYS_MOD, buf);
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_PCI_CLOCK,
-			PRB_MX_ADDR_VALID_PCI_MOD, buf);
+			   PRB_MX_ADDR_VALID_PCI_MOD, buf);
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_XGM_CLOCK,
-			PRB_MX_ADDR_VALID_XGM_MOD, buf);
+			   PRB_MX_ADDR_VALID_XGM_MOD, buf);
 	buf = ql_get_probe(qdev, PRB_MX_ADDR_FC_CLOCK,
-			PRB_MX_ADDR_VALID_FC_MOD, buf);
+			   PRB_MX_ADDR_VALID_FC_MOD, buf);
 	return 0;
 
 }
@@ -666,7 +667,7 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 				result_index = 0;
 				while ((result_index & MAC_ADDR_MR) == 0) {
 					result_index = ql_read32(qdev,
-								MAC_ADDR_IDX);
+								 MAC_ADDR_IDX);
 				}
 				result_data = ql_read32(qdev, MAC_ADDR_DATA);
 				*buf = result_index;
@@ -740,7 +741,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 	/* Insert the global header */
 	memset(&(mpi_coredump->mpi_global_header), 0,
-		sizeof(struct mpi_coredump_global_header));
+	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
 	mpi_coredump->mpi_global_header.headerSize =
 		sizeof(struct mpi_coredump_global_header);
@@ -751,23 +752,23 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 	/* Get generic NIC reg dump */
 	ql_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
-			NIC1_CONTROL_SEG_NUM,
+				     NIC1_CONTROL_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->nic_regs), "NIC1 Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->nic2_regs_seg_hdr,
-			NIC2_CONTROL_SEG_NUM,
+				     NIC2_CONTROL_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->nic2_regs), "NIC2 Registers");
 
 	/* Get XGMac registers. (Segment 18, Rev C. step 21) */
 	ql_build_coredump_seg_header(&mpi_coredump->xgmac1_seg_hdr,
-			NIC1_XGMAC_SEG_NUM,
+				     NIC1_XGMAC_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->xgmac1), "NIC1 XGMac Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xgmac2_seg_hdr,
-			NIC2_XGMAC_SEG_NUM,
+				     NIC2_XGMAC_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->xgmac2), "NIC2 XGMac Registers");
 
@@ -798,14 +799,14 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 	/* Rev C. Step 20a */
 	ql_build_coredump_seg_header(&mpi_coredump->xaui_an_hdr,
-			XAUI_AN_SEG_NUM,
+				     XAUI_AN_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xaui_an),
 			"XAUI AN Registers");
 
 	/* Rev C. Step 20b */
 	ql_build_coredump_seg_header(&mpi_coredump->xaui_hss_pcs_hdr,
-			XAUI_HSS_PCS_SEG_NUM,
+				     XAUI_HSS_PCS_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xaui_hss_pcs),
 			"XAUI HSS PCS Registers");
@@ -816,31 +817,31 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 			"XFI AN Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi_train_hdr,
-			XFI_TRAIN_SEG_NUM,
+				     XFI_TRAIN_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xfi_train),
 			"XFI TRAIN Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_pcs_hdr,
-			XFI_HSS_PCS_SEG_NUM,
+				     XFI_HSS_PCS_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xfi_hss_pcs),
 			"XFI HSS PCS Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_tx_hdr,
-			XFI_HSS_TX_SEG_NUM,
+				     XFI_HSS_TX_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xfi_hss_tx),
 			"XFI HSS TX Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_rx_hdr,
-			XFI_HSS_RX_SEG_NUM,
+				     XFI_HSS_RX_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xfi_hss_rx),
 			"XFI HSS RX Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_pll_hdr,
-			XFI_HSS_PLL_SEG_NUM,
+				     XFI_HSS_PLL_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes_xfi_hss_pll),
 			"XFI HSS PLL Registers");
@@ -858,7 +859,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 			"XAUI2 HSS PCS Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi2_an_hdr,
-			XFI2_AN_SEG_NUM,
+				     XFI2_AN_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes2_xfi_an),
 			"XFI2 AN Registers");
@@ -870,7 +871,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 			"XFI2 TRAIN Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pcs_hdr,
-			XFI2_HSS_PCS_SEG_NUM,
+				     XFI2_HSS_PCS_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes2_xfi_hss_pcs),
 			"XFI2 HSS PCS Registers");
@@ -882,13 +883,13 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 			"XFI2 HSS TX Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_rx_hdr,
-			XFI2_HSS_RX_SEG_NUM,
+				     XFI2_HSS_RX_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes2_xfi_hss_rx),
 			"XFI2 HSS RX Registers");
 
 	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pll_hdr,
-			XFI2_HSS_PLL_SEG_NUM,
+				     XFI2_HSS_PLL_SEG_NUM,
 			sizeof(struct mpi_coredump_segment_header) +
 			sizeof(mpi_coredump->serdes2_xfi_hss_pll),
 			"XFI2 HSS PLL Registers");
@@ -943,10 +944,10 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 	/* Get the FCMAC1 Registers */
 	ql_build_coredump_seg_header(&mpi_coredump->fcmac1_regs_seg_hdr,
-				FCMAC1_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->fcmac1_regs),
-				"FCMAC1 Registers");
+				     FCMAC1_SEG_NUM,
+				     sizeof(struct mpi_coredump_segment_header)
+				     + sizeof(mpi_coredump->fcmac1_regs),
+				     "FCMAC1 Registers");
 	status = ql_get_mpi_regs(qdev, &mpi_coredump->fcmac1_regs[0],
 				 FCMAC1_REGS_ADDR, FCMAC_REGS_CNT);
 	if (status)
@@ -1141,7 +1142,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 		goto err;
 
 	ql_build_coredump_seg_header(&mpi_coredump->mac_prot_reg_seg_hdr,
-				MAC_PROTOCOL_SEG_NUM,
+					MAC_PROTOCOL_SEG_NUM,
 				sizeof(struct mpi_coredump_segment_header)
 				+ sizeof(mpi_coredump->mac_prot_regs),
 				"MAC Prot Regs");
@@ -1991,7 +1992,7 @@ void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
 		       le16_to_cpu(ib_mac_rsp->vlan_id));
 
 	pr_err("flags4 = %s%s%s\n",
-		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
+	       ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
 		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS ? "HS " : "",
 		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HL ? "HL " : "");
 
-- 
2.21.0

