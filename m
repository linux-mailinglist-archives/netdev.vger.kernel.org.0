Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172D2655398
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 19:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiLWSUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 13:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiLWSU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 13:20:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB671EC46;
        Fri, 23 Dec 2022 10:20:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F81B82079;
        Fri, 23 Dec 2022 18:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 678ABC433EF;
        Fri, 23 Dec 2022 18:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671819625;
        bh=s+w4Vmkri+bQvZZCCxXHo7hLKUZYkLV7NRkCb2P8dOY=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=k7o1B37iLcvQbAgqpyghW77C3EvLbhD6S0Wf2Z1obGWbylLmsCqPeTSHlk/S96PXR
         oM3vMmEcawuI4IsrHFvKrEVcmIIwjtBDQ41dBplv1F+iV6iaGYWxXUDb2w49xcn0nS
         nfDVKRhDwAh+0mLHQhf5kanIxeH+2ipxA0a7BbADdJGvChyIaWkBZo0C2OAYAOXqff
         5hkuXt7/J65foEc8k0P3vX9ZEYLmImJLpZ3CWO/nogtDxUYjijbW2F95/GXRFY9NvX
         5q48q0CCfm6PoZ1mntl/9Tjm3vuj76KRdO8hAGEXSKDiJnoDbNag3QUh+nHW7F5pjr
         bjkxXMs71ODzg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 502EEC4332F;
        Fri, 23 Dec 2022 18:20:25 +0000 (UTC)
From:   Konstantin Ryabitsev via B4 Submission Endpoint 
        <devnull+icon.mricon.com@kernel.org>
Date:   Fri, 23 Dec 2022 13:20:23 -0500
Subject: [PATCH v2] wifi: rtlwifi: rtl8723ae: fix obvious spelling error tyep->type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com>
X-B4-Tracking: v=1; b=H4sIAGfxpWMC/32NTQ6CMBBGr0K6dowd0KIr72FYtGWQJtKSadNIC
 He3cACX7/vJW0UkdhTFo1oFU3bRBV8AT5Wwo/ZvAtcXFnhBlIgInD6twloTpGUOMLgvXK1VQ28U
 9bdBlKPRkcCw9nbcr5OOiXgvZqayP2yvrvDoYgq8HPIs9/SvJ0uQ0DZtUzdGqrtVz4mdDf5swyS
 6bdt+hIUvSM4AAAA=
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671819624; l=1637;
 i=icon@mricon.com; s=20221221; h=from:subject:message-id;
 bh=57gO259Fc/KT9ex4SOU3uyVtvu/dYwCeWFrRcLQPeeo=; =?utf-8?q?b=3DcaFDCH83b5cJ?=
 =?utf-8?q?QQhl9O6KJ+wtipnd0wu1TvUnFsdV2pLp9ntgoczGWiWaqaE5og9SBsi9upMf1Xr+?=
 J9LU85qRCeAXRT3YAbT1qGTO4MTE7F5DzdJBVTPj6SWepd4Ajpus
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
Changes in v2:
- Updated commit subject based on feedback.
- Link to v1: https://lore.kernel.org/r/20221222-rtl8723ae-typo-fix-v1-1-848434b179c7@mricon.com
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
