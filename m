Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87030F2CF
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 13:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhBDMBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 07:01:03 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:60982 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbhBDMBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 07:01:01 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7cro-008lpZ-Bs; Thu, 04 Feb 2021 11:32:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 9/9] lan78xx: remove set but unused 'ret' variable
Date:   Thu,  4 Feb 2021 11:31:21 +0000
Message-Id: <20210204113121.29786-10-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Incorporate changes from commit 06cd7c46b3ab ("net: usb: lan78xx:
Remove lots of set but unused 'ret' variables") that fixes kernel
build warnings.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 107 +++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 54 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 0a6f4765f595..fe1db4336e23 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1034,9 +1034,9 @@ static int lan78xx_read_raw_otp(struct lan78xx_net *dev, u32 offset,
 
 	for (i = 0; i < length; i++) {
 		lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
 		lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
+				  ((offset + i) & OTP_ADDR2_10_3));
 
 		lan78xx_write_reg(dev, OTP_FUNC_CMD, OTP_FUNC_CMD_READ_);
 		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
@@ -1090,9 +1090,9 @@ static int lan78xx_write_raw_otp(struct lan78xx_net *dev, u32 offset,
 
 	for (i = 0; i < length; i++) {
 		lan78xx_write_reg(dev, OTP_ADDR1,
-					((offset + i) >> 8) & OTP_ADDR1_15_11);
+				  ((offset + i) >> 8) & OTP_ADDR1_15_11);
 		lan78xx_write_reg(dev, OTP_ADDR2,
-					((offset + i) & OTP_ADDR2_10_3));
+				  ((offset + i) & OTP_ADDR2_10_3));
 		lan78xx_write_reg(dev, OTP_PRGM_DATA, data[i]);
 		lan78xx_write_reg(dev, OTP_TST_CMD, OTP_TST_CMD_PRGVRFY_);
 		lan78xx_write_reg(dev, OTP_CMD_GO, OTP_CMD_GO_GO_);
@@ -1235,9 +1235,9 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 	for (i = 1; i < NUM_OF_MAF; i++) {
 		lan78xx_write_reg(dev, MAF_HI(i), 0);
 		lan78xx_write_reg(dev, MAF_LO(i),
-					pdata->pfilter_table[i][1]);
+				  pdata->pfilter_table[i][1]);
 		lan78xx_write_reg(dev, MAF_HI(i),
-					pdata->pfilter_table[i][0]);
+				  pdata->pfilter_table[i][0]);
 	}
 
 	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
@@ -2236,7 +2236,7 @@ static int lan8835_fixup(struct phy_device *phydev)
 
 	/* RGMII MAC TXC Delay Enable */
 	lan78xx_write_reg(dev, MAC_RGMII_ID,
-				MAC_RGMII_ID_TXC_DELAY_EN_);
+			  MAC_RGMII_ID_TXC_DELAY_EN_);
 
 	/* RGMII TX DLL Tune Adjust */
 	lan78xx_write_reg(dev, RGMII_TX_BYP_DLL, 0x3D00);
@@ -2549,9 +2549,9 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 	/* The station MAC address in the perfect address filter table
 	 * must also be updated to ensure frames are received
 	 */
-	ret = lan78xx_write_reg(dev, MAF_HI(0), 0);
-	ret = lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
-	ret = lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
+	lan78xx_write_reg(dev, MAF_HI(0), 0);
+	lan78xx_write_reg(dev, MAF_LO(0), addr_lo);
+	lan78xx_write_reg(dev, MAF_HI(0), addr_hi | MAF_HI_VALID_);
 
 	return 0;
 }
@@ -4438,34 +4438,33 @@ static u16 lan78xx_wakeframe_crc16(const u8 *buf, int len)
 static int lan78xx_set_auto_suspend(struct lan78xx_net *dev)
 {
 	u32 buf;
-	int ret;
 
 	lan78xx_stop_tx_path(dev);
 	lan78xx_stop_rx_path(dev);
 
 	/* auto suspend (selective suspend) */
 
-	ret = lan78xx_write_reg(dev, WUCSR, 0);
-	ret = lan78xx_write_reg(dev, WUCSR2, 0);
-	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+	lan78xx_write_reg(dev, WUCSR, 0);
+	lan78xx_write_reg(dev, WUCSR2, 0);
+	lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
 
 	/* set goodframe wakeup */
 
-	ret = lan78xx_read_reg(dev, WUCSR, &buf);
+	lan78xx_read_reg(dev, WUCSR, &buf);
 	buf |= WUCSR_RFE_WAKE_EN_;
 	buf |= WUCSR_STORE_WAKE_;
-	ret = lan78xx_write_reg(dev, WUCSR, buf);
-	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	lan78xx_write_reg(dev, WUCSR, buf);
+	lan78xx_read_reg(dev, PMT_CTL, &buf);
 	buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
 	buf |= PMT_CTL_RES_CLR_WKP_STS_;
 	buf |= PMT_CTL_PHY_WAKE_EN_;
 	buf |= PMT_CTL_WOL_EN_;
 	buf &= ~PMT_CTL_SUS_MODE_MASK_;
 	buf |= PMT_CTL_SUS_MODE_3_;
-	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
-	ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+	lan78xx_write_reg(dev, PMT_CTL, buf);
+	lan78xx_read_reg(dev, PMT_CTL, &buf);
 	buf |= PMT_CTL_WUPS_MASK_;
-	ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+	lan78xx_write_reg(dev, PMT_CTL, buf);
 
 	lan78xx_start_rx_path(dev);
 
@@ -4528,10 +4527,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		/* set WUF_CFG & WUF_MASK for IPv4 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv4_multicast, 3);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 7);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -4542,10 +4541,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		/* for IPv6 Multicast */
 		crc = lan78xx_wakeframe_crc16(ipv6_multicast, 2);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_MCAST_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_MCAST_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 3);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -4572,10 +4571,10 @@ static int lan78xx_set_suspend(struct lan78xx_net *dev, u32 wol)
 		 */
 		crc = lan78xx_wakeframe_crc16(arp_type, 2);
 		lan78xx_write_reg(dev, WUF_CFG(mask_index),
-					WUF_CFGX_EN_ |
-					WUF_CFGX_TYPE_ALL_ |
-					(0 << WUF_CFGX_OFFSET_SHIFT_) |
-					(crc & WUF_CFGX_CRC16_MASK_));
+				  WUF_CFGX_EN_ |
+				  WUF_CFGX_TYPE_ALL_ |
+				  (0 << WUF_CFGX_OFFSET_SHIFT_) |
+				  (crc & WUF_CFGX_CRC16_MASK_));
 
 		lan78xx_write_reg(dev, WUF_MASK0(mask_index), 0x3000);
 		lan78xx_write_reg(dev, WUF_MASK1(mask_index), 0);
@@ -4667,19 +4666,19 @@ static int lan78xx_suspend(struct usb_interface *intf, pm_message_t message)
 
 		set_bit(EVENT_DEV_ASLEEP, &dev->flags);
 
-		ret = lan78xx_write_reg(dev, WUCSR, 0);
-		ret = lan78xx_write_reg(dev, WUCSR2, 0);
+		lan78xx_write_reg(dev, WUCSR, 0);
+		lan78xx_write_reg(dev, WUCSR2, 0);
 
-		ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		lan78xx_read_reg(dev, PMT_CTL, &buf);
 		buf &= ~PMT_CTL_RES_CLR_WKP_EN_;
 		buf |= PMT_CTL_RES_CLR_WKP_STS_;
 		buf &= ~PMT_CTL_SUS_MODE_MASK_;
 		buf |= PMT_CTL_SUS_MODE_3_;
-		ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+		lan78xx_write_reg(dev, PMT_CTL, buf);
 
-		ret = lan78xx_read_reg(dev, PMT_CTL, &buf);
+		lan78xx_read_reg(dev, PMT_CTL, &buf);
 		buf |= PMT_CTL_WUPS_MASK_;
-		ret = lan78xx_write_reg(dev, PMT_CTL, buf);
+		lan78xx_write_reg(dev, PMT_CTL, buf);
 	}
 
 	ret = 0;
@@ -4783,22 +4782,22 @@ static int lan78xx_resume(struct usb_interface *intf)
 		clear_bit(EVENT_DEV_ASLEEP, &dev->flags);
 	}
 
-	ret = lan78xx_write_reg(dev, WUCSR2, 0);
-	ret = lan78xx_write_reg(dev, WUCSR, 0);
-	ret = lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
-
-	ret = lan78xx_write_reg(dev, WUCSR2, WUCSR2_NS_RCD_ |
-					     WUCSR2_ARP_RCD_ |
-					     WUCSR2_IPV6_TCPSYN_RCD_ |
-					     WUCSR2_IPV4_TCPSYN_RCD_);
-
-	ret = lan78xx_write_reg(dev, WUCSR, WUCSR_EEE_TX_WAKE_ |
-					    WUCSR_EEE_RX_WAKE_ |
-					    WUCSR_PFDA_FR_ |
-					    WUCSR_RFE_WAKE_FR_ |
-					    WUCSR_WUFR_ |
-					    WUCSR_MPR_ |
-					    WUCSR_BCST_FR_);
+	lan78xx_write_reg(dev, WUCSR2, 0);
+	lan78xx_write_reg(dev, WUCSR, 0);
+	lan78xx_write_reg(dev, WK_SRC, 0xFFF1FF1FUL);
+
+	lan78xx_write_reg(dev, WUCSR2, WUCSR2_NS_RCD_ |
+				       WUCSR2_ARP_RCD_ |
+				       WUCSR2_IPV6_TCPSYN_RCD_ |
+				       WUCSR2_IPV4_TCPSYN_RCD_);
+
+	lan78xx_write_reg(dev, WUCSR, WUCSR_EEE_TX_WAKE_ |
+				      WUCSR_EEE_RX_WAKE_ |
+				      WUCSR_PFDA_FR_ |
+				      WUCSR_RFE_WAKE_FR_ |
+				      WUCSR_WUFR_ |
+				      WUCSR_MPR_ |
+				      WUCSR_BCST_FR_);
 
 	mutex_unlock(&dev->dev_mutex);
 
-- 
2.17.1

