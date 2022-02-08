Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF564AD0D1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245250AbiBHFcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiBHFQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:16:05 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1881FC0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 21:16:04 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id w5-20020a4a9785000000b0030956914befso16349979ooi.9
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 21:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGIJnWXuciHYiExOOI2SkrHu9YT4I9sMMe7asShp8ME=;
        b=BOqLf6Mmigkv9xRJFWVZ/CMT0wzh539bWBf/bktUlm+dR+d/wDP7kTOdIdNkRvyRpE
         FeqwPwCEs58UDZW3BN0XhzrDTrejWc502Oc5vL8R8X5jKvGhcR2RdqjhywZKBVOnmrB5
         ibumegw00anTonSAGiG1MOa56wv2Op1UgikWrhPhCapfuq4e/XU987+kYN6VaFTB5M1t
         G/tKvJR82CtILgJK+BnJdg90hZLlcaK0Pl4IIxrVPOUbcx0c6rO1g3MZ3owlOC/NS8FO
         rF740avpClsfkzpPwLYEHr8CRmxhNQK9Ngj9wWZrZ96gn4RKKjE0IWeqoIrOBgSyrweL
         80xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yGIJnWXuciHYiExOOI2SkrHu9YT4I9sMMe7asShp8ME=;
        b=q8tFyA56ekEDpccv8vlmmceLJQz8bValXbnsBAF0s8N8hVw7KpWXNSfHuqA5aZtgf8
         ZEqweBSxD02SKnw7JWv4qAhzCk7SVDwHLg3YUodd3h/rPhiGa5j/B7JlaJjuB/2J3lmW
         ND+EG7HM35SEgsn1TDnUM/XsC3Cup+M95JPmNNFGoGEF7G2PwZl3y2kEXr0sc9gjIeKu
         FAwAu1qv7G47mxHlBW7k06z8OygV6QGH9B5RekWHxkU7fK7MRusvSwBC9dZhpzY9ljcT
         kgRoK4zEwLpwffEnVLPIeQEQe0lGPWOPQQHhShNkgdz1vOLatTwEnt+qiDvsM/f0HFHS
         uY2g==
X-Gm-Message-State: AOAM531B4ijrszImIN+6Ybt4XjlznEBSW3NUiKRpxR4EzSpvx9SMLhHK
        v5xR9zdHY8WQnT1KPLFxAuxQfnznEwWuRA==
X-Google-Smtp-Source: ABdhPJzOrCv6VVt9b67Tew1h4eaWELEu7ho9mYLWIE7/Qt6YkBxa6HmuEI2ZlKgejqMxEfYTh91DSw==
X-Received: by 2002:a05:6870:3844:: with SMTP id z4mr794216oal.52.1644297363134;
        Mon, 07 Feb 2022 21:16:03 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id ay42sm5288931oib.5.2022.02.07.21.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 21:16:02 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
Date:   Tue,  8 Feb 2022 02:15:52 -0300
Message-Id: <20220208051552.13368-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

RTL8367RB-VB was not mentioned in the compatible table, nor in the
Kconfig help text.

The driver still detects the variant by itself and ignores which
compatible string was used to select it. So, any compatible string will
work for any compatible model.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/Kconfig        | 3 ++-
 drivers/net/dsa/realtek/realtek-mdio.c | 1 +
 drivers/net/dsa/realtek/realtek-smi.c  | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index b7427a8292b2..8eb5148bcc00 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -29,7 +29,8 @@ config NET_DSA_REALTEK_RTL8365MB
 	depends on NET_DSA_REALTEK_SMI || NET_DSA_REALTEK_MDIO
 	select NET_DSA_TAG_RTL8_4
 	help
-	  Select to enable support for Realtek RTL8365MB-VC and RTL8367S.
+	  Select to enable support for Realtek RTL8365MB-VC, RTL8367RB-VB
+	  and RTL8367S.
 
 config NET_DSA_REALTEK_RTL8366RB
 	tristate "Realtek RTL8366RB switch subdriver"
diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 0c5f2bdced9d..e6e3c1769166 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -206,6 +206,7 @@ static const struct of_device_id realtek_mdio_of_match[] = {
 #endif
 #if IS_ENABLED(CONFIG_NET_DSA_REALTEK_RTL8365MB)
 	{ .compatible = "realtek,rtl8365mb", .data = &rtl8365mb_variant, },
+	{ .compatible = "realtek,rtl8367rb", .data = &rtl8365mb_variant, },
 	{ .compatible = "realtek,rtl8367s", .data = &rtl8365mb_variant, },
 #endif
 	{ /* sentinel */ },
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 946fbbd70153..a849b5cbb4e4 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -510,6 +510,10 @@ static const struct of_device_id realtek_smi_of_match[] = {
 		.compatible = "realtek,rtl8365mb",
 		.data = &rtl8365mb_variant,
 	},
+	{
+		.compatible = "realtek,rtl8367rb",
+		.data = &rtl8365mb_variant,
+	},
 	{
 		.compatible = "realtek,rtl8367s",
 		.data = &rtl8365mb_variant,
-- 
2.35.1

