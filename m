Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5DA2A2921
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgKBLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbgKBLZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:25:09 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64078C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:25:09 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 23so824957wmg.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UT5EgnUvoHP+GjgilFxQnCqaL6JOwHOcMs3W1ZOmRXU=;
        b=xukb2MhFxJbVUdsWilattJVsGg0OAs77+oLW3aMTLk/EF/Ai4AANnWiI3wmBS5XwRf
         zi7tVBPSLiEoKSaopsSuC8MTjW7bGWgXFnsXe5GenkjXYAZ3XF+6Yc/v6MIMR2jYGiEA
         JccZN775WqcJLqdINDeWs5q/CcQ80igoAj4GphmiroGQwXn4EVHTg2tP0s0nBUTxWM2L
         Iiy3ylxRXTxxErZbkKpC3QUymQbzduX1rJycnCa03pcZ20vbdAiKvEkmk7c7wQ5Lkf5y
         vMwRN5JIToSpejVIkfvae9Gc+n2c/GQjELhxciFLObO1W62xiJ9tmDWdsqrJ74MpM93K
         k/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UT5EgnUvoHP+GjgilFxQnCqaL6JOwHOcMs3W1ZOmRXU=;
        b=jTtO4vIPm47+ErVcI4AcQJwSWSSD35uOglmtdYwgr2q0sk2j/0hUNGkWQh2vH5mvq7
         SvN5OrtXQjfHEp4xrgaCYwhzYZtYiEwDOIk1ZGCMUsZxYSVbt+0Tu0SIHqeQhfg2uMbV
         uVVShGGBmXRhSsE33yRwUpAY+dAZh7x9bePlsyHxWtmiGLk7f8iZ6RqzgjmBP+VbEPAj
         mCLT7GaSZi8/Rztke7b844AOl89g8Sicj/y7m8vKFVm3sNswUKUprcLtBGbP2BO+NTNV
         ADar9syNFaN6TNB0fo21nXfD9d9VQDWwTm+QsJ+C/ZDsKkUkA9VwNDP35wUYF+AjXpJn
         Q8yg==
X-Gm-Message-State: AOAM5337dZwiMMt2obLnD/vwFyrLPknw1mXPKzoGwiIWVWEOIpwkCSor
        4BlgaH8QU0JXC9tAPC0lE1oM9A==
X-Google-Smtp-Source: ABdhPJzxaJagDnvgeH2HbXfAEJ2LYyd+wNu8tVtlIN4gwozyl0vvjVt8g0xrZK5de9DGHD5UPb/VJA==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr17030497wme.0.1604316308191;
        Mon, 02 Nov 2020 03:25:08 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:25:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 38/41] realtek: rtw8822c: Remove unused variable 'corr_val'
Date:   Mon,  2 Nov 2020 11:24:07 +0000
Message-Id: <20201102112410.1049272-39-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtw88/rtw8822c.c: In function ‘rtw8822c_dpk_dc_corr_check’:
 drivers/net/wireless/realtek/rtw88/rtw8822c.c:2445:5: warning: variable ‘corr_val’ set but not used [-Wunused-but-set-variable]

Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index e37300e98517b..b129a10707573 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2442,7 +2442,7 @@ static void rtw8822c_dpk_rxbb_dc_cal(struct rtw_dev *rtwdev, u8 path)
 static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)
 {
 	u16 dc_i, dc_q;
-	u8 corr_val, corr_idx;
+	u8 corr_idx;
 
 	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000900f0);
 	dc_i = (u16)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(27, 16));
@@ -2455,7 +2455,7 @@ static u8 rtw8822c_dpk_dc_corr_check(struct rtw_dev *rtwdev, u8 path)
 
 	rtw_write32(rtwdev, REG_RXSRAM_CTL, 0x000000f0);
 	corr_idx = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(7, 0));
-	corr_val = (u8)rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(15, 8));
+	rtw_read32_mask(rtwdev, REG_STAT_RPT, GENMASK(15, 8));
 
 	if (dc_i > 200 || dc_q > 200 || corr_idx < 40 || corr_idx > 65)
 		return 1;
-- 
2.25.1

