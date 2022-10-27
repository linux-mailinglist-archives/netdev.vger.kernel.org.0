Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E92D60F8EA
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiJ0NVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiJ0NVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:21:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48229A2B3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ef9sdEyx3lpk9AgJbzaW/e2n4JUzEAIMMKFRhhHsPxo=; b=SS8HHpmYc2qHGh45voYkY6ieLJ
        6rtzDYS2fMHypMEGCd/Mj4oP+veleChiYCG/W15ZzSuOT7GSDVFvTfvOoTFa71IUD4Yx5O2CQIV2u
        YZqN5+7lAcFxIicgscYdxWoGFYmyBHm5Dlw879qQ4ZVrV9az0WkzXjEb837/ffBjRCVklMNqQnASQ
        t2EgGY55CAG6rD+qjfdWbKmaG/kcl36TExscOnJC4NmUbkXka7w1M/cjrt7Jph88H5BYns+jWcMoW
        302GoRbaoDAQ6IOEIYf+7gxfwFzoc1eECqXZmNk/9Y88ySHSSPRPNKQy7saTdTs3FuBarn33Jg0P6
        hrm/uV7w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40762 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2ou-00071n-PJ; Thu, 27 Oct 2022 14:21:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2ou-00HFJg-6q; Thu, 27 Oct 2022 14:21:16 +0100
In-Reply-To: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sfp: convert register indexes from hex to
 decimal
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2ou-00HFJg-6q@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:21:16 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register indexes in the standards are in decimal rather than hex,
so lets specify them in decimal in the header file so we can easily
cross-reference without converting between hex and decimal.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/sfp.h | 180 ++++++++++++++++++++++----------------------
 1 file changed, 90 insertions(+), 90 deletions(-)

diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 01ae9f1dd2ad..4e2db155664d 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -332,37 +332,37 @@ enum {
 
 /* SFP EEPROM registers */
 enum {
-	SFP_PHYS_ID			= 0x00,
-	SFP_PHYS_EXT_ID			= 0x01,
-	SFP_CONNECTOR			= 0x02,
-	SFP_COMPLIANCE			= 0x03,
-	SFP_ENCODING			= 0x0b,
-	SFP_BR_NOMINAL			= 0x0c,
-	SFP_RATE_ID			= 0x0d,
-	SFP_LINK_LEN_SM_KM		= 0x0e,
-	SFP_LINK_LEN_SM_100M		= 0x0f,
-	SFP_LINK_LEN_50UM_OM2_10M	= 0x10,
-	SFP_LINK_LEN_62_5UM_OM1_10M	= 0x11,
-	SFP_LINK_LEN_COPPER_1M		= 0x12,
-	SFP_LINK_LEN_50UM_OM4_10M	= 0x12,
-	SFP_LINK_LEN_50UM_OM3_10M	= 0x13,
-	SFP_VENDOR_NAME			= 0x14,
-	SFP_VENDOR_OUI			= 0x25,
-	SFP_VENDOR_PN			= 0x28,
-	SFP_VENDOR_REV			= 0x38,
-	SFP_OPTICAL_WAVELENGTH_MSB	= 0x3c,
-	SFP_OPTICAL_WAVELENGTH_LSB	= 0x3d,
-	SFP_CABLE_SPEC			= 0x3c,
-	SFP_CC_BASE			= 0x3f,
-	SFP_OPTIONS			= 0x40,	/* 2 bytes, MSB, LSB */
-	SFP_BR_MAX			= 0x42,
-	SFP_BR_MIN			= 0x43,
-	SFP_VENDOR_SN			= 0x44,
-	SFP_DATECODE			= 0x54,
-	SFP_DIAGMON			= 0x5c,
-	SFP_ENHOPTS			= 0x5d,
-	SFP_SFF8472_COMPLIANCE		= 0x5e,
-	SFP_CC_EXT			= 0x5f,
+	SFP_PHYS_ID			= 0,
+	SFP_PHYS_EXT_ID			= 1,
+	SFP_CONNECTOR			= 2,
+	SFP_COMPLIANCE			= 3,
+	SFP_ENCODING			= 11,
+	SFP_BR_NOMINAL			= 12,
+	SFP_RATE_ID			= 13,
+	SFP_LINK_LEN_SM_KM		= 14,
+	SFP_LINK_LEN_SM_100M		= 15,
+	SFP_LINK_LEN_50UM_OM2_10M	= 16,
+	SFP_LINK_LEN_62_5UM_OM1_10M	= 17,
+	SFP_LINK_LEN_COPPER_1M		= 18,
+	SFP_LINK_LEN_50UM_OM4_10M	= 18,
+	SFP_LINK_LEN_50UM_OM3_10M	= 19,
+	SFP_VENDOR_NAME			= 20,
+	SFP_VENDOR_OUI			= 37,
+	SFP_VENDOR_PN			= 40,
+	SFP_VENDOR_REV			= 56,
+	SFP_OPTICAL_WAVELENGTH_MSB	= 60,
+	SFP_OPTICAL_WAVELENGTH_LSB	= 61,
+	SFP_CABLE_SPEC			= 60,
+	SFP_CC_BASE			= 63,
+	SFP_OPTIONS			= 64,	/* 2 bytes, MSB, LSB */
+	SFP_BR_MAX			= 66,
+	SFP_BR_MIN			= 67,
+	SFP_VENDOR_SN			= 68,
+	SFP_DATECODE			= 84,
+	SFP_DIAGMON			= 92,
+	SFP_ENHOPTS			= 93,
+	SFP_SFF8472_COMPLIANCE		= 94,
+	SFP_CC_EXT			= 95,
 
 	SFP_PHYS_EXT_ID_SFP		= 0x04,
 	SFP_OPTIONS_HIGH_POWER_LEVEL	= BIT(13),
@@ -404,63 +404,63 @@ enum {
 /* SFP Diagnostics */
 enum {
 	/* Alarm and warnings stored MSB at lower address then LSB */
-	SFP_TEMP_HIGH_ALARM		= 0x00,
-	SFP_TEMP_LOW_ALARM		= 0x02,
-	SFP_TEMP_HIGH_WARN		= 0x04,
-	SFP_TEMP_LOW_WARN		= 0x06,
-	SFP_VOLT_HIGH_ALARM		= 0x08,
-	SFP_VOLT_LOW_ALARM		= 0x0a,
-	SFP_VOLT_HIGH_WARN		= 0x0c,
-	SFP_VOLT_LOW_WARN		= 0x0e,
-	SFP_BIAS_HIGH_ALARM		= 0x10,
-	SFP_BIAS_LOW_ALARM		= 0x12,
-	SFP_BIAS_HIGH_WARN		= 0x14,
-	SFP_BIAS_LOW_WARN		= 0x16,
-	SFP_TXPWR_HIGH_ALARM		= 0x18,
-	SFP_TXPWR_LOW_ALARM		= 0x1a,
-	SFP_TXPWR_HIGH_WARN		= 0x1c,
-	SFP_TXPWR_LOW_WARN		= 0x1e,
-	SFP_RXPWR_HIGH_ALARM		= 0x20,
-	SFP_RXPWR_LOW_ALARM		= 0x22,
-	SFP_RXPWR_HIGH_WARN		= 0x24,
-	SFP_RXPWR_LOW_WARN		= 0x26,
-	SFP_LASER_TEMP_HIGH_ALARM	= 0x28,
-	SFP_LASER_TEMP_LOW_ALARM	= 0x2a,
-	SFP_LASER_TEMP_HIGH_WARN	= 0x2c,
-	SFP_LASER_TEMP_LOW_WARN		= 0x2e,
-	SFP_TEC_CUR_HIGH_ALARM		= 0x30,
-	SFP_TEC_CUR_LOW_ALARM		= 0x32,
-	SFP_TEC_CUR_HIGH_WARN		= 0x34,
-	SFP_TEC_CUR_LOW_WARN		= 0x36,
-	SFP_CAL_RXPWR4			= 0x38,
-	SFP_CAL_RXPWR3			= 0x3c,
-	SFP_CAL_RXPWR2			= 0x40,
-	SFP_CAL_RXPWR1			= 0x44,
-	SFP_CAL_RXPWR0			= 0x48,
-	SFP_CAL_TXI_SLOPE		= 0x4c,
-	SFP_CAL_TXI_OFFSET		= 0x4e,
-	SFP_CAL_TXPWR_SLOPE		= 0x50,
-	SFP_CAL_TXPWR_OFFSET		= 0x52,
-	SFP_CAL_T_SLOPE			= 0x54,
-	SFP_CAL_T_OFFSET		= 0x56,
-	SFP_CAL_V_SLOPE			= 0x58,
-	SFP_CAL_V_OFFSET		= 0x5a,
-	SFP_CHKSUM			= 0x5f,
-
-	SFP_TEMP			= 0x60,
-	SFP_VCC				= 0x62,
-	SFP_TX_BIAS			= 0x64,
-	SFP_TX_POWER			= 0x66,
-	SFP_RX_POWER			= 0x68,
-	SFP_LASER_TEMP			= 0x6a,
-	SFP_TEC_CUR			= 0x6c,
-
-	SFP_STATUS			= 0x6e,
+	SFP_TEMP_HIGH_ALARM		= 0,
+	SFP_TEMP_LOW_ALARM		= 2,
+	SFP_TEMP_HIGH_WARN		= 4,
+	SFP_TEMP_LOW_WARN		= 6,
+	SFP_VOLT_HIGH_ALARM		= 8,
+	SFP_VOLT_LOW_ALARM		= 10,
+	SFP_VOLT_HIGH_WARN		= 12,
+	SFP_VOLT_LOW_WARN		= 14,
+	SFP_BIAS_HIGH_ALARM		= 16,
+	SFP_BIAS_LOW_ALARM		= 18,
+	SFP_BIAS_HIGH_WARN		= 20,
+	SFP_BIAS_LOW_WARN		= 22,
+	SFP_TXPWR_HIGH_ALARM		= 24,
+	SFP_TXPWR_LOW_ALARM		= 26,
+	SFP_TXPWR_HIGH_WARN		= 28,
+	SFP_TXPWR_LOW_WARN		= 30,
+	SFP_RXPWR_HIGH_ALARM		= 32,
+	SFP_RXPWR_LOW_ALARM		= 34,
+	SFP_RXPWR_HIGH_WARN		= 36,
+	SFP_RXPWR_LOW_WARN		= 38,
+	SFP_LASER_TEMP_HIGH_ALARM	= 40,
+	SFP_LASER_TEMP_LOW_ALARM	= 42,
+	SFP_LASER_TEMP_HIGH_WARN	= 44,
+	SFP_LASER_TEMP_LOW_WARN		= 46,
+	SFP_TEC_CUR_HIGH_ALARM		= 48,
+	SFP_TEC_CUR_LOW_ALARM		= 50,
+	SFP_TEC_CUR_HIGH_WARN		= 52,
+	SFP_TEC_CUR_LOW_WARN		= 54,
+	SFP_CAL_RXPWR4			= 56,
+	SFP_CAL_RXPWR3			= 60,
+	SFP_CAL_RXPWR2			= 64,
+	SFP_CAL_RXPWR1			= 68,
+	SFP_CAL_RXPWR0			= 72,
+	SFP_CAL_TXI_SLOPE		= 76,
+	SFP_CAL_TXI_OFFSET		= 78,
+	SFP_CAL_TXPWR_SLOPE		= 80,
+	SFP_CAL_TXPWR_OFFSET		= 82,
+	SFP_CAL_T_SLOPE			= 84,
+	SFP_CAL_T_OFFSET		= 86,
+	SFP_CAL_V_SLOPE			= 88,
+	SFP_CAL_V_OFFSET		= 90,
+	SFP_CHKSUM			= 95,
+
+	SFP_TEMP			= 96,
+	SFP_VCC				= 98,
+	SFP_TX_BIAS			= 100,
+	SFP_TX_POWER			= 102,
+	SFP_RX_POWER			= 104,
+	SFP_LASER_TEMP			= 106,
+	SFP_TEC_CUR			= 108,
+
+	SFP_STATUS			= 110,
 	SFP_STATUS_TX_DISABLE		= BIT(7),
 	SFP_STATUS_TX_DISABLE_FORCE	= BIT(6),
 	SFP_STATUS_TX_FAULT		= BIT(2),
 	SFP_STATUS_RX_LOS		= BIT(1),
-	SFP_ALARM0			= 0x70,
+	SFP_ALARM0			= 112,
 	SFP_ALARM0_TEMP_HIGH		= BIT(7),
 	SFP_ALARM0_TEMP_LOW		= BIT(6),
 	SFP_ALARM0_VCC_HIGH		= BIT(5),
@@ -470,11 +470,11 @@ enum {
 	SFP_ALARM0_TXPWR_HIGH		= BIT(1),
 	SFP_ALARM0_TXPWR_LOW		= BIT(0),
 
-	SFP_ALARM1			= 0x71,
+	SFP_ALARM1			= 113,
 	SFP_ALARM1_RXPWR_HIGH		= BIT(7),
 	SFP_ALARM1_RXPWR_LOW		= BIT(6),
 
-	SFP_WARN0			= 0x74,
+	SFP_WARN0			= 116,
 	SFP_WARN0_TEMP_HIGH		= BIT(7),
 	SFP_WARN0_TEMP_LOW		= BIT(6),
 	SFP_WARN0_VCC_HIGH		= BIT(5),
@@ -484,15 +484,15 @@ enum {
 	SFP_WARN0_TXPWR_HIGH		= BIT(1),
 	SFP_WARN0_TXPWR_LOW		= BIT(0),
 
-	SFP_WARN1			= 0x75,
+	SFP_WARN1			= 117,
 	SFP_WARN1_RXPWR_HIGH		= BIT(7),
 	SFP_WARN1_RXPWR_LOW		= BIT(6),
 
-	SFP_EXT_STATUS			= 0x76,
+	SFP_EXT_STATUS			= 118,
 	SFP_EXT_STATUS_PWRLVL_SELECT	= BIT(0),
 
-	SFP_VSL				= 0x78,
-	SFP_PAGE			= 0x7f,
+	SFP_VSL				= 120,
+	SFP_PAGE			= 127,
 };
 
 struct fwnode_handle;
-- 
2.30.2

