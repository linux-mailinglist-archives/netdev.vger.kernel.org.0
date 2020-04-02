Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0235619BD7F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 10:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgDBITX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 04:19:23 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37997 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387716AbgDBITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 04:19:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id c21so1417893pfo.5;
        Thu, 02 Apr 2020 01:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VcLk53K2T0017oS2ltgvgf+ueg1rt2M43xBurnp4rmU=;
        b=FW8wv0FCbof6bO/HEK7jdkaKxTVJsLvyf9QNGHnzUVj1GBkzGjEcfm3PXCCxjws053
         3LuXI+xR4ZDOJHjjZpbt7vN0pun72MU/V0vkjic75waC0W4vPCCYdBFUJo70GqAN/jnZ
         1C/sKkFzH2snO2jcQt6CEhxZAZudceQDXpk+HlWaycF4J8ZQ0D4flJEYU2zPVx6YUY+r
         fTp4VdHYQO061q3WwMkn5NZ+X2/i1mEF86k+0kXKcQ6nT8KrT+8JtES3/+N49lLKxqsx
         xgsuHKur4YfKBBjCrCOKh4lQQirzsxkoSsniI9NnYhN1rk5Gbvp97r0nMBLhOC//jsWY
         1Isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VcLk53K2T0017oS2ltgvgf+ueg1rt2M43xBurnp4rmU=;
        b=eO8LqmzoVHjQg2cMk9SCkx7didfRlIPCFiIh1q3k4Zs+pBkTdugt+yCbmQb33UpwwG
         XZt+ilJ20GYxGFISfNOlFO45432EjW9LgNbQsHoAgOr7a2JF3v5n+3KDhyPASd7WlzAy
         phxHVU6i+TwmwoDQ43OjrYBJQSfOiNsTfwfFhlyVjtJgDA+8aq6WoNZsa5v3wY5KMIZO
         XBq8FNUet7efZN73DZevF6QLtbSMtcf/Jh/9yD+WC7BF1rKd6qz7Dzed+L9TRai5i+eM
         zhUNp3OpXboWtZZ35jFnrD/qomuR7RqzCOURKdiXs2QmuEiQbvVuHzFdzAfyZcM7ZR3V
         Lc5w==
X-Gm-Message-State: AGi0PuZT3yBvB+sosjCQBz7esuuHdT1ow4EafVdyE/2RovHK5Zm+WIZR
        m9SKJdE2aTslwM9gxuj5Xew=
X-Google-Smtp-Source: APiQypJVOLMjPtKqXIsBFtNQVMOsJ7OmBQaXkc2Dn3TNb+VYodKyJpp3n0wpXQDPrPORjG1K4AO3nw==
X-Received: by 2002:a63:735c:: with SMTP id d28mr2335726pgn.63.1585815561779;
        Thu, 02 Apr 2020 01:19:21 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id 135sm3292353pfu.207.2020.04.02.01.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 01:19:21 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] rtlwifi: rtl8723ae: fix spelling mistake "chang" -> "change"
Date:   Thu,  2 Apr 2020 16:19:17 +0800
Message-Id: <1585815557-20212-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a spelling mistake in a trace message. Fix it.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index 6801982..652d8ff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -131,7 +131,7 @@ static bool rtl8723e_dm_bt_is_same_coexist_state(struct ieee80211_hw *hw)
 	    (rtlpriv->btcoexist.previous_state_h ==
 	     rtlpriv->btcoexist.cstate_h)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
-			 "[DM][BT], Coexist state do not chang!!\n");
+			 "[DM][BT], Coexist state do not change!!\n");
 		return true;
 	} else {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
-- 
1.8.3.1

