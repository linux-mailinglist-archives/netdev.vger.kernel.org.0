Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E96D2A2934
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgKBLZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728814AbgKBLY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:57 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93987C061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:57 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id s9so14124757wro.8
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dC1HY3295RvOHBr8DWnLhRLYKV4wb0SqtT4zdtIpm24=;
        b=MPOo7oFMsJRFYLXnm/bFDJdP2kpvPc2ioROvNmvc60Sdy+TTBecmDAtP8zK9lsd//A
         55Y5jq38ujkRuZDcK7PkYlQmnC9OxYTHddgio2w82EBBAtw1J9eaBdYqXANsvWHDjp2G
         w6W28QUgfhB1NI4P1noH1xZFhtd+Xi1BRlJpQn8c8xB4uIEMcNuVbxPk4zWABkykyZrB
         Uq3hejnrR/w4Ci3Emed7V6gyvUi47+s6TIpNUeShTeLygvrabpTauqFt0J5MDiy5j0PP
         BThA+1l9inNjnj7Yqpz7BXEGOdmP944EoO+5kmyjvxiXTJEU2DdY7ivzXZRIAVVdEwb1
         6hNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dC1HY3295RvOHBr8DWnLhRLYKV4wb0SqtT4zdtIpm24=;
        b=JcVN91NrBIY6NbPdlu+AqJyUwY1l9cd7u9OFI0hLTh9SYML5zlpC/qBxobU1FhXBm0
         2JfLDfxf6pU5lG+pUlEdXhzWdEjtlatJW4OUE+zhZlmE8wZR0rKDAZBX0iGbrdtUcFXs
         +VRF2g21AGCLZgm7nd3BgwLsTFXfoLYvh/NUCKDMllHl96Gny7dJQzL6IvGPl8EecBtA
         RU3stHihBvL2gSrNypnk2EsFF5I+DmreV+VegoJdpt8ZxmfS4vBiKjK8UTopFw62vrdb
         pMAcsTytB03DpX6269/yFWm9XqZMrO1I1ZEP3saB87vAaz/viz19v60vD+qS8EFpekc0
         iHOA==
X-Gm-Message-State: AOAM5314mnBnxRuayYtxkwjCer99sX0FHXQ4aytwR1uP+KZbZlSfnWGO
        i1xPKsJKkRZAPqF7qVPRTM2nSl1mU9xJRQ==
X-Google-Smtp-Source: ABdhPJx0zmNhrM4E9BGxq1guyT1+xmUrcrR3J/bI5Rpar14jhZoBxvxNLD5dLF25N5hj0eSL/CJu8g==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr20975973wrx.249.1604316296305;
        Mon, 02 Nov 2020 03:24:56 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:55 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 28/41] rtl8723be: phy: Remove set but unused variable 'lc_cal'
Date:   Mon,  2 Nov 2020 11:23:57 +0000
Message-Id: <20201102112410.1049272-29-lee.jones@linaro.org>
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

 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c: In function ‘_rtl8723be_phy_lc_calibrate’:
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2181:36: warning: variable ‘lc_cal’ set but not used [-Wunused-but-set-variable]

Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index f09f55b0468a4..2b9313cb93dbd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -2178,7 +2178,7 @@ static u8 _get_right_chnl_place_for_iqk(u8 chnl)
 static void _rtl8723be_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
-	u32 rf_a_mode = 0, rf_b_mode = 0, lc_cal;
+	u32 rf_a_mode = 0, rf_b_mode = 0;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	tmpreg = rtl_read_byte(rtlpriv, 0xd03);
@@ -2202,7 +2202,7 @@ static void _rtl8723be_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 			rtl_set_rfreg(hw, RF90_PATH_B, 0x00, MASK12BITS,
 				      (rf_b_mode & 0x8FFFF) | 0x10000);
 	}
-	lc_cal = rtl_get_rfreg(hw, RF90_PATH_A, 0x18, MASK12BITS);
+	rtl_get_rfreg(hw, RF90_PATH_A, 0x18, MASK12BITS);
 
 	rtl_set_rfreg(hw, RF90_PATH_A, 0xb0, RFREG_OFFSET_MASK, 0xdfbe0);
 	rtl_set_rfreg(hw, RF90_PATH_A, 0x18, MASK12BITS, 0x8c0a);
-- 
2.25.1

