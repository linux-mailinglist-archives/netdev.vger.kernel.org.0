Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6512A58FBDD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiHKMEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbiHKMEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:04:11 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3939595681;
        Thu, 11 Aug 2022 05:04:08 -0700 (PDT)
X-QQ-mid: bizesmtp72t1660219428t21r2z35
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 20:03:47 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: KvvwR/hcPA3r5QG70V//gL+6hjsLram42ARWmDM9M1uFp7B/4D3RYEZaXOmFr
        OfUJ8iGZCbtJKPhV3F4K61hcJDdyrouBzs7Dz8t/i0tUSJwJ9Z1A5SCk94s4Ryg/zr826Za
        6Xwh+jcPiQIT8OgTyr5jnFjZIEIXw4LZcAlm3lJGKW8mZ13qCxxXsder6MPsHJG83qHLaPD
        CbbCIuDhCrzr0cRdtoCtW/ocM7mlIODbkCBf6wWKZ7pygB76DpGh/QCdv4aV6Juf5NcUbNk
        sxP/Y6VrBGQdlYHolmcwQ26Ik7Pz4/ZH4YNXHO3HJU+kfg2f3+8sjZZgkZL3rLkV0iPpmXq
        iZT9VSHvFDa+XOEVwtm56qsllOkc5ECm208p3ig42Za1bbosnMoNXUBmyLZQFNWfXjJCkqZ
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kvalo@kernel.org
Cc:     chunkeey@googlemail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] wifi: p54: Fix comment typo
Date:   Thu, 11 Aug 2022 20:03:40 +0800
Message-Id: <20220811120340.12968-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `to' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index b925e327e091..e127453ab51a 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -635,7 +635,7 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
 				/*
 				 * hw/fw has not accumulated enough sample sets.
 				 * Wait for 100ms, this ought to be enough to
-				 * to get at least one non-null set of channel
+				 * get at least one non-null set of channel
 				 * usage statistics.
 				 */
 				msleep(100);
-- 
2.36.1

