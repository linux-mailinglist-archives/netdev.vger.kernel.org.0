Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752C3F618E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 22:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfKIVCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 16:02:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33628 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfKIVCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 16:02:53 -0500
Received: by mail-wr1-f65.google.com with SMTP id w9so3880522wrr.0
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 13:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KJY/VJ63TFo1ZH23E6cn4jdvaITuhiRajFhOXqWR15U=;
        b=mhr0LfNuw5svYT0aUxEuEZnusj7DOJyeIjriEXMm71RrnnOg/XiaCLd6GyJ8Eh8rjw
         rGisRuT+wlcH9KQPkZL8FeHuZS9rq+MtiXF+/LkScHMReHgouOtNkaYBWsqNd+5O4F2h
         NY6Igs+xTTs3694AdrAk7F8LgbkUFeWQI4bGaOK2nu5Rs70iAmpOkLUvmjjpbMQmFmaC
         bwYsmpN6ykxAjbs8OgsCGItV+8+bb55GDQOW/nJ6DQp5WbJLKf0LoTvqHeJJDziphTyh
         Vbu6Hmj32NRLSorOZMpmMB6d0rBr89Y8aGK8b2kKj3+11vHeSqhlWqmqTJ88CI0kgCkr
         ZvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJY/VJ63TFo1ZH23E6cn4jdvaITuhiRajFhOXqWR15U=;
        b=Ld/hXDIuxcyJojdjN5PvyZfI6p9nRHljqOm5cVtEuHmAdCQ6+E/tjifLwYcT97Yidg
         OwY5AmWvVDUvq7CixCAe27GoajQrdtib3n5p/ACt3EFbQqVJuStvcz5xpfAIwdlVONaW
         i3K/yYwU1vHJrXFYay/aZPSdhRTLmOqF1/dbz8ju4f0r2ucDXMuQTyBpCS88IRLux+Kv
         Mg4KKwF5Y9zKUBtN1LYAQu3B6bcpdBMi/ilRk42ccFSci5UHoo+Cra5349SoSreAMI8S
         ePPOm7olSEJtyfmXnxxMon8Q1+AU55gEM6R0U/r4njHb6iDkg5JzFmzdN55ATM1o0FBM
         m1ug==
X-Gm-Message-State: APjAAAV/a+r+kO8ctMT8/V/4MWY0Pur74tJPi6LqcXl+GnO50EpAPYs/
        w0Sb1FeF+VuwsrSsDLWo3M4jgzcR
X-Google-Smtp-Source: APXvYqyCpg+EgDhUVoHeBerrXfm4uxgLypuSHB5p8GXxe/iqgV1zNCTgSEnitbEOx5VXCtVtAXOVbw==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr4899474wrw.141.1573333371450;
        Sat, 09 Nov 2019 13:02:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id v10sm18291900wmg.48.2019.11.09.13.02.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 13:02:51 -0800 (PST)
Subject: [PATCH net-next 5/5] r8169: remove rtl8168c_4_hw_phy_config
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Message-ID: <70946ba6-d18b-2fc3-81e4-df124bdb011b@gmail.com>
Date:   Sat, 9 Nov 2019 22:02:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8168c_4_hw_phy_config() duplicates rtl8168c_3_hw_phy_config(),
so we can remove the function.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8aa681dfe..d4345493f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2635,11 +2635,6 @@ static void rtl8168c_3_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-static void rtl8168c_4_hw_phy_config(struct rtl8169_private *tp)
-{
-	rtl8168c_3_hw_phy_config(tp);
-}
-
 static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
 	/* Channel Estimation */
 	{ 0x1f, 0x0001 },
@@ -3528,7 +3523,7 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_19] = rtl8168c_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_20] = rtl8168c_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_21] = rtl8168c_3_hw_phy_config,
-		[RTL_GIGA_MAC_VER_22] = rtl8168c_4_hw_phy_config,
+		[RTL_GIGA_MAC_VER_22] = rtl8168c_3_hw_phy_config,
 		[RTL_GIGA_MAC_VER_23] = rtl8168cp_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_24] = rtl8168cp_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_25] = rtl8168d_1_hw_phy_config,
-- 
2.24.0


