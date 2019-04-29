Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0246DA1B
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfD2ASS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55575 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfD2ASQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id o25so11490467wmf.5;
        Sun, 28 Apr 2019 17:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WRytol4TsLCjzvjFivOBEq5e1CUmdiuLX9qE0edSQhk=;
        b=BGPSCS6ojz9nm/TKHuLkr9IzMY0qibhEQQLnk6L+YhFlNMV6+hj2NGw4G9PKWwiwrL
         uU6vzyuExMcsrYJi7orN2mApfwyGc0f6fnHgCj18k54kvzUQaGdxzr94KCD9qc/GDO0e
         5UFErZlvfDtutCkLwfrMfy2UGNcC3tX0Mx15uWKbNoO4y2J+RbLhgq2ebn6+y1ymIPDb
         px/p7SdSH6UdQZ7utuvAih9RcM4FYdzXGPdQ3uClKbnoSpSLu4vOdSTRerJkTnF3A1j/
         fclwJqEFmlc5LmJ+7upfxIYpDVeKOYANJojtcP4WZty9owSNKL7I6nZnqyOUBBB1JlOX
         lj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WRytol4TsLCjzvjFivOBEq5e1CUmdiuLX9qE0edSQhk=;
        b=TNGaDeVr8uiLD/lR+XfPMaRDnkbI1i0uD54rxdTMy79rZz3w2hMPP6Kj7ylkpRDXHv
         s7iwZdOj08Zj88Pu9ACEvUpXuN/sICYxPwM92I4iOllIwRufaBkkhShY0wq2TA1qjGim
         uazLLwqos6K/dr/61NdLNuNhCOXYJ740Lh6HDQhK3B7tIO6f7oZK5ENVuheTiaXMH40O
         puZdNef4UuEozXN2NxAmTq3d7pVvseiKUe5c337b4lg3zTyx7sn5CBGHlbJkJNnDJ3L0
         6If1yJG1fHeDBr7PEJVCBmoSiEwpYX3oAWXV1yaNQgmZMihX5DXBrdhOK0buXGSzbvji
         fl4w==
X-Gm-Message-State: APjAAAWVs7MZjfYsdmDy8htRQzDjKYAcYgV5j80QbKpyj4faGqInBHVx
        HgPAqTlH0fu4Lx+ZdVztVZpCcA3XFMs=
X-Google-Smtp-Source: APXvYqyL7EyYUeIAGHJUIWxCUUyfNiQqNzucPjwGb/7w8iUIAfX+Z9XF32ENViuAEGAQX5DEbPMcoA==
X-Received: by 2002:a7b:c923:: with SMTP id h3mr15114054wml.34.1556497093652;
        Sun, 28 Apr 2019 17:18:13 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 12/12] dt-bindings: net: dsa: Add documentation for NXP SJA1105 driver
Date:   Mon, 29 Apr 2019 03:17:06 +0300
Message-Id: <20190429001706.7449-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Renamed sja1105,phy-mode to sja1105,role-phy and similarly for mac.
Clarified the switch situation with RGMII delays.

 .../devicetree/bindings/net/dsa/sja1105.txt   | 157 ++++++++++++++++++
 1 file changed, 157 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/sja1105.txt b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
new file mode 100644
index 000000000000..cf4961af36c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/sja1105.txt
@@ -0,0 +1,157 @@
+NXP SJA1105 switch driver
+=========================
+
+Required properties:
+
+- compatible:
+	Must be one of:
+	- "nxp,sja1105e"
+	- "nxp,sja1105t"
+	- "nxp,sja1105p"
+	- "nxp,sja1105q"
+	- "nxp,sja1105r"
+	- "nxp,sja1105s"
+
+	Although the device ID could be detected at runtime, explicit bindings
+	are required in order to be able to statically check their validity.
+	For example, SGMII can only be specified on port 4 of R and S devices,
+	and the non-SGMII devices, while pin-compatible, are not equal in terms
+	of support for RGMII internal delays (supported on P/Q/R/S, but not on
+	E/T).
+
+Optional properties:
+
+- sja1105,role-mac:
+- sja1105,role-phy:
+	Boolean properties that can be assigned under each port node. By
+	default (unless otherwise specified) a port is configured as MAC if it
+	is driving a PHY (phy-handle is present) or as PHY if it is PHY-less
+	(fixed-link specified, presumably because it is connected to a MAC).
+	The effect of this property (in either its implicit or explicit form)
+	is:
+	- In the case of MII or RMII it specifies whether the SJA1105 port is a
+	  clock source or sink for this interface (not applicable for RGMII
+	  where there is a Tx and an Rx clock).
+	- In the case of RGMII it affects the behavior regarding internal
+	  delays:
+	  1. If sja1105,role-mac is specified, and the phy-mode property is one
+	     of "rgmii-id", "rgmii-txid" or "rgmii-rxid", then the entity
+	     designated to apply the delay/clock skew necessary for RGMII
+	     is the PHY. The SJA1105 MAC does not apply any internal delays.
+	  2. If sja1105,role-phy is specified, and the phy-mode property is one
+	     of the above, the designated entity to apply the internal delays
+	     is the SJA1105 MAC (if hardware-supported). This is only supported
+	     by the second-generation (P/Q/R/S) hardware. On a first-generation
+	     E or T device, it is an error to specify an RGMII phy-mode other
+	     than "rgmii" for a port that is in fixed-link mode. In that case,
+	     the clock skew must either be added by the MAC at the other end of
+	     the fixed-link, or by PCB serpentine traces on the board.
+	These properties are required, for example, in the case where SJA1105
+	ports are at both ends of a MII/RMII PHY-less setup. One end would need
+	to have sja1105,role-mac, while the other sja1105,role-phy.
+
+See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of standard
+DSA required and optional properties.
+
+Other observations
+------------------
+
+The SJA1105 SPI interface requires a CS-to-CLK time (t2 in UM10944) of at least
+one half of t_CLK. At an SPI frequency of 1MHz, this means a minimum
+cs_sck_delay of 500ns. Ensuring that this SPI timing requirement is observed
+depends on the SPI bus master driver.
+
+Example
+-------
+
+Ethernet switch connected via SPI to the host, CPU port wired to enet2:
+
+arch/arm/boot/dts/ls1021a-tsn.dts:
+
+/* SPI controller of the LS1021 */
+&dspi0 {
+	sja1105@1 {
+		reg = <0x1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nxp,sja1105t";
+		spi-max-frequency = <4000000>;
+		fsl,spi-cs-sck-delay = <1000>;
+		fsl,spi-sck-cs-delay = <1000>;
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				/* ETH5 written on chassis */
+				label = "swp5";
+				phy-handle = <&rgmii_phy6>;
+				phy-mode = "rgmii-id";
+				reg = <0>;
+				/* Implicit "sja1105,role-mac;" */
+			};
+			port@1 {
+				/* ETH2 written on chassis */
+				label = "swp2";
+				phy-handle = <&rgmii_phy3>;
+				phy-mode = "rgmii-id";
+				reg = <1>;
+				/* Implicit "sja1105,role-mac;" */
+			};
+			port@2 {
+				/* ETH3 written on chassis */
+				label = "swp3";
+				phy-handle = <&rgmii_phy4>;
+				phy-mode = "rgmii-id";
+				reg = <2>;
+				/* Implicit "sja1105,role-mac;" */
+			};
+			port@3 {
+				/* ETH4 written on chassis */
+				phy-handle = <&rgmii_phy5>;
+				label = "swp4";
+				phy-mode = "rgmii-id";
+				reg = <3>;
+				/* Implicit "sja1105,role-mac;" */
+			};
+			port@4 {
+				/* Internal port connected to eth2 */
+				ethernet = <&enet2>;
+				phy-mode = "rgmii";
+				reg = <4>;
+				/* Implicit "sja1105,role-phy;" */
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
+		};
+	};
+};
+
+/* MDIO controller of the LS1021 */
+&mdio0 {
+	/* BCM5464 */
+	rgmii_phy3: ethernet-phy@3 {
+		reg = <0x3>;
+	};
+	rgmii_phy4: ethernet-phy@4 {
+		reg = <0x4>;
+	};
+	rgmii_phy5: ethernet-phy@5 {
+		reg = <0x5>;
+	};
+	rgmii_phy6: ethernet-phy@6 {
+		reg = <0x6>;
+	};
+};
+
+/* Ethernet master port of the LS1021 */
+&enet2 {
+	phy-connection-type = "rgmii";
+	status = "ok";
+	fixed-link {
+		speed = <1000>;
+		full-duplex;
+	};
+};
+
-- 
2.17.1

