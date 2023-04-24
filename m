Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10856ED5A8
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjDXTyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjDXTyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:54:32 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909835FF0;
        Mon, 24 Apr 2023 12:54:30 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs3W2027957;
        Mon, 24 Apr 2023 14:54:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682366043;
        bh=/hIVaDRPytFtvy2tkUUkMuKDhZDcTmgZdxOPlegxtmI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=fJRCG8C3qZzVXcgQu41XIZAYXNQS5lcP5UIvjPIjNlZf24NutCLQ5JzZebjtOBbrT
         n/8dZFOrG/SPkUEf5ruwg/QDSBNAdkoz+WF8GQJhdSsyx71dSXv1rXul6rIUvqxzf8
         3/OwPdM0uCKYrXclPw8VJkclxvq5dfklPAq0g7yc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33OJs3fj095053
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Apr 2023 14:54:03 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 24
 Apr 2023 14:54:02 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 24 Apr 2023 14:54:02 -0500
Received: from a0498204.dal.design.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33OJs23I009344;
        Mon, 24 Apr 2023 14:54:02 -0500
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
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH v2 3/4] DO_NOT_MERGE arm64: dts: ti: Add AM62x MCAN MAIN domain transceiver overlay
Date:   Mon, 24 Apr 2023 14:54:01 -0500
Message-ID: <20230424195402.516-4-jm@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230424195402.516-1-jm@ti.com>
References: <20230424195402.516-1-jm@ti.com>
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
index 000000000000..0a7b2f394f87
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
+#include "k3-pinctrl.h"
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

