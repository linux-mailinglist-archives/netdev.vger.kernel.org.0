Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683A4136124
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgAITfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:38 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40304 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730594AbgAITfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:38 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so4121441wmi.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NKN/diDNeWw2K2xtMhH5HjrgXG+LYeRoJACWuCrIi3A=;
        b=aSBc72Q6iF3mvEReGxQuX1xLonkmw/fY9uxO0m2OsyuqXOeSmibTm+qodzsiABQXBR
         U9k+XwZzxgStxmkQvAiJ51cJ9wmItHGWq0ir0bIjYsdRAWT160URo9bMfq9eRs1XvfFJ
         xCXGZ1g1Co381KmJkq0ALHp/tb/SEmavIF/h/fttoQUFv1/JW7DpSYhqY0K/gq3NS9gY
         tLxQHiqW7vdycz1RZPJAHufWi4eQBVgLYcOknjbwmOMX1u+yWQLvbQUgk2fgu6/oX4R2
         R52pCHF7KHSAAgQUX6+ptv4464bWYliePPdAadBcgO9HjseVMdRrrLb+Veh1HV6LvJR1
         +Uyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NKN/diDNeWw2K2xtMhH5HjrgXG+LYeRoJACWuCrIi3A=;
        b=kIKGeEA9roH4y4UXabz7dRq69SkorLPzPMb0cThTsR266rpS1mKwHljOjnYKnMQVXl
         zH5zfyoY8KqC3y/ZaiAMiOv//QCr92vcYUXkpvC1xr+4ZFIbeS36YfHKWp1lA+jTWsXa
         Lt0v8toxhEy4FDfT07oUtq/+edO6fVHjhRdKrIs5fNZslqje3vmiNFZRrtCzToofN0YO
         jpov52XdtttZTT0eKrqJjxpRKJsw7Mlv+I2ZFjMy0CZLGk3zn2d+ChdDXhOopkd/3Mr5
         CY7h075Br4qgS14zR7A1AAaN1RyZR4Z18UlTgz5MS2OQ/OaVYOXUw+TNwmrPgOUB1gmm
         8K0g==
X-Gm-Message-State: APjAAAUxjkAk5Kfp/ZzFoDuI7VEh7/b9sswYRoBqEqqlu0gqMXnwIEiN
        o2dS/rJ2JEgMzzb/6s3GEGQplAui
X-Google-Smtp-Source: APXvYqwX1SHvaMtkkF/thHPzlgh1241xkRbXGxQ/TfjYYKXG9WdvSwixyT7lDDZdeu5AAh5m/XplOw==
X-Received: by 2002:a7b:cc81:: with SMTP id p1mr6706060wma.62.1578598536686;
        Thu, 09 Jan 2020 11:35:36 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id n16sm9689801wro.88.2020.01.09.11.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:36 -0800 (PST)
Subject: [PATCH net-next 02/15] r8169: remove not needed debug print in
 rtl8169_init_phy
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <0893f739-3342-de76-8a1a-e4f2a107ecc8@gmail.com>
Date:   Thu, 9 Jan 2020 20:26:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove a useless debug statement. This also allows to remove the
net_device parameter from rtl8169_init_phy().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index df3df5e70..7277d39f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3622,15 +3622,14 @@ static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
 		schedule_work(&tp->wk.work);
 }
 
-static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
+static void rtl8169_init_phy(struct rtl8169_private *tp)
 {
 	r8169_hw_phy_config(tp, tp->phydev, tp->mac_version);
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
 		pci_write_config_byte(tp->pci_dev, PCI_LATENCY_TIMER, 0x40);
 		pci_write_config_byte(tp->pci_dev, PCI_CACHE_LINE_SIZE, 0x08);
-		netif_dbg(tp, drv, dev,
-			  "Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
+		/* set undocumented MAC Reg C+CR Offset 0x82h */
 		RTL_W8(tp, 0x82, 0x01);
 	}
 
@@ -6245,7 +6244,7 @@ static int rtl_open(struct net_device *dev)
 
 	napi_enable(&tp->napi);
 
-	rtl8169_init_phy(dev, tp);
+	rtl8169_init_phy(tp);
 
 	rtl_pll_power_up(tp);
 
@@ -6376,7 +6375,7 @@ static void __rtl8169_resume(struct net_device *dev)
 	netif_device_attach(dev);
 
 	rtl_pll_power_up(tp);
-	rtl8169_init_phy(dev, tp);
+	rtl8169_init_phy(tp);
 
 	phy_start(tp->phydev);
 
-- 
2.24.1


