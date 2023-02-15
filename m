Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40ACD697395
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjBOB0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbjBOB0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:26:33 -0500
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9813525A;
        Tue, 14 Feb 2023 17:26:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VbhaWsD_1676424348;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VbhaWsD_1676424348)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 09:25:49 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, kvalo@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] wifi: ath12k: dp_mon: clean up some inconsistent indentings
Date:   Wed, 15 Feb 2023 09:25:48 +0800
Message-Id: <20230215012548.90989-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/ath/ath12k/dp_mon.c:532 ath12k_dp_mon_parse_he_sig_su() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4062
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 8b3f0769dd58..b30f50ee88dd 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -529,12 +529,12 @@ static void ath12k_dp_mon_parse_he_sig_su(u8 *tlv_data,
 	case 3:
 		if (he_dcm && he_stbc) {
 			he_gi = HE_GI_0_8;
-					he_ltf = HE_LTF_4_X;
+			he_ltf = HE_LTF_4_X;
 		} else {
 			he_gi = HE_GI_3_2;
 			he_ltf = HE_LTF_4_X;
-			}
-			break;
+		}
+		break;
 	}
 	ppdu_info->gi = he_gi;
 	value = he_gi << HE_GI_SHIFT;
-- 
2.20.1.7.g153144c

