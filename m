Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A21342F57
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhCTTrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTTqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:46:50 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1773C061574;
        Sat, 20 Mar 2021 12:46:49 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id q26so1324684qkm.6;
        Sat, 20 Mar 2021 12:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Y5LE0OO9qwuhftBRmCY2moX1aD8xL03Bn6dwZGmc58=;
        b=LbjvA82qhP8HdNBNp8M0yYPbSrvzvCxQeZ3aJtkBn/hlf+4E1jmsK8vN8ckt97Hhlz
         gR90RYHe1EAjzvQODNRGGVgIWSiKqissLKOw3SO8GrTrrL/Gk9bVYDbGv6ehtjiZRT3A
         LWHLNWhtZ6i5TN9Pf/UqZya1nZqSBTbtpB/rn++GAw/0UOIJdOf/D8PofBwUrs71fIO1
         +A1GudNQz3XpofPR7nkeewbsXQP43m6XRRDsjPq9TwVhXgvviHX3VxuoALBMHoMKwooE
         a00AuBDe2GFyHjIBGGbL7QeSHK8iRgpxCRbt5BgbNfhlyULHg3GMh8GmyqNzgaHqeYZy
         zGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Y5LE0OO9qwuhftBRmCY2moX1aD8xL03Bn6dwZGmc58=;
        b=XcsmAFvmJruLrgr/x0IMV9Vs99omAANd+PRqT1sH8Fs+cU7NpcVSVVn7y63fOEFr5h
         ar7ufVZtIK8+X98qvxwW1isSH463rLFHTNRcbWa7UYhMWqG5/ni+FmemdobjPAXAqXN1
         /h11GglMJ/F1OrZzoiKxZebINudKRqkHQIoFmzKlz7dgXii/cVx5lprDJ1sjQV3KwVb3
         1iu/mX5UfSrKApRud8Ve+oPWDUH4LpwQzacs+URTVKU83OXFBjBF62uVJmsqPSgelRW3
         +fHEhjIXLG9a8OdZj9wasTQ2yYMExYhkG2Hu4KHdEjJBBOavitP+Zd+rhoQqjGMOOFQr
         Pigg==
X-Gm-Message-State: AOAM531k83X0Yx+o15blYmwD4Fd09ifwMe1Jykgc3LKpR+G+1In92sm+
        lnUxdMygBaHily1QNxuylTLQDCl3S5BthLhd
X-Google-Smtp-Source: ABdhPJzB6yxsVRtuUJpDBxLEwaAiG5ZDzQw1dK4XpA4/jJs4MXz0tMI7D0VscErKXJEE7n7EEn8Y6A==
X-Received: by 2002:a37:a390:: with SMTP id m138mr4130645qke.59.1616269609105;
        Sat, 20 Mar 2021 12:46:49 -0700 (PDT)
Received: from localhost.localdomain ([138.199.13.205])
        by smtp.gmail.com with ESMTPSA id d14sm7728568qkg.33.2021.03.20.12.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 12:46:48 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] rtlwifi: Few mundane typo fixes
Date:   Sun, 21 Mar 2021 01:14:26 +0530
Message-Id: <20210320194426.21621-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/resovle/resolve/
s/broadcase/broadcast/
s/sytem/system/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 965bd9589045..c9b6ee81dcb9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -564,7 +564,7 @@ static int rtl_op_resume(struct ieee80211_hw *hw)
 	rtlhal->enter_pnp_sleep = false;
 	rtlhal->wake_from_pnp_sleep = true;

-	/* to resovle s4 can not wake up*/
+	/* to resolve s4 can not wake up*/
 	now = ktime_get_real_seconds();
 	if (now - rtlhal->last_suspend_sec < 5)
 		return -1;
@@ -806,7 +806,7 @@ static void rtl_op_configure_filter(struct ieee80211_hw *hw,
 	if (0 == changed_flags)
 		return;

-	/*TODO: we disable broadcase now, so enable here */
+	/*TODO: we disable broadcast now, so enable here */
 	if (changed_flags & FIF_ALLMULTI) {
 		if (*new_flags & FIF_ALLMULTI) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_AM] |
@@ -1796,7 +1796,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 				value |= (GET_PWR_CFG_VALUE(cfg_cmd) &
 					  GET_PWR_CFG_MASK(cfg_cmd));

-				/*Write the value back to sytem register*/
+				/*Write the value back to system register*/
 				rtl_write_byte(rtlpriv, offset, value);
 				break;
 			case PWR_CMD_POLLING:
--
2.26.2

