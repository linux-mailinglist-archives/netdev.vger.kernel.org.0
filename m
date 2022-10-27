Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFE60F8EB
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiJ0NVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbiJ0NVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:21:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84DF9C20A
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uyBDQ9fwuIGf/NuFeYx4hhmpjAVrylKJcZpwOvpaBSM=; b=qX3kCVXPvWtRui5PpVZTg1FCDr
        MsiQG1uWXKwJKqrJty3noe5b7aZu6bNff02tyQuPJosqSqpD5rAio74Xb33Ko6MPbxQP2iq51GcUF
        SzqmKmFkBp/HfDeGWn3GyHtfrZHxN9jFJDVCyILrkk2BXSTVZfickmFGOBQ5XWp/NbPqjsdTPBj/2
        BCGqe9MFkdj3QdTxpL33koWsa/Aywa787rsmyHqDF87yqXv9ZpVQRiNQB8dd9HntiLW+Ke4fs9dTj
        q8FA2hm2O00CGK/bQHVc+muTgg3e9m/Ah32pzn660dI+qUUXvIA/QmccRJ9GhWNv3bDTreT91IoAz
        VjJslfYw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45928 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2oz-00071x-SX; Thu, 27 Oct 2022 14:21:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2oz-00HFJm-AF; Thu, 27 Oct 2022 14:21:21 +0100
In-Reply-To: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
References: <Y1qFvaDlLVM1fHdG@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sfp: move field definitions along side
 register index
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2oz-00HFJm-AF@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:21:21 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just as we do for the A2h enum, arrange the A0h enum to have the
field definitions next to their corresponding register index.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/sfp.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index 4e2db155664d..52b98f9666a2 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -333,7 +333,10 @@ enum {
 /* SFP EEPROM registers */
 enum {
 	SFP_PHYS_ID			= 0,
+
 	SFP_PHYS_EXT_ID			= 1,
+	SFP_PHYS_EXT_ID_SFP		= 0x04,
+
 	SFP_CONNECTOR			= 2,
 	SFP_COMPLIANCE			= 3,
 	SFP_ENCODING			= 11,
@@ -354,17 +357,8 @@ enum {
 	SFP_OPTICAL_WAVELENGTH_LSB	= 61,
 	SFP_CABLE_SPEC			= 60,
 	SFP_CC_BASE			= 63,
-	SFP_OPTIONS			= 64,	/* 2 bytes, MSB, LSB */
-	SFP_BR_MAX			= 66,
-	SFP_BR_MIN			= 67,
-	SFP_VENDOR_SN			= 68,
-	SFP_DATECODE			= 84,
-	SFP_DIAGMON			= 92,
-	SFP_ENHOPTS			= 93,
-	SFP_SFF8472_COMPLIANCE		= 94,
-	SFP_CC_EXT			= 95,
 
-	SFP_PHYS_EXT_ID_SFP		= 0x04,
+	SFP_OPTIONS			= 64,	/* 2 bytes, MSB, LSB */
 	SFP_OPTIONS_HIGH_POWER_LEVEL	= BIT(13),
 	SFP_OPTIONS_PAGING_A2		= BIT(12),
 	SFP_OPTIONS_RETIMER		= BIT(11),
@@ -378,11 +372,20 @@ enum {
 	SFP_OPTIONS_TX_FAULT		= BIT(3),
 	SFP_OPTIONS_LOS_INVERTED	= BIT(2),
 	SFP_OPTIONS_LOS_NORMAL		= BIT(1),
+
+	SFP_BR_MAX			= 66,
+	SFP_BR_MIN			= 67,
+	SFP_VENDOR_SN			= 68,
+	SFP_DATECODE			= 84,
+
+	SFP_DIAGMON			= 92,
 	SFP_DIAGMON_DDM			= BIT(6),
 	SFP_DIAGMON_INT_CAL		= BIT(5),
 	SFP_DIAGMON_EXT_CAL		= BIT(4),
 	SFP_DIAGMON_RXPWR_AVG		= BIT(3),
 	SFP_DIAGMON_ADDRMODE		= BIT(2),
+
+	SFP_ENHOPTS			= 93,
 	SFP_ENHOPTS_ALARMWARN		= BIT(7),
 	SFP_ENHOPTS_SOFT_TX_DISABLE	= BIT(6),
 	SFP_ENHOPTS_SOFT_TX_FAULT	= BIT(5),
@@ -390,6 +393,8 @@ enum {
 	SFP_ENHOPTS_SOFT_RATE_SELECT	= BIT(3),
 	SFP_ENHOPTS_APP_SELECT_SFF8079	= BIT(2),
 	SFP_ENHOPTS_SOFT_RATE_SFF8431	= BIT(1),
+
+	SFP_SFF8472_COMPLIANCE		= 94,
 	SFP_SFF8472_COMPLIANCE_NONE	= 0x00,
 	SFP_SFF8472_COMPLIANCE_REV9_3	= 0x01,
 	SFP_SFF8472_COMPLIANCE_REV9_5	= 0x02,
@@ -399,6 +404,8 @@ enum {
 	SFP_SFF8472_COMPLIANCE_REV11_3	= 0x06,
 	SFP_SFF8472_COMPLIANCE_REV11_4	= 0x07,
 	SFP_SFF8472_COMPLIANCE_REV12_0	= 0x08,
+
+	SFP_CC_EXT			= 95,
 };
 
 /* SFP Diagnostics */
-- 
2.30.2

