Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936EC379CC0
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhEKCNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhEKCNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:13:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF70CC06138F;
        Mon, 10 May 2021 19:11:14 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso330628wmj.2;
        Mon, 10 May 2021 19:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqMnO3VT2i4M3faVTMux4QDLP8zL5VN1wUnSrpXnu9w=;
        b=j1U5wyUsopAMXiyf1xFL8ED6UCP0l77w++CD6EtlObxoyzcQ0XK+7tFa5MvCExRbTu
         3uMbL6ZJrNe6x/K0vCk8E9AzjdmmdT1DDMxjDo+MsFSDjnbeyOlo1O20OW0p2CB/4KJz
         hbXcxC3ubjV85hv1CZU4gS0y83+LyWg9ZrD1n02VVK8mjTfCVMP8rY5KY3FSa1X3L8JW
         ZhVfgXiS8+BXD2HldKEs8j8taXqV3LkYFi1XqlHYm7CYTr1y+YSdnOSOhjnUq6H8GSmR
         s6sQxS6yKGKDK30I6cgmsT/c9tukO3aSkY51QI69QQ0dri2QfvfJvGBBQgDH+1YB0ZMq
         9kuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EqMnO3VT2i4M3faVTMux4QDLP8zL5VN1wUnSrpXnu9w=;
        b=ZIHLD5iF82ccAeYFNGy2ij1uzhCc6DKxraUkG4VNU+3TwtpbE4VqL9OPQzQ0Isvr1p
         0Mhq0SL/IHW//r9u6yLkYkiIYxs+iz9bH/jLQFj4GbPUNWh5cNDsT/BUxMTmfoS9tH0Z
         G7cYoBNrRlE9aB+4OXTXFNPtdaGAIm18CE8SmNfcEoEXjvZDNswRkJiN9CTVrztcQy/Z
         OaoiOKgwIag3P/+BTCU3Xk1F4c1OOt51zKnT5R6H8uIdUF5mTDGsUZZx8tCOQ8q9Webu
         NJBCwQcu4QB7cZC8xcWNgAw9ZqZjz8rGA1TZN4aHijPTlHF8k7AGnI6JvKenzIFI8wfI
         Jy6w==
X-Gm-Message-State: AOAM530YGdvKHdpw/9tApozDrvpxgIIcVxccnzjYxK6dVSsVM37GqGAt
        NpZRXF+0yij2kXJrIlUDem8=
X-Google-Smtp-Source: ABdhPJzAKb0WPvb+XsyoBXn0VGYjgsjHYPCoYFnBZI8t1W+jrP9tkyRMFHQ7BDIzmlS7nSxE/FtDfA==
X-Received: by 2002:a05:600c:2242:: with SMTP id a2mr29400413wmm.125.1620699073430;
        Mon, 10 May 2021 19:11:13 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id l18sm25697583wrt.97.2021.05.10.19.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:11:13 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:ETHERNET PHY LIBRARY),
        linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 1/3] net: mdio: ipq8064: clean whitespaces in define
Date:   Tue, 11 May 2021 04:11:08 +0200
Message-Id: <20210511021110.17522-1-ansuelsmth@gmail.com>
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

