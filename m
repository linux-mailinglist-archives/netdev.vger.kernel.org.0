Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B01029C0A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390869AbfEXQUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:20:45 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37598 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390662AbfEXQUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:20:45 -0400
Received: by mail-lf1-f67.google.com with SMTP id m15so6970605lfh.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+YTaRWfG9Yuoc1VN58/KFdiQHjekpSnoND3oo5X7AWA=;
        b=NjZRAoLxo+Ip5dEbPdESYrjYCfaLVSmU05FgO/wDT0mwXn769CYCivZYZEUqwqYZ0r
         ud5tTPimwETjf05D9g8zyAXhWvzxQXH26CjXkKw22blyRIS1PMn2ZjWgJDn/Ga3a2xBf
         CC6Vo68JmkGQCDekb3KZvNQQ4cgW7C8bqJJevS/WoUM8wYlMg/hn2Arc78ny0rLmUduN
         PY4lV8VQNpXtPA+NZDtxNPsP/L61POrZ1OUmQs083KUiiYaKcxgumRVcHwMJ3raAhZ9O
         6hji68iQWJeQNo/bD22kEw29OP2Bnh+OSlstU/mA/uPt+u+dRNkdHZb9JEch7wEZ7/4K
         r2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+YTaRWfG9Yuoc1VN58/KFdiQHjekpSnoND3oo5X7AWA=;
        b=l/ZHUnoAc9fY1yjY7SZrFLSkmmkC1krbzuL1ZaUWHD56aSPqvvkm8HjdqfWlae3JtB
         YnLBN3Z60K7iCRtohGpDxVu5Icx5oEB+U5NTSYuo/QQ4Lxs0mgGUWtdWKLn8LlxvaBek
         MjL/ZZQsv2KJ1DnXJr/Yb4mwHyBp/QsTxQYmc9LjHwTCehNI7cfEpJHoapOZfnFaSe2T
         pis0/mMPiOSEEKXXLPntPJBIlLUuD1OlCCQVs1IiivoQ1pSZlwaxale8F/O6h4t1sypS
         1iyQY1RQyeTQJ+B30LykOGa6tOfYOVnYixB1BQMZ4pZ7DM2fDFe01CEjCLjkjgW3gHYN
         7jUg==
X-Gm-Message-State: APjAAAXk0zhdD++PERqoKoGCWnvXGtCyjdt2KzrFYoFMKrgrvefWjvNm
        Yb+L3IWuzms6P8wYxosyavLIEGqD+HE=
X-Google-Smtp-Source: APXvYqx7j3ZfuK71RqYfUCuZn9nSibcP1yzz0ipyn1zKNeIsPoofBGmz8PtIl5eu8FQE9wF71cs1Cw==
X-Received: by 2002:ac2:528f:: with SMTP id q15mr33624519lfm.37.1558714842202;
        Fri, 24 May 2019 09:20:42 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.20.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:20:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/8] net: ethernet: ixp4xx: Use distinct local variable
Date:   Fri, 24 May 2019 18:20:17 +0200
Message-Id: <20190524162023.9115-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "ndev" for the struct net_device and "dev" for the
struct device in probe() and remove(). Add the local
"dev" pointer for later use in refactoring.

Take this opportunity to fix inverse christmas tree
coding style.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 51 +++++++++++++-----------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ae69836d0080..a0c02458f456 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1369,20 +1369,23 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
 
 static int ixp4xx_eth_probe(struct platform_device *pdev)
 {
-	struct port *port;
-	struct net_device *dev;
-	struct eth_plat_info *plat = dev_get_platdata(&pdev->dev);
+	char phy_id[MII_BUS_ID_SIZE + 3];
 	struct phy_device *phydev = NULL;
+	struct device *dev = &pdev->dev;
+	struct eth_plat_info *plat;
+	struct net_device *ndev;
+	struct port *port;
 	u32 regs_phys;
-	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
-	if (!(dev = alloc_etherdev(sizeof(struct port))))
+	plat = dev_get_platdata(dev);
+
+	if (!(ndev = alloc_etherdev(sizeof(struct port))))
 		return -ENOMEM;
 
-	SET_NETDEV_DEV(dev, &pdev->dev);
-	port = netdev_priv(dev);
-	port->netdev = dev;
+	SET_NETDEV_DEV(ndev, dev);
+	port = netdev_priv(ndev);
+	port->netdev = ndev;
 	port->id = pdev->id;
 
 	switch (port->id) {
@@ -1435,18 +1438,18 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	dev->netdev_ops = &ixp4xx_netdev_ops;
-	dev->ethtool_ops = &ixp4xx_ethtool_ops;
-	dev->tx_queue_len = 100;
+	ndev->netdev_ops = &ixp4xx_netdev_ops;
+	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
+	ndev->tx_queue_len = 100;
 
-	netif_napi_add(dev, &port->napi, eth_poll, NAPI_WEIGHT);
+	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
 	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
 		err = -EIO;
 		goto err_free;
 	}
 
-	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, dev->name);
+	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
 		err = -EBUSY;
 		goto err_npe_rel;
@@ -1454,9 +1457,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	port->plat = plat;
 	npe_port_tab[NPE_ID(port->id)] = port;
-	memcpy(dev->dev_addr, plat->hwaddr, ETH_ALEN);
+	memcpy(ndev->dev_addr, plat->hwaddr, ETH_ALEN);
 
-	platform_set_drvdata(pdev, dev);
+	platform_set_drvdata(pdev, ndev);
 
 	__raw_writel(DEFAULT_CORE_CNTRL | CORE_RESET,
 		     &port->regs->core_control);
@@ -1466,7 +1469,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
 		mdio_bus->id, plat->phy);
-	phydev = phy_connect(dev, phy_id, &ixp4xx_adjust_link,
+	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
 			     PHY_INTERFACE_MODE_MII);
 	if (IS_ERR(phydev)) {
 		err = PTR_ERR(phydev);
@@ -1475,10 +1478,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	phydev->irq = PHY_POLL;
 
-	if ((err = register_netdev(dev)))
+	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", dev->name, plat->phy,
+	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
 	       npe_name(port->npe));
 
 	return 0;
@@ -1491,23 +1494,23 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 err_npe_rel:
 	npe_release(port->npe);
 err_free:
-	free_netdev(dev);
+	free_netdev(ndev);
 	return err;
 }
 
 static int ixp4xx_eth_remove(struct platform_device *pdev)
 {
-	struct net_device *dev = platform_get_drvdata(pdev);
-	struct phy_device *phydev = dev->phydev;
-	struct port *port = netdev_priv(dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct phy_device *phydev = ndev->phydev;
+	struct port *port = netdev_priv(ndev);
 
-	unregister_netdev(dev);
+	unregister_netdev(ndev);
 	phy_disconnect(phydev);
 	ixp4xx_mdio_remove();
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(dev);
+	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.20.1

