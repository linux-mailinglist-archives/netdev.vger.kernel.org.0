Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38870557A4F
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 14:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiFWM2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 08:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiFWM2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 08:28:07 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3270B1D6
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 05:27:55 -0700 (PDT)
X-QQ-mid: bizesmtp90t1655987177tvudpioa
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 23 Jun 2022 20:26:12 +0800 (CST)
X-QQ-SSF: 01000000008000C0C000D00A0000000
X-QQ-FEAT: PdU/eI8FBMBa+osO4ttSIsYgTzat1MkFtXq+8udwQRW8JaFSvPU6VWlSIfETT
        tP++IhAfi9RyKK6wzPazIj/bEJwT/Kag3/4xlJeT7FWz38+CaRCJrhEMbKzHPyyDcHEOrVG
        4AkcQ27XTF1IOkUQNuUx9nm5ixXWqtUaoTiIweHJMNtB2qyn7wcXG84X6AC7Jhe+AG6IBUq
        UILW/h8lrgP4SDk15KlrrZflZhDSH9kBxC0qYIP3ilRzg78WLNn6GHPvscqDEXeDM3kwlll
        /w4MQHrRAxUEw7LzyIWa44KgompnvfMSD6i0TvrMqNGT1hu0zK/efafZ1Az/xE1SWtzuElg
        pYXFyIxp3j0kNxiWDrOK/kcYmqoSA==
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     gregory.greenman@intel.com, kvalo@kernel.org,
        luciano.coelho@intel.com, johannes.berg@intel.com,
        jiangjian@cdjrlc.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fw: paging.c - drop unexpected word 'for' in comments
Date:   Thu, 23 Jun 2022 20:26:10 +0800
Message-Id: <20220623122610.52292-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word 'for' in the comments that need to be dropped

file - drivers/net/wireless/intel/iwlwifi/fw/paging.c
line - 252

/* loop for for all paging blocks + CSS block */

changed to:

/* loop for all paging blocks + CSS block */

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
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
2.17.1

