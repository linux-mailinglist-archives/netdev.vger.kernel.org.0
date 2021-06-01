Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED6E397182
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhFAKda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:33:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39970 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhFAKd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 06:33:29 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lo1gW-0000NA-BW; Tue, 01 Jun 2021 10:31:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Fix spelling mistake "vesion" -> "version"
Date:   Tue,  1 Jun 2021 11:31:44 +0100
Message-Id: <20210601103144.9213-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a dev_warning message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index bd63305ba6d2..053cc872d0cc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1371,7 +1371,7 @@ static int npc_apply_custom_kpu(struct rvu *rvu,
 	if (NPC_KPU_VER_MIN(profile->version) <
 	    NPC_KPU_VER_MIN(NPC_KPU_PROFILE_VER)) {
 		dev_warn(rvu->dev,
-			 "Invalid KPU profile version: %d.%d.%d expected vesion <= %d.%d.%d\n",
+			 "Invalid KPU profile version: %d.%d.%d expected version <= %d.%d.%d\n",
 			 NPC_KPU_VER_MAJ(profile->version),
 			 NPC_KPU_VER_MIN(profile->version),
 			 NPC_KPU_VER_PATCH(profile->version),
-- 
2.31.1

