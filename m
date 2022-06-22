Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A6D55471C
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiFVIZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 04:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345851AbiFVIZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 04:25:32 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 256D838783;
        Wed, 22 Jun 2022 01:25:31 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 8BBB31E80CD1;
        Wed, 22 Jun 2022 16:25:20 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id R8cSbYdEPwKM; Wed, 22 Jun 2022 16:25:17 +0800 (CST)
Received: from localhost.localdomain (unknown [112.64.61.97])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 255281E80C7D;
        Wed, 22 Jun 2022 16:25:17 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        renyu@nfschina.com, Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] rtlwifi: Remove duplicate word and Fix typo
Date:   Wed, 22 Jun 2022 16:25:24 +0800
Message-Id: <20220622082524.21304-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicate 'in'.
Change 'entrys' to 'entries'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 99a1d91ced5a..98b7d4a40ea0 100644
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
@@ -1702,7 +1702,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		rtlpriv->sec.key_len[key_idx] = 0;
 		eth_zero_addr(mac_addr);
 		/*
-		 *mac80211 will delete entrys one by one,
+		 *mac80211 will delete entries one by one,
 		 *so don't use rtl_cam_reset_all_entry
 		 *or clear all entry here.
 		 */
-- 
2.25.1

