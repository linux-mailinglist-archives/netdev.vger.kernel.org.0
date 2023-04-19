Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92F6E8545
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 00:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbjDSWwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 18:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjDSWwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 18:52:06 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B8C1701;
        Wed, 19 Apr 2023 15:52:05 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JMXO6e078079;
        Wed, 19 Apr 2023 17:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681943604;
        bh=OrWMLGnqJwjHMR2zESshsELG2IHJFL0T+AwlGIO3pco=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=FQbPTeoyNkBPYpWOYcbN9XBT9hTBpXTj/II18vwjA7MVdmFljCrDMGYsR8Xj5oTOb
         Ebkmb+D7pylbJPEslARZxtZXq6nOKKG1mMukZke5GWdUKIsVyMfZX15/h0xcinBk8o
         10DjKnxjfqUFVyElXJIaFfn0kiphe5gyEeZ5oNnY=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JMXOk7027126
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 17:33:24 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 17:33:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 17:33:24 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JMXNLY015736;
        Wed, 19 Apr 2023 17:33:23 -0500
From:   Judith Mendez <jm@ti.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Judith Mendez <jm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 3/4] DO_NOT_MERGE arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
Date:   Wed, 19 Apr 2023 17:33:22 -0500
Message-ID: <20230419223323.20384-4-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419223323.20384-1-jm@ti.com>
References: <20230419223323.20384-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an overlay for main domain MCAN on AM62x SK. The AM62x
SK board does not have on-board CAN transceiver so instead
of changing the DTB permanently, add an overlay to enable
MAIN domain MCAN and support for 1 CAN transceiver.

Signed-off-by: Judith Mendez <jm@ti.com>
---
 arch/arm64/boot/dts/ti/Makefile               |  2 ++
 .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 +++++++++++++++++++
 2 files changed, 37 insertions(+)
 create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index c83c9d772b81..abe15e76b614 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -9,8 +9,10 @@
 # alphabetically.
 
 # Boards with AM62x SoC
+k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
+dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am62-lp-sk.dtb
 
 # Boards with AM62Ax SoC
diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
new file mode 100644
index 000000000000..72b68fd51121
--- /dev/null
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * DT overlay for MCAN transceiver in main domain on AM625 SK
+ *
+ * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
+ */
+
+/dts-v1/;
+/plugin/;
+
+#include <dt-bindings/pinctrl/k3.h>
+
+&{/} {
+	transceiver1: can-phy0 {
+		compatible = "ti,tcan1042";
+		#phy-cells = <0>;
+		max-bitrate = <5000000>;
+	};
+};
+
+&main_pmx0 {
+	main_mcan0_pins_default: main-mcan0-pins-default {
+		pinctrl-single,pins = <
+			AM62X_IOPAD(0x1dc, PIN_INPUT, 0) /* (E15) MCAN0_RX */
+			AM62X_IOPAD(0x1d8, PIN_OUTPUT, 0) /* (C15) MCAN0_TX */
+		>;
+	};
+};
+
+&main_mcan0 {
+	status = "okay";
+	pinctrl-names = "default";
+	pinctrl-0 = <&main_mcan0_pins_default>;
+	phys = <&transceiver1>;
+};
-- 
2.17.1

