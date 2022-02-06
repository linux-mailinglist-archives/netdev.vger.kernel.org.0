Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25E64AB091
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 17:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiBFQH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 11:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiBFQH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 11:07:27 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582ECC06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 08:07:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l5so24896449edv.3
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 08:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=MfSRa8SzGorEIciIvFacs94wlErL2RvQ0HenIwlrlCM=;
        b=jf1GDUTWpYFWDAaN69I1yAydzX7RHAxYyu1OEOi2GPO2jIXsFexoxZQ/OD9+cxoRVy
         bIJ36o837aaHuc2+4yYPGlSazO6w0BBZh4jQMAy84+ymzYF5PsnPNFAQxR2xI0beynu+
         EqaPd5WrVwNrilMLFb5vK46JQj0gJbv08dXJhf7p2tGCHqz1eneWRI5zpltmU/H/+vVB
         a24F2olsUQcfI6iAumpdWqABFzs12YCBJRScMPVnyNA/VIjTU40e8ST7aFI9jOtNfqwu
         MofMWy9LedBvr/ZYnCWC0ozLQFjK2v0cjBAFXJ+aqeO72x4y+3wCu5FdqJdkY/a8KGqg
         BbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=MfSRa8SzGorEIciIvFacs94wlErL2RvQ0HenIwlrlCM=;
        b=wCALhxwVMsqJCw8wuzCd0EAv0SlIBfDdcnpX0Cya0JSt19W6UsB3e8QBYeticUR/6G
         Xh8I+p7nFmF2DS8IqTUn42vjVvkO3nmD/oOBNY59mz0vUP4fg1VJP+m9ybOcxy6u7ges
         eR7nWAER5U37dtXo4yujFNdzDXHJkWDOIMz2ugvI1VzX6P1+OQBW7my7N49oqlRlNwBz
         0p9S3lddwXNBI46VeIVHnmBOmMkVn+q6KJlSG6ZIRbxYG8BadzGuFaMkCMZ2N5DyOa6n
         12+MpBvWD38P94iPKcXbXDLgf+0i2oUcbu45nPzZY4gmUUy+pWsHHf62e1+mk6Ybv3x5
         KOMw==
X-Gm-Message-State: AOAM531GbORZoNuZETf4RyfQusVnEzB4K4uwUNpzjHXvazgcQEsEVHdV
        yxet9OsH03W4Tgxpv60OQfyddn6Ru6Y=
X-Google-Smtp-Source: ABdhPJzdtEDsnPyLUoOGL/gohN0zX6o3+rSXe8kWwW13dN167mTHaAlJYYalceG5y00q+BLsXzkuQQ==
X-Received: by 2002:aa7:c917:: with SMTP id b23mr2809486edt.118.1644163644784;
        Sun, 06 Feb 2022 08:07:24 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:102e:bd16:6d55:bf2d? (p200300ea8f4d2b00102ebd166d55bf2d.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:102e:bd16:6d55:bf2d])
        by smtp.googlemail.com with ESMTPSA id n6sm3936299edy.87.2022.02.06.08.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 08:07:24 -0800 (PST)
Message-ID: <467ee9c1-4587-08c0-60ca-e653d31cbc9f@gmail.com>
Date:   Sun, 6 Feb 2022 17:07:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Subject: [PATCH net-next] r8169: factor out redundant RTL8168d PHY config
 functionality to rtl8168d_1_common()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8168d_2_hw_phy_config() shares quite some functionality with
rtl8168d_1_hw_phy_config(), so let's factor out the common part to a
new function rtl8168d_1_common(). In addition improve the code a little.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 .../net/ethernet/realtek/r8169_phy_config.c   | 71 +++++++------------
 1 file changed, 25 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index f7ad54878..15c295f90 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -429,15 +429,6 @@ static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
 	{ 0x0d, 0xf880 }
 };
 
-static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
-	{ 0x1f, 0x0002 },
-	{ 0x05, 0x669a },
-	{ 0x1f, 0x0005 },
-	{ 0x05, 0x8330 },
-	{ 0x06, 0x669a },
-	{ 0x1f, 0x0002 }
-};
-
 static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
 					 struct phy_device *phydev,
 					 u16 val)
@@ -455,6 +446,29 @@ static void rtl8168d_apply_firmware_cond(struct rtl8169_private *tp,
 		r8169_apply_firmware(tp);
 }
 
+static void rtl8168d_1_common(struct phy_device *phydev)
+{
+	u16 val;
+
+	phy_write_paged(phydev, 0x0002, 0x05, 0x669a);
+	r8168d_phy_param(phydev, 0x8330, 0xffff, 0x669a);
+	phy_write(phydev, 0x1f, 0x0002);
+
+	val = phy_read(phydev, 0x0d);
+
+	if ((val & 0x00ff) != 0x006c) {
+		static const u16 set[] = {
+			0x0065, 0x0066, 0x0067, 0x0068,
+			0x0069, 0x006a, 0x006b, 0x006c
+		};
+		int i;
+
+		val &= 0xff00;
+		for (i = 0; i < ARRAY_SIZE(set); i++)
+			phy_write(phydev, 0x0d, val | set[i]);
+	}
+}
+
 static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -469,25 +483,7 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify(phydev, 0x0c, 0x5d00, 0xa200);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		int val;
-
-		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
-
-		val = phy_read(phydev, 0x0d);
-
-		if ((val & 0x00ff) != 0x006c) {
-			static const u32 set[] = {
-				0x0065, 0x0066, 0x0067, 0x0068,
-				0x0069, 0x006a, 0x006b, 0x006c
-			};
-			int i;
-
-			phy_write(phydev, 0x1f, 0x0002);
-
-			val &= 0xff00;
-			for (i = 0; i < ARRAY_SIZE(set); i++)
-				phy_write(phydev, 0x0d, val | set[i]);
-		}
+		rtl8168d_1_common(phydev);
 	} else {
 		phy_write_paged(phydev, 0x0002, 0x05, 0x6662);
 		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x6662);
@@ -513,24 +509,7 @@ static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp,
 	rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_0);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		int val;
-
-		rtl_writephy_batch(phydev, rtl8168d_1_phy_reg_init_1);
-
-		val = phy_read(phydev, 0x0d);
-		if ((val & 0x00ff) != 0x006c) {
-			static const u32 set[] = {
-				0x0065, 0x0066, 0x0067, 0x0068,
-				0x0069, 0x006a, 0x006b, 0x006c
-			};
-			int i;
-
-			phy_write(phydev, 0x1f, 0x0002);
-
-			val &= 0xff00;
-			for (i = 0; i < ARRAY_SIZE(set); i++)
-				phy_write(phydev, 0x0d, val | set[i]);
-		}
+		rtl8168d_1_common(phydev);
 	} else {
 		phy_write_paged(phydev, 0x0002, 0x05, 0x2642);
 		r8168d_phy_param(phydev, 0x8330, 0xffff, 0x2642);
-- 
2.35.1

