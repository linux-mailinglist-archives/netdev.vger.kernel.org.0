Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0522C11BB37
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfLKSPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:12 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36063 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbfLKSPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:07 -0500
Received: by mail-yw1-f66.google.com with SMTP id n184so2543765ywc.3;
        Wed, 11 Dec 2019 10:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wf4U8S55NS29nIX2MAXcq5psdR7k5pO3qtIDUjhcvoE=;
        b=A3mlfrRSpEtlwdK9iTaJ3EpY39raLid+/qUwTN5+vyRDDMDIjbwvHnM10sR5yHIBNq
         SZ+VL+4otOYDgMUsCIa7pEPz+DbvS+TZRNSAuaPno9bX8VgaXfSUhJ+SuOB7mLySl2dG
         KTImdrrEtkkDuOAg859Y7y+jZ6oEfDqh3JbLFaY2n1BInC2WD99L3gktOjGzG8i6ApUn
         04XBtbBtUV9gRYTFaZG6ki3Pw2BuWxzTRkX0hRWsrPWXd56NCddJ56kOko6VKfhU38hv
         T5PL2u7UWhi7idmjkTwkZw/HE9AL7rMWsR8Br9zwGGciN/HDsy78BJi+btcwMZRPVeju
         tK6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wf4U8S55NS29nIX2MAXcq5psdR7k5pO3qtIDUjhcvoE=;
        b=QAupXBMdF9TzasiM9VO6qNq3u0GOyzNK5rndsw59R84pw8vakY9QNEyCDHaanYXXQe
         EKtPtLI+s/FKZ5vQFYXOQBUe9ppE2jw30qt52GZpJAGf3pfvTkpzAkqvekjdfzNGEVYo
         FZe6NMwCJ8wvRhNeCBXV9IxmQKtPgVatxUzvbcAke9sx+ZbGAqqlUFrgNLqRgnuiDKJB
         NNqwijOeIOhoCHQsqrOUjwDcLZ6FqV5J77kjRXB5N0ynjc0A36g637sJgJlW/Z4Ho3cm
         F8xtXvNPSKMK48VK+6Bas/ZFSXuV1EJh144SnIk8JOlGaLaDrh3aX+3fAZOu/f8/VzL4
         3daA==
X-Gm-Message-State: APjAAAVHAfbg6BXoIfNo3pmS4SV4k5tQSwJkDjFWbImR6yosPUQO1M3w
        GoNYTLeL/393OeGFLDvZOi1hQdRI5TZBSA==
X-Google-Smtp-Source: APXvYqzFyjmE+1u8XWATNn1K+5u8H7GFptU3mVAg5nxKYFiHRBp9lsQrZseAywZ67jeoUsunKcsHgg==
X-Received: by 2002:a0d:e982:: with SMTP id s124mr840401ywe.435.1576088105381;
        Wed, 11 Dec 2019 10:15:05 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id e63sm1276152ywd.64.2019.12.11.10.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:05 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/23] staging: qlge: Fix CHECK extra blank lines in many files
Date:   Wed, 11 Dec 2019 12:12:30 -0600
Message-Id: <9387760ae35bdeb606dc03ca9dd167f5214cd3a8.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Please don't use multiple blank lines in qlge.h, qlge_dbg.c,
qlge_ethtool.c, qlge_main.c, and qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h         | 1 -
 drivers/staging/qlge/qlge_dbg.c     | 4 ----
 drivers/staging/qlge/qlge_ethtool.c | 1 -
 drivers/staging/qlge/qlge_main.c    | 2 --
 drivers/staging/qlge/qlge_mpi.c     | 5 -----
 5 files changed, 13 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 57884aac308f..4bc5d5fce9bf 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -63,7 +63,6 @@
 #define UDELAY_COUNT 3
 #define UDELAY_DELAY 100
 
-
 #define TX_DESC_PER_IOCB 8
 
 #if ((MAX_SKB_FRAGS - TX_DESC_PER_IOCB) + 2) > 0
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 1fe16602ece8..c82a38c1b770 100644
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
@@ -1227,7 +1225,6 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 {
 	int i, status;
 
-
 	memset(&(mpi_coredump->mpi_global_header), 0,
 	       sizeof(struct mpi_coredump_global_header));
 	mpi_coredump->mpi_global_header.cookie = MPI_COREDUMP_COOKIE;
@@ -1238,7 +1235,6 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
 		sizeof(mpi_coredump->mpi_global_header.id_string));
 
-
 	/* segment 16 */
 	ql_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
 				     MISC_NIC_INFO_SEG_NUM,
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index ea7bc6f2dde2..792b4d754ab8 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -32,7 +32,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 
-
 #include "qlge.h"
 
 struct ql_stats {
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 29861f01ca26..b2f826822a51 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -207,7 +207,6 @@ static int ql_wait_cfg(struct ql_adapter *qdev, u32 bit)
 	return -ETIMEDOUT;
 }
 
-
 /* Used to issue init control blocks to hw. Maps control block,
  * sets address, triggers download, waits for completion.
  */
@@ -2641,7 +2640,6 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-
 static void ql_free_shadow_space(struct ql_adapter *qdev)
 {
 	if (qdev->rx_ring_shadow_reg_area) {
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 9e422bbbb6ab..843b32240a73 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -544,7 +544,6 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	if (status)
 		goto end;
 
-
 	/* If we're generating a system error, then there's nothing
 	 * to wait for.
 	 */
@@ -730,7 +729,6 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev)
 	mbcp->mbox_in[1] = qdev->link_config;
 	mbcp->mbox_in[2] = qdev->max_frame_size;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -768,7 +766,6 @@ static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
 	mbcp->mbox_in[7] = LSW(MSD(req_dma));
 	mbcp->mbox_in[8] = MSW(addr);
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -850,7 +847,6 @@ int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol)
 	mbcp->mbox_in[0] = MB_CMD_SET_WOL_MODE;
 	mbcp->mbox_in[1] = wol;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
@@ -965,7 +961,6 @@ int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config)
 	mbcp->mbox_in[0] = MB_CMD_SET_LED_CFG;
 	mbcp->mbox_in[1] = led_config;
 
-
 	status = ql_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
-- 
2.20.1

