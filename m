Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9326F94E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgIRJaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:30:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56920 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgIRJaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:30:39 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D3D811A0160;
        Fri, 18 Sep 2020 11:30:37 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 272C41A0057;
        Fri, 18 Sep 2020 11:30:35 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 635E0402C3;
        Fri, 18 Sep 2020 11:30:31 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [v2] dpaa2-eth: fix a build warning in dpmac.c
Date:   Fri, 18 Sep 2020 17:22:25 +0800
Message-Id: <20200918092225.21967-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below sparse warning in dpmac.c.
warning: cast to restricted __le64

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Fixed in right way.
---
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index 3ea51dd..a24b20f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -66,8 +66,8 @@ struct dpmac_cmd_get_counter {
 };
 
 struct dpmac_rsp_get_counter {
-	u64 pad;
-	u64 counter;
+	__le64 pad;
+	__le64 counter;
 };
 
 #endif /* _FSL_DPMAC_CMD_H */
-- 
2.7.4

