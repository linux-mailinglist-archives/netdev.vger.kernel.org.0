Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DC67E0A0
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 10:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjA0Jr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 04:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbjA0JrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 04:47:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086CF7A4AC;
        Fri, 27 Jan 2023 01:47:15 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R8CLE5005980;
        Fri, 27 Jan 2023 01:47:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ysJfYatCKfErNMHr3h7K9HldML90KLd30l3omuP/v5U=;
 b=gK48+KpZ/glq1jvHlizW6eW4PcwYYPa26o95ZsOlgDlJlPiq2xt+Dkw5wOT3cKiYeM+u
 L8WulPI4HPD/g3zddiHMow7hz7ADn1obRZFxsss6u48WRyvdlV+ghfAH0ZBxORCkuJft
 bGrGvGtcQytsvHduaIIbwuDvBsM3D1O5QT+y0klj1vF0QqPAySRxpRh8YFDCXV3mIrg5
 fLmQ1QiDFBOSHE6I+/PoA3UVRRsSONjvYfxihWrOfphDLFaSozjLPncBLSYuj1ZfIsCB
 bDW/PlN2Au0BSAqDSx68RPlP9JzT28m5hqHApadA41CYALO5RptypsxC1rxvl37aq17d jw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nbpc93xrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 01:47:04 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 27 Jan
 2023 01:47:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 27 Jan 2023 01:47:02 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 7E6ED3F7040;
        Fri, 27 Jan 2023 01:47:00 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sgoutham@marvell.com>
Subject: [net PATCH] octeontx2-af: Removed unnecessary debug messages.
Date:   Fri, 27 Jan 2023 15:16:52 +0530
Message-ID: <20230127094652.666693-2-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127094652.666693-1-rkannoth@marvell.com>
References: <20230127094652.666693-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 3FkLirKToAfaRSgYtH2D4MaxFr4nF4r7
X-Proofpoint-ORIG-GUID: 3FkLirKToAfaRSgYtH2D4MaxFr4nF4r7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_05,2023-01-27_01,2022-06-22_01
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

Fixes: b747923afff8 ("octeontx2-af: Exact match support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c    | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index f69102d20c90..2c832469229b 100644
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
@@ -1854,16 +1850,12 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	/* Check exact match feature is supported */
 	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
 	if (!(npc_const3 & BIT_ULL(62))) {
-		dev_info(rvu->dev, "%s: No support for exact match support\n",
-			 __func__);
 		return 0;
 	}
 
 	/* Check if kex profile has enabled EXACT match nibble */
 	cfg = rvu_read64(rvu, blkaddr, NPC_AF_INTFX_KEX_CFG(NIX_INTF_RX));
 	if (!(cfg & NPC_EXACT_NIBBLE_HIT)) {
-		dev_info(rvu->dev, "%s: NPC exact match nibble not enabled in KEX profile\n",
-			 __func__);
 		return 0;
 	}
 
@@ -2005,6 +1997,5 @@ int rvu_npc_exact_init(struct rvu *rvu)
 		(*drop_mcam_idx)++;
 	}
 
-	dev_info(rvu->dev, "initialized exact match table successfully\n");
 	return 0;
 }
-- 
2.25.1

