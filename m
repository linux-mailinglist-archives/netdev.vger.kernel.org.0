Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D332C1647FB
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgBSPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38744 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgBSPNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id e8so973916wrm.5;
        Wed, 19 Feb 2020 07:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wmYxNZlHmk+e/dR3BUF4sjOLDFYl6cCNjL/czQpAEHY=;
        b=YTtZpZ6oy/nsZrV+oEs9qIqANrUNBLoY3fNJwoQ7b0fRU/vn6XpyMR7P2jGrkeD+8o
         GMNFgg3OcidBxMOlll/feM2ZtBWXB67Ajc0m2I5g9QpCQoaOstj2QCZ3L2ujGbXGyVCq
         da7bIUcHoZ6NJP8nxXdn3cV6na0RHRXHa7sqFirrJIhDSuLnh15FGLz0MOg4Gegbt7Po
         UBjwfMbPPXw5iQ9/78gSnVo9J6UeV1uXUY0CDyhzhOY8mLgd1ZmcCmkYe9Ai0sq71PUW
         hk/spFNokYtRsAFxBSed6vNTWZIB4HviwccocUNc1pUL1qlpSw9M44GJBAom5mcokLIw
         PtRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wmYxNZlHmk+e/dR3BUF4sjOLDFYl6cCNjL/czQpAEHY=;
        b=ZPiuh8SDcaFzhdZnYQskxs3c4zx9ekIhWDxIwPBjnc5Te9q42VraSbVHeqOZxftHpq
         d+A29JdGZAXAGBjxbVKETWMCjNy2lNo2lZp8rJcwT7OVXzoYlFEHnR3Uy4FVnFfq+Zmm
         PsjPg3ULiBW8ddLxxkATp91kqPHTR6iv7P2pPhdbW8ZwwUqYEYAueNJFUISNUe61k7mo
         zT5ZPKtzn36dVnqd3L46/vGw0RPxiCnqPJtDqx5QmlDfnuz1h6WJhwck0hkm/DxUNFEp
         UT4PIW7t4wZqiJ/MoDbnBF91PTUdUZbujRs70Kper8XMKSEmU6icDCic0koTtCn/3KBy
         OHFA==
X-Gm-Message-State: APjAAAWK33XCkaVXkjJUOiQl0KeBl8YbqTBPm35bCCdNQWYToi6ZSWTw
        9VYTdV/Z+PkBAgHCXthaIdM=
X-Google-Smtp-Source: APXvYqwTMicfTcnQyclJDgkOo0qALGCtCrf/+mQ3VmUwi69x1NiIwaCvVgiHxmAZqCAtEHTOqSGpEA==
X-Received: by 2002:a5d:6a07:: with SMTP id m7mr8852655wru.332.1582125188893;
        Wed, 19 Feb 2020 07:13:08 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 3/5] dt-bindings: net: dsa: ocelot: document the vsc9959 core
Date:   Wed, 19 Feb 2020 17:12:57 +0200
Message-Id: <20200219151259.14273-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219151259.14273-1-olteanv@gmail.com>
References: <20200219151259.14273-1-olteanv@gmail.com>
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
---
Changes in v2:
Adapted phy-mode = "gmii" to phy-mode = "internal".

 .../devicetree/bindings/net/dsa/ocelot.txt    | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
new file mode 100644
index 000000000000..a9d86e09dafa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -0,0 +1,96 @@
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
+Any port can be disabled, but the CPU port should be kept enabled.
+
+The CPU port property ("ethernet"), which is assigned by default to the 2.5Gbps
+port@4, can be moved to the 1Gbps port@5, depending on the specific use case.
+DSA tagging is supported on a single port at a time.
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

