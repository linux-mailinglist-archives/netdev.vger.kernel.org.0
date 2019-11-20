Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6F33103990
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfKTMIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:08:54 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12770 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbfKTMIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:08:53 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: oglyA8zYRJbbpo+FAZZPJKIeYqd/yaqsyOYVgbUT1aAew4yjDHZnHAHf+uNIohehAUfXXWZduh
 cXOh0PKg48nLEa3CTJ2mgA+g9UBSj42zOEC0qgXWFuF2WDcstGG7unPldwpuDTySQBGmKGrplo
 c2a6FNn/PaEsZNUzV7xSMgrUaI+NexI7OeATxZUl4t2fgvNW6/5dvcmhYlH2MXJ5naq2Mn9bBz
 up95ZAg1IIkYkVzzjqAkcCEdqbJ7SyZeX/Q+mkYup4+auuRGd8L7o10jlYP8S2d5ryWCdDmXBr
 ZKI=
X-IronPort-AV: E=Sophos;i="5.69,221,1571727600"; 
   d="scan'208";a="57347229"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Nov 2019 05:08:52 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 Nov 2019 05:08:52 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 20 Nov 2019 05:08:52 -0700
Date:   Wed, 20 Nov 2019 13:08:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
 <20191119214257.GB19542@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20191119214257.GB19542@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/19/2019 22:42, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > Before this commit it was ok to use PHY_INTERFACE_MODE_NA but now that
> > is not true anymore. In this case we have 4 ports that have phy and
> > then 6 sfp ports. So I was looking to describe this in DT but without
> > any success. If you have any advice that would be great.
> 
> Is it the copper ports causing the trouble, or the SFP?  Ideally, you
> should describe the SFPs as SFPs. But i don't think the driver has the
> needed support for that yet. So you might need to use fixed-link for
> the moment.

It was both of them. So I have done few small changes to these patches.
- first I added the phy-mode in DT on the interfaces that have a
  phy(internal or external)
- add a check for PHY_INTERFACE_MODE_NA before the port is probed so it
  would not create net device if the phy mode is PHY_INTERFACE_MODE_NA
  because in that case the phylink was not created.

With these changes now only the ports that have phy are probed. This is
the same behaviour as before these patches. I have tried to configure
the sfp ports as fixed-links but unfortunetly it didn't work, I think
because of some missconfiguration on MAC or SerDes, which I need to
figure out. But I think this can be fix in a different patch.

I have done few tests and they seem to work fine.
Here are my changes.

diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
index 33991fd209f5..0800a86b7f16 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb120.dts
@@ -60,18 +60,22 @@
 
 &port0 {
 	phy-handle = <&phy0>;
+	phy-mode = "sgmii";
 };
 
 &port1 {
 	phy-handle = <&phy1>;
+	phy-mode = "sgmii";
 };
 
 &port2 {
 	phy-handle = <&phy2>;
+	phy-mode = "sgmii";
 };
 
 &port3 {
 	phy-handle = <&phy3>;
+	phy-mode = "sgmii";
 };
 
 &port4 {
diff --git a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
index ef852f382da8..6b0b1fb358ad 100644
--- a/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
+++ b/arch/mips/boot/dts/mscc/ocelot_pcb123.dts
@@ -47,17 +47,21 @@
 };
 
 &port0 {
+	phy-mode = "sgmii";
 	phy-handle = <&phy0>;
 };
 
 &port1 {
+	phy-mode = "sgmii";
 	phy-handle = <&phy1>;
 };
 
 &port2 {
+	phy-mode = "sgmii";
 	phy-handle = <&phy2>;
 };
 
 &port3 {
+	phy-mode = "sgmii";
 	phy-handle = <&phy3>;
 };
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index aecaf4ef6ef4..9dad031900b5 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -513,6 +513,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		if (IS_ERR(regs))
 			continue;
 
+		of_get_phy_mode(portnp, &phy_mode);
+		if (phy_mode == PHY_INTERFACE_MODE_NA)
+			continue;
+
 		err = ocelot_probe_port(ocelot, port, regs);
 		if (err) {
 			of_node_put(portnp);
@@ -523,11 +527,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 
-		of_get_phy_mode(portnp, &phy_mode);
-
 		switch (phy_mode) {
-		case PHY_INTERFACE_MODE_NA:
-			continue;
 		case PHY_INTERFACE_MODE_SGMII:
 			break;
 		case PHY_INTERFACE_MODE_QSGMII:
@@ -549,20 +549,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		}
 
 		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
-		if (IS_ERR(serdes)) {
-			err = PTR_ERR(serdes);
-			if (err == -EPROBE_DEFER)
-				dev_dbg(ocelot->dev, "deferring probe\n");
-			else
-				dev_err(ocelot->dev,
-					"missing SerDes phys for port%d\n",
-					port);
-
-			of_node_put(portnp);
-			goto out_put_ports;
-		}
-
-		if (serdes) {
+		if (!IS_ERR(serdes)) {
 			err = phy_set_mode_ext(serdes, PHY_MODE_ETHERNET,
 					       phy_mode);
 			if (err) {
-- 
2.17.1


> 
>    Andrew

-- 
/Horatiu
