Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8580370F8B
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhEBXIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBXII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:08 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF09C06174A;
        Sun,  2 May 2021 16:07:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i3so4297147edt.1;
        Sun, 02 May 2021 16:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YV5eZFougkqLFomRpziIWM5ZZI90CmJhUMytWBI8Wm4=;
        b=rd0W9tymiNxIFuUmY+vuiJfgGh9N2rTEEGxZgWNKZJTKmqCcYt0LQJDDKkRUDsmf+m
         4FbmTuZ6eUMxzjaapNf+kxxl0e+1IAbQSICzahVmb18Q5FmiQWmp/sKTKeHyaSKeDJs7
         fuOyruNbELKFcG7nt0Da1xlWaVyg9FiCkpnoCvrchmyJQUKHvjh9IYzHBPEfb9l7PobQ
         L/5Xq2rITf11MwguHP/T/bA38wEDQiaabksvnSCLFxu+5H6PPXixvBYi0qwvNJYtDH0X
         szrVpJnB9vD9D6MZijm676LkbKGxWWfEmo3sEpqPqIcgFfbdg5iXKIVE0f2Sus2W1ple
         zH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YV5eZFougkqLFomRpziIWM5ZZI90CmJhUMytWBI8Wm4=;
        b=D+kkbK9CQJYXiB5Orze5H4nm37rVc4Mi2TbsOHonCktqtKCTkXkjWJA685aZI2crVr
         ChSUYH+ncuqh3CVKhRU7qJULaOFDC9jHKcWh+JGb6vNlr0VcPdc8OT7C51Sm6tBJA371
         35S83Gw3+tNdNe3Q4XnkK6xBPTA0g/8xTJCU2yucgVseQ+JqsVr3rCRgT4xoxE+S0ZJZ
         85d/+647XCQotgwx1MvGc13tQIKgovU6S7xa+51qNh3JYjHKwjE/uYGHAPNWkyTTypct
         P7sT55iJAeLbFXxWBAfamP0ZVA2EwGGD/7gk7M9mP4huFaFPx8Vbmp/G6QwCwIY5jMpX
         rrBg==
X-Gm-Message-State: AOAM531djw9wRODtmuZBDpp7fFYalUSW4c5k+hGnbzoI7pxpCG8yy4DC
        eZvhLDbku37VsXt+C4kAmzPcuBvyKBQN+A==
X-Google-Smtp-Source: ABdhPJwVBh7wJUhGOy1LSnWyvTmgnUG5D+JXXLj51NICpJoi6dhF7Gbx1RciO2S6g2kPvy5Iv74HFw==
X-Received: by 2002:aa7:dc4e:: with SMTP id g14mr3688636edu.11.1619996834830;
        Sun, 02 May 2021 16:07:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:14 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 01/17] net: mdio: ipq8064: clean whitespaces in define
Date:   Mon,  3 May 2021 01:06:53 +0200
Message-Id: <20210502230710.30676-1-ansuelsmth@gmail.com>
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

