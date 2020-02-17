Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8131614F2
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgBQOo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:44:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34102 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgBQOoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:44:24 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so18101178wrm.1;
        Mon, 17 Feb 2020 06:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L4M/ibBBRdcqDYZGaD9/OlVhGEQv3shq3kw51JTm0KM=;
        b=YU5jZu9svKTVWPQ+6ocBvta8tqZbBcXdz9ulODnNhS76nfcXd386TRBmc34EKZIiMW
         zYpfNzMmRuD1tHimyBeO9U18ptBsSlTw+9ZuCra9UVnirkEKpKqisfyGoN7fcR3w0MZg
         2W0pkD/sJbOpx5of2shxyHlVfz1B9A6eID5pgZFIlnMtZUWG1JLrOwiELUaw8hsRrgPp
         eLPiJCP3NqVYP5V4Pzd3tUkGuEK0IV84jfJX9TkQHATs+Gukh5Nn/wQMcWDJSWB1P+8T
         o14mmXfRvShTatkJnvi8g7n01Lm5zGmSAEOzWy571SvnJzvWZw1ZaouW9UQK6xH91cw7
         ym1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L4M/ibBBRdcqDYZGaD9/OlVhGEQv3shq3kw51JTm0KM=;
        b=NmIvpWd13G7JWw5lJdrWvcheNZPLMjmNMp74BHjOAlGmZAa8qHT8YOmylCsIMM6/LV
         5b4iLKEahKHCSx/y6F8qV6dSMxqpy75Jm9PiYxlsMQw9VqLVfq5oVRdevPnI1z+Z4ZqV
         5gxsEYiVHBVpseqhoQehf6Ga05mbTEI31o35M3KOziOkXCIAg/qCY88r5WmPpfhrLEwX
         /p05CEHxAOqhs270u1kM7UgeFI6QgF1V5Ed7RY93ViuPLH7rqGVCmVFRlLJCKuU18Sn4
         qTQL+2cGAvNor8XSMz9gBJlM3pel0VN14BB/InvEvRdyl+gdos2skJsCLPeHwg4cEoEU
         zt1g==
X-Gm-Message-State: APjAAAUUSxxiyMgG/inpEiIMxvurzMZ7tl1N4Tps0/3Io6oYmxTcHhsn
        s1NtIOIfF8ey55iGBD5quVg=
X-Google-Smtp-Source: APXvYqypIBVkDqVgdwGHtEStvxGHrdKhi7scsYwoccRe8yz3FX4uCVK5kVhTORUNKP/zA62yk/DG5Q==
X-Received: by 2002:a5d:6452:: with SMTP id d18mr22102588wrw.303.1581950662118;
        Mon, 17 Feb 2020 06:44:22 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j5sm1381699wrb.33.2020.02.17.06.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:44:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH devicetree 2/4] dt-bindings: net: dsa: ocelot: document the vsc9959 core
Date:   Mon, 17 Feb 2020 16:44:12 +0200
Message-Id: <20200217144414.409-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200217144414.409-1-olteanv@gmail.com>
References: <20200217144414.409-1-olteanv@gmail.com>
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
 .../devicetree/bindings/net/dsa/ocelot.txt    | 97 +++++++++++++++++++
 1 file changed, 97 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
new file mode 100644
index 000000000000..6afd677c6ac0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
@@ -0,0 +1,97 @@
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
+				/* Internal CPU port */
+				port@4 {
+					reg = <4>;
+					ethernet = <&enetc_port2>;
+					phy-mode = "gmii";
+
+					fixed-link {
+						speed = <2500>;
+						full-duplex;
+					};
+				};
+
+				/* Internal non-CPU port */
+				port@5 {
+					reg = <5>;
+					phy-mode = "gmii";
+					status = "disabled";
+
+					fixed-link {
+						speed = <1000>;
+						full-duplex;
+						pause;
+					};
+				};
+			};
+		};
+	};
+};
-- 
2.17.1

