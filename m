Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D6744C107
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhKJMOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhKJMOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:14:37 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9454C061766;
        Wed, 10 Nov 2021 04:11:49 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id x64so2486900pfd.6;
        Wed, 10 Nov 2021 04:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bd62kUhFHKorEdg0sPrkxQ7qB2nMKiUIB+3qfTaStf0=;
        b=DXNNf6K83ULfqyjdU1hySEHbe4hiMeTVhtpocirou30jBV6NRaemNjAufpb0tBihXH
         2DLCTDGVDwmndpCuL0aC+TyVpSh0yy+Tl74jpCmLyVKHLkx3smRG+s7UWFI85KXS/9+t
         OCCn3trCcxjiJ4ZMMkpaxBIDqvctok7B3jDYyndKdUxHLDgGXKPlvUuRSUCnihxj1QJ4
         V2cPeIS2lpgpcWx0aqOCAKjUO7y85sGSUKnMrF2jkc9EGBvaJ7RbL3wad61bmjg5f7gg
         SJlnEcW7j5tEF//16yAuU9N++kKFJsjzLUrV9MaBfgBABUSy9bowEWa42WxhECguSn9Q
         35Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bd62kUhFHKorEdg0sPrkxQ7qB2nMKiUIB+3qfTaStf0=;
        b=spN0YSUUZaxS5lajVZRXt/e1pnWbcTDgGg8b7qIOP3/SAzPV0lC8OnNbY94bAbuz4T
         6NQTmHgDJtI1XPG4/NPVjP8HVG6RgmlPC6DzBxfyRW4w3V3KIuTDv5JT9q9eFR//WZMG
         9vF0e+UQ3UIKtgL2f3HYSMOq8iU/HoAZe9TiYvdpoC/N4cu19Dpbo+YSvI0P3+1yCkwb
         wrY/07NYS1O/5RqrowqDCJDDXd8vKb43P9012AYn/wMb5DqyEGFoiXcIBcird80hYJv6
         WFZE9/5wAcyv8H5F0Iukjh+cdRhmDPFx47n4CF3LxL+/y2xe8WKO3AW8+wG0I9GDFv89
         Xarw==
X-Gm-Message-State: AOAM5330F2jzX3eHBTeKmxXEqxQEk+t7StSR1jj801VGHqCvHrzf7us3
        jvtEwkccnn8qYBJqdncPark=
X-Google-Smtp-Source: ABdhPJwr4wIOT77bNfmqObauPfPmEKjjSNks6dI4WNWcOOTv92WOABSsSJOe/B2ifrX8ypuaLuksyg==
X-Received: by 2002:a05:6a00:10d1:b0:47b:aa9b:1e7a with SMTP id d17-20020a056a0010d100b0047baa9b1e7amr96981336pfu.57.1636546309355;
        Wed, 10 Nov 2021 04:11:49 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m19sm7935319pgh.75.2021.11.10.04.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:11:49 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, deng.changcheng@zte.com.cn,
        pkshih@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] rtw89: remove unneeded variable
Date:   Wed, 10 Nov 2021 12:11:35 +0000
Message-Id: <20211110121135.151187-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./drivers/net/wireless/realtek/rtw89/mac.c: 1096: 5-8: Unneeded variable

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 0171a5a7b1de..b93ac242b305 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1093,7 +1093,6 @@ static int cmac_func_en(struct rtw89_dev *rtwdev, u8 mac_idx, bool en)
 static int dmac_func_en(struct rtw89_dev *rtwdev)
 {
 	u32 val32;
-	u32 ret = 0;
 
 	val32 = (B_AX_MAC_FUNC_EN | B_AX_DMAC_FUNC_EN | B_AX_MAC_SEC_EN |
 		 B_AX_DISPATCHER_EN | B_AX_DLE_CPUIO_EN | B_AX_PKT_IN_EN |
@@ -1107,7 +1106,7 @@ static int dmac_func_en(struct rtw89_dev *rtwdev)
 		 B_AX_WD_RLS_CLK_EN);
 	rtw89_write32(rtwdev, R_AX_DMAC_CLK_EN, val32);
 
-	return ret;
+	return 0;
 }
 
 static int chip_func_en(struct rtw89_dev *rtwdev)
-- 
2.25.1

