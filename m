Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446623048C3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbhAZFjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:41 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:51039 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbhAZDrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 22:47:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMwnF0k_1611632770;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMwnF0k_1611632770)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 26 Jan 2021 11:46:25 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v2] rtlwifi: rtl8821ae: style: Simplify bool comparison
Date:   Tue, 26 Jan 2021 11:46:08 +0800
Message-Id: <1611632768-6293-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3853:7-17:
WARNING: Comparison of 0/1 to bool variable

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---

Changes in v2:
-Modify email address

 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 372d6f8..1fb857c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -3848,7 +3848,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 			else
 				rtl_write_dword(rtlpriv, 0xc8c, 0x00163e96);
 
-			if (vdf_enable == 1) {
+			if (vdf_enable) {
 				rtl_dbg(rtlpriv, COMP_IQK, DBG_LOUD, "VDF_enable\n");
 				for (k = 0; k <= 2; k++) {
 					switch (k) {
-- 
1.8.3.1

