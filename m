Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAE4410C7C
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbhISRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhISRBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 13:01:53 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F144C061574;
        Sun, 19 Sep 2021 10:00:27 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g8so51245223edt.7;
        Sun, 19 Sep 2021 10:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FWSZ0ScdX9/vFWzS9q81FlnqYgwmAD2fUqhq1c6CFi4=;
        b=VnLfLkfhU4W9W/apJuUjRraKmWJuth6e9BJg4ygIs8ft6/NsmkQL7KLXZO2T4KcgSe
         OciXYe9RSLo5ZndAZlZ9J9jiJ/Lw5/hmmQZzezQBak8BD0vCZ3BKXKmE4AB1905VYXU9
         SUsBC6Jzef9cvPcDQ3ZJDOH+vcsFluTItzNqagwrpBqHDMWs1UbuwRrWJrBdViFjzVUe
         vvTLf9NiuHEZOLh/94dsiMx0H4tuk5feDmRR7wy/q7CBEGqW8y6wugKcoxgIUbHLwbpg
         iiQ8JIxNVFSdc1nXEBcWd5OgxBG6v+fQoYXIO82mVVysWq3Vi8SpYS3l23Olipz6PYWt
         hwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FWSZ0ScdX9/vFWzS9q81FlnqYgwmAD2fUqhq1c6CFi4=;
        b=qhfjHeUknxZmRvrnFnT5811XnCHSgLWrXVsUIwA7qCDSoCw38UWujl7c20sHlqGh08
         wUmw2w0XRLRvmWqd8bR0Fg2kwZYU41Bd9HabsB67ozMUyBT699IfP7+58L33KXz59Eot
         slgju9qoGn5HWGpA52sZ+mb/yI8hg8PuxFm7M+H4AXvZl47sbvfFFwy+8A9m5GNLyEiS
         f/c+jaBAECcZSAKSUVs2Qlt38NRUIa6b4nuPTCK/N7gZS9MeYpAXFmP1dkGsKU4IjhPl
         udxnV9eLWsr39NuwOY/lY8BdaIonuOSIsJQ9qEeiTkFeZn0vtBZRZhS9EQp33zUzcU4G
         ygSw==
X-Gm-Message-State: AOAM532SQBal+XzBdSpK7E4e70EJB5gdoHCv1pELMj8qFWtp2cWbjd3l
        5/MEE4vAUjI1nN+7E8g9+d2JKvXXddE=
X-Google-Smtp-Source: ABdhPJyyu9Y7ZhAHoQSx4pjam8aHz0XEKp1SgNs4uR0NbE40NPvG1d/5ajR23tA5s/PLqoauANILpg==
X-Received: by 2002:a17:906:1510:: with SMTP id b16mr25101733ejd.332.1632070825756;
        Sun, 19 Sep 2021 10:00:25 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-67-254.ip85.fastwebnet.it. [93.42.67.254])
        by smtp.googlemail.com with ESMTPSA id a15sm6101760edr.2.2021.09.19.10.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 10:00:25 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 3/3] net: phy: at803x: fix spacing and improve name for 83xx phy
Date:   Sun, 19 Sep 2021 18:28:17 +0200
Message-Id: <20210919162817.26924-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210919162817.26924-1-ansuelsmth@gmail.com>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
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
index db432d228d07..3feee4d59030 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1410,47 +1410,47 @@ static struct phy_driver at803x_driver[] = {
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
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
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
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
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
 	.suspend		= genphy_suspend,
 	.resume			= genphy_resume,
 }, };
-- 
2.32.0

