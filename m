Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6209E1563
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403782AbfJWJJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:09:20 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55848 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403767AbfJWJJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 05:09:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6E975200137;
        Wed, 23 Oct 2019 11:09:14 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 61F5E2000DF;
        Wed, 23 Oct 2019 11:09:14 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 1C407205FE;
        Wed, 23 Oct 2019 11:09:14 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        jakub.kicinski@netronome.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v3 7/7] dpaa_eth: add newline in dev_err() msg
Date:   Wed, 23 Oct 2019 12:08:46 +0300
Message-Id: <1571821726-6624-8-git-send-email-madalin.bucur@nxp.com>
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

Newline was missing at the end of the error message.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index e376c32fa003..d3214541c7c5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -901,7 +901,7 @@ static void dpaa_fq_setup(struct dpaa_priv *priv,
 
 	if (num_portals == 0)
 		dev_err(priv->net_dev->dev.parent,
-			"No Qman software (affine) channels found");
+			"No Qman software (affine) channels found\n");
 
 	/* Initialize each FQ in the list */
 	list_for_each_entry(fq, &priv->dpaa_fq_list, list) {
-- 
2.1.0

