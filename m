Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D650E169A08
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgBWUrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:40 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39505 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgBWUrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so7265942wme.4;
        Sun, 23 Feb 2020 12:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sqqxOH1roeZlLfVga52X20fyWtPVIkv1wXk6qPVKwv4=;
        b=E9GDlKJBpA2I2sI0UBRJOBkaDMEfDrJ2IjL+OubS3ZEeQguTrSXL0Ookw3Q+kqDUmE
         IBmjnCELPQlZqwvSk4Z+vSQfbJId3l6gJTgaAFA9/0fGwRgJka0LsDdxESoXXP1FNA7D
         akmnKD+MVg9BpWAnQvmYFbVKrLxjrWoVUIk5DIvknzoMNdotVKvfMdp8neItTvOdCJ6Z
         Xmz6UzGm1wtcX8zYoURVh5aosAtPXHOX6K/wF8wQzLCXffZ7NA2IscvTmM6oHdCEG537
         eECE7x1PxnUxgm5hTfdK/vMps4IkfegX3UoDeMc2iki53FGGkDC93eyGdgA1qBVND17R
         8pXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sqqxOH1roeZlLfVga52X20fyWtPVIkv1wXk6qPVKwv4=;
        b=XmzMfpHfQOOsOsJY3Q65GXNNKh9Pm+jZig0vg2uAIDM4QnALWLpU5R0Xegjb+kr7pk
         7oCebflj5thxLkGmYKUwtp+ZHK62AjZLax7+HuMOsyvrW1H0U2WOI2nsLJpWUN1LD8VW
         clIOTZkQMslGqhXeV5WRf349BfUOvXBzAd3YEMbE3PNIf5tI3nvk+tiU0MSRkdcfivkd
         zoyKtxIydnxOn6Q6Dlp5OblwQejBa9qoxgrUDiJ2f3BqWdtO/+sHogdgJPt6pXdBZGR3
         aLwxKW99Yh2UvgZ7Q7LamEcXUvDn7b++xyACdn30j/FNqEUDfm8OK1tjyn9KIybYs0Bm
         JJpw==
X-Gm-Message-State: APjAAAUPHiAgSv2rxFLjSseUmyPtXaLyoAn66hPBWia+UmwCG3DiH/jX
        /ESbp/Amg8ti4rS4dfL79/c=
X-Google-Smtp-Source: APXvYqweJIEgtN+wGl6p6jIiN/b4kZDAUqprVO6SMbdt+HNTXYx1IMy16ZSpWUmsqQS1JRUwOZZl/g==
X-Received: by 2002:a7b:c249:: with SMTP id b9mr16979814wmj.61.1582490848518;
        Sun, 23 Feb 2020 12:47:28 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 4/6] dt-bindings: net: dsa: ocelot: document the vsc9959 core
Date:   Sun, 23 Feb 2020 22:47:14 +0200
Message-Id: <20200223204716.26170-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
References: <20200223204716.26170-1-olteanv@gmail.com>
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

