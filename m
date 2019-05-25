Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9083F2A6C0
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 21:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfEYTOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 15:14:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56200 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfEYTOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 15:14:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id x64so12387913wmb.5
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 12:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2QRHaDBeJqQMoSKXrS2cXteybH4NmXxtmYvZ6vcqiRk=;
        b=Njl3pQoPsn9fwreWuigttWPHlXgCe+5R7VmjXzgegpnhxZn0GYTkOY+4uUrkp0x/YE
         fERxNa3AKou1ByoX7s8BTX2UCkzqDhDf/IM3p+fzlrPzuD78lLyD+WzwaF1iVEjONa1P
         0FXfJWclmMwq5Y74MA/0HOaMaGaJG9xpD19uAWLcyfB8CYEEW6GiGsGrneSu8D1T+ut6
         9LYS5TXbBZU9wtuzWm6moNgVbDQJ14+JLAz0Wc4FGnsQT+rjxuok/T+hqIcvtprKg9vy
         XsUUY3dMolhKoHVZg0fLghsc0YUyL+fEpMTB7V7FNqsmVcEeqL9ybpjrqkEhUYNRtriT
         plGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2QRHaDBeJqQMoSKXrS2cXteybH4NmXxtmYvZ6vcqiRk=;
        b=oI/aczk09kIX07845bRPXYNvrXQ1axjODDbYzSh8KD6enZAOudUBNzdJJi6KAcpRkL
         accyisfyB4o7pw/xHZo3RwSQ6qxLnBYww2QkdIUj8klezAdj2lp4bOlwtFIVfTu+2cRI
         mbfdUuVA+Btn7BeBiVFtwQQJ8Ju1xrnZ+EszjXcYan3GwOvJBYqY3PSa/nXYxK2Yd0Ew
         czWm6i/44ITuscIYW77GkPJTMz1JVGnY8XapL7m6VdKwz5KVVX89rHMnY5AR9zK8cZ1e
         dVM/gCctdc+98w5FOq7ifLF7KgKo0jeAZHnf7KRUVVRLoUVskPlmzsdQGFqHHB7tE4w1
         eapw==
X-Gm-Message-State: APjAAAXN5d7cMBHSpMz+KoVDdvk4HpxRIli76oPjsJbjcDwjDA+cv5CW
        EyWpwb+h6NtZSaZV2pII8A4KC1wi
X-Google-Smtp-Source: APXvYqzwzlG7z4bmMrb2yagS6ZOqcwTcAsuW2EkRBwU+zFYltgihmJlSF4vIpzQnkzzYI9kP522Ncw==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr4182635wmc.40.1558811687917;
        Sat, 25 May 2019 12:14:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id t6sm12148446wmt.34.2019.05.25.12.14.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 12:14:47 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: remove support for RTL_GIGA_MAC_VER_01
Message-ID: <48cd2f91-3fbb-00d9-c02f-259b7583ce8e@gmail.com>
Date:   Sat, 25 May 2019 21:14:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL_GIGA_MAC_VER_01 is RTL8169, the ancestor of the chip family.
It didn't have an internal PHY and I've never seen it in the wild.
What isn't there doesn't need to be maintained, so let's remove
support for it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 43 ++++++----------------------
 1 file changed, 9 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 940ff0898..64c25913a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -81,7 +81,7 @@ static const int multicast_filter_limit = 32;
 #define RTL_R32(tp, reg)		readl(tp->mmio_addr + (reg))
 
 enum mac_version {
-	RTL_GIGA_MAC_VER_01 = 0,
+	/* support for ancient RTL_GIGA_MAC_VER_01 has been removed */
 	RTL_GIGA_MAC_VER_02,
 	RTL_GIGA_MAC_VER_03,
 	RTL_GIGA_MAC_VER_04,
@@ -146,7 +146,6 @@ static const struct {
 	const char *fw_name;
 } rtl_chip_infos[] = {
 	/* PCI devices. */
-	[RTL_GIGA_MAC_VER_01] = {"RTL8169"				},
 	[RTL_GIGA_MAC_VER_02] = {"RTL8169s"				},
 	[RTL_GIGA_MAC_VER_03] = {"RTL8110s"				},
 	[RTL_GIGA_MAC_VER_04] = {"RTL8169sb/8110sb"			},
@@ -406,8 +405,6 @@ enum rtl_register_content {
 	RxOK		= 0x0001,
 
 	/* RxStatusDesc */
-	RxBOVF	= (1 << 24),
-	RxFOVF	= (1 << 23),
 	RxRWT	= (1 << 22),
 	RxRES	= (1 << 21),
 	RxRUNT	= (1 << 20),
@@ -503,9 +500,6 @@ enum rtl_register_content {
 	LinkStatus	= 0x02,
 	FullDup		= 0x01,
 
-	/* _TBICSRBit */
-	TBILinkOK	= 0x02000000,
-
 	/* ResetCounterCommand */
 	CounterReset	= 0x1,
 
@@ -1424,7 +1418,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	}
 
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_17:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_17:
 		options = RTL_R8(tp, Config1) & ~PMEnable;
 		if (wolopts)
 			options |= PMEnable;
@@ -2252,7 +2246,6 @@ static void rtl8169_get_mac_version(struct rtl8169_private *tp)
 		{ 0xfc8, 0x100,	RTL_GIGA_MAC_VER_04 },
 		{ 0xfc8, 0x040,	RTL_GIGA_MAC_VER_03 },
 		{ 0xfc8, 0x008,	RTL_GIGA_MAC_VER_02 },
-		{ 0xfc8, 0x000,	RTL_GIGA_MAC_VER_01 },
 
 		/* Catch-all */
 		{ 0x000, 0x000,	RTL_GIGA_MAC_NONE   }
@@ -3936,7 +3929,6 @@ static void rtl_hw_phy_config(struct net_device *dev)
 {
 	static const rtl_generic_fct phy_configs[] = {
 		/* PCI devices. */
-		[RTL_GIGA_MAC_VER_01] = NULL,
 		[RTL_GIGA_MAC_VER_02] = rtl8169s_hw_phy_config,
 		[RTL_GIGA_MAC_VER_03] = rtl8169s_hw_phy_config,
 		[RTL_GIGA_MAC_VER_04] = rtl8169sb_hw_phy_config,
@@ -4001,12 +3993,6 @@ static void rtl_schedule_task(struct rtl8169_private *tp, enum rtl_flag flag)
 		schedule_work(&tp->wk.work);
 }
 
-static bool rtl_tbi_enabled(struct rtl8169_private *tp)
-{
-	return (tp->mac_version == RTL_GIGA_MAC_VER_01) &&
-	       (RTL_R8(tp, PHYstatus) & TBI_Enable);
-}
-
 static void rtl8169_init_phy(struct net_device *dev, struct rtl8169_private *tp)
 {
 	rtl_hw_phy_config(dev);
@@ -4195,7 +4181,7 @@ static void r8168_pll_power_up(struct rtl8169_private *tp)
 static void rtl_pll_power_down(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_13 ... RTL_GIGA_MAC_VER_15:
 		break;
 	default:
@@ -4206,7 +4192,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_13 ... RTL_GIGA_MAC_VER_15:
 		break;
 	default:
@@ -4217,7 +4203,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
 		RTL_W32(tp, RxConfig, RX_FIFO_THRESH | RX_DMA_BURST);
 		break;
@@ -6219,14 +6205,8 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 				dev->stats.rx_length_errors++;
 			if (status & RxCRC)
 				dev->stats.rx_crc_errors++;
-			/* RxFOVF is a reserved bit on later chip versions */
-			if (tp->mac_version == RTL_GIGA_MAC_VER_01 &&
-			    status & RxFOVF) {
-				rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
-				dev->stats.rx_fifo_errors++;
-			} else if (status & (RxRUNT | RxCRC) &&
-				   !(status & RxRWT) &&
-				   dev->features & NETIF_F_RXALL) {
+			if (status & (RxRUNT | RxCRC) && !(status & RxRWT) &&
+			    dev->features & NETIF_F_RXALL) {
 				goto process_pkt;
 			}
 		} else {
@@ -7019,7 +6999,7 @@ static void rtl_hw_initialize(struct rtl8169_private *tp)
 static bool rtl_chip_supports_csum_v2(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
 		return false;
 	default:
@@ -7035,7 +7015,7 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 
 	switch (tp->mac_version) {
 	/* RTL8169 */
-	case RTL_GIGA_MAC_VER_01 ... RTL_GIGA_MAC_VER_06:
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 		return JUMBO_7K;
 	/* RTL8168b */
 	case RTL_GIGA_MAC_VER_11:
@@ -7149,11 +7129,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (tp->mac_version == RTL_GIGA_MAC_NONE)
 		return -ENODEV;
 
-	if (rtl_tbi_enabled(tp)) {
-		dev_err(&pdev->dev, "TBI fiber mode not supported\n");
-		return -ENODEV;
-	}
-
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd);
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
-- 
2.21.0

