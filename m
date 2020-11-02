Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C842A291E
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgKBLZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgKBLZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:25:04 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7689AC061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:25:03 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id n18so14134588wrs.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V56hUx4Ik29TQLj2+CSFLe9SRW9C8bcqnq7xkJaiUmI=;
        b=LbLnLJ7sYZ0Y4ts2ejFZSO6VFjct/fqvAsi66WGbmbjiWxrlKP23awk5AoxWovYtQq
         ANyWpgdkbExKHSc4LRTxA3Wm0sLoiUn/xeYK7K8YxzBckH70djdbeTaZ7sVmCcyxLH/7
         LbV8udT93qwScqZSTKAcQ+sj80osPAff/t4/43FDsEHUxBY+thIUAqd6YjLvT4roAwnx
         vL8mI2Vq5xzw5DESN0m3QKTKHsOBwDfAYAo/1nGEjKG7vuM02DvSM6IJXUhqFCgPi6i+
         QBZHISS14SQLp1xJ1BSdY058i5GfkClF7p6g1xsGJbL7YxzUX2H7j+aKltf7vdTzROyX
         vZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V56hUx4Ik29TQLj2+CSFLe9SRW9C8bcqnq7xkJaiUmI=;
        b=udHLekl9eI8lTauzBouiJrXg+uStsqzWMy45hm7RzzFCIfSX3gXm2kGZNfiqLyJh1d
         eAcLR3wHctKOnFz+xp1O90OxEQaXVKMmADwclSL5uZx1tcyqTl0mCCkhcSc9qMJvyGl+
         390r2//Tj+xhtd+ETKOhlxl4PiRwmGcQBGmTnGpvwO1MGt2iLbLShvbyAz6algBMhIHD
         t9lN/F1G7rTISdqADx6Vcuib/3d2Fmd8GU34rundzOEvGANEPx6hekSKRPGEtN8frwqs
         w62HAmW3cGxQLHTiDp9bn2pnuq2baZgXEhBwwQvUwjRtUrNMYdFRGpouNVCdMqAozWPn
         gKvg==
X-Gm-Message-State: AOAM532An+mRmeZop6h0q7tVpuTik5rR3kipl0B3PiL5X9D7GjO73rGI
        A9mo4Gox+DcSa7Nbybd/TMdUzg==
X-Google-Smtp-Source: ABdhPJzTyFAeigdIzuKUqE+E8GyCEp2hfljOIkpyNn8sJbCdvxcGFGLf34+xtIbYZk3zUTIk7raa1Q==
X-Received: by 2002:adf:e8d0:: with SMTP id k16mr19559451wrn.362.1604316302226;
        Mon, 02 Nov 2020 03:25:02 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:25:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 33/41] rtlwifi: rtl8821ae: phy: Remove a couple of unused variables
Date:   Mon,  2 Nov 2020 11:24:02 +0000
Message-Id: <20201102112410.1049272-34-lee.jones@linaro.org>
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

 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function ‘rtl8821ae_phy_switch_wirelessband’:
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:597:14: warning: variable ‘rxpath’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:597:6: warning: variable ‘txpath’ set but not used [-Wunused-but-set-variable]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index f41a7643b9c42..72ee0700a5497 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -594,11 +594,10 @@ void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_dm *rtldm = rtl_dm(rtlpriv);
 	u8 current_band = rtlhal->current_bandtype;
-	u32 txpath, rxpath;
 	s8 bb_diff_between_band;
 
-	txpath = rtl8821ae_phy_query_bb_reg(hw, RTXPATH, 0xf0);
-	rxpath = rtl8821ae_phy_query_bb_reg(hw, RCCK_RX, 0x0f000000);
+	rtl8821ae_phy_query_bb_reg(hw, RTXPATH, 0xf0);
+	rtl8821ae_phy_query_bb_reg(hw, RCCK_RX, 0x0f000000);
 	rtlhal->current_bandtype = (enum band_type) band;
 	/* reconfig BB/RF according to wireless mode */
 	if (rtlhal->current_bandtype == BAND_ON_2_4G) {
-- 
2.25.1

