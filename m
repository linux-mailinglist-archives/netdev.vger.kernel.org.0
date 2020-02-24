Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE8C16A5E2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBXMQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:16:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32784 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXMQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:16:21 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so10565627wmc.0;
        Mon, 24 Feb 2020 04:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LACOWlic8Bei/m5Jjae2+GJQtGbqJanecrT9YSMXyL8=;
        b=hfj3TCaKlm6V/5/GhAvqnncPIOsjWXhZguYKzCxRIWg2rIkG0FDN3Ada7cdcUrskUe
         +64YQTgCVM3ljH/cV7k7O4BhWRRFD6GGiaM/LGjRsLQz37PGoKglF5lvAy1cfBhdavOR
         eSTwz6UiU39i5mekwP6G50qTUsz+olWI19UVhTk28UH02WKLckmCN2cJiFKYj/ETmF1e
         gj4oho1FVv97y6wz0KhjXz3MTgI/6mR/NsH0dCykFKOEAuN74gbmsDKQ8ZjGoufHyUTi
         1ea/0s+6Csko//WTKGJM8XQdXU4g8o2zICjh50OdR6vFBRsB+PWyKjFAr/9BKLDp0QsM
         AZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LACOWlic8Bei/m5Jjae2+GJQtGbqJanecrT9YSMXyL8=;
        b=AfuU1ls0fuKleLqNlwkxLBo9qNjzvrEY2J7cO0H7zEYpB+tWaBWVJi5nKzY5L5XYFp
         oPGysLOxN+pUNMWXoJYVt3leM07u15kHXgFx/HSWW3i7sjtIviIB+p5J2ryra9JxjtfR
         lGl+8Rtn5BHVIGFPX+ylntsfhzzycgP45+ITZDpQ94841UnqlQGFkb5HQ8MK7hMzCnNH
         R6N63Vu+hiv7zISDlzy/9R+XEkDemv/U4v5F9kupuTfdH45XU6Opls4M5V69/8vB/XB6
         e1PqETd/cJJb3IDF9bwihGoyAjTDXUMiGbe1BgsOLndLLwQtzLHvQf+99HUNdERoGkBM
         qFkg==
X-Gm-Message-State: APjAAAU3i2G5KiS5T2hkNm+Qk2O9mYFtLkcdisEZCUFanYSc6GSGrSHM
        w987o3dej4ErYL0v+9TiSc4=
X-Google-Smtp-Source: APXvYqyHrj1qODTjWTYb1vcBazr7bATv63g+Tv4sQMzolIijlv8P8xd1sG2nl4BprajGXL2Wydrgtg==
X-Received: by 2002:a7b:c249:: with SMTP id b9mr21858273wmj.74.1582546579145;
        Mon, 24 Feb 2020 04:16:19 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id a13sm8450456wrv.62.2020.02.24.04.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 04:16:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 2/2] dt-bindings: net: dsa: ocelot: document the vsc9959 core
Date:   Mon, 24 Feb 2020 14:15:34 +0200
Message-Id: <20200224121534.29679-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224121534.29679-1-olteanv@gmail.com>
References: <20200224121534.29679-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch adds the required documentation for the embedded L2 switch
inside the NXP LS1028A chip.

I've submitted it in the legacy format instead of yaml schema, because
DSA itself has not yet been converted to yaml, and this driver defines
no custom bindings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
None.

Changes in v3:
- Clarify the real restriction regarding enetc_port2 which can't be
  disabled.
- Document the supported phy-modes on Felix switch ports.

Changes in v2:
Adapted phy-mode = "gmii" to phy-mode = "internal".

 .../devicetree/bindings/net/dsa/ocelot.txt    | 116 ++++++++++++++++++
 1 file changed, 116 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
new file mode 100644
index 000000000000..66a129fea705
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -0,0 +1,116 @@
+Microchip Ocelot switch driver family
+=====================================
+
+Felix
+-----
+
+The VSC9959 core is currently the only switch supported by the driver, and is
+found in the NXP LS1028A. It is a PCI device, part of the larger ENETC root
+complex. As a result, the ethernet-switch node is a sub-node of the PCIe root
+complex node and its "reg" property conforms to the parent node bindings:
+
+* reg: Specifies PCIe Device Number and Function Number of the endpoint device,
+  in this case for the Ethernet L2Switch it is PF5 (of device 0, bus 0).
+
+It does not require a "compatible" string.
+
+The interrupt line is used to signal availability of PTP TX timestamps and for
+TSN frame preemption.
+
+For the external switch ports, depending on board configuration, "phy-mode" and
+"phy-handle" are populated by board specific device tree instances. Ports 4 and
+5 are fixed as internal ports in the NXP LS1028A instantiation.
+
+The CPU port property ("ethernet") configures the feature called "NPI port" in
+the Ocelot hardware core. The CPU port in Ocelot is a set of queues, which are
+connected, in the Node Processor Interface (NPI) mode, to an Ethernet port.
+By default, in fsl-ls1028a.dtsi, the NPI port is assigned to the internal
+2.5Gbps port@4, but can be moved to the 1Gbps port@5, depending on the specific
+use case.  Moving the NPI port to an external switch port is hardware possible,
+but there is no platform support for the Linux system on the LS1028A chip to
+operate as an entire slave DSA chip.  NPI functionality (and therefore DSA
+tagging) is supported on a single port at a time.
+
+Any port can be disabled (and in fsl-ls1028a.dtsi, they are indeed all disabled
+by default, and should be enabled on a per-board basis). But if any external
+switch port is enabled at all, the ENETC PF2 (enetc_port2) should be enabled as
+well, regardless of whether it is configured as the DSA master or not. This is
+because the Felix PHYLINK implementation accesses the MAC PCS registers, which
+in hardware truly belong to the ENETC port #2 and not to Felix.
+
+Supported PHY interface types (appropriate SerDes protocol setting changes are
+needed in the RCW binary):
+
+* phy_mode = "internal": on ports 4 and 5
+* phy_mode = "sgmii": on ports 0, 1, 2, 3
+* phy_mode = "qsgmii": on ports 0, 1, 2, 3
+* phy_mode = "usxgmii": on ports 0, 1, 2, 3
+* phy_mode = "2500base-x": on ports 0, 1, 2, 3
+
+For the rest of the device tree binding definitions, which are standard DSA and
+PCI, refer to the following documents:
+
+Documentation/devicetree/bindings/net/dsa/dsa.txt
+Documentation/devicetree/bindings/pci/pci.txt
+
+Example:
+
+&soc {
+	pcie@1f0000000 { /* Integrated Endpoint Root Complex */
+		ethernet-switch@0,5 {
+			reg = <0x000500 0 0 0 0>;
+			/* IEP INT_B */
+			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				/* External ports */
+				port@0 {
+					reg = <0>;
+					label = "swp0";
+				};
+
+				port@1 {
+					reg = <1>;
+					label = "swp1";
+				};
+
+				port@2 {
+					reg = <2>;
+					label = "swp2";
+				};
+
+				port@3 {
+					reg = <3>;
+					label = "swp3";
+				};
+
+				/* Tagging CPU port */
+				port@4 {
+					reg = <4>;
+					ethernet = <&enetc_port2>;
+					phy-mode = "internal";
+
+					fixed-link {
+						speed = <2500>;
+						full-duplex;
+					};
+				};
+
+				/* Non-tagging CPU port */
+				port@5 {
+					reg = <5>;
+					phy-mode = "internal";
+					status = "disabled";
+
+					fixed-link {
+						speed = <1000>;
+						full-duplex;
+					};
+				};
+			};
+		};
+	};
+};
-- 
2.17.1

