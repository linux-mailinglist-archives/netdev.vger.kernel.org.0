Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D8415FEB3
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgBONyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43511 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgBONyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id r11so14289123wrq.10
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O5KMYrTN5suvHyl0mefZu8JwVjRRuTUqOfRkPDUhW+c=;
        b=nd3pYwYId8z+19AN/+r0yxPQbhuEfF3FA6k9pLVHP5eM0xZHfJkd/n+U17hj4Bdj64
         48TbRuPSwc0Qo/U4B0UU/f+4uHQr1i+FoZeYI5BvEzHNyF5CIh9jXSEF11YEBN23jxKc
         HsKg+ip5hxcuh4dDJCq4xCy7dXG9Kxevjmr2y3wiubuCJVg5D3abITUmkOcw6qx5zSYZ
         8BQ9MBDGRmx+58iCnRvyaW0gKm1InEpjX0mmPRdFXs350Zk4IKsEMIuvMcMw6AI0oKk3
         L/fgrhKfa0KQyPTo9ZWM6lGvD9pIt4HAJokRt9GS/nUsweN4H8it1m+tdNhyJepfHvPv
         OFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O5KMYrTN5suvHyl0mefZu8JwVjRRuTUqOfRkPDUhW+c=;
        b=EdDUOLxuxzxgN4dGjXggwblhaQOsRSdsCypvOTY+XIrg8R667bguIL5Ad40Xp187ei
         iOK6u8/At0CRSQdCiaUdPBV/uXCtIApdiMS0mVkckc8Bjug+Au6wdCTSn61E5NUeG47g
         zlTAzMONQ+s5a0qDokuiMqoQi/oQCwTkoH8BKUgPUPUfSV/7HRbnt4AIs+MZzCCBCwVk
         nkXEkUkSdN/AW6nb1e6Zl403B+4WjhX2P45wKNU4rfabNKJQIZds9/KXPqEWfTtcQKgS
         aeNrmYRsyp5Y9K929b3ZZnWl391DAqKKx3l1rtQxZLb6xDxMFINcmNZ0C6dHkgCIkIa+
         a3kQ==
X-Gm-Message-State: APjAAAVo8vFec6ijpFmd+gJsbeG5+CLdkRWa4i5snEON2Lshs/kPNXxJ
        UHEIr3YowbdrVrJ5EAa/FKpXirrT
X-Google-Smtp-Source: APXvYqznN23b7VTBmtDkPiMYIvD4LWLzrdunMKSe8X84mHz2uJytK9y7nIUXNpByVBVesBVjiQunSQ==
X-Received: by 2002:a05:6000:1251:: with SMTP id j17mr10891033wrx.210.1581774874993;
        Sat, 15 Feb 2020 05:54:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id t187sm9371659wmt.25.2020.02.15.05.54.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:34 -0800 (PST)
Subject: [PATCH net-next 1/7] r8169: remove unneeded check from
 rtl_link_chg_patch
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <a3d4eda0-c705-3dc3-c2a1-ac78f563af7c@gmail.com>
Date:   Sat, 15 Feb 2020 14:48:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl_link_chg_patch() can be called from rtl_open() to rtl8169_close()
only. And in rtl8169_close() phy_stop() ensures that this function
isn't called afterwards. So we don't need this check.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a2168a147..b6614f15a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1325,12 +1325,8 @@ static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
 
 static void rtl_link_chg_patch(struct rtl8169_private *tp)
 {
-	struct net_device *dev = tp->dev;
 	struct phy_device *phydev = tp->phydev;
 
-	if (!netif_running(dev))
-		return;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_34 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_38) {
 		if (phydev->speed == SPEED_1000) {
-- 
2.25.0


