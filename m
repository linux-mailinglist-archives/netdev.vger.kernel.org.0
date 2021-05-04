Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9BD37324E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhEDWa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232667AbhEDWaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CA1C061574;
        Tue,  4 May 2021 15:29:27 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id t4so15637192ejo.0;
        Tue, 04 May 2021 15:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YV5eZFougkqLFomRpziIWM5ZZI90CmJhUMytWBI8Wm4=;
        b=XMyAkG6Y8BBvmy4eZNbFoGF1BgPKQF24DTQOH5xFmmrpBKMXRVB1wodi8AHTLlca19
         5pBslCHVmY6oQheq5Px1uOIT1bVdMsNPX9UcAfHiqLUNFC3b4Lek7Rhjk75tsMwaE6Qd
         sGGhKpZXQlMGc15XqWC/rCxucRwRQzX52QuA8LbHkHfk16/rEJrxPJIjonAs4lTAAfEC
         u2eGavg6VSIdLhx2FbvuuYGsk9DOsRJA6kgU+N1bwUaHZweQBKjIt0YAclfFeZHK46Aa
         3b4+vo1FhS4eA8OfaYKKZffpN3q1fX6szqJzYeEOafotzyGPMCUqCHPx/TIpu01fOx6d
         4aYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YV5eZFougkqLFomRpziIWM5ZZI90CmJhUMytWBI8Wm4=;
        b=F0adHzPz5jPsw5U3DLs7D6lxkfl/PhoX95fB+Tqo+UtVoq5QmB9VO6vOWtdeknTIB5
         Wid3ymrQLVFAt3qgIo7qztAgfqyvXfADFJ/cOPL+Ttvy0hDicdVnFW+4JGiLFNz0d3Hj
         pOKWFzkJIn1cTtn+E+WVtc6pNnl9TVUci1j+PVEtrqbvZJYIH6CHuWiazuVkkLSNHFTX
         0AyastbXQvF8l3+TRUt8AaR7FOhHe+Xhmigdu2PcSPE7vB5/4LgwbAh6yp9xjGSV2Ru1
         /JU4FRQf3GQOWdg9eOIRL+F07177SxUMyXpeDJDcG90Z/Lei1a0hP+UCdE4Alwwm2rdd
         JNuw==
X-Gm-Message-State: AOAM531rIjqRixPGLcizcCEOBfq1XWaNvwRuZ51N4s2j1Av4HWT9MSln
        INmFIyuyw7T7J/71ekxfaEvsiWgY+/ugaQ==
X-Google-Smtp-Source: ABdhPJwDRLwfeG7iRZnAPhequ5WtwT6q9xZ18zcF7CL72wsQgiB3X9HVmrszzDxtIt3/v32hAuJfEQ==
X-Received: by 2002:a17:907:960b:: with SMTP id gb11mr14542966ejc.123.1620167366514;
        Tue, 04 May 2021 15:29:26 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 01/20] net: mdio: ipq8064: clean whitespaces in define
Date:   Wed,  5 May 2021 00:28:55 +0200
Message-Id: <20210504222915.17206-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix mixed whitespace and tab for define spacing.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/mdio/mdio-ipq8064.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 1bd18857e1c5..fb1614242e13 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -15,25 +15,26 @@
 #include <linux/mfd/syscon.h>
 
 /* MII address register definitions */
-#define MII_ADDR_REG_ADDR                       0x10
-#define MII_BUSY                                BIT(0)
-#define MII_WRITE                               BIT(1)
-#define MII_CLKRANGE_60_100M                    (0 << 2)
-#define MII_CLKRANGE_100_150M                   (1 << 2)
-#define MII_CLKRANGE_20_35M                     (2 << 2)
-#define MII_CLKRANGE_35_60M                     (3 << 2)
-#define MII_CLKRANGE_150_250M                   (4 << 2)
-#define MII_CLKRANGE_250_300M                   (5 << 2)
+#define MII_ADDR_REG_ADDR			0x10
+#define MII_BUSY				BIT(0)
+#define MII_WRITE				BIT(1)
+#define MII_CLKRANGE(x)				((x) << 2)
+#define MII_CLKRANGE_60_100M			MII_CLKRANGE(0)
+#define MII_CLKRANGE_100_150M			MII_CLKRANGE(1)
+#define MII_CLKRANGE_20_35M			MII_CLKRANGE(2)
+#define MII_CLKRANGE_35_60M			MII_CLKRANGE(3)
+#define MII_CLKRANGE_150_250M			MII_CLKRANGE(4)
+#define MII_CLKRANGE_250_300M			MII_CLKRANGE(5)
 #define MII_CLKRANGE_MASK			GENMASK(4, 2)
 #define MII_REG_SHIFT				6
 #define MII_REG_MASK				GENMASK(10, 6)
 #define MII_ADDR_SHIFT				11
 #define MII_ADDR_MASK				GENMASK(15, 11)
 
-#define MII_DATA_REG_ADDR                       0x14
+#define MII_DATA_REG_ADDR			0x14
 
-#define MII_MDIO_DELAY_USEC                     (1000)
-#define MII_MDIO_RETRY_MSEC                     (10)
+#define MII_MDIO_DELAY_USEC			(1000)
+#define MII_MDIO_RETRY_MSEC			(10)
 
 struct ipq8064_mdio {
 	struct regmap *base; /* NSS_GMAC0_BASE */
-- 
2.30.2

