Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004B9CB743
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbfJDJWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:22:06 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40102 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfJDJWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 05:22:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 73AF12002D7;
        Fri,  4 Oct 2019 11:22:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 7188820028D;
        Fri,  4 Oct 2019 11:22:04 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 3A3AE205EF;
        Fri,  4 Oct 2019 11:22:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 1/3] dpaa2-eth: Cleanup dead code
Date:   Fri,  4 Oct 2019 12:21:31 +0300
Message-Id: <1570180893-9538-2-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1570180893-9538-1-git-send-email-ioana.ciornei@nxp.com>
References: <1570180893-9538-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

Remove one function call whose result was not used anywhere.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 162d7d8fb295..2c5072fa9aa0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2043,7 +2043,6 @@ static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
 {
 	struct fsl_mc_device *dpcon;
 	struct device *dev = priv->net_dev->dev.parent;
-	struct dpcon_attr attrs;
 	int err;
 
 	err = fsl_mc_object_allocate(to_fsl_mc_device(dev),
@@ -2068,12 +2067,6 @@ static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
 		goto close;
 	}
 
-	err = dpcon_get_attributes(priv->mc_io, 0, dpcon->mc_handle, &attrs);
-	if (err) {
-		dev_err(dev, "dpcon_get_attributes() failed\n");
-		goto close;
-	}
-
 	err = dpcon_enable(priv->mc_io, 0, dpcon->mc_handle);
 	if (err) {
 		dev_err(dev, "dpcon_enable() failed\n");
-- 
1.9.1

