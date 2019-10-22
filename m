Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FB8E0297
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbfJVLPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:15:09 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41992 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387542AbfJVLPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 07:15:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C52DE20064E;
        Tue, 22 Oct 2019 13:15:06 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B8A2820010A;
        Tue, 22 Oct 2019 13:15:06 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C0192060F;
        Tue, 22 Oct 2019 13:15:06 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v2 3/6] dpaa_eth: remove redundant code
Date:   Tue, 22 Oct 2019 14:14:58 +0300
Message-Id: <1571742901-22923-4-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
References: <1571742901-22923-1-git-send-email-madalin.bucur@nxp.com>
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

