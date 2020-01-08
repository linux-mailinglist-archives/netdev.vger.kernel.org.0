Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30835133C46
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgAHH0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 02:26:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42014 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgAHH0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:26:44 -0500
Received: by mail-pl1-f194.google.com with SMTP id p9so752608plk.9;
        Tue, 07 Jan 2020 23:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7VftiggN6dkZ3Wld3EMtRQ7oFxfSHkKpxj6onZ/SbJc=;
        b=Glfycd+SSp+dBJBi3Ypl6EParnW4iGMSf+JYdW6Pd3J68JqoN/r8bol0HWwKdYSZ15
         zc74LTakqvZhLaMNTzaGrk4zGl+4xLp1Qbo+Aca8Yz9MYe0qqOYqb3ZC/1GsUIt/id0e
         uY9yR8PG2CcCbVXnpVfKqQ0kd6CTtdZ485/ggaCNAIGfJDI5yo6Rnr2mdRsfHb9TGi6+
         LbcR9mwVMnpWIiu8rX3oPPdUxIwe3Htdn4XXDrMYQEbZMB+O2cyDOlT4WZBk3eXVaSHY
         RdgxoHjAveUdhnyjGWm78KpGL2OyLi/zIcEyhCrDvy/SgGpdF+kYdM6OI/5jPh7Q5aD3
         YT6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7VftiggN6dkZ3Wld3EMtRQ7oFxfSHkKpxj6onZ/SbJc=;
        b=bZywgS5iKQxzsIY1zUk+M7qu5am+ga3pW7jPWykOr27fupGs0y15Wlwaj0tnXwltct
         QQj2l8HbJ6n+18SpytrJShFnXiDAmAMJGPViLbuBDuo2jbW76LYPdPpWNGS/OkmXOsP5
         pnOih5/ZbtOXwFzUvMvv0eY/NCKL8A1ndi5nqsazDsumoiZXrS+xR7eyz/qFR5DcfZVC
         5ZXJwzsWjOfztZEJgjCLnN6v8HHrkdXcqoS5B3jUIu/bJ5Noyo0B52DRNW7FK0400NA4
         5t8yxyVB3UqB7tDi57xXenfY5zGAg6OkNuFI/ogbs9lod5GmwECaIxXyVGHn+lwEU0yg
         hgJQ==
X-Gm-Message-State: APjAAAX916VOmhC0xmGlhWinOV+wWlmb9NLwc3zJ4DjMdOgXpT5x4aga
        +876msiSDTzdAh7NHxaVa+Q=
X-Google-Smtp-Source: APXvYqxbFTnUZ6d8VqD/d4wmwctKRYDWxkXacHotBt/0Gx6M6rHuYA5t3zbUJvR7A0x/TKP1/atRdg==
X-Received: by 2002:a17:90a:c706:: with SMTP id o6mr2758419pjt.82.1578468403228;
        Tue, 07 Jan 2020 23:26:43 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id n4sm2149624pgg.88.2020.01.07.23.26.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 23:26:42 -0800 (PST)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, martin.blumenstingl@googlemail.com,
        treding@nvidia.com, andrew@lunn.ch, weifeng.voon@intel.com,
        tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH v2 2/2] net: stmmac: remove the useless member phy_mask
Date:   Wed,  8 Jan 2020 15:25:50 +0800
Message-Id: <20200108072550.28613-3-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200108072550.28613-1-zhengdejin5@gmail.com>
References: <20200108072550.28613-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value of phy_mask in struct stmmac_mdio_bus_data will be passed
to phy_mask of struct mii_bus before register mdiobus, the mii_bus
was obtained by mdiobus_alloc() and set mii_bus->phy_mask as zero
by default. the stmmac_mdio_bus_data->phy_mask also set zero when
got stmmac_mdio_bus_data by devm_kzalloc(), so doesn't need to pass
the value and remove the useless member phy_mask in the struct
stmmac_mdio_bus_data.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---

Changes since v1:
    add this new commit.

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 1 -
 include/linux/stmmac.h                            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index cfe5d8b73142..662b1cde51ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -388,7 +388,6 @@ int stmmac_mdio_register(struct net_device *ndev)
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 new_bus->name, priv->plat->bus_id);
 	new_bus->priv = ndev;
-	new_bus->phy_mask = mdio_bus_data->phy_mask;
 	new_bus->parent = priv->device;
 
 	err = of_mdiobus_register(new_bus, mdio_node);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index d4bcd9387136..e9aaa9bfb304 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -79,7 +79,6 @@
 /* Platfrom data for platform device structure's platform_data field */
 
 struct stmmac_mdio_bus_data {
-	unsigned int phy_mask;
 	int *irqs;
 	int probed_phy_irq;
 	bool needs_reset;
-- 
2.17.1

