Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6B16EB73
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbfGSUFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 16:05:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40514 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbfGSUFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 16:05:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so30082396wmj.5;
        Fri, 19 Jul 2019 13:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LhwuEfAWfiEHK8h+/sGCMcZbf2WkYnCPlgk8A3vAekc=;
        b=aZ6pI29mc8rQNUafXyq9rPme6gj6WIeWZv6e1FXQ6vnfDWO6baE3wG5YE09axX0NKT
         vTc/Ct2llNDfKtZFgdIyWVgqviYmugoNZRTctJdCyekfHMm51zeNena++xU7CQ1qighk
         QB7gOhZHTBKr84B3N4lZ6KXydpZpEayklJX0dBK1GyC9d6f9b76n2ls6dcgcDhBZQzZ5
         kDE2510r8EeTHF6RA+p919Nqmzp7W0hgflMlysk4nx38WsUz5hlQrjXB1BgU0SNy4ebN
         g1P04X99bFcT/KGmU52zjVSuGSRr5e5RS+uberbnakv4eP9a3VAcWpz71yuLUkgHKg28
         ybAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LhwuEfAWfiEHK8h+/sGCMcZbf2WkYnCPlgk8A3vAekc=;
        b=mkUHCNYw1VB6LLlgmACqLgOoRiGPi4A4Ika6uCkv5svs2/Brb7W3oSgLmYw1ygUj6q
         4amtxODOBdZUycUKLJIWY6Wgz9NC8ofLVRonNtWaskPx/fYuew9/hWPuiNMvQgtNMcNt
         +uCtpTVaQrz9js55P+YOzove3XxdpK1UY4bL4r5R+UyXm9JByCQfPCzSW2t0I4y/vrne
         z0CStjMpNKBVC8z4MqNdQIG041I7n95HP3L1OjLlRtRNQjlsW2pAwVKvsWTp3iXbSm7c
         uIzEKZ3fgBZayllHM+VlLo/ZGEnCxOy32wOObr03EAExy7MwtqCOqGjWbsZF7g+6CLV7
         5q6g==
X-Gm-Message-State: APjAAAUedcZ0bKJJ2z9XjMi992MXJg/V00YS1/yWRbMgcIGLIBFELQNH
        pWav8ZEZcWeDtG7GQrTUmwQuhPt0
X-Google-Smtp-Source: APXvYqwmzDlp81Z8OSCWa5VeLuVh1tSdAWMlvZ7w7wN10bNLCP9vJQt+Ja6w8/mC/EY2qPuV0Ko5OQ==
X-Received: by 2002:a1c:c747:: with SMTP id x68mr49510714wmf.138.1563566747044;
        Fri, 19 Jul 2019 13:05:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:40e3:8fe6:4421:a541? ([2003:ea:8bd6:c00:40e3:8fe6:4421:a541])
        by smtp.googlemail.com with ESMTPSA id o6sm57912418wra.27.2019.07.19.13.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 13:05:45 -0700 (PDT)
Subject: Re: network problems with r8169
To:     Thomas Voegtle <tv@lio96.de>
References: <alpine.LSU.2.21.1907182032370.7080@er-systems.de>
Cc:     linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2eeedff5-4911-db6e-6bfd-99b591daa7ef@gmail.com>
Date:   Fri, 19 Jul 2019 22:05:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1907182032370.7080@er-systems.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.07.2019 20:50, Thomas Voegtle wrote:
> 
> Hello,
> 
> I'm having network problems with the commits on r8169 since v5.2. There are ping packet loss, sometimes 100%, sometimes 50%. In the end network is unusable.
> 
> v5.2 is fine, I bisected it down to:
> 
> a2928d28643e3c064ff41397281d20c445525032 is the first bad commit
> commit a2928d28643e3c064ff41397281d20c445525032
> Author: Heiner Kallweit <hkallweit1@gmail.com>
> Date:   Sun Jun 2 10:53:49 2019 +0200
> 
>     r8169: use paged versions of phylib MDIO access functions
> 
>     Use paged versions of phylib MDIO access functions to simplify
>     the code.
> 
>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> Reverting that commit on top of v5.2-11564-g22051d9c4a57 fixes the problem
> for me (had to adjust the renaming to r8169_main.c).
> 
> I have a:
> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev
> 0c)
>         Subsystem: Biostar Microtech Int'l Corp Device [1565:2400]
>         Kernel driver in use: r8169
> 
> on a BIOSTAR H81MG motherboard.
> 
Interesting. I have the same chip version (RTL8168g) and can't reproduce
the issue. Can you provide a full dmesg output and test the patch below
on top of linux-next? I'd be interested in the WARN_ON stack traces
(if any) and would like to know whether the experimental change to
__phy_modify_changed helps.

> 
> greetings,
> 
>   Thomas
> 
> 
Heiner


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8d7dd4c5f..26be73000 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1934,6 +1934,8 @@ static int rtl_get_eee_supp(struct rtl8169_private *tp)
 	struct phy_device *phydev = tp->phydev;
 	int ret;
 
+	WARN_ON(phy_read(phydev, 0x1f));
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_35:
@@ -1957,6 +1959,8 @@ static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
 	struct phy_device *phydev = tp->phydev;
 	int ret;
 
+	WARN_ON(phy_read(phydev, 0x1f));
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_35:
@@ -1980,6 +1984,8 @@ static int rtl_get_eee_adv(struct rtl8169_private *tp)
 	struct phy_device *phydev = tp->phydev;
 	int ret;
 
+	WARN_ON(phy_read(phydev, 0x1f));
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_35:
@@ -2003,6 +2009,8 @@ static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
 	struct phy_device *phydev = tp->phydev;
 	int ret = 0;
 
+	WARN_ON(phy_read(phydev, 0x1f));
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_35:
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 16667fbac..1aa1142b8 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -463,12 +463,10 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
 		return ret;
 
 	new = (ret & ~mask) | set;
-	if (new == ret)
-		return 0;
 
-	ret = __phy_write(phydev, regnum, new);
+	__phy_write(phydev, regnum, new);
 
-	return ret < 0 ? ret : 1;
+	return new != ret;
 }
 EXPORT_SYMBOL_GPL(__phy_modify_changed);
 
-- 
2.22.0

