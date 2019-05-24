Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0129AC7
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389908AbfEXPPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:15:23 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43748 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389314AbfEXPPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 11:15:21 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A836A20048E;
        Fri, 24 May 2019 17:15:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 998C6200483;
        Fri, 24 May 2019 17:15:19 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 39497205EF;
        Fri, 24 May 2019 17:15:19 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net 3/3] dpaa2-eth: Make constant 64-bit long
Date:   Fri, 24 May 2019 18:15:17 +0300
Message-Id: <1558710917-4555-4-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1558710917-4555-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function dpaa2_eth_cls_key_size() expects a 64bit argument,
but DPAA2_ETH_DIST_ALL is defined as UINT_MAX. Fix this.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 5fb8f5c..e180d5a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -467,7 +467,7 @@ enum dpaa2_eth_rx_dist {
 #define DPAA2_ETH_DIST_IPPROTO		BIT(6)
 #define DPAA2_ETH_DIST_L4SRC		BIT(7)
 #define DPAA2_ETH_DIST_L4DST		BIT(8)
-#define DPAA2_ETH_DIST_ALL		(~0U)
+#define DPAA2_ETH_DIST_ALL		(~0ULL)
 
 static inline
 unsigned int dpaa2_eth_needed_headroom(struct dpaa2_eth_priv *priv,
-- 
2.7.4

