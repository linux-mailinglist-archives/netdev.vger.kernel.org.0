Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F956BDED
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238459AbiGHPuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238179AbiGHPuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:50:24 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560312E6AC;
        Fri,  8 Jul 2022 08:50:18 -0700 (PDT)
X-QQ-mid: bizesmtp91t1657295380tcxfli33
Received: from localhost.localdomain ( [182.148.15.249])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 08 Jul 2022 23:49:36 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: q/wYYW8PSxp3q5FGD44mhIxn6gZZ/P6Z1Nx0XEVQtykLPlGrxbE24WWIXg1w/
        8ldJRKK+gP9ipcHwHqUyAP+42jAlXHRXqVKqJsE1wf9gLjaIdD6Kt9pTutyvcnmK79XhQIH
        rTYH8ebUuQGjMmIpoi+Ns5U6c1huy9YBH9nrn/G5oZEq7i4Xq31tgH6zKlbfgEL4Ax1nsnz
        S+mkZf7bgsB6XPGj25JBnBGe9vjZ8Ih8G6S0hhaHRDW5CrAwR/W6AkPWsu/QhJKmItYOxGX
        R1olc5TrUmDBNY7aQPR5HcC6ljt2M4TC6Kx8xrkaA5Iy2KVs5+SdUUZVb6X0AShJgsufdjk
        PuvEQBI82VKbpoVBCyxR1Wwhof8dcHRMEVP+nCMTrs2sBpt4Yoh8WfEr5bdYg==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     jirislaby@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wireless/ath: fix repeated words in comments
Date:   Fri,  8 Jul 2022 23:49:29 +0800
Message-Id: <20220708154929.19199-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'don't'.
 Delete the redundant word 'but'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/ath5k/base.c         | 2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 66d123f48085..947c94efeb21 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1982,7 +1982,7 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 
 	/*
 	 * Check if the previous beacon has gone out.  If
-	 * not, don't don't try to post another: skip this
+	 * not, don't try to post another: skip this
 	 * period and wait for the next.  Missed beacons
 	 * indicate a problem and should not occur.  If we
 	 * miss too many consecutive beacons reset the device.
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 532eeac9e83e..f6e108a67fbd 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -410,7 +410,7 @@ ath5k_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 	/* FIF_CONTROL doc says we should only pass on control frames for this
 	 * station. This needs testing. I believe right now this
 	 * enables *all* control frames, which is OK.. but
-	 * but we should see if we can improve on granularity */
+	 * we should see if we can improve on granularity */
 	if (*new_flags & FIF_CONTROL)
 		rfilt |= AR5K_RX_FILTER_CONTROL;
 
-- 
2.36.1

