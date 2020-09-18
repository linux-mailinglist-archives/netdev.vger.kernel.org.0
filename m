Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEB227078B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIRUwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgIRUwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:52:34 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A983DC0613CF
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:52:33 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so6892483wrt.3
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+JO/vRiLXpeB8VcV6Xg2lUUCdaWgeJtk26slYXjrIcM=;
        b=vobeWwYmo7S0l34NyjNzjICAmjbBDuFO2B63Xhjc0h99nUk+yVIwjhxEmNn0eUsS7T
         YGQufSHm0IXhrzvVKLvroepijQAOah7GhhHLc2ABljb5hvG8y+7siFo9ui4JcACjNyfr
         mX1iNnQsVPM/rZFwa0/ZG1guMJtDzfzs4pabG0CR+XDeTuyt2g2OiIJqJjQFMyE3deO7
         QTgtVfWoY5YvqXXLhqLtoge9beNEAOdzesj0vx+3bK2UjgzPI9lYX9gU9xzJHb2pEdNg
         EXfHoWACs8XYciBfjnL/5699gbdA3UnGQQ93tt9Ea+Eayr+cgPMUbsdbpV6Rmop2MQW2
         r/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+JO/vRiLXpeB8VcV6Xg2lUUCdaWgeJtk26slYXjrIcM=;
        b=iiprEDmWGZO2a7pzB19kH9hF7I9QDUkRozwZrAIH2emhUFcxGc7vcYggEb7ZmyaQbx
         QpbNjKoed0ynRoIKQnDWxqcjVyTlwKW9tKAGWKmrq1uvBEL8jRk+8LPKMa+7P3NOW0yl
         cXmuZZu3HfYOhBEHPnMcUJaMM1yeelXB9T5LMtpaDcw0Td2Mf9Tn5O9yF4a5rMqXq0w2
         EhHQQNdI8NWIzwKCydED0ZSuhZE8cJHMhhQ+k2ToLfhbdn+tpNku+IdGhKOts/fPpvOb
         tM+9qv7Y3804xAUzTPfqTsSySzUtptzLo1NMAXyDMbOccT6IK2hjE6yM24Zz46PJ8pPP
         Ow6Q==
X-Gm-Message-State: AOAM530QjJkW/NKhZCLgjbXm1cPOgvD+gce0KyEd5EZFpfBSLyuJWjTW
        SVdr1+uGafBL2k2FMH0ZAkZ0og==
X-Google-Smtp-Source: ABdhPJz4YtWsNsUCsdNJ1RjgsLmYbXxPyBBCR5isQie3XJGzd8Sv/eF6OmcNGLrGvOG4aC9sDfOymw==
X-Received: by 2002:adf:fd12:: with SMTP id e18mr40830264wrr.96.1600462352376;
        Fri, 18 Sep 2020 13:52:32 -0700 (PDT)
Received: from localhost.localdomain (dh207-97-14.xnet.hr. [88.207.97.14])
        by smtp.googlemail.com with ESMTPSA id z19sm6694041wmi.3.2020.09.18.13.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 13:52:31 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 1/2] net: mdio-ipq4019: change defines to upper case
Date:   Fri, 18 Sep 2020 22:52:21 +0200
Message-Id: <20200918205222.2698102-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918205222.2698102-1-robert.marko@sartura.hr>
References: <20200918205222.2698102-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the commit adding the IPQ4019 MDIO driver, defines for timeout and sleep partially used lower case.
Lets change it to upper case in line with the rest of driver defines.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio-ipq4019.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio-ipq4019.c b/drivers/net/phy/mdio-ipq4019.c
index 1ce81ff2f41d..64b169e5a699 100644
--- a/drivers/net/phy/mdio-ipq4019.c
+++ b/drivers/net/phy/mdio-ipq4019.c
@@ -21,8 +21,8 @@
 #define MDIO_CMD_ACCESS_CODE_READ	0
 #define MDIO_CMD_ACCESS_CODE_WRITE	1
 
-#define ipq4019_MDIO_TIMEOUT	10000
-#define ipq4019_MDIO_SLEEP		10
+#define IPQ4019_MDIO_TIMEOUT	10000
+#define IPQ4019_MDIO_SLEEP		10
 
 struct ipq4019_mdio_data {
 	void __iomem	*membase;
@@ -35,7 +35,7 @@ static int ipq4019_mdio_wait_busy(struct mii_bus *bus)
 
 	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
 				  (busy & MDIO_CMD_ACCESS_BUSY) == 0,
-				  ipq4019_MDIO_SLEEP, ipq4019_MDIO_TIMEOUT);
+				  IPQ4019_MDIO_SLEEP, IPQ4019_MDIO_TIMEOUT);
 }
 
 static int ipq4019_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
-- 
2.26.2

