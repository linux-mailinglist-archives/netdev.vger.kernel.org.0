Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DE4169A06
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgBWUrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:47:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53567 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgBWUrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:47:32 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so7003896wmh.3;
        Sun, 23 Feb 2020 12:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nCv2qkKWtDHxvh0iJVpICyofV+GyS7wLpg2MkaCMWPk=;
        b=uQUWIhVyeHDJO3kl6IiLNDfiSruZu5K+JGkYSWw/08eoGiGCpoI73jviO7+ZaucIsz
         d7MAxzx+hM9HTmsi827oyHoTqwdMEYUS6EhkPVUnZVwsFfFnaB6ETeBYgT+mpTjNvBc4
         vKNK4KLHJtUzKuswR0dzzPHInq0c3sP4xYCB/3zvwXXTlaqa/YwEJh3thoH8KoNu1vSF
         aeoHnLcQZE34HsAKg+rDMhgy6WjOYDuMWaUSGQTdL9cPC1XW5uvrq7IW7Zwuv24TVgKl
         ItGMJZyARgBjUnRwYvbOaulrqEUYsC8iT33wwwf4nmsDf5NW2Kdi0/CDBtUVeUrpeh7D
         iUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nCv2qkKWtDHxvh0iJVpICyofV+GyS7wLpg2MkaCMWPk=;
        b=IitEDoGsv15NMXQV2zTJ4KkDhZ91Qq4fs+A99gSJjkiips0yNuJJhnrgwdVjmfpBoN
         XzJh6RiMiPNrid2kd2XiqX/6PscEa2AnbX0LW2lNUY7DdoIqJljdc1B2tpVmvfSXAXOy
         84kfgwz7NKu6gDCjzHO5DxGSxFwXy9bcshBC76igEo8O9Z7pRLNYRNVQnRtmfFuS79Fl
         eeg3I0LSco1HQf1EZunLDTbEUSOqVgq6SyflzHydXL0wYFscRPrOZl2fVrpDj79b7vI2
         TFW1h0GMDXaefCc+u5yrgH+FpVGHd5nOXeCO44A4U1gNtFda3KoswtDG/TDqQ6DdSqGq
         j54w==
X-Gm-Message-State: APjAAAWZm1KZOeWQhWo99+4B921GsoJgzDTvA67yxttTCgOo+ybJL6CM
        vES7MFxy9rih7ihItCmATuw=
X-Google-Smtp-Source: APXvYqwAIHFb5U25fiKcxG+LHaNwfLUx56quFjS0RQfNVzq19+7miByBXZU3T503uLyBzS+NbWHa1Q==
X-Received: by 2002:a7b:c190:: with SMTP id y16mr17907150wmi.107.1582490849726;
        Sun, 23 Feb 2020 12:47:29 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id z8sm14817927wrq.22.2020.02.23.12.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 12:47:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 devicetree 5/6] arm64: dts: fsl: ls1028a: add node for Felix switch
Date:   Sun, 23 Feb 2020 22:47:15 +0200
Message-Id: <20200223204716.26170-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223204716.26170-1-olteanv@gmail.com>
References: <20200223204716.26170-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

Add the switch device node, available on PF5, so that the switch port
sub-nodes (net devices) can be linked to corresponding board specific
phy nodes (external ports) or have their link mode defined (internal
ports).

The switch device features 6 ports, 4 with external links and 2
internally facing to the LS1028A SoC and connected via fixed links to 2
internal ENETC Ethernet controller ports.

Add the corresponding ENETC host port device nodes, mapped to PF2 and
PF6 PCIe functions. Since the switch only supports tagging on one CPU
port, only one port pair (swp4, eno2) is enabled by default and the
other, lower speed, port pair is disabled to prevent the PCI core from
probing them. If enabled, swp5 will be a fixed-link slave port.

DSA tagging can also be moved from the swp4-eno2 2.5G port pair to the
1G swp5-eno3 pair by changing the ethernet = <&enetc_port2> phandle to
<&enetc_port3> and moving it under port5, but in that case enetc_port2
should not be disabled, because it is the hardware owner of the Felix
PCS and disabling its memory would result in access faults in the Felix
DSA driver.

All ports are disabled by default, including the CPU port, and need to
be enabled on a per-board basis.

The phy-mode binding of the internal ENETC ports was modified from
"gmii" to "internal" to match the phy-mode of the internal-facing switch
ports connected to them. The ENETC driver does not perform any phy_mode
validation anyway, so the change is only cosmetic. Also, enetc_port2 is
defined as a fixed-link 1000 Mbps port even though it is 2500 Mbps (as
can be seen by the fact that it is connected to mscc_felix_port4). The
fact that it is currently defined as 1000 Mbps is an artifact of its
PHYLIB implementation instead of PHYLINK (the former can't describe a
fixed-link speed higher than what swphy can emulate from the Clause 22
MDIO spec).

The switch's INTB interrupt line signals:
- PTP TX timestamp availability
- TSN Frame Preemption

And don't forget to enable the 4MB BAR4 in the root complex ECAM space,
where the switch registers are mapped.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc>
---
Changes in v3:
- Disabled the CPU port and the DSA master by default.
- Removed the "ethernet" property from the DTSI to let the board set the
  CPU port.

Changes in v2:
Adapted phy-mode = "gmii" to phy-mode = "internal".

 .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 83 ++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 1b330b7cce62..90ff75547db0 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -700,7 +700,9 @@
 				  /* PF1: VF0-1 BAR0 - non-prefetchable memory */
 				  0x82000000 0x0 0x00000000  0x1 0xf8210000  0x0 0x020000
 				  /* PF1: VF0-1 BAR2 - prefetchable memory */
-				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000>;
+				  0xc2000000 0x0 0x00000000  0x1 0xf8230000  0x0 0x020000
+				  /* BAR4 (PF5) - non-prefetchable memory */
+				  0x82000000 0x0 0x00000000  0x1 0xfc000000  0x0 0x400000>;
 
 			enetc_port0: ethernet@0,0 {
 				compatible = "fsl,enetc";
@@ -714,6 +716,18 @@
 				status = "disabled";
 			};
 
+			enetc_port2: ethernet@0,2 {
+				compatible = "fsl,enetc";
+				reg = <0x000200 0 0 0 0>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+
 			enetc_mdio_pf3: mdio@0,3 {
 				compatible = "fsl,enetc-mdio";
 				reg = <0x000300 0 0 0 0>;
@@ -727,6 +741,73 @@
 				clocks = <&clockgen 4 0>;
 				little-endian;
 			};
+
+			ethernet-switch@0,5 {
+				reg = <0x000500 0 0 0 0>;
+				/* IEP INT_B */
+				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					/* External ports */
+					mscc_felix_port0: port@0 {
+						reg = <0>;
+						status = "disabled";
+					};
+
+					mscc_felix_port1: port@1 {
+						reg = <1>;
+						status = "disabled";
+					};
+
+					mscc_felix_port2: port@2 {
+						reg = <2>;
+						status = "disabled";
+					};
+
+					mscc_felix_port3: port@3 {
+						reg = <3>;
+						status = "disabled";
+					};
+
+					/* Internal ports */
+					mscc_felix_port4: port@4 {
+						reg = <4>;
+						phy-mode = "internal";
+						status = "disabled";
+
+						fixed-link {
+							speed = <2500>;
+							full-duplex;
+						};
+					};
+
+					mscc_felix_port5: port@5 {
+						reg = <5>;
+						phy-mode = "internal";
+						status = "disabled";
+
+						fixed-link {
+							speed = <1000>;
+							full-duplex;
+						};
+					};
+				};
+			};
+
+			enetc_port3: ethernet@0,6 {
+				compatible = "fsl,enetc";
+				reg = <0x000600 0 0 0 0>;
+				phy-mode = "internal";
+				status = "disabled";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 		};
 	};
 
-- 
2.17.1

