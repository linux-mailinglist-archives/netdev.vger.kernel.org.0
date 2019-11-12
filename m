Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9561F9C3A
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLVZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:25:51 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37554 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLVZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:25:51 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so4537501wmj.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pceUXCL7I3UkCAjBUXSsi/kD7VOfNalF6PjE8NHBhV4=;
        b=V1zqcRA7pn5xeVEU27pKHqD3pnUrcGnN2hL4uMqysuQyEkQ8/K/50Mqhe6cLFcdxPb
         mHOtKRvpedF07hDf2pphNQdxR8p8EutFBzTT8hTlNkklx3piBBZdSCqV3JlL32oBBs0o
         MpxP5VYS/nKcyjuHLNlrMkhcFfUEyS1IFcEPBPOYjlmvkUFTnbyU5Bjp8iVtiS3opIAI
         Ic1Q0yefqeqfcc9CFZThP9u2vs/ZPwxKBRvQnRp83qxZiyKom6QsrLVfM4fVn7wtpRrt
         poQuopS57VkovFr7aHoR2N6fhspOZDtIzFxOwTIy4T4i0LgOo/hmwcm18bTuxg5nClqM
         HA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pceUXCL7I3UkCAjBUXSsi/kD7VOfNalF6PjE8NHBhV4=;
        b=rSsLHcbZJ3NXgQpZDuLyl3krMEZJdXoTsqOmFBaJzd9wKPCWsNpw/gxYdD8Rm/XsHD
         krGSk5VYtw1s9BehUVERilGtro4A3bvPigcEV5FBK3am8Jt+pHGZeqoer4sXjAjyvOLQ
         5S236eD1cTNDBtTYFXoHrS5mfX8Nw7MXG/ryp9s9q0dsxWnigJFQkGvLl6Pfm/JcJ3Hq
         vqTpqmF5EnKppD3virfTtK6vBUL6Ipp0qEYc49VvtZIhd6Ff0XlKZgX6QK4EV17g3VIK
         1RJWwRtu+DPWtJ9WdbMWW/LYz8TCo6g3M1XqTo2Sf+0Jjk57ta8gCU3X0uO1a4670Q2R
         FxZA==
X-Gm-Message-State: APjAAAVdeYT9lJw4VYo+D/6YXC9SJq0MHwG3c13B+SkprtBoM4U05Isz
        AJZxmq8l9rDSPpR8Wv/UIH3Mg4oc
X-Google-Smtp-Source: APXvYqxeB9ZL8jGsD3r6Rhno+yOV0FSNJ8e0ntBFocBCV54PSZAAnyMaQ24jhPT/1/wt8PlywQZiRw==
X-Received: by 2002:a1c:f404:: with SMTP id z4mr5871688wma.12.1573593949212;
        Tue, 12 Nov 2019 13:25:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:7:bfb7:2ee9:e19? (p200300EA8F2D7D000007BFB72EE90E19.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:7:bfb7:2ee9:e19])
        by smtp.googlemail.com with ESMTPSA id o1sm154978wrs.50.2019.11.12.13.25.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:25:48 -0800 (PST)
Subject: [PATCH net-next 1/3] net: phy: realtek: export rtl821x_modify_extpage
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Message-ID: <ddf12809-eabc-0e0f-f878-beebd6e15ef4@gmail.com>
Date:   Tue, 12 Nov 2019 22:23:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <461096ec-9185-a919-ae56-0208e73342fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain Realtek PHY's support a proprietary "extended page" access mode
that is used in the Realtek PHY driver and in r8169 network driver.
Let's implement it properly in the Realtek PHY driver and export it for
use in other drivers like r8169.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c   | 36 ++++++++++++++++++++++--------------
 include/linux/realtek_phy.h |  8 ++++++++
 2 files changed, 30 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/realtek_phy.h

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 677c45985..89f125191 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 #include <linux/phy.h>
 #include <linux/module.h>
+#include <linux/realtek_phy.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -63,6 +64,24 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
 	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
 }
 
+int rtl821x_modify_extpage(struct phy_device *phydev, int extpage, int reg,
+			   u16 mask, u16 val)
+{
+	int oldpage = phy_select_page(phydev, 0x0007), ret = 0;
+
+	if (oldpage < 0)
+		goto out;
+
+	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, extpage);
+	if (ret)
+		goto out;
+
+	ret = __phy_modify(phydev, reg, mask, val);
+out:
+	return phy_restore_page(phydev, oldpage, ret);
+}
+EXPORT_SYMBOL(rtl821x_modify_extpage);
+
 static int rtl8201_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -194,7 +213,6 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
-	int ret = 0, oldpage;
 	u16 val;
 
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
@@ -223,19 +241,9 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 	 * 2 = RX Delay, 1 = TX Delay, 0 = SELRGV (see original PHY datasheet
 	 * for details).
 	 */
-	oldpage = phy_select_page(phydev, 0x7);
-	if (oldpage < 0)
-		goto err_restore_page;
-
-	ret = __phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
-	if (ret)
-		goto err_restore_page;
-
-	ret = __phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
-			   val);
-
-err_restore_page:
-	return phy_restore_page(phydev, oldpage, ret);
+	return rtl821x_modify_extpage(phydev, 0xa4, 0x1c,
+				      RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,
+				      val);
 }
 
 static int rtl8211b_suspend(struct phy_device *phydev)
diff --git a/include/linux/realtek_phy.h b/include/linux/realtek_phy.h
new file mode 100644
index 000000000..dd9eee56f
--- /dev/null
+++ b/include/linux/realtek_phy.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _REALTEK_PHY_H
+#define _REALTEK_PHY_H
+
+int rtl821x_modify_extpage(struct phy_device *phydev, int extpage,
+			   int reg, u16 mask, u16 val);
+
+#endif /* _REALTEK_PHY_H */
-- 
2.24.0


