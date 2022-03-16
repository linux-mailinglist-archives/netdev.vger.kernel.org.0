Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7664DBB45
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349723AbiCPXoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiCPXoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:44:01 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9F11AD86;
        Wed, 16 Mar 2022 16:42:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id j17so5185075wrc.0;
        Wed, 16 Mar 2022 16:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9GllwDD1lbwf5TdbQUghkmXuyp60McuGtPv3Aj+W5Go=;
        b=mDD+sPjAuJQoC7C5Am/WO2Wsonxpx/hUAZwYXHzAT+YKEM1o7bO8aHOT+QrRd8RXrn
         xEscKX2S0JBAQcGrmW2ytZ9rJVP4VdoZtFOTHAcovTBpvQQswajvJ82OjCzgQpi6Hrmm
         7WblHE81ndtm6zkv/2xcteUc6rBDb1MUy4OLgKn9BPx//0/Iz9iNVnyCtlnpBIkoZ8+Z
         KprSeQA/4qYN4/6aOd5PTsN6YAcfoYUdEUaTx15tVhmc983SMhdpc29cuaOZ6fIVcrUx
         JWJvLMHmP++asFHbwV6cPpjpRqmCxufxxA8A9wR+0vVCsNAJDpiXvNRn1l395a3HQw7u
         ZxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9GllwDD1lbwf5TdbQUghkmXuyp60McuGtPv3Aj+W5Go=;
        b=1CAcdhVyJTYoMkQHTSXtCRng8qVY07elJwM4kixUNg0xVy29wE6THkRahWa0xTFO4Q
         z4uiE/7fnF1kn5WYyaH+7X9ghcDlWuhJO2cz5agWncp5vG+7FwrCMhh8mBwnz3gqJOls
         mTowpa9cZJ62yGRH+KN8GMWU0QM5Rg4wfY4gQDuAnvAlRttoUhEnXQdIHqrHG6sRBJ7m
         EOQzaOEuwcc+0f6FUBCgs6t9iyEGoIxP0IUJSrzpnvgCp+vjvFclLRM8eulpARc5Kwr5
         HTEY9C8lm75C0k1RzfjDkQhfZ/f4gx/eQa+oA0rVd0bgsYnIG3kwMBaao+TU7nemGmYf
         /IOQ==
X-Gm-Message-State: AOAM53300YoICbvrtsn/HLDQWHCGMuomONu65MMm4RSIWi5CmT4+4j0P
        kNgZz25rGhD8KUfZRF8Ei2F0QilBamKfIw==
X-Google-Smtp-Source: ABdhPJx+ifk/0d/5lefPj0dTm/N0bmsw3Ym25Aw1wpy8wOkWUPMJBtSc4nAyoD2h3byfIx2uXXl4sQ==
X-Received: by 2002:a5d:64c5:0:b0:1f1:e6b8:bd3c with SMTP id f5-20020a5d64c5000000b001f1e6b8bd3cmr1711097wri.686.1647474164008;
        Wed, 16 Mar 2022 16:42:44 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id a14-20020a05600c348e00b00389ab74c033sm2779518wmq.4.2022.03.16.16.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:42:43 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"
Date:   Wed, 16 Mar 2022 23:42:42 +0000
Message-Id: <20220316234242.55515-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some spelling mistakes in some literal strings. Fix them.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 07f26718b66f..99abd0fe7f15 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4623,12 +4623,12 @@ static void _show_cx_info(struct rtw89_dev *rtwdev, struct seq_file *m)
 	ver_hotfix = FIELD_GET(GENMASK(15, 8), chip->wlcx_desired);
 	seq_printf(m, "(%s, desired:%d.%d.%d), ",
 		   (wl->ver_info.fw_coex >= chip->wlcx_desired ?
-		   "Match" : "Mis-Match"), ver_main, ver_sub, ver_hotfix);
+		   "Match" : "Mismatch"), ver_main, ver_sub, ver_hotfix);
 
 	seq_printf(m, "BT_FW_coex:%d(%s, desired:%d)\n",
 		   bt->ver_info.fw_coex,
 		   (bt->ver_info.fw_coex >= chip->btcx_desired ?
-		   "Match" : "Mis-Match"), chip->btcx_desired);
+		   "Match" : "Mismatch"), chip->btcx_desired);
 
 	if (bt->enable.now && bt->ver_info.fw == 0)
 		rtw89_btc_fw_en_rpt(rtwdev, RPT_EN_BT_VER_INFO, true);
@@ -5075,7 +5075,7 @@ static void _show_dm_info(struct rtw89_dev *rtwdev, struct seq_file *m)
 	seq_printf(m, "leak_ap:%d, fw_offload:%s%s\n", dm->leak_ap,
 		   (BTC_CX_FW_OFFLOAD ? "Y" : "N"),
 		   (dm->wl_fw_cx_offload == BTC_CX_FW_OFFLOAD ?
-		    "" : "(Mis-Match!!)"));
+		    "" : "(Mismatch!!)"));
 
 	if (dm->rf_trx_para.wl_tx_power == 0xff)
 		seq_printf(m,
-- 
2.35.1

