Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376CEDDC0C
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfJTDUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:33 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38710 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfJTDUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:31 -0400
Received: by mail-qk1-f196.google.com with SMTP id p4so9084590qkf.5;
        Sat, 19 Oct 2019 20:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oWEPKXzI3zpONKJC1e+58irR7Iit5u7zSvvRGKRNGU8=;
        b=sR2PsRSRYukeXNGMIaqclJ5WWCEHhrxS9OckvaLUslC0py34510n7pdtq/2NjK1Ogr
         fjPxOnlCVc6BWEjcs20LpI+bnQA0rWm6C5y/jlcIgPDKzcuHpVDmyBCv9qtIRcXFP9WV
         BvBUzubEg/QWH2lA20NpuskE9UFfK/yyDcwz6p16fNxI2GEceu6UsTSd/2FxNhn9KPKy
         ADsfqbqAJJvAdOymWsiJ8nx6jmlZ6VgI7nz5dDAZlIUQWNnciDT42EGbzBVIByxGAPzy
         3VxjueAkDMnLK1atRGOuJBhajvnngAqdIvGFCdTp4w3934niV1uto9WPL4CUvwbYBFn6
         CEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oWEPKXzI3zpONKJC1e+58irR7Iit5u7zSvvRGKRNGU8=;
        b=iGgd5EhbTKzr2iS0zxwzppZxhQK7Ih0QfXbI95Mu7+OS9GXbVJHduKjlZYo29dBqdR
         xERm5Ciy9bJhMB8OhZqWamKyOkQFBIiF0C/fFELkG/VcGeI9PPlw9oFB+weRsYQc3oIa
         /h4mjjGgZueEQ7lsUdMQqSAARiaa5yGq7NRyiaoZ8bR6GPmRn5CVfIqcSXc2eIqmn59z
         KJFiF6Yp7rj5zSFN7cvFyuWkDPsXKtDY4OexXQSEQwECqbPDCEGIzEqGd8BMIxr8xyDC
         4t+1qUnoN+wFO5cIRFYyZor9wTPOy0KDOgKxuhBo2fwx8SCFF6dwACOrReGPYmqZNGwg
         iSfg==
X-Gm-Message-State: APjAAAU1HPGqgm9C6Y25SoSzM4pjE+c2o4Y2T46aqzJki68WqXAVF6yt
        C33gyD64F8U/pwSlfPiPIq0=
X-Google-Smtp-Source: APXvYqyCdu5TgEzZKrgfNmgN1aNWHVs0x9c4FBKuKg4wJjLZWKqFjEn8GIAxm3MEUDjl/iNys6nUQg==
X-Received: by 2002:a37:d0b:: with SMTP id 11mr16091093qkn.466.1571541630170;
        Sat, 19 Oct 2019 20:20:30 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x55sm6341490qta.74.2019.10.19.20.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:29 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 16/16] net: dsa: remove dsa_switch_alloc helper
Date:   Sat, 19 Oct 2019 23:19:41 -0400
Message-Id: <20191020031941.3805884-17-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that ports are dynamically listed in the fabric, there is no need
to provide a special helper to allocate the dsa_switch structure. This
will give more flexibility to drivers to embed this structure as they
wish in their private structure.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c       |  5 ++++-
 drivers/net/dsa/dsa_loop.c             |  5 ++++-
 drivers/net/dsa/lan9303-core.c         |  4 +++-
 drivers/net/dsa/lantiq_gswip.c         |  4 +++-
 drivers/net/dsa/microchip/ksz_common.c |  5 ++++-
 drivers/net/dsa/mt7530.c               |  5 ++++-
 drivers/net/dsa/mv88e6060.c            |  4 +++-
 drivers/net/dsa/mv88e6xxx/chip.c       |  4 +++-
 drivers/net/dsa/qca8k.c                |  5 ++++-
 drivers/net/dsa/realtek-smi-core.c     |  5 ++++-
 drivers/net/dsa/sja1105/sja1105_main.c |  4 +++-
 drivers/net/dsa/vitesse-vsc73xx-core.c |  5 ++++-
 include/net/dsa.h                      |  1 -
 net/dsa/dsa2.c                         | 21 ++++++---------------
 14 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 9ba91f1370ac..0a5ab2ce74e3 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2342,10 +2342,13 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	struct dsa_switch *ds;
 	struct b53_device *dev;
 
-	ds = dsa_switch_alloc(base, DSA_MAX_PORTS);
+	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return NULL;
 
+	ds->dev = base;
+	ds->num_ports = DSA_MAX_PORTS;
+
 	dev = devm_kzalloc(base, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return NULL;
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 925ed135a4d9..c8d7ef27fd72 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -286,10 +286,13 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 	dev_info(&mdiodev->dev, "%s: 0x%0x\n",
 		 pdata->name, pdata->enabled_ports);
 
-	ds = dsa_switch_alloc(&mdiodev->dev, DSA_MAX_PORTS);
+	ds = devm_kzalloc(&mdiodev->dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
 
+	ds->dev = &mdiodev->dev;
+	ds->num_ports = DSA_MAX_PORTS;
+
 	ps = devm_kzalloc(&mdiodev->dev, sizeof(*ps), GFP_KERNEL);
 	if (!ps)
 		return -ENOMEM;
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index bbec86b9418e..e3c333a8f45d 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1283,10 +1283,12 @@ static int lan9303_register_switch(struct lan9303 *chip)
 {
 	int base;
 
-	chip->ds = dsa_switch_alloc(chip->dev, LAN9303_NUM_PORTS);
+	chip->ds = devm_kzalloc(chip->dev, sizeof(*chip->ds), GFP_KERNEL);
 	if (!chip->ds)
 		return -ENOMEM;
 
+	chip->ds->dev = chip->dev;
+	chip->ds->num_ports = LAN9303_NUM_PORTS;
 	chip->ds->priv = chip;
 	chip->ds->ops = &lan9303_switch_ops;
 	base = chip->phy_addr_base;
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index a69c9b9878b7..955324968b74 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1854,10 +1854,12 @@ static int gswip_probe(struct platform_device *pdev)
 	if (!priv->hw_info)
 		return -EINVAL;
 
-	priv->ds = dsa_switch_alloc(dev, priv->hw_info->max_ports);
+	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
 
+	priv->ds->dev = dev;
+	priv->ds->num_ports = priv->hw_info->max_ports;
 	priv->ds->priv = priv;
 	priv->ds->ops = &gswip_switch_ops;
 	priv->dev = dev;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index b0b870f0c252..c755d9e1c4f6 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -398,10 +398,13 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 	struct dsa_switch *ds;
 	struct ksz_device *swdev;
 
-	ds = dsa_switch_alloc(base, DSA_MAX_PORTS);
+	ds = devm_kzalloc(base, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return NULL;
 
+	ds->dev = base;
+	ds->num_ports = DSA_MAX_PORTS;
+
 	swdev = devm_kzalloc(base, sizeof(*swdev), GFP_KERNEL);
 	if (!swdev)
 		return NULL;
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a91293e47a57..add9e4279176 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1632,10 +1632,13 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (!priv)
 		return -ENOMEM;
 
-	priv->ds = dsa_switch_alloc(&mdiodev->dev, DSA_MAX_PORTS);
+	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
 
+	priv->ds->dev = &mdiodev->dev;
+	priv->ds->num_ports = DSA_MAX_PORTS;
+
 	/* Use medatek,mcm property to distinguish hardware type that would
 	 * casues a little bit differences on power-on sequence.
 	 */
diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index 2a2489b5196d..a5a37f47b320 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -270,10 +270,12 @@ static int mv88e6060_probe(struct mdio_device *mdiodev)
 
 	dev_info(dev, "switch %s detected\n", name);
 
-	ds = dsa_switch_alloc(dev, MV88E6060_PORTS);
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
 
+	ds->dev = dev;
+	ds->num_ports = MV88E6060_PORTS;
 	ds->priv = priv;
 	ds->dev = dev;
 	ds->ops = &mv88e6060_switch_ops;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8771f2525932..e414f9f8f86e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4975,10 +4975,12 @@ static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
 	struct device *dev = chip->dev;
 	struct dsa_switch *ds;
 
-	ds = dsa_switch_alloc(dev, mv88e6xxx_num_ports(chip));
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
 
+	ds->dev = dev;
+	ds->num_ports = mv88e6xxx_num_ports(chip);
 	ds->priv = chip;
 	ds->dev = dev;
 	ds->ops = &mv88e6xxx_switch_ops;
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 71e44c8763b8..7e742cd491e8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1077,10 +1077,13 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (id != QCA8K_ID_QCA8337)
 		return -ENODEV;
 
-	priv->ds = dsa_switch_alloc(&mdiodev->dev, QCA8K_NUM_PORTS);
+	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds),
+				QCA8K_NUM_PORTS);
 	if (!priv->ds)
 		return -ENOMEM;
 
+	priv->ds->dev = &mdiodev->dev;
+	priv->ds->num_ports = DSA_MAX_PORTS;
 	priv->ds->priv = priv;
 	priv->ops = qca8k_switch_ops;
 	priv->ds->ops = &priv->ops;
diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index dc0509c02d29..fae188c60191 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -444,9 +444,12 @@ static int realtek_smi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	smi->ds = dsa_switch_alloc(dev, smi->num_ports);
+	smi->ds = devm_kzalloc(dev, sizeof(*smi->ds), GFP_KERNEL);
 	if (!smi->ds)
 		return -ENOMEM;
+
+	smi->ds->dev = dev;
+	smi->ds->num_ports = smi->num_ports;
 	smi->ds->priv = smi;
 
 	smi->ds->ops = var->ds_ops;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 0ebbda5ca665..2ae84a9dea59 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2047,10 +2047,12 @@ static int sja1105_probe(struct spi_device *spi)
 
 	dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
 
-	ds = dsa_switch_alloc(dev, SJA1105_NUM_PORTS);
+	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
 
+	ds->dev = dev;
+	ds->num_ports = SJA1105_NUM_PORTS;
 	ds->ops = &sja1105_switch_ops;
 	ds->priv = priv;
 	priv->ds = ds;
diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 614377ef7956..42c1574d45f2 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -1178,9 +1178,12 @@ int vsc73xx_probe(struct vsc73xx *vsc)
 	 * We allocate 8 ports and avoid access to the nonexistant
 	 * ports.
 	 */
-	vsc->ds = dsa_switch_alloc(dev, 8);
+	vsc->ds = devm_kzalloc(dev, sizeof(*vsc->ds), GFP_KERNEL);
 	if (!vsc->ds)
 		return -ENOMEM;
+
+	vsc->ds->dev = dev;
+	vsc->ds->num_ports = 8;
 	vsc->ds->priv = vsc;
 
 	vsc->ds->ops = &vsc73xx_ds_ops;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d28ac54cb8c4..0b46b63fef67 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -577,7 +577,6 @@ static inline bool dsa_can_decode(const struct sk_buff *skb,
 	return false;
 }
 
-struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n);
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 #ifdef CONFIG_PM_SLEEP
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7669a6278c40..da84d0d14511 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -854,6 +854,12 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	struct device_node *np = ds->dev->of_node;
 	int err;
 
+	if (!ds->dev)
+		return -ENODEV;
+
+	if (!ds->num_ports)
+		return -EINVAL;
+
 	if (np)
 		err = dsa_switch_parse_of(ds, np);
 	else if (pdata)
@@ -867,21 +873,6 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	return dsa_switch_add(ds);
 }
 
-struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
-{
-	struct dsa_switch *ds;
-
-	ds = devm_kzalloc(dev, sizeof(*ds), GFP_KERNEL);
-	if (!ds)
-		return NULL;
-
-	ds->dev = dev;
-	ds->num_ports = n;
-
-	return ds;
-}
-EXPORT_SYMBOL_GPL(dsa_switch_alloc);
-
 int dsa_register_switch(struct dsa_switch *ds)
 {
 	int err;
-- 
2.23.0

