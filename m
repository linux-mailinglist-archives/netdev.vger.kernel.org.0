Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14995273578
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgIUWLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgIUWLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 18:11:03 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82105C0613D0;
        Mon, 21 Sep 2020 15:11:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id y1so10231582pgk.8;
        Mon, 21 Sep 2020 15:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2r2b0KPod5OkUOq1IUFI5hozrLOWDCfm+dUGdotpenI=;
        b=e2fT3Rs3Jc9WVXprfz87UCl8fvvSR1xwSmJDxb8ntg/WIfp27v8Q+2PeGMmtI0pNO+
         ozVhDQFqv8QjwIVgwxyGOyL11aBA9poO8mEpVh/6rubsfiAM2vQUY78Cqz0UoyEQ7y96
         SiT64mmZbsHwX8Kxhbs98I08rP2oMee795Rn6CQmqLKJXB0AVgmBlZtQ1BlvIIzviTsz
         fqT7ttz6W+3xUPmH9eS/Aq0kK0LtZCzn7yAasS2+d4A+5AtmlVXExCOg84sFYzWvUiU6
         p4/k7f/Q7MN9t4nYg8YOhss+5U4pMXS2bd6zeeyKMR6fFWItCO1jnCr5OKa6231FU071
         m8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2r2b0KPod5OkUOq1IUFI5hozrLOWDCfm+dUGdotpenI=;
        b=X3JNhTdm4fi5C3X57NSTgbAd/hdIKT7ZJ0OxQBf8aJ8re/SQWmrsXmP0X1vUjKCG7V
         EBg1C1Kah3A0nFeKS3WEVuU5WeoFiDoAlE+Z0G2jLB9EdNhTxfJ8uJKckUucWisLcgWG
         +H0M0HRU71EPwvWy9Calwi6zh5UiuLWvT464mppOuNQEEUQnCAi23ssRLDMm3RMJHqz8
         lPl9rR004IA9vhSBsuYXMOGfJPxBm991YZ0jbOoxl/HSd4hjk+CWjPjkd9HxEaENgbHN
         myW/9R8WUf+rPSgy5K1ZBROHYws9Gz20JY/V6l/30fp5zTXigmRouJ4h67fVG/ic55HM
         uIOQ==
X-Gm-Message-State: AOAM530ZfvFYSxNQW3Zc46Nr9py24O5sRCZkp8Hgqu9feLAQL1/8vxNV
        uFavSXJgPBQYEeu4L6DgilDGkXXcbtCJHw==
X-Google-Smtp-Source: ABdhPJzivyHMR5wxwkIqLH+bhvIpB9lD0c9i58dW9j8BC8GNUIIvkc+74+rRywg27DztRbYbhMe2dg==
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id n20-20020a1709029694b02900d21b520f46mr1930061plp.78.1600726262563;
        Mon, 21 Sep 2020 15:11:02 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w6sm13000643pgf.72.2020.09.21.15.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 15:11:01 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: bcm7xxx: Add an entry for BCM72113
Date:   Mon, 21 Sep 2020 15:10:53 -0700
Message-Id: <20200921221053.2506156-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM72113 features a 28nm integrated EPHY, add an entry to the driver for
it.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 2 ++
 include/linux/brcmphy.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 744c24491d63..15812001b3ff 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -611,6 +611,7 @@ static void bcm7xxx_28nm_remove(struct phy_device *phydev)
 }
 
 static struct phy_driver bcm7xxx_driver[] = {
+	BCM7XXX_28NM_EPHY(PHY_ID_BCM72113, "Broadcom BCM72113"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7250, "Broadcom BCM7250"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7255, "Broadcom BCM7255"),
 	BCM7XXX_28NM_EPHY(PHY_ID_BCM7260, "Broadcom BCM7260"),
@@ -631,6 +632,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 };
 
 static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
+	{ PHY_ID_BCM72113, 0xfffffff0 },
 	{ PHY_ID_BCM7250, 0xfffffff0, },
 	{ PHY_ID_BCM7255, 0xfffffff0, },
 	{ PHY_ID_BCM7260, 0xfffffff0, },
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 6ad4c000661a..d0bd226d6bd9 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -30,6 +30,7 @@
 #define PHY_ID_BCM57780			0x03625d90
 #define PHY_ID_BCM89610			0x03625cd0
 
+#define PHY_ID_BCM72113			0x35905310
 #define PHY_ID_BCM7250			0xae025280
 #define PHY_ID_BCM7255			0xae025120
 #define PHY_ID_BCM7260			0xae025190
-- 
2.25.1

