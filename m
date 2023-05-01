Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21616F3AB1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 00:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbjEAWrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 18:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjEAWq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 18:46:57 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6723581;
        Mon,  1 May 2023 15:46:56 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 341MkPvf097656;
        Mon, 1 May 2023 17:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682981185;
        bh=0vr6OTb6WAGKkCzclnyhUo3rW3Mr6nZ8oCbIk9ryJFg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Dcert+WssAeIU2Uzs+ibbz5bwbILWvhGhtmjL7QS5+KmF84rSNqpsSCaiEwaPfwoC
         p1WsRKmBttaczAGLH4RmuhOlTZSAJYBVNhDQkSsmBDP1K+F5ujDw5WSXcGDEu7q2iT
         Yp6u5jgPC3BiFPpnagAZekMVdCWm+fzFZI3nP7R0=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 341MkPJ5007128
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 1 May 2023 17:46:25 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 1
 May 2023 17:46:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 1 May 2023 17:46:24 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 341MkOhh002097;
        Mon, 1 May 2023 17:46:24 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 4/4] DO_NOT_MERGE arm64: dts: ti: Enable MCU MCANs for AM62x
Date:   Mon, 1 May 2023 17:46:24 -0500
Message-ID: <20230501224624.13866-5-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230501224624.13866-1-jm@ti.com>
References: <20230501224624.13866-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM62x there are no hardware interrupts routed to A53 GIC
interrupt controller for MCU MCAN IPs, so MCU MCANs were not
added to the MCU dtsi. In this patch series an hrtimer is introduced
to MCAN driver to generate software interrupts. Now add MCU MCAN
nodes to the MCU dtsi but disable the MCAN devices by default.

AM62x does not carry on-board CAN transceivers, so instead of
changing DTB permanently use an overlay to enable MCU MCANs and to
add CAN transceiver nodes.

If there is no hardware interrupt and timer method is used, remove
interrupt properties and add poll-interval to enable the hrtimer
per MCAN node.

This DT overlay can be used with the following EVM:
Link: https://www.ti.com/tool/TCAN1042DEVM

Signed-off-by: Judith Mendez <jm@ti.com>
---
Changelog:
v3:
 1. Add link for specific board
 
 arch/arm64/boot/dts/ti/Makefile               |  2 +-
 arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi       | 24 ++++++++
 .../boot/dts/ti/k3-am625-sk-mcan-mcu.dtso     | 57 +++++++++++++++++++
 3 files changed, 82 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index abe15e76b614..c76be3888e4d 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -9,7 +9,7 @@
 # alphabetically.
 
 # Boards with AM62x SoC
-k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
+k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo k3-am625-sk-mcan-mcu.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
diff --git a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
index 076601a41e84..20462f457643 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-mcu.dtsi
@@ -141,4 +141,28 @@
 		/* Tightly coupled to M4F */
 		status = "reserved";
 	};
+
+	mcu_mcan1: can@4e00000 {
+		compatible = "bosch,m_can";
+		reg = <0x00 0x4e00000 0x00 0x8000>,
+			  <0x00 0x4e08000 0x00 0x200>;
+		reg-names = "message_ram", "m_can";
+		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
+		clock-names = "hclk", "cclk";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+		status = "disabled";
+	};
+
+	mcu_mcan2: can@4e10000 {
+		compatible = "bosch,m_can";
+		reg = <0x00 0x4e10000 0x00 0x8000>,
+			  <0x00 0x4e18000 0x00 0x200>;
+		reg-names = "message_ram", "m_can";
+		power-domains = <&k3_pds 189 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 189 6>, <&k3_clks 189 1>;
+		clock-names = "hclk", "cclk";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+		status = "disabled";
+	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
new file mode 100644
index 000000000000..5145b3de4f9b
--- /dev/null
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-mcu.dtso
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * DT overlay for MCAN in MCU domain on AM625 SK
+ *
+ * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
+ */
+
+/dts-v1/;
+/plugin/;
+
+#include "k3-pinctrl.h"
+
+&{/} {
+	transceiver2: can-phy1 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+	};
+
+	transceiver3: can-phy2 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+	};
+};
+
+&mcu_pmx0 {
+	mcu_mcan1_pins_default: mcu-mcan1-pins-default {
+		pinctrl-single,pins = <
+			AM62X_IOPAD(0x038, PIN_INPUT, 0) /* (B3) MCU_MCAN0_RX */
+			AM62X_IOPAD(0x034, PIN_OUTPUT, 0) /* (D6) MCU_MCAN0_TX */
+		>;
+	};
+
+	mcu_mcan2_pins_default: mcu-mcan2-pins-default {
+		pinctrl-single,pins = <
+			AM62X_IOPAD(0x040, PIN_INPUT, 0) /* (D4) MCU_MCAN1_RX */
+			AM62X_IOPAD(0x03C, PIN_OUTPUT, 0) /* (E5) MCU_MCAN1_TX */
+		>;
+	};
+};
+
+&mcu_mcan1 {
+	poll-interval;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_mcan1_pins_default>;
+	phys = <&transceiver2>;
+	status = "okay";
+};
+
+&mcu_mcan2 {
+	poll-interval;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcu_mcan2_pins_default>;
+	phys = <&transceiver3>;
+	status = "okay";
+};
-- 
2.17.1

