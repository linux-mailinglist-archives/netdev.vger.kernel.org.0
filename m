Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2528C2FCB7C
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbhATH2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:28:03 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52030 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725320AbhATH2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:28:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UMJ.y0-_1611127630;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMJ.y0-_1611127630)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 15:27:14 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        bigeasy@linutronix.de, colin.king@canonical.com,
        Larry.Finger@lwfinger.net, andriy.shevchenko@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] rtlwifi: Assign boolean values to a bool variable
Date:   Wed, 20 Jan 2021 15:27:08 +0800
Message-Id: <1611127628-50504-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:
892:1-10: WARNING: Assignment of 0/1 to bool variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index be4c0e6..c198222 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -873,7 +873,7 @@ static void halbtc_display_wifi_status(struct btc_coexist *btcoexist,
 	dc_mode = true;	/*TODO*/
 	under_ips = rtlpriv->psc.inactive_pwrstate == ERFOFF ? 1 : 0;
 	under_lps = rtlpriv->psc.dot11_psmode == EACTIVE ? 0 : 1;
-	low_power = 0; /*TODO*/
+	low_power = false; /*TODO*/
 	seq_printf(m, "\n %-35s = %s%s%s%s",
 		   "Power Status",
 		   (dc_mode ? "DC mode" : "AC mode"),
-- 
1.8.3.1

