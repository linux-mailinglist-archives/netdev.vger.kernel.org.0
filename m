Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D96126597
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLSPVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:21:38 -0500
Received: from inva021.nxp.com ([92.121.34.21]:34106 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfLSPVg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 10:21:36 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 602A2200962;
        Thu, 19 Dec 2019 16:21:34 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 52CA0200422;
        Thu, 19 Dec 2019 16:21:34 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C7462203C8;
        Thu, 19 Dec 2019 16:21:33 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH 3/6] net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G
Date:   Thu, 19 Dec 2019 17:21:18 +0200
Message-Id: <1576768881-24971-4-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the only 10G PHY interface type defined at the moment the code
was developed was XGMII, although the PHY interface mode used was
not XGMII, XGMII was used everywhere in the code. This patch
renames the 10G interface mode to remove the ambiguity as more
PHY interface modes are possible.

Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 41c6fa200e74..e1901874c19f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -110,7 +110,7 @@ do {									\
 /* Interface Mode Register (IF_MODE) */
 
 #define IF_MODE_MASK		0x00000003 /* 30-31 Mask on i/f mode bits */
-#define IF_MODE_XGMII		0x00000000 /* 30-31 XGMII (10G) interface */
+#define IF_MODE_10G		0x00000000 /* 30-31 10G interface */
 #define IF_MODE_GMII		0x00000002 /* 30-31 GMII (1G) interface */
 #define IF_MODE_RGMII		0x00000004
 #define IF_MODE_RGMII_AUTO	0x00008000
@@ -440,7 +440,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	tmp = 0;
 	switch (phy_if) {
 	case PHY_INTERFACE_MODE_XGMII:
-		tmp |= IF_MODE_XGMII;
+		tmp |= IF_MODE_10G;
 		break;
 	default:
 		tmp |= IF_MODE_GMII;
-- 
2.1.0

