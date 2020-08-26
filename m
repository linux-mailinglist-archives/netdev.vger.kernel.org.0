Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3B1252A4F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgHZJhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgHZJfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAF1C0617A2
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:32 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b18so1092438wrs.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y9vzHS6aHZF+kDxD6ikVzao6jVEkcdJnGSqUufDJu9w=;
        b=YC0J7kOL2kJwoCB6PgkNpW5h3dq6NVC2Xkws2NJEAH5xD2iKNQobz7x/NieN3UBwaM
         cSn2z7m4Smw7oi2IWzzyP/ohnJE3YCZOtULAeRrePXs6M5iC/emGeaaGP+9bxGeazca/
         XME3AmOZg1kmyCCBeoP7SBIgjOvM0Twrt2+nKfkF8nC8UbaFCTW8QbDAMZ9U2wHWbUmr
         LoKbo+u8L1/REpsf1gxSh/Z8XFx0y1MbeHZJe5QM7dyEyyg+CcQ/0Jdnv6ScroburOgu
         +rAMk8tWQ4Lg9SaajGHqbhpP3cjBL7rEyrGnlPYUwPigpw7QeM8kH5AHWTP5FCw7t5Ct
         fSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y9vzHS6aHZF+kDxD6ikVzao6jVEkcdJnGSqUufDJu9w=;
        b=AJt2kG8K48MiVxCnhzbEUkCjmzzQ6YnA/i699/KQAKUrDwI5umBJBHteCuQ6je4tLR
         sCZK7cb7PxcCpIT925vEHwh20IPH9j09rZ+LQzY9fzOIuut/ZRFe6sjd7zHSFMwRxdCb
         2ARBETttzgIMvxfCz9Pelim8hekCNbiHAVXK3P5NsW61BoL9BUZubPui8plAQTd0B15F
         IkkqF786NJL0JDb6Ekkez+IumI0Vc1TiUZoL86MH1+luNJf7XmUapCySHUn4HGOeb6bA
         oXhj3ebByNhBb4mzAOywC3ud0gg6ktktWGRAwJ7RX1cMekDvMt7R9SinT+8MHnSraZnD
         HjEg==
X-Gm-Message-State: AOAM533RyXryITATecy1Z+bZ97VgU4qtGAI27GhoRigskM2ZbmtAdrkx
        0QXbM7XkvI8junDnrO5BlE4QfA==
X-Google-Smtp-Source: ABdhPJyN4ci4jtPd/M2OA/JeSCKTm6lmnTrzznvThCroyX1Ow0WW+6LwG7XzM3P56DikPqpdT57ZYg==
X-Received: by 2002:a5d:56c6:: with SMTP id m6mr6343048wrw.204.1598434470695;
        Wed, 26 Aug 2020 02:34:30 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Subject: [PATCH 21/30] wireless: realtek: rtw88: debug: Remove unused variables 'val'
Date:   Wed, 26 Aug 2020 10:33:52 +0100
Message-Id: <20200826093401.1458456-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/realtek/rtw88/debug.c: In function ‘rtw_debug_get_mac_page’:
 drivers/net/wireless/realtek/rtw88/debug.c:430:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]
 drivers/net/wireless/realtek/rtw88/debug.c: In function ‘rtw_debug_get_bb_page’:
 drivers/net/wireless/realtek/rtw88/debug.c:450:6: warning: variable ‘val’ set but not used [-Wunused-but-set-variable]

Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index f769c982cc91e..985cf5d606159 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -427,12 +427,11 @@ static int rtw_debug_get_mac_page(struct seq_file *m, void *v)
 {
 	struct rtw_debugfs_priv *debugfs_priv = m->private;
 	struct rtw_dev *rtwdev = debugfs_priv->rtwdev;
-	u32 val;
 	u32 page = debugfs_priv->cb_data;
 	int i, n;
 	int max = 0xff;
 
-	val = rtw_read32(rtwdev, debugfs_priv->cb_data);
+	rtw_read32(rtwdev, debugfs_priv->cb_data);
 	for (n = 0; n <= max; ) {
 		seq_printf(m, "\n%8.8x  ", n + page);
 		for (i = 0; i < 4 && n <= max; i++, n += 4)
@@ -447,12 +446,11 @@ static int rtw_debug_get_bb_page(struct seq_file *m, void *v)
 {
 	struct rtw_debugfs_priv *debugfs_priv = m->private;
 	struct rtw_dev *rtwdev = debugfs_priv->rtwdev;
-	u32 val;
 	u32 page = debugfs_priv->cb_data;
 	int i, n;
 	int max = 0xff;
 
-	val = rtw_read32(rtwdev, debugfs_priv->cb_data);
+	rtw_read32(rtwdev, debugfs_priv->cb_data);
 	for (n = 0; n <= max; ) {
 		seq_printf(m, "\n%8.8x  ", n + page);
 		for (i = 0; i < 4 && n <= max; i++, n += 4)
-- 
2.25.1

