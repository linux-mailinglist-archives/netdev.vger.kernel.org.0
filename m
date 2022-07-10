Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6E56CCA4
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 06:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiGJEVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 00:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGJEVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 00:21:22 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAEB22531;
        Sat,  9 Jul 2022 21:21:09 -0700 (PDT)
X-QQ-mid: bizesmtp88t1657426851t9cmf4ud
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 10 Jul 2022 12:20:47 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: mVJZl7SIEgijNN91Ngu4wfxx0Jx6cmlMLwWSZZ8rTsr3bD8kS/kU+4XmnRynx
        OBR2kDdWhKDVeO8zSWgMJRU2vHYJysBwt0zf4wKQIPWt6oSHsFShflA/B/gDobKAqnBLvg7
        qeDJgByk7pvzSBYOlqCT1rwCOsuQay7Vk59TFOFx7WBA3JT4mpzU4fo3530MNURTt1+nz8a
        dgks8AB66c/KyArWrWB7e2R+zXglOoChAvJaWc+T/L6/WnTzJ8fdTJcOFxfbPCASTpFztH8
        uOdknzNUKfeJ8j5ahNmhGY0tK6G8ItEMNEKuKZnNJKgc6tzdK8yJ7m89DlcdYQrO004Kezv
        tnQzVGpPbtmdTEOuDL6LdkYQ23w+hYKh91Xac1jkTyoN85Id+E=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: rtlwifi: fix repeated words in comments
Date:   Sun, 10 Jul 2022 12:20:40 +0800
Message-Id: <20220710042040.22456-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'in'.
 Delete the redundant word 'scan'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 99a1d91ced5a..a1cbedb346dd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -671,7 +671,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 
 		/*
 		 *because we should back channel to
-		 *current_network.chan in in scanning,
+		 *current_network.chan in scanning,
 		 *So if set_chan == current_network.chan
 		 *we should set it.
 		 *because mac80211 tell us wrong bw40
diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index 4cf8face0bbd..0bc4afa4fda3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -178,7 +178,7 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	}
 }
 
-/* Allows active scan scan on Ch 12 and 13 */
+/* Allows active scan on Ch 12 and 13 */
 static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 					     enum nl80211_reg_initiator
 					     initiator)
-- 
2.36.1

