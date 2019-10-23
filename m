Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B2EE155F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403761AbfJWJJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:09:13 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34192 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390604AbfJWJJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 05:09:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 564361A0137;
        Wed, 23 Oct 2019 11:09:11 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 47AD71A0016;
        Wed, 23 Oct 2019 11:09:11 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 02124205FE;
        Wed, 23 Oct 2019 11:09:10 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        jakub.kicinski@netronome.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v3 3/7] dpaa_eth: remove redundant code
Date:   Wed, 23 Oct 2019 12:08:42 +0300
Message-Id: <1571821726-6624-4-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
References: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Condition was previously checked, removing duplicate code.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 75eeb2ef409f..8d5686d88d30 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2304,10 +2304,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
 
-	dpaa_bp = dpaa_bpid2pool(fd->bpid);
-	if (!dpaa_bp)
-		return qman_cb_dqrr_consume;
-
 	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
 
 	/* prefetch the first 64 bytes of the frame or the SGT start */
-- 
2.1.0

