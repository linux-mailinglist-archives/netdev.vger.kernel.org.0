Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2580650C95
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 14:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiLSNVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 08:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbiLSNVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 08:21:03 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C150266B;
        Mon, 19 Dec 2022 05:21:00 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VXhf1e9_1671456046;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VXhf1e9_1671456046)
          by smtp.aliyun-inc.com;
          Mon, 19 Dec 2022 21:20:57 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] wifi: ath10k: Remove the unused function ath10k_ce_shadow_src_ring_write_index_set()
Date:   Mon, 19 Dec 2022 21:20:41 +0800
Message-Id: <20221219132041.91418-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ath10k_ce_shadow_src_ring_write_index_set is defined in the
ce.c file, but not called elsewhere, so remove this unused function.

drivers/net/wireless/ath/ath10k/ce.c:212:1: warning: unused function 'ath10k_ce_shadow_dest_ring_write_index_set'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3519
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 59926227bd49..c2f3bd35c392 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -208,14 +208,6 @@ ath10k_ce_shadow_src_ring_write_index_set(struct ath10k *ar,
 	ath10k_ce_write32(ar, shadow_sr_wr_ind_addr(ar, ce_state), value);
 }
 
-static inline void
-ath10k_ce_shadow_dest_ring_write_index_set(struct ath10k *ar,
-					   struct ath10k_ce_pipe *ce_state,
-					   unsigned int value)
-{
-	ath10k_ce_write32(ar, shadow_dst_wr_ind_addr(ar, ce_state), value);
-}
-
 static inline void ath10k_ce_src_ring_base_addr_set(struct ath10k *ar,
 						    u32 ce_id,
 						    u64 addr)
-- 
2.20.1.7.g153144c

