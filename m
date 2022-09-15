Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F69A5B92E7
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiIODJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiIODJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:09:26 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6768E90C68;
        Wed, 14 Sep 2022 20:09:24 -0700 (PDT)
X-QQ-mid: bizesmtp63t1663211347t987whnn
Received: from localhost.localdomain ( [125.70.163.64])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 15 Sep 2022 11:09:05 +0800 (CST)
X-QQ-SSF: 01000000000000E0G000000A0000000
X-QQ-FEAT: 6IGTEsLXdibpysUJWTC5aUyhSp+VwqBJscX8MISHrZ2ZDgLFyy+gvVVgsyQe5
        +s4ttKCdjGcmXSqoRbNwi5X9WpipQTxK9CPWVtJR5CuYxfP8vqQOgb9qzVb3SSlasUpllg4
        TNrkPwJhvDDyHGoKzQgjOcO44VHDHlqhUd/WZqO6h+7o9KyVfGMy1MIJztYp/Ac0ulFaSA8
        wApY6zwJDukZdZ+Bol6v94K0WZuiy1f8Dv1yN7yZx91ZI3FT2slBbIo7uBUX2U0n/JU2tbu
        4m1QQFciIC82rsz8WldaTVHbAERXeSFcc8l6VjpceafC/k1N6cspPuHRg9V9j1CzX5rZhAQ
        olfTuldeM85M2GJtVu0MKRg7kPn7scH0zHxO8lS2qNaGrQFNPLPpBrRHZaTwbSp+KjyFDBQ
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] ath9k: fix repeated words in comments
Date:   Thu, 15 Sep 2022 11:08:59 +0800
Message-Id: <20220915030859.45384-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index dc0e5ea25673..090ff0600c81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1744,7 +1744,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
-- 
2.36.1


