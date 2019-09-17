Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7CB47AE
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404346AbfIQGux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:50:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38653 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbfIQGux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:50:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id x10so1467549pgi.5;
        Mon, 16 Sep 2019 23:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=A09ebAA08AUXlIM7rfJAlfeNFb0/R3dzB4utBep7g5k=;
        b=NFR60qqidHaph1jwlnhZRW3ByDD9bHtGwZnAvitu0gchqdLaQ8TJRpdntardshvLP/
         HXCsWoPL1e53p9YJnxS3UUcfnZrd3Ns9Lf/dSdJzhWBQ8W2lCXDoOGuCwmNGtPfFRzU1
         3dlWUxKDAL7faO5GMgwsxngt5VoYp/+9HzEVvag9C0HtrTUdOhtV7M253apWJEpnG/Eu
         qdtoxDC/u/SycTF8h7KlrOStdgpGfxVLb7lrFutIVK2S1ByJJ9XtCZn+juDgdUmrmkfX
         kzxs8Rco/90ISXEQ1mqrTGOgMe5IaOdiDMRRNOjD5AjQmf3N4MVUVDGzK6vTKGyzUPMj
         NNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=A09ebAA08AUXlIM7rfJAlfeNFb0/R3dzB4utBep7g5k=;
        b=n5MrHH1M/EI9riGHgmm8dygwEp3gbN6MKJvreAuIIwdgEMusfO1vJ2tuyNjXkzIXHZ
         qK00unwqFZ4GgNmETHma5zC7JaJoRnXEfnKx16hHb2tzfCL8ARXjUz0djhyFETJI2ijD
         NlEe/ax1VAyt4Hr+XO83PyDOdLZ57Z8IapHDP3SO59ivoD1Rd0zcRBdXM9AFosPEArUg
         SUHvBlzgY4vxQVj6OkRkXXQYQCiStXaec2Tb/archdcr4Ej0V3mXB+GlL0kGZDtcU5Kb
         +Xw34M/SsGbqgtdvC7Xc5w67cn6Ur82TZ3OpaS50xczAUo/RbnwI6RjK/KQi7Kiz13/p
         cNiw==
X-Gm-Message-State: APjAAAVd4UVKyVN7/g7rXzSAR3PBvahSbj2aHrR1+KqtrAggeVsxgbBa
        elSQrqg9V1blw8+0arP23Ic=
X-Google-Smtp-Source: APXvYqzwM1TmdOu8NcHkAeG+Pl6QsEYbNbIdHu1NSxPw+dSxhz1ml+UvP48URsmAGWL44BJIuj1eyg==
X-Received: by 2002:a62:8c10:: with SMTP id m16mr2487881pfd.58.1568703050638;
        Mon, 16 Sep 2019 23:50:50 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id f62sm1500038pfg.74.2019.09.16.23.50.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 23:50:50 -0700 (PDT)
Date:   Tue, 17 Sep 2019 15:50:44 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, austindh.kim@gmail.com
Subject: [PATCH] rtlwifi: rtl8723ae: Remove unused 'rtstatus' variable
Message-ID: <20190917065044.GA173797@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'rtstatus' local variable is not used,
so remove it for clean-up.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
index 54a3aec..22441dd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
@@ -485,15 +485,12 @@ bool rtl8723e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					    enum radio_path rfpath)
 {
 	int i;
-	bool rtstatus = true;
 	u32 *radioa_array_table;
 	u16 radioa_arraylen;
 
 	radioa_arraylen = RTL8723ERADIOA_1TARRAYLENGTH;
 	radioa_array_table = RTL8723E_RADIOA_1TARRAY;
 
-	rtstatus = true;
-
 	switch (rfpath) {
 	case RF90_PATH_A:
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
-- 
2.6.2

