Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015D311BB7D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbfLKSQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:59 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37289 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731125AbfLKSPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:15 -0500
Received: by mail-yb1-f195.google.com with SMTP id x139so9399057ybe.4;
        Wed, 11 Dec 2019 10:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZXx8l/KZR9WA/iLmy6R3NDKrk90jnB1w9ZPxl/FOlyA=;
        b=ARRfo75caDlaUM77eb9NKZr7s/hpRohQ4HGRG0FRSrHEI+miHD5iMIscYEQRdwjftZ
         WXRG2nO+AHuhNonEp4gnSS51mMBorNML4802ZpMBOpp1869MpJk8POi8iGKA+cN9iSIf
         QVhVAvfRrDEUlAgWSZUhZZhNPkcsQVrKMBw9zBFxPKsxlpcO6UtoeaHseQizxGf3bAWV
         7ALww8cBfK7DaCMD84RkRtD8yUr9b2kMaITXc7SPU4ygffVhvpIKJaR7ApZYwHfMPWSF
         AwhVe6RYQFNMIpq1c0bQ7D44YEItov48Rnb3MQ6a8Dtx+huWhkFflnSA6GmZxVfviHzR
         4YjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZXx8l/KZR9WA/iLmy6R3NDKrk90jnB1w9ZPxl/FOlyA=;
        b=RsWET3b/WRg/qymbn34SnaWdG4hBZP1GKHEnCYlEtj43nnK+UGA9AvUbdtziJ7ZyQ5
         cPJPAgTsJEYqleU7s69X8qu/CIF69XvIYWhAbbuA7PCEu5EOwiNUSOlnW5BPqwHQa3bU
         uARQBUSl8jXsmkf6+R9ci8k0sjsdjxUzD8rMwsQ8okhyyT8fnNbfB0Z7pwVJ6DGY0vE/
         2kquVT9vwu/tRr163F+d0sz/HTQulDBojt1VIGcVOw3HDBuXsJgEfa2F+hWAmyMIwO0k
         zrB/zd2+7rnpmdCrjQnDTmotFPZilMyIdKKH8axbuGRZRcorGJYjKZHzDKtZH2hHWeMD
         T5ig==
X-Gm-Message-State: APjAAAUedTUpOSKBAtOeF6VvGHb3wLbcpF4FH4Gw6lJfMNfuOSOGKGcV
        YTsP7nVx+G+NoKMARa91xuxJYR7GOpgPPg==
X-Google-Smtp-Source: APXvYqwiW7be29TyHRSkp63bTis8H0+I9y8yxv7gHYZM74/5pzH8MtPi0+eDz8hszKlRg7d/ExEDkw==
X-Received: by 2002:a25:76c7:: with SMTP id r190mr1008957ybc.214.1576088113095;
        Wed, 11 Dec 2019 10:15:13 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id a23sm1299972ywa.32.2019.12.11.10.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:12 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/23] staging: qlge: Fix CHECK: Blank lines aren't necessary after an open brace '{'
Date:   Wed, 11 Dec 2019 12:12:35 -0600
Message-Id: <bf74d7ad7868f5b826b527ade55460658d32e53f.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix CHECK: Blank lines aren't necessary after an open brace '{' in the
following files:

qlge.h
qlge_dbg.c
qlge_main.c
qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h      | 3 ---
 drivers/staging/qlge/qlge_dbg.c  | 1 -
 drivers/staging/qlge/qlge_main.c | 6 ------
 drivers/staging/qlge/qlge_mpi.c  | 2 --
 4 files changed, 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index d45c53a053c2..ede767a70b10 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -119,7 +119,6 @@ enum {
  * Processor Address Register (PROC_ADDR) bit definitions.
  */
 enum {
-
 	/* Misc. stuff */
 	MAILBOX_COUNT = 16,
 	MAILBOX_TIMEOUT = 5,
@@ -1762,7 +1761,6 @@ struct ql_nic_misc {
 };
 
 struct ql_reg_dump {
-
 	/* segment 0 */
 	struct mpi_coredump_global_header mpi_global_header;
 
@@ -2059,7 +2057,6 @@ enum {
 };
 
 struct nic_operations {
-
 	int (*get_flash) (struct ql_adapter *);
 	int (*port_initialize) (struct ql_adapter *);
 };
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index b44f80e93b27..6b740a712943 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -610,7 +610,6 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 
 	for (type = 0; type < MAC_ADDR_TYPE_COUNT; type++) {
 		switch (type) {
-
 		case 0: /* CAM */
 			initial_val |= MAC_ADDR_ADR;
 			max_index = MAC_ADDR_MAX_CAM_ENTRIES;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1a5b82b68b44..f5cc235e9854 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2119,7 +2119,6 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 	struct tx_ring *tx_ring;
 	/* While there are entries in the completion queue. */
 	while (prod != rx_ring->cnsmr_idx) {
-
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
 			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
@@ -2127,7 +2126,6 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 		net_rsp = (struct ob_mac_iocb_rsp *)rx_ring->curr_entry;
 		rmb();
 		switch (net_rsp->opcode) {
-
 		case OPCODE_OB_MAC_TSO_IOCB:
 		case OPCODE_OB_MAC_IOCB:
 			ql_process_mac_tx_intr(qdev, net_rsp);
@@ -2166,7 +2164,6 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 
 	/* While there are entries in the completion queue. */
 	while (prod != rx_ring->cnsmr_idx) {
-
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
 			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
@@ -2479,7 +2476,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 
 static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 {
-
 	if (skb_is_gso(skb)) {
 		int err;
 		__be16 l3_proto = vlan_get_protocol(skb);
@@ -2886,7 +2882,6 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 				 struct rx_ring *rx_ring)
 {
-
 	/*
 	 * Allocate the completion queue for this rx_ring.
 	 */
@@ -3815,7 +3810,6 @@ static int ql_wol(struct ql_adapter *qdev)
 
 static void ql_cancel_all_work_sync(struct ql_adapter *qdev)
 {
-
 	/* Don't kill the reset worker thread if we
 	 * are in the process of recovery.
 	 */
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 0f9bd9a8b523..4f8365cf2092 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -360,7 +360,6 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		for (i = 0; i < mbcp->out_count; i++)
 			netif_err(qdev, drv, qdev->ndev, "mbox_out[%d] = 0x%.08x.\n",
 				  i, mbcp->mbox_out[i]);
-
 	}
 	return status;
 }
@@ -407,7 +406,6 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	}
 
 	switch (mbcp->mbox_out[0]) {
-
 	/* This case is only active when we arrive here
 	 * as a result of issuing a mailbox command to
 	 * the firmware.
-- 
2.20.1

