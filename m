Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223C6DB6AE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406969AbfJQS7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:59:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33965 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733256AbfJQS7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:59:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id j11so3584890wrp.1
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=uNulbYh4Vz5I4wMVOYYqzBOObbs2fIr9JjrWga8sbIc=;
        b=YnsaOEAFItJz0I05jE/zZk85NWEQo5GRz0i7HVWvby1MjzkkNxTmdkGhcomU6MzOnI
         cE4dez/v+VA5cCt8XQnl2rzid2NfuDyCGSEQ9s0KP8pUjDBWQoTq//wys4/IT19PRZvx
         FgoYT48xXmNFiF8mz7+E1O62aVmkafXh6lPFNDVxG6+t6hW9SJQ7g/RRcGVemEZzdSMb
         04ITZb2ZObZZlg3hFAlLt8ZIpQw7BwZHReFsSxca5IOViMS9TDxPhp4lF/w9GyVYHpxZ
         y4B+Hy8OuTcBOeY646WPMbkuHaZ+mi08hX26wJleAltR3mV9SaW3DnRX+1/lh3NFLzDb
         oe7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=uNulbYh4Vz5I4wMVOYYqzBOObbs2fIr9JjrWga8sbIc=;
        b=lBSm7BWkQTAEsPFEuPQGYOpplTTBqghrZMgh9WfcpjhS1CPKvYoYgJFt2SUDwj+i4H
         mSWiMmkE+N9wM/8102KbkwlmsrdpnOW4nxs77CJ6Xi2loP+d7ZZFwleWWK99jvdNYIC4
         VSGCi3ugQK6XrJ0FSDXA9MvU+2PXss1nowvskwnONmYAiYrYUG7EA4Ec+Y8Wt9/ZT39J
         puvQFy7IKzm8564rITB3kM0kzaCobzjOCug5jQAK0mAYF5BfxjCpTvck61/Nu9Zi1Nun
         Dvr5BjMt0229bFHNFZOx/D9AgEhAWd+j9u8xJ32S053AdJeAlIWh+CRH3aHjSbmbdbAb
         P4Tw==
X-Gm-Message-State: APjAAAWZIAAneAgIpscZRZ3to6j6n45IV+Bin+DhGB3Z2N0NC1czVUyc
        1frJCZmxrn0Ap0gNNWMxZFzyUjK2
X-Google-Smtp-Source: APXvYqyIGqxSu7qJu4HHS2/6fRX3RBntLrC6yYp6AdpxBaeTzClDu7Q2Lgt7mV1jmoWy2RY21PQ6lA==
X-Received: by 2002:adf:8068:: with SMTP id 95mr4662021wrk.249.1571338791861;
        Thu, 17 Oct 2019 11:59:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:405c:5b8a:afd3:d375? (p200300EA8F266400405C5B8AAFD3D375.dip0.t-ipconnect.de. [2003:ea:8f26:6400:405c:5b8a:afd3:d375])
        by smtp.googlemail.com with ESMTPSA id d193sm3766419wmd.0.2019.10.17.11.59.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 11:59:51 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove support for RTL8100e
Message-ID: <002ad7a5-f1ce-37f4-fa22-e8af1ffa2c18@gmail.com>
Date:   Thu, 17 Oct 2019 20:59:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's unclear where these entries came from and also the r8101
vendor driver doesn't mention any such chip type. So let's
remove these entries.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 350b0d949..2feddc26f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -97,8 +97,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_11,
 	RTL_GIGA_MAC_VER_12,
 	RTL_GIGA_MAC_VER_13,
-	RTL_GIGA_MAC_VER_14,
-	RTL_GIGA_MAC_VER_15,
+	/* versions 14 and 15 don't seem to exist */
 	RTL_GIGA_MAC_VER_16,
 	RTL_GIGA_MAC_VER_17,
 	RTL_GIGA_MAC_VER_18,
@@ -164,8 +163,6 @@ static const struct {
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_12] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_13] = {"RTL8101e"				},
-	[RTL_GIGA_MAC_VER_14] = {"RTL8100e"				},
-	[RTL_GIGA_MAC_VER_15] = {"RTL8100e"				},
 	[RTL_GIGA_MAC_VER_16] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_17] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_18] = {"RTL8168cp/8111cp"			},
@@ -2188,9 +2185,6 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x248,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_16 },
-		/* FIXME: where did these entries come from ? -- FR */
-		{ 0xfc8, 0x388,	RTL_GIGA_MAC_VER_15 },
-		{ 0xfc8, 0x308,	RTL_GIGA_MAC_VER_14 },
 
 		/* 8110 family. */
 		{ 0xfc8, 0x980,	RTL_GIGA_MAC_VER_06 },
@@ -3781,8 +3775,6 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
 		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_13] = NULL,
-		[RTL_GIGA_MAC_VER_14] = NULL,
-		[RTL_GIGA_MAC_VER_15] = NULL,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
@@ -5354,8 +5346,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168bb,
 		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168bef,
 		[RTL_GIGA_MAC_VER_13] = NULL,
-		[RTL_GIGA_MAC_VER_14] = NULL,
-		[RTL_GIGA_MAC_VER_15] = NULL,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168bef,
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
-- 
2.23.0

