Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D236810AFAB
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 13:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0MkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 07:40:05 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:50422 "EHLO
        faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbfK0MkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 07:40:04 -0500
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2019 07:40:03 EST
Received: from faui04s.informatik.uni-erlangen.de (faui04s.informatik.uni-erlangen.de [131.188.30.149])
        by faui03.informatik.uni-erlangen.de (Postfix) with ESMTP id D13B1241838;
        Wed, 27 Nov 2019 13:31:02 +0100 (CET)
Received: by faui04s.informatik.uni-erlangen.de (Postfix, from userid 66121)
        id AE1FE15E15AC; Wed, 27 Nov 2019 13:31:02 +0100 (CET)
From:   Dorothea Ehrl <dorothea.ehrl@fau.de>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc:     linux-kernel@i4.cs.fau.de, Dorothea Ehrl <dorothea.ehrl@fau.de>,
        Vanessa Hack <vanessa.hack@fau.de>
Subject: [PATCH 5/5] staging/qlge: fix block comment coding style
Date:   Wed, 27 Nov 2019 13:30:52 +0100
Message-Id: <20191127123052.16424-5-dorothea.ehrl@fau.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127123052.16424-1-dorothea.ehrl@fau.de>
References: <20191127123052.16424-1-dorothea.ehrl@fau.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes:
"WARNING: block comment use * on subsequent lines"
"WARNING: block comments should align the * on each line"
"WARNING: block comments use a trailing */ on a separate line"
by checkpatch.pl.

Signed-off-by: Dorothea Ehrl <dorothea.ehrl@fau.de>
Co-developed-by: Vanessa Hack <vanessa.hack@fau.de>
Signed-off-by: Vanessa Hack <vanessa.hack@fau.de>
---
 drivers/staging/qlge/qlge_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index d19709bcdc20..29861f01ca26 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -402,8 +402,8 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 				   (index << MAC_ADDR_IDX_SHIFT) |	/* index */
 				   type);	/* type */
 			/* This field should also include the queue id
-			   and possibly the function id.  Right now we hardcode
-			   the route field to NIC core.
+			 * and possibly the function id.  Right now we hardcode
+			 * the route field to NIC core.
 			 */
 			cam_output = (CAM_OUT_ROUTE_NIC |
 				      (qdev->
@@ -683,7 +683,7 @@ static int ql_read_flash_word(struct ql_adapter *qdev, int offset, __le32 *data)
 			FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
-	 /* This data is stored on flash as an array of
+	/* This data is stored on flash as an array of
 	 * __le32.  Since ql_read32() returns cpu endian
 	 * we need to swap it back.
 	 */
@@ -2223,7 +2223,8 @@ static int ql_napi_poll_msix(struct napi_struct *napi, int budget)
 		     "Enter, NAPI POLL cq_id = %d.\n", rx_ring->cq_id);

 	/* Service the TX rings first.  They start
-	 * right after the RSS rings. */
+	 * right after the RSS rings.
+	 */
 	for (i = qdev->rss_ring_count; i < qdev->rx_ring_count; i++) {
 		trx_ring = &qdev->rx_ring[i];
 		/* If this TX completion ring belongs to this vector and
@@ -2888,7 +2889,8 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 }

 /* Allocate queues and buffers for this completions queue based
- * on the values in the parameter structure. */
+ * on the values in the parameter structure.
+ */
 static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 				 struct rx_ring *rx_ring)
 {
--
2.20.1

