Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F38B5611E0
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 07:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiF3FnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 01:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiF3FnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 01:43:01 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC733E8C;
        Wed, 29 Jun 2022 22:42:55 -0700 (PDT)
X-QQ-mid: bizesmtp67t1656567743tdpnzprp
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 13:42:12 +0800 (CST)
X-QQ-SSF: 0100000000200070C000B00A0000000
X-QQ-FEAT: HDjpALELSmGfVeh0SWOBbH4foC3bxlM/7l4HkUuV2ul4UEzBXBAqOcJ+EXbM+
        rxMp8qaCMRWh8WSPUeeNdgs8mfQuUHL7FR1rODqszNRY1WsBYMGrYGtJYQXb1EeOvkt2nJg
        0DNE2iCD67vL72FMzx9gFjLyt6t+f/Phkzs+B5s1xaBxu8zOWUi8fn8gtaurSJ+rxeKuohl
        a6V3gi4+M8eeqOIGk+apTKU6HjG8rvxOpIKHHP/JamdurbtGKr8oTVhw81xP3BH38/YBUra
        +gjtiJSUWyEX1IcOmsewDJWSKSUNtXbh2oHE56D27xX82AzdU2CmGpAS4jnzzu0X5e5w==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] marvell/octeontx2/af: fix repeated words in comments
Date:   Thu, 30 Jun 2022 13:42:04 +0800
Message-Id: <20220630054204.47501-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'so'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 3a31fb8cc155..e05fd2b9a929 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -2534,7 +2534,7 @@ static int npc_mcam_alloc_entries(struct npc_mcam *mcam, u16 pcifunc,
 
 	/* Copy MCAM entry indices into mbox response entry_list.
 	 * Requester always expects indices in ascending order, so
-	 * so reverse the list if reverse bitmap is used for allocation.
+	 * reverse the list if reverse bitmap is used for allocation.
 	 */
 	if (!req->contig && rsp->count) {
 		index = 0;
-- 
2.36.1


