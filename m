Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE39C685E24
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 05:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjBAEEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 23:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjBAEEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 23:04:37 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A073B457C0;
        Tue, 31 Jan 2023 20:04:31 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VMj67G008260;
        Tue, 31 Jan 2023 20:04:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=y1bWAoQwDCisxlh9pZlz7FoeUoSd9CHu/MlmbLIzVOM=;
 b=FflzD2OZ/CPgPrH/xyX7H+nOhv6C3PfB+1/MkYUT46v+fa+l9Bwsp+8mV4DM9qZEtPEl
 boPDmUmnerXZhI0VLo8fiSp242MJWgis8mnTr+4+ZsTdfyOpBlgMr8DRjY8QrhrXykQd
 h0UdxZ3kUgbO69KarjfAu2ngjaF9ZOqmSAs3iHg1b05Xac5BneFxTkWyBl2CMTslUU7O
 aNs7UhmbBOD2MPpv9j3lmQntquK4QQSakhDObki3rFKMujxCW0z0GSfBMyTEUAGsOeti
 jGv7SQp7W/QDW7Sv9bEDHBdNEu6cYBZoFmigTro9ZI1XG2hkVEyufix5ySJZCvSaqvsB Ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nd442vmu4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 20:04:21 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 31 Jan
 2023 20:03:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 31 Jan 2023 20:03:06 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id A468E3F70DC;
        Tue, 31 Jan 2023 20:03:03 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v1] octeontx2-af: Removed unnecessary debug messages.
Date:   Wed, 1 Feb 2023 09:33:01 +0530
Message-ID: <20230201040301.1034843-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PKkPIdpjXqXcaEMn0fywGNowunrsRclX
X-Proofpoint-ORIG-GUID: PKkPIdpjXqXcaEMn0fywGNowunrsRclX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

NPC exact match feature is supported only on one silicon
variant, removed debug messages which print that this
feature is not available on all other silicon variants.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 .../marvell/octeontx2/af/rvu_npc_hash.c        | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index f69102d20c90..20ebb9c95c73 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -200,10 +200,8 @@ void npc_config_secret_key(struct rvu *rvu, int blkaddr)
 	struct rvu_hwinfo *hw = rvu->hw;
 	u8 intf;
 
-	if (!hwcap->npc_hash_extract) {
-		dev_info(rvu->dev, "HW does not support secret key configuration\n");
+	if (!hwcap->npc_hash_extract)
 		return;
-	}
 
 	for (intf = 0; intf < hw->npc_intfs; intf++) {
 		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf),
@@ -221,10 +219,8 @@ void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
 	struct rvu_hwinfo *hw = rvu->hw;
 	u8 intf;
 
-	if (!hwcap->npc_hash_extract) {
-		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
+	if (!hwcap->npc_hash_extract)
 		return;
-	}
 
 	for (intf = 0; intf < hw->npc_intfs; intf++) {
 		npc_program_mkex_hash_rx(rvu, blkaddr, intf);
@@ -1853,19 +1849,13 @@ int rvu_npc_exact_init(struct rvu *rvu)
 
 	/* Check exact match feature is supported */
 	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
-	if (!(npc_const3 & BIT_ULL(62))) {
-		dev_info(rvu->dev, "%s: No support for exact match support\n",
-			 __func__);
+	if (!(npc_const3 & BIT_ULL(62)))
 		return 0;
-	}
 
 	/* Check if kex profile has enabled EXACT match nibble */
 	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
-	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
-		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
-			 __func__);
+	if (!(cfg & NPC_EXACT_NIBBLE_HIT))
 		return 0;
-	}
 
 	/* Set capability to true */
 	rvu->hw->cap.npc_exact_match_enabled = true;
-- 
2.25.1

