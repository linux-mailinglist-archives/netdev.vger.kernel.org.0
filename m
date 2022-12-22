Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC02F654710
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLVU0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 15:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLVU0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 15:26:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60D71129;
        Thu, 22 Dec 2022 12:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E742B81F4E;
        Thu, 22 Dec 2022 20:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 397C9C433D2;
        Thu, 22 Dec 2022 20:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671740770;
        bh=qHR2zPL/B++9QMiW8PY2adF7drOv1mN1P/N96IPTXvw=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=hyZhyXQsk1u33ls5rZOZFptQF3KwtSTwBsjX7lI7M5kgyngieLpzFWPa8mkalPuAW
         U6wpG3nhxzBjm0a23Lx7CJ9wndohy0q7zg5wq5mSrmQFUXnKoEj3ETkmdxHvm8X8RE
         qrprP1y7mces2jW4o8XiMpeM89me8xVwyQtsTwSubxET+7x2EJDi0RcDtt+wNNPhx6
         DxwLZfCrLal69ByvUYaQmA3xlhbQr9Ra6JnXc776Rttty0MCoYzPBhnrchoSRhMlU5
         wq5npsgO6a5GT78Yn2R0AvW4tniTpC95l7MJTMW+CUvT+OZOSXx3/VzQLdOEtJS2qX
         j5EVI0hXQAMyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 20F8FC4332F;
        Thu, 22 Dec 2022 20:26:10 +0000 (UTC)
From:   Konstantin Ryabitsev via B4 Submission Endpoint 
        <devnull+icon.mricon.com@kernel.org>
Date:   Thu, 22 Dec 2022 15:26:05 -0500
Subject: [PATCH] rtl8723ae: fix obvious spelling error tyep->type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221222-rtl8723ae-typo-fix-v1-1-848434b179c7@mricon.com>
X-B4-Tracking: v=1; b=H4sIAF29pGMC/x2N0QrCMAxFf2Xk2YCLzIq/Ij6kbeoC2o20DGXs3
 +32eDj3cFcoYioF7t0KJosWnXKD/tRBGDm/BDU2BjoT9USEVt83RxcWrL95wqRfHEJwKXon8Zqg
 hZ6LoDfOYdzTD5cqtovZpO2Pt8dz2/7zn07PfQAAAA==
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jens Schleusener <Jens.Schleusener@fossies.org>,
        Konstantin Ryabitsev <mricon@kernel.org>,
        Konstantin Ryabitsev <icon@mricon.com>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671740769; l=1473;
 i=icon@mricon.com; s=20221221; h=from:subject:message-id;
 bh=oCZJAayGA+HuvI2C2uO/qjBYv80/QKeamQWghltN4rw=; =?utf-8?q?b=3D6IPoQOd0wT7g?=
 =?utf-8?q?y3OrBdrL5Bv9HxpyKZvO/NfKADAOjMBZXh+lJVo5aNThMoRLl4B+2uQLUTyzTW5C?=
 X5Ksp+adDh68B1/RFrRTqDcqM15+L042hqzGhqOM6Gz27ljLQXz/
X-Developer-Key: i=icon@mricon.com; a=ed25519;
 pk=24L8+ejW6PwbTbrJ/uT8HmSM8XkvGGtjTZ6NftSSI6I=
X-Endpoint-Received: by B4 Submission Endpoint for icon@mricon.com/20221221 with auth_id=17
X-Original-From: Konstantin Ryabitsev <icon@mricon.com>
Reply-To: <icon@mricon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Ryabitsev <icon@mricon.com>

This appears to be an obvious spelling error, initially identified in a
codespell report and never addressed.

Reported-by: Jens Schleusener <Jens.Schleusener@fossies.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=205891
Signed-off-by: Konstantin Ryabitsev <icon@mricon.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
index 0455a3712f3e..12cdecdafc32 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
@@ -116,7 +116,7 @@ void rtl8723e_dm_bt_hw_coex_all_off(struct ieee80211_hw *hw);
 long rtl8723e_dm_bt_get_rx_ss(struct ieee80211_hw *hw);
 void rtl8723e_dm_bt_balance(struct ieee80211_hw *hw,
 			    bool balance_on, u8 ms0, u8 ms1);
-void rtl8723e_dm_bt_agc_table(struct ieee80211_hw *hw, u8 tyep);
+void rtl8723e_dm_bt_agc_table(struct ieee80211_hw *hw, u8 type);
 void rtl8723e_dm_bt_bb_back_off_level(struct ieee80211_hw *hw, u8 type);
 u8 rtl8723e_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					u8 level_num, u8 rssi_thresh,

---
base-commit: 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
change-id: 20221222-rtl8723ae-typo-fix-5cc7fdb7ed6f

Best regards,
-- 
Konstantin Ryabitsev <icon@mricon.com>
