Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD13B96A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfFJQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:28:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35898 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390323AbfFJQZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:25:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so8787953wmm.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=37njWOYZlG92FSukFBnxNcdM0yMEA/stA3j7dEVUnF0=;
        b=kcLwss6WWivGzqS11TP3R/ok1HiqZpV4xhSIz2C/PLGpKO73fZL4533moBZbGvldTH
         LjBazyMoxZsAwOw/FLILMLlOoy9X5VN0AsEyHPzJ8W9kz/xJNICrRkFK4klDYClE0kfj
         QUSaUwMNBsllT5C3uIC2O/ZIrdXcIkmQ7F5JJeHVLze5TnYYOh9a6YMi4os+3omUXvyB
         4T+NckXFH+EaawUKEQVHdGrOINf7asp1G/clp29S3RJF/t3bYf/jc9uGvMHWuA1s+ymr
         uVHybw2Km05uXNscTFrfTbh1LA50h4Jfx+GGarUGyQTar3r/zTI/5laucEQQUx54Cs3z
         k5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=37njWOYZlG92FSukFBnxNcdM0yMEA/stA3j7dEVUnF0=;
        b=oE8siECGVkHNaiLT4R9xJsyp5RI6ueOontvl8nitcpGqpYSidwJaBYuyJ+zpxwoKm6
         et0UYokQ5LQXTxwCQYCJxb3uVoT9XB0jH0p35CNUA9pu8APqg9ViQetzFj1+jR1KL4Kd
         i/8yTXt9P/kTnyQpqhQv6a/eX/lGHOBGkrkPulIkxw3aJff9hx4qJ62wQmM66CmYr9Te
         /MAXqqE9dzRaMfmtbfM5l5m/1Css/kxZhilHrpVNoFdVSdxMl3NjJMTrfaPxGAJ5xc0B
         tlyfZkcnxn2CdhunV3nqWAN/P+plTeALhwOokbFotsnDd5I44Fvn8ydF50EjFLADjpj/
         Bkig==
X-Gm-Message-State: APjAAAVHJsnm8gBeqThMX/5JIsD3iGvguwiQmh607yNyFw5vuQfaNqwR
        UsZFtEXaNShVPwYLRYQwJnX2N8Nu
X-Google-Smtp-Source: APXvYqxKkDVpEGOs8uT+uQoDXbpdJitFw+mXTWihpaiB27Gc+ZQRUT/dUletTAzK3UiXYs7RJs5eYQ==
X-Received: by 2002:a1c:7a01:: with SMTP id v1mr14761618wmc.10.1560183944558;
        Mon, 10 Jun 2019 09:25:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id t14sm10939617wrr.33.2019.06.10.09.25.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:25:44 -0700 (PDT)
Subject: [PATCH next 2/5] r8169: rename CPCMD_QUIRK_MASK and apply it on all
 chip versions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Message-ID: <a6491b5e-e687-7b6d-9cf4-4723a255989b@gmail.com>
Date:   Mon, 10 Jun 2019 18:22:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPCMD_QUIRK_MASK isn't specific to certain chip versions. The vendor
driver applies this mask to all 8168 versions. Therefore remove QUIRK
from the mask name and apply it on all chip versions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c62e6845f..9a03b7a09 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -490,6 +490,7 @@ enum rtl_register_content {
 	PCIDAC		= (1 << 4),
 	PCIMulRW	= (1 << 3),
 #define INTT_MASK	GENMASK(1, 0)
+#define CPCMD_MASK	(Normal_mode | RxVlan | RxChkSum | INTT_MASK)
 
 	/* rtl8169_PHYstatus */
 	TBI_Enable	= 0x80,
@@ -573,7 +574,6 @@ enum rtl_rx_desc_bit {
 };
 
 #define RsvdMask	0x3fffc000
-#define CPCMD_QUIRK_MASK	(Normal_mode | RxVlan | RxChkSum | INTT_MASK)
 
 struct TxDesc {
 	__le32 opts1;
@@ -4210,6 +4210,9 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 
+	tp->cp_cmd &= CPCMD_MASK;
+	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
+
 	tp->hw_start(tp);
 
 	rtl_set_rx_max_size(tp);
@@ -4377,9 +4380,6 @@ static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-
 	if (tp->dev->mtu <= ETH_DATA_LEN) {
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B |
 					 PCI_EXP_DEVCTL_NOSNOOP_EN);
@@ -4405,9 +4405,6 @@ static void __rtl_hw_start_8168cp(struct rtl8169_private *tp)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
 	rtl_disable_clock_request(tp);
-
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 }
 
 static void rtl_hw_start_8168cp_1(struct rtl8169_private *tp)
@@ -4435,9 +4432,6 @@ static void rtl_hw_start_8168cp_2(struct rtl8169_private *tp)
 
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 }
 
 static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
@@ -4453,9 +4447,6 @@ static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
 
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 }
 
 static void rtl_hw_start_8168c_1(struct rtl8169_private *tp)
@@ -4511,9 +4502,6 @@ static void rtl_hw_start_8168d(struct rtl8169_private *tp)
 
 	if (tp->dev->mtu <= ETH_DATA_LEN)
 		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 }
 
 static void rtl_hw_start_8168dp(struct rtl8169_private *tp)
@@ -5148,9 +5136,6 @@ static void rtl_hw_start_8101(struct rtl8169_private *tp)
 
 	RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
-	tp->cp_cmd &= CPCMD_QUIRK_MASK;
-	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
-
 	rtl_hw_config(tp);
 }
 
-- 
2.21.0


