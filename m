Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588BD381283
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhENVGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhENVGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:06:06 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79BCC06134F;
        Fri, 14 May 2021 14:03:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m12so606693eja.2;
        Fri, 14 May 2021 14:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqMnO3VT2i4M3faVTMux4QDLP8zL5VN1wUnSrpXnu9w=;
        b=BdiqB/0y0OBoWZuEbXF1PVMMEVNuHMweuEA7wcjq0Ync31RvWcBIkA41FwjnbcNT1Y
         MIsNsSzBT+xqpFaFtg5c6rkGa6RvpMPxFbbxnFSB4Ax2rI3TSfXaLePBd8Du5QGDxVdL
         q/zwiErIqfjlyaR0dG+Tvy0yNhtkFofbwnnHaOgzBneLdUnGT3LsIz9SLX7MFQBSbclq
         jZlbpysMr0MfGXRttZfWcOk58CeoHBsI5gQqXiA8/+3BS/O0Em/aXvJm6Qb63em5LhzI
         oakZjekTrc8KOQRDYu6fvBPc+KarAbwii1j7lRC9aiLulUETmwxMqA5Y4Ka8CAEmohte
         dEaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqMnO3VT2i4M3faVTMux4QDLP8zL5VN1wUnSrpXnu9w=;
        b=jODh0rFyiE+ZiUJHhSlXm2V+kz7/uNaBBihBDHK+ERs8JB+ZiU8IamhVktrXG9Wclr
         fKB/fBSY0uwT7Gwdw+mjYj3+w029CmE4bLYehbidCaEVsedet3exnJkmclj1h+zoC0AS
         h8ccQG0Fm+fjvigJQv0Del3IU7W0hSclWp776ccMkqRZNh2W0jKgJ2Ke6gMsX/nFeVjJ
         c+kiknLKdDLxHs4+OdA92nzFDQxf0AdfcR1YrlCfdx3/260wUhHWPGw6WOCguJiHKPzm
         yZmEjeI7ihK86sD2It0ItmN/nf2hoRATg2c4NnMFR1YU3ySwtf3oyfZGXOewBWgn8pmy
         H0Og==
X-Gm-Message-State: AOAM530F8c3Zl6GweVmSFsQduI0buEBzXJkiHNhuvF7w5q89FAoa4Uis
        bvn3N9v2ARdGOBJattv3ezA=
X-Google-Smtp-Source: ABdhPJxiKaETpI5YUfaId8voZYUy7LAyXHcq3orJgovWZGVkbaGviSzJH6KbagxjvLeIhOAuhVO6Tw==
X-Received: by 2002:a17:907:93a:: with SMTP id au26mr21595382ejc.271.1621026235647;
        Fri, 14 May 2021 14:03:55 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f7sm5428330edd.5.2021.05.14.14.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:03:55 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next 1/3] net: mdio: ipq8064: clean whitespaces in define
Date:   Fri, 14 May 2021 23:03:49 +0200
Message-Id: <20210514210351.22240-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix mixed whitespace and tab for define spacing.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/mdio-ipq8064.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
index 8fe8f0119fc1..f776a843a63b 100644
--- a/drivers/net/mdio/mdio-ipq8064.c
+++ b/drivers/net/mdio/mdio-ipq8064.c
@@ -15,25 +15,26 @@
 #include <linux/regmap.h>
 
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

