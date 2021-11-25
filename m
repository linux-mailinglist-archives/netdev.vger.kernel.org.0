Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E88045D28B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347998AbhKYBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352764AbhKYBsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 20:48:17 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40436C07E5DB;
        Wed, 24 Nov 2021 16:57:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z6so4243062pfe.7;
        Wed, 24 Nov 2021 16:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xR2NYEIoPjbsCHjQ06YGxVuRr3wcloc+LodiEzZnzbE=;
        b=BJ/vYCJVyBLPEbD48YT0t8joXeV3lz2LyX3dgnxGQ8QTUQV4nIUBZgmsb9ZIggmk8P
         llUhJI7Nx90y5NALeCe1LgLbNz7vCj5K4dvDOu5DrAhkmI+qXGj/y8+106Bgx3mG39qL
         532JPrXW0FFyau83M9hWz5ccvYqvldDQEBXaYeL3Lpr9iHSjoP4CMrYW5ftvOevb2G/2
         wuSQlT/mDWSIm9s9KMjPuX0xuLNEuLK/CjyS2Tcf6cJ2F9blREb5lMxiVS/Xq8JUQ0uC
         Zq8skAhHlcngT0ggs2IO0Ro0Q1wNHLrRyELO7yjWdga4fwmoDQU7q3rtvPhAbMc3cch+
         HnPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xR2NYEIoPjbsCHjQ06YGxVuRr3wcloc+LodiEzZnzbE=;
        b=Mh1C6CzsD88wzt8zngiETPb8bCtIMFPk+S04WAu9eLj3bEWXwycntrANU4san3r9Rw
         FnZCgSr3FKoQUxKsk5aMZx7cnVba6FO4qo9GAiFWiE4Igyi9v0D7+iBCvbMTODMNv19x
         Z8TcoxWldNXYX8g0gNRZl45tT0v+ZVE4y+3Xbng2dj/vQgsAvtEylSUi+uKqBfJLQcBm
         ENyR9l3cQ/KwVd0r8WcjNrPOtsHwmswblwCYcfTRq3RIsU2I+GlduF3sDU3XKPiBx9cD
         3Px8cU7NRn9IdMFiA2yDendTJtAkm8j0Wf/ek7WXadSko2uBznKbaD0+myj8hjLsj2N1
         pqNA==
X-Gm-Message-State: AOAM532s2MasFs7d34nW+V78XH6T2o/tIIywnfxQ3FujFC6P8mVYgNHt
        jtTgs1JW38hS9AWCsAe3+8gt1cxwnQcezA==
X-Google-Smtp-Source: ABdhPJzlZ0CVi6RCACpQrBBvvK0WH7o6F5mXb5hR2pWYL67OLlJArtTY++riobJtb8J7RVqsetWwJQ==
X-Received: by 2002:a62:7803:0:b0:494:64ef:7bd7 with SMTP id t3-20020a627803000000b0049464ef7bd7mr10435904pfc.85.1637801820789;
        Wed, 24 Nov 2021 16:57:00 -0800 (PST)
Received: from debian11-dev-61.localdomain (192.243.120.180.16clouds.com. [192.243.120.180])
        by smtp.gmail.com with ESMTPSA id e10sm940557pfv.140.2021.11.24.16.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:57:00 -0800 (PST)
From:   davidcomponentone@gmail.com
X-Google-Original-From: yang.guang5@zte.com.cn
To:     pkshih@realtek.com
Cc:     davidcomponentone@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] rtw89: remove unneeded conversion to bool
Date:   Thu, 25 Nov 2021 08:56:46 +0800
Message-Id: <d9492bb9bced106f20006edb49200926184c3763.1637739090.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

The coccinelle report
./drivers/net/wireless/realtek/rtw89/debug.c:817:21-26:
WARNING: conversion to bool not needed here
./drivers/net/wireless/realtek/rtw89/mac.c:3698:49-54:
WARNING: conversion to bool not needed here
./drivers/net/wireless/realtek/rtw89/phy.c:1770:49-54:
WARNING: conversion to bool not needed here
./drivers/net/wireless/realtek/rtw89/rtw8852a.c:1056:41-46:
WARNING: conversion to bool not needed here

Relational and logical operators evaluate to bool,
explicit conversion is overly verbose and unneeded.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
---
 drivers/net/wireless/realtek/rtw89/debug.c    | 2 +-
 drivers/net/wireless/realtek/rtw89/mac.c      | 2 +-
 drivers/net/wireless/realtek/rtw89/phy.c      | 2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

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
index 5c6ffca3a324..b79e061d03e8 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -1053,7 +1053,7 @@ static void rtw8852a_set_channel_bb(struct rtw89_dev *rtwdev,
 				    struct rtw89_channel_params *param,
 				    enum rtw89_phy_idx phy_idx)
 {
-	bool cck_en = param->center_chan > 14 ? false : true;
+	bool cck_en = param->center_chan <= 14;
 	u8 pri_ch_idx = param->pri_ch_idx;
 
 	if (param->center_chan <= 14)
-- 
2.30.2

