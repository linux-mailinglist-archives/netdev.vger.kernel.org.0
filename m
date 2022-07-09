Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3AF56CA1B
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 16:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGIObR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGIObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 10:31:16 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3222CDD4;
        Sat,  9 Jul 2022 07:31:07 -0700 (PDT)
X-QQ-Spam: true
X-QQ-mid: bizesmtp70t1657375245tjzj7j81
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 22:00:42 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     gregory.greenman@intel.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: fw: fix repeated words in comments
Date:   Sat,  9 Jul 2022 22:00:36 +0800
Message-Id: <20220709140036.48913-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,
        PP_MIME_FAKE_ASCII_TEXT,RDNS_DYNAMIC,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'for'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/paging.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/paging.c b/drivers/net/wireless/intel/iwlwifi/fw/paging.c
index 945bc4160cc9..a7b7cae874a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/paging.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/paging.c
@@ -249,7 +249,7 @@ static int iwl_send_paging_cmd(struct iwl_fw_runtime *fwrt,
 	};
 	int blk_idx;
 
-	/* loop for for all paging blocks + CSS block */
+	/* loop for all paging blocks + CSS block */
 	for (blk_idx = 0; blk_idx < fwrt->num_of_paging_blk + 1; blk_idx++) {
 		dma_addr_t addr = fwrt->fw_paging_db[blk_idx].fw_paging_phys;
 		__le32 phy_addr;
-- 
2.36.1
‰
