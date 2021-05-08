Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79807376DAA
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhEHAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEHAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:30:21 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ED2C061574;
        Fri,  7 May 2021 17:29:19 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so5750717wmh.4;
        Fri, 07 May 2021 17:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zzb7lt9+x9O2s44k4kSu1lzOPp+x1XlcNqKjooCHFzg=;
        b=s0BGHi3g9S7i92EBWHhs/u7b07WHcJYAaSjPWTS2I+9CBuWQ6iSCRMBTVp8AZw6sMt
         A0q6LqdHBxh7hUSIFz9Np6HdKI6+QwFsozgPHOhYSC1y3PcuGDL7TrXT6AoiLp8T9F8N
         S8faMkOxWx+nNCh0j6/P5uf5YJUVBj6+aNtPDJEN5jkhwriXvNk+cD188uvUYsuF3TCV
         h5IEOKlTW2ZeV5Z0ndkn9bl2Y7AOIcG5As7mZG0b/YXZeKFFzwRW5ibfTE2S77QMhvRB
         vq5gxfukb4Q7UBLBGh3PqXBlohAPbnsNonc+iJ0wsMM/Um+8gdJvc+gpJ0iEofXXXA65
         AIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zzb7lt9+x9O2s44k4kSu1lzOPp+x1XlcNqKjooCHFzg=;
        b=SlLnrh65Hr9xlow6/Tv2JIQ0TArLinzQ3nTId1HVmBJRZ34vB+NHvrtnrbMSeXVPMl
         o2uAZ116HdhS1v9AiktnF+S/wE0XfFos1RmC4pQjI8K37lbNYwCpegHKp17fLJD3Q4PX
         lviJ73oLpdtY9KgcdVuTIK2SYc/tVT20EuRnZj4efu8oy9gdXSPOC/OJOpJp/5/mvBdw
         R7b9BaDaa9kKRLXIw29RpOVYaWko8g4GGlGBwpOBoRf2oS8RRLYkO1n1e08RgiOwfJ/S
         5Yfr2snBRVKjEl/8klgSifIogbc0e6FD/JYdrNmAu3CfaMcAHx+zen06aiOTqQLZtYZ6
         LBdA==
X-Gm-Message-State: AOAM533GBWDZlyA2or/RY3TH8aT3hRi0xrl2oQz4oOU33Y61KcveDjfl
        /2PcsQDrvuPUYEEbgeBEnN0=
X-Google-Smtp-Source: ABdhPJwGGbtKbVOUb99QhM7IxRgzszX/N68JVA8x41GPfbF0L3O8s7BNaObPJPmCbDuKjMZ+8Y0HLA==
X-Received: by 2002:a7b:c94b:: with SMTP id i11mr1481097wml.120.1620433758489;
        Fri, 07 May 2021 17:29:18 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:18 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean whitespaces in define
Date:   Sat,  8 May 2021 02:28:51 +0200
Message-Id: <20210508002920.19945-1-ansuelsmth@gmail.com>
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

