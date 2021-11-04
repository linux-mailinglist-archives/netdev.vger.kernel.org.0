Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF72444EA7
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhKDGOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhKDGOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:14:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343DAC061714;
        Wed,  3 Nov 2021 23:11:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p18so5478501plf.13;
        Wed, 03 Nov 2021 23:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjnEPOzUPFVGMCkVUBCfucHinXUbvfA4ZiPiZdFe5fE=;
        b=XmkgLy9WF+XWPTfg+VhTS0tA2at/XszKlLy7PvInlpvfaviSpNRiQ2uT2WEG+hi1cs
         CfhlaWYG4Q/CoLxyrOTRDVvPyacema2lYk2Yi5IOJUF48QQl7JHrcuqbikbRnYXm6QQ0
         igaNyTENS5uDlZvaCbal1HLqr1D/JtU0ikCA1ctWsWYGyNHTRjjXuT6o60qNW/DAnpdp
         YwjHXFh/1jZHAttkv0n3HX7q3Wlyrpk1KVyoLNzWRd0/OymMJLGHTMBPi2sT4qKNkBh1
         br7rhuT9HjxUBDL9EdM7YokSqvQIlS0U5tbqkNql7duKCZqrDUjZQRzBelHxPUscsLhm
         lr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjnEPOzUPFVGMCkVUBCfucHinXUbvfA4ZiPiZdFe5fE=;
        b=oVeu51dsKaS9hlPe322R4MQy0H3QncJoRLvWwksBJ33HoHNYCcF6ZG3p0d5erZ8DfM
         S5MFpMMhpe5EQhwsPr/Z4BxUtgcm/TACtZ4zwG03pBLllZvu0jgI42646exPURcWbkHI
         BzlEa2AfZJVgXnxi4vuj774xDeS+uSN5Xa8nNm0HQt27qztD+kPJ9CCcR9zBn52ccu9G
         H44kUyaB7LwmnA90yrrKeqMgT1aaYhVbw9DZDaOCU956vcqMMmE4PJmXqWIe4hYD4m+4
         +HhCCJlGKyOPUClP8gXd5MDFSImqTOcDbTd6B44jgWeE4lRXStzfabzTlgA10tUeUa/q
         Xlqg==
X-Gm-Message-State: AOAM5319D2SDsnu0Xq86n3ys28G1v/UXW9Nvmec0lNIO9/Bq0Or3vSh2
        UbXjJ3LOgHzG8/6v4ym+hRw=
X-Google-Smtp-Source: ABdhPJzyBGLpaLsRqTMYZCDVSew0TVLrzxI1xxC1OR5kuon+oe5k3/id6FRd9dZ0cZuq6Hxt/cq0kg==
X-Received: by 2002:a17:90b:124d:: with SMTP id gx13mr19936360pjb.106.1636006288575;
        Wed, 03 Nov 2021 23:11:28 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s7sm4242655pfu.139.2021.11.03.23.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:11:28 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.guojin@zte.com.cn
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ye Guojin <ye.guojin@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] rtw89: remove unnecessary conditional operators
Date:   Thu,  4 Nov 2021 06:11:19 +0000
Message-Id: <20211104061119.1685-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

The conditional operator is unnecessary while assigning values to the
bool variables.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 drivers/net/wireless/realtek/rtw89/debug.c    | 2 +-
 drivers/net/wireless/realtek/rtw89/mac.c      | 2 +-
 drivers/net/wireless/realtek/rtw89/phy.c      | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 29eb188c888c..75f10627585b 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -814,7 +814,7 @@ rtw89_debug_priv_mac_dbg_port_dump_select(struct file *filp,
 		return -EINVAL;
 	}
 
-	enable = set == 0 ? false : true;
+	enable = set != 0;
 	switch (sel) {
 	case 0:
 		debugfs_priv->dbgpkg_en.ss_dbg = enable;
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index afcd07ab1de7..944c23293cb9 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3695,7 +3695,7 @@ void _rtw89_mac_bf_monitor_track(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_traffic_stats *stats = &rtwdev->stats;
 	struct rtw89_vif *rtwvif;
-	bool en = stats->tx_tfc_lv > stats->rx_tfc_lv ? false : true;
+	bool en = stats->tx_tfc_lv <= stats->rx_tfc_lv;
 	bool old = test_bit(RTW89_FLAG_BFEE_EN, rtwdev->flags);
 
 	if (en == old)
diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index ab134856baac..b7107eff9edc 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -1767,7 +1767,7 @@ static void rtw89_phy_cfo_dm(struct rtw89_dev *rtwdev)
 	}
 	rtw89_phy_cfo_crystal_cap_adjust(rtwdev, new_cfo);
 	cfo->cfo_avg_pre = new_cfo;
-	x_cap_update =  cfo->crystal_cap == pre_x_cap ? false : true;
+	x_cap_update =  cfo->crystal_cap != pre_x_cap;
 	rtw89_debug(rtwdev, RTW89_DBG_CFO, "Xcap_up=%d\n", x_cap_update);
 	rtw89_debug(rtwdev, RTW89_DBG_CFO, "Xcap: D:%x C:%x->%x, ofst=%d\n",
 		    cfo->def_x_cap, pre_x_cap, cfo->crystal_cap,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 5c6ffca3a324..9e25e53f6c4a 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -1053,10 +1053,10 @@ static void rtw8852a_set_channel_bb(struct rtw89_dev *rtwdev,
 				    struct rtw89_channel_params *param,
 				    enum rtw89_phy_idx phy_idx)
 {
-	bool cck_en = param->center_chan > 14 ? false : true;
+	bool cck_en = param->center_chan <= 14;
 	u8 pri_ch_idx = param->pri_ch_idx;
 
-	if (param->center_chan <= 14)
+	if (cck_en)
 		rtw8852a_ctrl_sco_cck(rtwdev, param->center_chan,
 				      param->primary_chan, param->bandwidth);
 
-- 
2.25.1

