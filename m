Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0D494EE87
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFUSOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:30 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37664 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfFUSOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:24 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDn8S094000;
        Fri, 21 Jun 2019 13:13:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140829;
        bh=PIDcKPbOh8VkBOzzNC+6yEWlI/kehcr9w1H0dRe83H4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=B5GkkyvWFjeUc1Xo0D5Otxma94wBGz9kNngx1kyiR9TQyQ5/st5bfZbgWosyd7dGy
         TIglKRjM80uwlYb8qJpYGL7dNQHG6BIA/ew9zrqiuX/4AEdyFalSKGnYtsUR6s8tfA
         IIvsyi03PrC3gNsP8kaOr24xjkFCivur/+xKyZrQ=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIDnZj118043
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:13:49 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:13:49 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:13:49 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDm4G029222;
        Fri, 21 Jun 2019 13:13:48 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 05/11] dt-bindings: net: ti: add new cpsw switch driver bindings
Date:   Fri, 21 Jun 2019 21:13:08 +0300
Message-ID: <20190621181314.20778-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for the new TI CPSW switch driver. Comparing to the legacy
bindings (net/cpsw.txt):
- ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
marked as "disabled" if not physically wired.
- ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
marked as "disabled" if not physically wired.
- all deprecated properties dropped;
- all legacy propertiies dropped which represents constant HW cpapbilities
(cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
active_slave)
- cpts properties grouped in "cpts" sub-node

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../bindings/net/ti,cpsw-switch.txt           | 147 ++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.txt

diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
new file mode 100644
index 000000000000..787219cddccd
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
@@ -0,0 +1,147 @@
+TI SoC Ethernet Switch Controller Device Tree Bindings (new)
+------------------------------------------------------
+
+The 3-port switch gigabit ethernet subsystem provides ethernet packet
+communication and can be configured as an ethernet switch. It provides the
+gigabit media independent interface (GMII),reduced gigabit media
+independent interface (RGMII), reduced media independent interface (RMII),
+the management data input output (MDIO) for physical layer device (PHY)
+management.
+
+Required properties:
+- compatible : be one of the below:
+	  "ti,cpsw-switch" for backward compatible
+	  "ti,am335x-cpsw-switch" for AM335x controllers
+	  "ti,am4372-cpsw-switch" for AM437x controllers
+	  "ti,dra7-cpsw-switch" for DRA7x controllers
+- reg : physical base address and size of the CPSW module IO range
+- ranges : shall contain the CPSW module IO range available for child devices
+- clocks : should contain the CPSW functional clock
+- clock-names : should be "fck"
+	See bindings/clock/clock-bindings.txt
+- interrupts : should contain CPSW RX, TX, MISC, RX_THRESH interrupts
+- interrupt-names : should contain "rx_thresh", "rx", "tx", "misc"
+	See bindings/interrupt-controller/interrupts.txt
+
+Optional properties:
+- syscon : phandle to the system control device node which provides access to
+	efuse IO range with MAC addresses
+
+Required Sub-nodes:
+- ports	: contains CPSW external ports descriptions
+	Required properties:
+	- #address-cells : Must be 1
+	- #size-cells : Must be 0
+	- reg : CPSW port number. Should be 1 or 2
+	- phys : phandle on phy-gmii-sel PHY (see phy/ti-phy-gmii-sel.txt)
+	- phy-mode : operation mode of the PHY interface [1]
+	- phy-handle : phandle to a PHY on an MDIO bus [1]
+
+	Optional properties:
+	- ti,label : Describes the label associated with this port
+	- ti,dual_emac_pvid : Specifies default PORT VID to be used to segregate
+		ports. Default value - CPSW port number.
+	- mac-address : array of 6 bytes, specifies the MAC address. Always
+		accounted first if present [1]
+	- local-mac-address : See [1]
+
+- mdio : CPSW MDIO bus block description
+	- bus_freq : MDIO Bus frequency
+	See bindings/net/mdio.txt and davinci-mdio.txt
+
+- cpts : The Common Platform Time Sync (CPTS) module description
+	- clocks : should contain the CPTS reference clock
+	- clock-names : should be "cpts"
+	See bindings/clock/clock-bindings.txt
+
+	Optional properties - all ports:
+	- cpts_clock_mult : Numerator to convert input clock ticks into ns
+	- cpts_clock_shift : Denominator to convert input clock ticks into ns
+			  Mult and shift will be calculated basing on CPTS
+			  rftclk frequency if both cpts_clock_shift and
+			  cpts_clock_mult properties are not provided.
+
+[1] See Documentation/devicetree/bindings/net/ethernet.txt
+
+Examples - SOC:
+mac_sw: ethernet_switch@0 {
+	compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
+	reg = <0x0 0x4000>;
+	ranges = <0 0 0x4000>;
+	clocks = <&gmac_main_clk>;
+	clock-names = "fck";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	syscon = <&scm_conf>;
+	status = "disabled";
+
+	interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
+		     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
+	interrupt-names = "rx_thresh", "rx", "tx", "misc"
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpsw_port1: port@1 {
+			reg = <1>;
+			ti,label = "port1";
+			/* Filled in by U-Boot */
+			mac-address = [ 00 00 00 00 00 00 ];
+			phys = <&phy_gmii_sel 1>;
+		};
+
+		cpsw_port2: port@2 {
+			reg = <2>;
+			ti,label = "port2";
+			/* Filled in by U-Boot */
+			mac-address = [ 00 00 00 00 00 00 ];
+			phys = <&phy_gmii_sel 2>;
+		};
+	};
+
+	davinci_mdio_sw: mdio@1000 {
+		compatible = "ti,cpsw-mdio","ti,davinci_mdio";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		ti,hwmods = "davinci_mdio";
+		bus_freq = <1000000>;
+		reg = <0x1000 0x100>;
+	};
+
+	cpts {
+		clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 25>;
+		clock-names = "cpts";
+	};
+};
+
+Examples - platform/board:
+
+&mac_sw {
+	pinctrl-names = "default", "sleep";
+	status = "okay";
+};
+
+&cpsw_port1 {
+	phy-handle = <&ethphy0_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <1>;
+};
+
+&cpsw_port2 {
+	phy-handle = <&ethphy1_sw>;
+	phy-mode = "rgmii";
+	ti,dual_emac_pvid = <2>;
+};
+
+&davinci_mdio_sw {
+	ethphy0_sw: ethernet-phy@0 {
+		reg = <0>;
+	};
+
+	ethphy1_sw: ethernet-phy@1 {
+		reg = <1>;
+	};
+};
-- 
2.17.1

