Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4268718C224
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbgCSVRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:17:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40871 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:17:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id f3so5017851wrw.7
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g3X36gap22YecCDN3KPZQ5VGihp53laFu6K6Ed8ZeD4=;
        b=JRS4546e7z1qaNxWeMUT3pHumE8J4rXfXFFx1cinFDaurd1ERH+i1M9E1IcKIg8Qdv
         S3sCwfP5EC0cHyPAQpxxP7KgS0PaXjmL8oH1O/M2F9GLlt44ov86R8PammXIfDAeDZyM
         C59y2GR7HsTszZwDa326DNJzXjMhoMeHBo2ENOrYRgQu8xCsqN88IxWxxhS8T3xSD88j
         xtlAixWnMhA7hJ7iPmAGouGaH7sOyWt5BmB3J/pPcmCVwycZNqAZ0Nh89ZM6Rw1ot91A
         3OPNkSHLreDqq8Rb8mysuiKIjpaDYsQR3bGB/J7ux5dZC3njUrrWiJ6gc1E//gcCvyqi
         j8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g3X36gap22YecCDN3KPZQ5VGihp53laFu6K6Ed8ZeD4=;
        b=k4QKnNMydI4V5M6B6JZja9AT8wASiLcDEzDmvY1+DagEX9J3QorcDmitFKgNst53F+
         PetTVd2JIFETHGqsx/8CrtvUjFrgDRYLh1X5IZ6qCXkODD4VM8TIkh5hPIBDlurr0wvJ
         vPAOcd6PX+bw9ykbzlpzfddWF+89dLvHE4ClCX0He+WSc2mRcg7VjgAv+QyPQ2B8ri4q
         iOIXiSklpEYo9I3OSPNdFrx/k8d2Bioh0hZ0dqGeOTnEenD05i8nw15kNntaaM3svQu8
         4b1A+hhFOkvBWwGqJXwyc1Nd04assN3ReFH8Yjh0kwpn+L9o8/mQW6m2IOa6fbZs/Q9i
         d99g==
X-Gm-Message-State: ANhLgQ1G/o1yjZrtURs5bFmMye6fb0TtVHZ9z3wyi5vb7ixnr0CGnke8
        VD1kjy2glDw8s7OftOYiZUk=
X-Google-Smtp-Source: ADFU+vscQHIO/Q8aAKqstqowmPrwZaI6nnXQOY8ow5WLbqILZ+WtjWujgbsoOUmj7ZdtlUKGIUq7gA==
X-Received: by 2002:adf:914e:: with SMTP id j72mr6737643wrj.109.1584652623232;
        Thu, 19 Mar 2020 14:17:03 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id l13sm5117655wrm.57.2020.03.19.14.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:17:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: [PATCH net-next 1/4] net: phy: mscc: rename enum rgmii_rx_clock_delay to rgmii_clock_delay
Date:   Thu, 19 Mar 2020 23:16:46 +0200
Message-Id: <20200319211649.10136-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319211649.10136-1-olteanv@gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There is nothing RX-specific about these clock skew values. So remove
"RX" from the name in preparation for the next patch where TX delays are
also going to be configured.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      | 18 +++++++++---------
 drivers/net/phy/mscc/mscc_main.c |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 29ccb2c9c095..56feb14838f3 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -12,15 +12,15 @@
 #include "mscc_macsec.h"
 #endif
 
-enum rgmii_rx_clock_delay {
-	RGMII_RX_CLK_DELAY_0_2_NS = 0,
-	RGMII_RX_CLK_DELAY_0_8_NS = 1,
-	RGMII_RX_CLK_DELAY_1_1_NS = 2,
-	RGMII_RX_CLK_DELAY_1_7_NS = 3,
-	RGMII_RX_CLK_DELAY_2_0_NS = 4,
-	RGMII_RX_CLK_DELAY_2_3_NS = 5,
-	RGMII_RX_CLK_DELAY_2_6_NS = 6,
-	RGMII_RX_CLK_DELAY_3_4_NS = 7
+enum rgmii_clock_delay {
+	RGMII_CLK_DELAY_0_2_NS = 0,
+	RGMII_CLK_DELAY_0_8_NS = 1,
+	RGMII_CLK_DELAY_1_1_NS = 2,
+	RGMII_CLK_DELAY_1_7_NS = 3,
+	RGMII_CLK_DELAY_2_0_NS = 4,
+	RGMII_CLK_DELAY_2_3_NS = 5,
+	RGMII_CLK_DELAY_2_6_NS = 6,
+	RGMII_CLK_DELAY_3_4_NS = 7
 };
 
 /* Microsemi VSC85xx PHY registers */
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2f6229a70ec1..d221583ed97a 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -525,7 +525,7 @@ static int vsc85xx_default_config(struct phy_device *phydev)
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 	mutex_lock(&phydev->lock);
 
-	reg_val = RGMII_RX_CLK_DELAY_1_1_NS << RGMII_RX_CLK_DELAY_POS;
+	reg_val = RGMII_CLK_DELAY_1_1_NS << RGMII_RX_CLK_DELAY_POS;
 
 	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
 			      MSCC_PHY_RGMII_CNTL, RGMII_RX_CLK_DELAY_MASK,
-- 
2.17.1

