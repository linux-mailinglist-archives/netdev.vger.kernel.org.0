Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86153B975
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfFJQcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:32:25 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34003 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfFJQcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:32:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so299378wmd.1
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UEYuVvTWd0PfLChOOhEtp6XCK3bzDXam8uN0L/f1d40=;
        b=Q5X3bnTrtDLHO0Zom8f5Q9aD/zhmWmjOzwVIw8x1Uijp/NaO362opb2doOvt2XnUk9
         4J2kZscBAyC9ZbLFTqCfeNi1HNVHNhgG04AqCt8Ov5IlKTZkaiVI24pC0Q9rMhU2JUQI
         Y3Kfk8Kv8IF/G59rsHWRRQO94C6s87RTPnNgfw/sPWZiqha1Yt2HUUCELi9NwyhcyO/c
         kV6nfu9gEQ6BDbJLNLggKzkqED48D/XWBi51F4JWVngYkL6dsv19noN9XwHC+4D7Sy1+
         k36XO+q9aGmhhGOrG/8Ojm1EyvccbZHIYgxs3M6CRSUByrHsL72gOD58oD9sD+dk3r5Q
         GAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UEYuVvTWd0PfLChOOhEtp6XCK3bzDXam8uN0L/f1d40=;
        b=Z4bhsiM2xslyiyC7pyvwkNBtdAtMBCEL8KS9VyYOnidrNP+6fcxhHSrMa+1t80+HiV
         rTUkYgrWGx/kU0MEBhWXwKUlpSyzZnetB4szWbC4I55TsTCWghMd0YiQQdlPnQ1AtNUT
         wrkRW58c/WXaoN31Hep03ZICkJMwhSzczsSmfs/7Fp2nLDlPLqF9G12TU2wTIwmaz1d9
         qwCRVMGpg2MMYsB4hOm8VbWwl2T3wNM4oy93AJSb0UtKJuPwW5TfavxyHTXrvnHKf9sd
         Ms5Rl+wfPPg+zjMhkuA5KhrRetC3fHxLijaf6S4XzmkoTJP2Ziw9apgR/uQvAgPVZ6aw
         otSQ==
X-Gm-Message-State: APjAAAVTE4RwAqoJ5h7TXWUCMTePaPatYSgVCRU4rT7pM6+NqlgFV2Ik
        Slo2SV32rlrPYqHMNm6ip279UTJo
X-Google-Smtp-Source: APXvYqwKUT7Zl/5NVl316CNBnKlxorirMm+KABd6MsMoLvPCVmuuvAIvM+ZXeb6wWlXEHod8/uPtAg==
X-Received: by 2002:a7b:c933:: with SMTP id h19mr14867110wml.52.1560183948437;
        Mon, 10 Jun 2019 09:25:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id b203sm12170965wmd.41.2019.06.10.09.25.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 09:25:47 -0700 (PDT)
Subject: [PATCH next 5/5] r8169: remove struct rtl_cfg_info
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1afce631-e188-58a9-ca72-3de2e5e73d09@gmail.com>
Message-ID: <c1e1a547-39d0-78d8-fb58-558f5f114ecf@gmail.com>
Date:   Mon, 10 Jun 2019 18:25:29 +0200
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

Simplify the code by removing struct rtl_cfg_info. Only info we need
per PCI ID is whether it supports GBit or not.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 56 ++++++++---------------
 1 file changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 65ae575ba..ca26cd659 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -73,6 +73,8 @@ static const int multicast_filter_limit = 32;
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
 
+#define RTL_CFG_NO_GBIT	1
+
 /* write/read MMIO register */
 #define RTL_W8(tp, reg, val8)	writeb((val8), tp->mmio_addr + (reg))
 #define RTL_W16(tp, reg, val16)	writew((val16), tp->mmio_addr + (reg))
@@ -200,32 +202,26 @@ static const struct {
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 };
 
-enum cfg_version {
-	RTL_CFG_0 = 0x00,
-	RTL_CFG_1,
-	RTL_CFG_2
-};
-
 static const struct pci_device_id rtl8169_pci_tbl[] = {
-	{ PCI_VDEVICE(REALTEK,	0x2502), RTL_CFG_1 },
-	{ PCI_VDEVICE(REALTEK,	0x2600), RTL_CFG_1 },
-	{ PCI_VDEVICE(REALTEK,	0x8129), RTL_CFG_0 },
-	{ PCI_VDEVICE(REALTEK,	0x8136), RTL_CFG_2 },
-	{ PCI_VDEVICE(REALTEK,	0x8161), RTL_CFG_1 },
-	{ PCI_VDEVICE(REALTEK,	0x8167), RTL_CFG_0 },
-	{ PCI_VDEVICE(REALTEK,	0x8168), RTL_CFG_1 },
-	{ PCI_VDEVICE(NCUBE,	0x8168), RTL_CFG_1 },
-	{ PCI_VDEVICE(REALTEK,	0x8169), RTL_CFG_0 },
+	{ PCI_VDEVICE(REALTEK,	0x2502) },
+	{ PCI_VDEVICE(REALTEK,	0x2600) },
+	{ PCI_VDEVICE(REALTEK,	0x8129) },
+	{ PCI_VDEVICE(REALTEK,	0x8136), RTL_CFG_NO_GBIT },
+	{ PCI_VDEVICE(REALTEK,	0x8161) },
+	{ PCI_VDEVICE(REALTEK,	0x8167) },
+	{ PCI_VDEVICE(REALTEK,	0x8168) },
+	{ PCI_VDEVICE(NCUBE,	0x8168) },
+	{ PCI_VDEVICE(REALTEK,	0x8169) },
 	{ PCI_VENDOR_ID_DLINK,	0x4300,
-		PCI_VENDOR_ID_DLINK, 0x4b10, 0, 0, RTL_CFG_1 },
-	{ PCI_VDEVICE(DLINK,	0x4300), RTL_CFG_0 },
-	{ PCI_VDEVICE(DLINK,	0x4302), RTL_CFG_0 },
-	{ PCI_VDEVICE(AT,	0xc107), RTL_CFG_0 },
-	{ PCI_VDEVICE(USR,	0x0116), RTL_CFG_0 },
+		PCI_VENDOR_ID_DLINK, 0x4b10, 0, 0 },
+	{ PCI_VDEVICE(DLINK,	0x4300), },
+	{ PCI_VDEVICE(DLINK,	0x4302), },
+	{ PCI_VDEVICE(AT,	0xc107), },
+	{ PCI_VDEVICE(USR,	0x0116), },
 	{ PCI_VENDOR_ID_LINKSYS,		0x1032,
-		PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
+		PCI_ANY_ID, 0x0024, 0, 0 },
 	{ 0x0001,				0x8168,
-		PCI_ANY_ID, 0x2410, 0, 0, RTL_CFG_2 },
+		PCI_ANY_ID, 0x2410, 0, 0, RTL_CFG_NO_GBIT },
 	{}
 };
 
@@ -6459,19 +6455,6 @@ static const struct net_device_ops rtl_netdev_ops = {
 
 };
 
-static const struct rtl_cfg_info {
-	unsigned int has_gmii:1;
-} rtl_cfg_infos [] = {
-	[RTL_CFG_0] = {
-		.has_gmii	= 1,
-	},
-	[RTL_CFG_1] = {
-		.has_gmii	= 1,
-	},
-	[RTL_CFG_2] = {
-	}
-};
-
 static void rtl_set_irq_mask(struct rtl8169_private *tp)
 {
 	tp->irq_mask = RTL_EVENT_NAPI | LinkChg;
@@ -6695,7 +6678,6 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
 
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	const struct rtl_cfg_info *cfg = rtl_cfg_infos + ent->driver_data;
 	/* align to u16 for is_valid_ether_addr() */
 	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
 	struct rtl8169_private *tp;
@@ -6713,7 +6695,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->dev = dev;
 	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
-	tp->supports_gmii = cfg->has_gmii;
+	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
-- 
2.21.0


