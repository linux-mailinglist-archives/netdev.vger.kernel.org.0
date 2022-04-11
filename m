Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94F14FB24E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 05:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244522AbiDKD1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 23:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiDKD1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 23:27:19 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1859328B;
        Sun, 10 Apr 2022 20:25:05 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id kk12so12236231qvb.13;
        Sun, 10 Apr 2022 20:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nbpd6ocYTqUDBqdcrhU6mhDeIP8IyA+MsrA+b8VDeAc=;
        b=Xk9E8WWAljzYNIwpqvkEqwQri+yqQzPcBZjd4lmBjCGLJ0Wd8eslylJD49LgT0WB0T
         wS1nzczZn4TDi+pJxP73R5ExvZIMHg/hK6UnRktsSgRnoC7Bl7g76f512oT5MAWZBjj4
         mKYU0N+ZR/Z53N4aAm/AQDt8kSASyCSescFaykdhqbw3UOgU/Eop9sl7nGbHhZWWx5+9
         W0zyXdoaghYG5KtvYUuGtzVFLJnxxbTLwAOUHvZPVzxwWI50uL137RMH9Qk81wpFdXPM
         YjrIAn935019C530KStkhwJVCiyso8DvehpQdlLswskwZt58mmgEfXT5YQM67RDHzrRc
         RIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nbpd6ocYTqUDBqdcrhU6mhDeIP8IyA+MsrA+b8VDeAc=;
        b=uHpP3fMZu2QaBYvs41cf/TWNHofoJVXEM78rBRUDYMLF1IxVkcNTzOxxZULfOiFC+3
         3BCKQyw5ij9jIFUd3+/Qy0IFZJLKRae2vug22e/A3xT31xleOG6mQJAOtNN5Y7J+yNmj
         8di+of4RqYnEuex+PVejNbpsBIQ/M/54798iyJvn33sTwPjCRWAwnMn9fH3KJSewWXeU
         OHDjFYYNGxsRmc+5/iKHZU2f/BE4Dw1Qzurw8RqsGRp7U2jQnZw/2GbrsUcJEUZAUkpa
         GHBuHkL8dbwhLFgwchLp7PLn/1NjLrn4yXE+p0AkMAMSUUBCPFNNMENvZFTpIFjftmwy
         KPBQ==
X-Gm-Message-State: AOAM532Vd/1pB8ZFWiM4m7Wh72yc2xSwjQ//vG+gtzeAstUDU8X7wt2N
        29AejfBCgSeYJNXavocp0AE=
X-Google-Smtp-Source: ABdhPJwcQkXDrB0lezApCraf9snvWNXdTDNNywBTFSQnhov5/In/OrAgAqwLkGFjkbIEHjezAwMCuw==
X-Received: by 2002:a05:6214:2a8d:b0:443:7f75:2aaf with SMTP id jr13-20020a0562142a8d00b004437f752aafmr25787589qvb.19.1649647505195;
        Sun, 10 Apr 2022 20:25:05 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h186-20020a376cc3000000b00699c789a757sm13579230qkc.132.2022.04.10.20.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 20:25:04 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, Larry.Finger@lwfinger.net,
        lv.ruyi@zte.com.cn, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] rtlwifi: rtl8192cu: Fix spelling mistake "writting" -> "writing"
Date:   Mon, 11 Apr 2022 03:24:58 +0000
Message-Id: <20220411032458.2517551-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Lv Ruyi <lv.ruyi@zte.com.cn>

There are some spelling mistakes in the comments. Fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index eaba66113328..fbb4941d0da8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -520,7 +520,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
 		 * 2 out-ep. Remainder pages have assigned to High queue */
 		if (outepnum > 1 && txqremaininpage)
 			numhq += txqremaininpage;
-		/* NOTE: This step done before writting REG_RQPN. */
+		/* NOTE: This step done before writing REG_RQPN. */
 		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
 				numnq = txqpageunit;
@@ -539,7 +539,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
 			numlq = ischipn ? WMM_CHIP_B_PAGE_NUM_LPQ :
 				WMM_CHIP_A_PAGE_NUM_LPQ;
 		}
-		/* NOTE: This step done before writting REG_RQPN. */
+		/* NOTE: This step done before writing REG_RQPN. */
 		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
 				numnq = WMM_CHIP_B_PAGE_NUM_NPQ;
-- 
2.25.1

