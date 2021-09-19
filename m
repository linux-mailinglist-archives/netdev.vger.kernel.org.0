Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD94410C38
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhISPpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 11:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhISPpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 11:45:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766D5C061574;
        Sun, 19 Sep 2021 08:43:46 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v24so50626740eda.3;
        Sun, 19 Sep 2021 08:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cdE3tlr27r+sjfChK7knCeuUo8PGCjjDp/M+CvdPjmg=;
        b=hhUgILbuYNm6pTiR5yB6kasYLq5KnxMIEisqdjuTPwQtkdxyxTgJHCB0bPMoEhIjIe
         4m2P11Wkg+c09xWySzIatDu6OD0K2+G4OCnVtUEtYotGPLQBzNoXZRUqOqTkfgrN2+LA
         g9l+8PgToTL4Y+umPGwEWrIhuBz72w28QD1Yex01uVQoFm0dWmrDOGXFaq1HrEQJA6Vf
         cRPPkGSNMXoj9fa3/69QXSNP7fNM6Egw5OJgMqj13Mx3dZ85qLwF+eTz5GT8WS0PtDUG
         cRQOebUcABmqOnPAjmqQDch+UzL5/GRSOPt26WMVbJ1+898mtEbCRI8qNR6eEViJ4Bjv
         pA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cdE3tlr27r+sjfChK7knCeuUo8PGCjjDp/M+CvdPjmg=;
        b=T+72BC8yJR7MMlIr44bVaM7LdmLRN5nWGpjHbPR3UZM2dCd5/j5pToERxnWyqfQ4J6
         5cP82ekbuluuA5nDIm28+zd/crIHaUGpzfbwRRt1CeEQciKeCseYBzBws+ItS2HaYR/4
         K2xF6MydkCLARdc0zaURnrD/gzIW+aDM6jPCbbsVkITbvx/Mafz+fMvZWs9opT3YsNcL
         6uuUKvYRiS2zS0iJlnosd1muAmjaDaMN4ZRP0lfmfEAtNCaSRzG55nRHIDBQPHnRFVGn
         xhg34RjS9ZgrJuzmWqjRkNebb+PTwVgnehDcVOQo4/J5Nm8JWHjyIzG8Skzk4UAd8qES
         Ho8w==
X-Gm-Message-State: AOAM530iaac52xLRERkoRKKiRwCKJI74Z5hlQGP2cg3rmqNT/SklbjfY
        4WFKtPTRMBqKtKs/AshH1ei/ZofjpYo=
X-Google-Smtp-Source: ABdhPJy+8m5K7XvuDsGAV3V4a6JGGjPwaeRZKUEvwB2u7px2G/voQUJ79njLRDW5sfWlBcITw6qh/w==
X-Received: by 2002:a17:906:3b56:: with SMTP id h22mr23385797ejf.141.1632066224875;
        Sun, 19 Sep 2021 08:43:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id g10sm4999309ejj.44.2021.09.19.08.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 08:43:44 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 3/3] net: phy: at803x: fix spacing and improve name for 83xx phy
Date:   Sun, 19 Sep 2021 17:11:46 +0200
Message-Id: <20210919151146.10501-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210919151146.10501-1-ansuelsmth@gmail.com>
References: <20210919151146.10501-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix spacing and improve name for 83xx phy following other phy in the
same driver.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 60 ++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 8156fbc7f00d..f6f44d343667 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1422,47 +1422,47 @@ static struct phy_driver at803x_driver[] = {
 	.config_aneg		= at803x_config_aneg,
 }, {
 	/* QCA8337 */
-	.phy_id = QCA8337_PHY_ID,
-	.phy_id_mask = QCA8K_PHY_ID_MASK,
-	.name = "QCA PHY 8337",
+	.phy_id			= QCA8337_PHY_ID,
+	.phy_id_mask		= QCA8K_PHY_ID_MASK,
+	.name			= "Qualcomm Atheros 8337 internal PHY",
 	/* PHY_GBIT_FEATURES */
-	.probe = at803x_probe,
-	.flags = PHY_IS_INTERNAL,
-	.config_init = qca83xx_config_init,
-	.soft_reset = genphy_soft_reset,
-	.get_sset_count = at803x_get_sset_count,
-	.get_strings = at803x_get_strings,
-	.get_stats = at803x_get_stats,
+	.probe			= at803x_probe,
+	.flags			= PHY_IS_INTERNAL,
+	.config_init		= qca83xx_config_init,
+	.soft_reset		= genphy_soft_reset,
+	.get_sset_count		= at803x_get_sset_count,
+	.get_strings		= at803x_get_strings,
+	.get_stats		= at803x_get_stats,
 	.suspend		= qca83xx_suspend,
 	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-A from switch QCA8327-AL1A */
-	.phy_id = QCA8327_A_PHY_ID,
-	.phy_id_mask = QCA8K_PHY_ID_MASK,
-	.name = "QCA PHY 8327-A",
+	.phy_id			= QCA8327_A_PHY_ID,
+	.phy_id_mask		= QCA8K_PHY_ID_MASK,
+	.name			= "Qualcomm Atheros 8327-A internal PHY",
 	/* PHY_GBIT_FEATURES */
-	.probe = at803x_probe,
-	.flags = PHY_IS_INTERNAL,
-	.config_init = qca83xx_config_init,
-	.soft_reset = genphy_soft_reset,
-	.get_sset_count = at803x_get_sset_count,
-	.get_strings = at803x_get_strings,
-	.get_stats = at803x_get_stats,
+	.probe			= at803x_probe,
+	.flags			= PHY_IS_INTERNAL,
+	.config_init		= qca83xx_config_init,
+	.soft_reset		= genphy_soft_reset,
+	.get_sset_count		= at803x_get_sset_count,
+	.get_strings		= at803x_get_strings,
+	.get_stats		= at803x_get_stats,
 	.suspend		= qca83xx_suspend,
 	.resume			= qca83xx_resume,
 }, {
 	/* QCA8327-B from switch QCA8327-BL1A */
-	.phy_id = QCA8327_B_PHY_ID,
-	.phy_id_mask = QCA8K_PHY_ID_MASK,
-	.name = "QCA PHY 8327-B",
+	.phy_id			= QCA8327_B_PHY_ID,
+	.phy_id_mask		= QCA8K_PHY_ID_MASK,
+	.name			= "Qualcomm Atheros 8327-B internal PHY",
 	/* PHY_GBIT_FEATURES */
-	.probe = at803x_probe,
-	.flags = PHY_IS_INTERNAL,
-	.config_init = qca83xx_config_init,
-	.soft_reset = genphy_soft_reset,
-	.get_sset_count = at803x_get_sset_count,
-	.get_strings = at803x_get_strings,
-	.get_stats = at803x_get_stats,
+	.probe			= at803x_probe,
+	.flags			= PHY_IS_INTERNAL,
+	.config_init		= qca83xx_config_init,
+	.soft_reset		= genphy_soft_reset,
+	.get_sset_count		= at803x_get_sset_count,
+	.get_strings		= at803x_get_strings,
+	.get_stats		= at803x_get_stats,
 	.suspend		= qca83xx_suspend,
 	.resume			= qca83xx_resume,
 }, };
-- 
2.32.0

