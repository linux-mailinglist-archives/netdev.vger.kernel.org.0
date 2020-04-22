Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC61B4C2D
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgDVRxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:53:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56102 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgDVRxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 13:53:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7A6401A12ED;
        Wed, 22 Apr 2020 19:52:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6EC0D1A0EE7;
        Wed, 22 Apr 2020 19:52:58 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 38B5D2030B;
        Wed, 22 Apr 2020 19:52:58 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] MAINTAINERS: update dpaa2-eth maintainer list
Date:   Wed, 22 Apr 2020 20:52:54 +0300
Message-Id: <20200422175254.2646-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add myself as another maintainer of dpaa2-eth.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6851ef7cf1bd..d5e4d13880b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5173,6 +5173,7 @@ S:	Maintained
 F:	drivers/soc/fsl/dpio
 
 DPAA2 ETHERNET DRIVER
+M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.17.1

