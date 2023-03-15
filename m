Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F596BB89B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjCOPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbjCOPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:18 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EDB7FD41;
        Wed, 15 Mar 2023 08:52:44 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTYY020126;
        Wed, 15 Mar 2023 10:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678895549;
        bh=MJHlEh4SQ4FxeOSayn+5ZdFsEIRqOLoLNPKLzloF+bk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=OqBJADOr+xj2V2ls9GwTgcFzcMsgHixcIvbqy7frfM+l46AgmTjeEOLvzlygXCDhH
         SyaHChzSh8334Yr0iUdGimYnq8z+PzspD3tG61JDl4VmD4kehJvlb32kWgke7i9uYt
         LG7cOss5NvPSaXuN3glM34wVLEdYhyIcrvhNZDGI=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32FFqTF7051766
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 10:52:29 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 10:52:29 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 10:52:29 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTNI025973;
        Wed, 15 Mar 2023 10:52:29 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH V2 2/3] arm64: dts: ti: Use local header for pinctrl register values
Date:   Wed, 15 Mar 2023 10:52:27 -0500
Message-ID: <20230315155228.1566883-3-nm@ti.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315155228.1566883-1-nm@ti.com>
References: <20230315155228.1566883-1-nm@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DTS uses hardware register values directly in pin controller pin
configuration and not an abstraction of any form.

These definitions were previously put in the bindings header to avoid
code duplication and to provide some context meaning (name), but they
do not fit the purpose of bindings.

Store the constants in a header next to DTS and use them instead of
bindings.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Changes since V1:
 - Updated $subject and $commit-message
 - Dropped the deletion of bindings header (instead followon patch
   provides a deprecation warning)
 - NOTE: checkpatch insists the following error exists:
   ERROR: Macros with complex values should be enclosed in parentheses
   However, as explained in patches to include/dt-bindings/pinctrl/k3.h,
   we do not need parentheses enclosing the values for this macro as we
   do intend it to generate two separate values as has been done for
   other similar platforms.

V1: https://lore.kernel.org/linux-arm-kernel/20230311131325.9750-3-nm@ti.com/

 arch/arm64/boot/dts/ti/k3-am62.dtsi   |  3 +-
 arch/arm64/boot/dts/ti/k3-am62a.dtsi  |  3 +-
 arch/arm64/boot/dts/ti/k3-am64.dtsi   |  3 +-
 arch/arm64/boot/dts/ti/k3-am65.dtsi   |  3 +-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi  |  3 +-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi  |  3 +-
 arch/arm64/boot/dts/ti/k3-j721s2.dtsi |  3 +-
 arch/arm64/boot/dts/ti/k3-j784s4.dtsi |  3 +-
 arch/arm64/boot/dts/ti/k3-pinctrl.h   | 53 +++++++++++++++++++++++++++
 9 files changed, 69 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/boot/dts/ti/k3-pinctrl.h

diff --git a/arch/arm64/boot/dts/ti/k3-am62.dtsi b/arch/arm64/boot/dts/ti/k3-am62.dtsi
index 37fcbe7a3c33..a401f5225243 100644
--- a/arch/arm64/boot/dts/ti/k3-am62.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62.dtsi
@@ -8,9 +8,10 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 AM625 SoC";
 	compatible = "ti,am625";
diff --git a/arch/arm64/boot/dts/ti/k3-am62a.dtsi b/arch/arm64/boot/dts/ti/k3-am62a.dtsi
index 6eb87c3f9f3c..fe60c9ce21e3 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a.dtsi
@@ -8,9 +8,10 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 AM62A SoC";
 	compatible = "ti,am62a7";
diff --git a/arch/arm64/boot/dts/ti/k3-am64.dtsi b/arch/arm64/boot/dts/ti/k3-am64.dtsi
index c858725133af..60fe95b48312 100644
--- a/arch/arm64/boot/dts/ti/k3-am64.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64.dtsi
@@ -8,9 +8,10 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 AM642 SoC";
 	compatible = "ti,am642";
diff --git a/arch/arm64/boot/dts/ti/k3-am65.dtsi b/arch/arm64/boot/dts/ti/k3-am65.dtsi
index c538a0bf3cdd..3093ef6b9b23 100644
--- a/arch/arm64/boot/dts/ti/k3-am65.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65.dtsi
@@ -8,9 +8,10 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 AM654 SoC";
 	compatible = "ti,am654";
diff --git a/arch/arm64/boot/dts/ti/k3-j7200.dtsi b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
index d74f86b0f622..bbe380c72a7e 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
@@ -7,9 +7,10 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 J7200 SoC";
 	compatible = "ti,j7200";
diff --git a/arch/arm64/boot/dts/ti/k3-j721e.dtsi b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
index 6975cae644d9..4c7d5f9d61a8 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -7,9 +7,10 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 J721E SoC";
 	compatible = "ti,j721e";
diff --git a/arch/arm64/boot/dts/ti/k3-j721s2.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2.dtsi
index 78295ee0fee5..376924726f1f 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2.dtsi
@@ -10,9 +10,10 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 
 	model = "Texas Instruments K3 J721S2 SoC";
diff --git a/arch/arm64/boot/dts/ti/k3-j784s4.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4.dtsi
index 3eb0d0568959..2e03d84da7d2 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4.dtsi
@@ -10,9 +10,10 @@
 
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
-#include <dt-bindings/pinctrl/k3.h>
 #include <dt-bindings/soc/ti,sci_pm_domain.h>
 
+#include "k3-pinctrl.h"
+
 / {
 	model = "Texas Instruments K3 J784S4 SoC";
 	compatible = "ti,j784s4";
diff --git a/arch/arm64/boot/dts/ti/k3-pinctrl.h b/arch/arm64/boot/dts/ti/k3-pinctrl.h
new file mode 100644
index 000000000000..c97548a3f42d
--- /dev/null
+++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * This header provides constants for pinctrl bindings for TI's K3 SoC
+ * family.
+ *
+ * Copyright (C) 2018-2023 Texas Instruments Incorporated - https://www.ti.com/
+ */
+#ifndef DTS_ARM64_TI_K3_PINCTRL_H
+#define DTS_ARM64_TI_K3_PINCTRL_H
+
+#define PULLUDEN_SHIFT		(16)
+#define PULLTYPESEL_SHIFT	(17)
+#define RXACTIVE_SHIFT		(18)
+
+#define PULL_DISABLE		(1 << PULLUDEN_SHIFT)
+#define PULL_ENABLE		(0 << PULLUDEN_SHIFT)
+
+#define PULL_UP			(1 << PULLTYPESEL_SHIFT | PULL_ENABLE)
+#define PULL_DOWN		(0 << PULLTYPESEL_SHIFT | PULL_ENABLE)
+
+#define INPUT_EN		(1 << RXACTIVE_SHIFT)
+#define INPUT_DISABLE		(0 << RXACTIVE_SHIFT)
+
+/* Only these macros are expected be used directly in device tree files */
+#define PIN_OUTPUT		(INPUT_DISABLE | PULL_DISABLE)
+#define PIN_OUTPUT_PULLUP	(INPUT_DISABLE | PULL_UP)
+#define PIN_OUTPUT_PULLDOWN	(INPUT_DISABLE | PULL_DOWN)
+#define PIN_INPUT		(INPUT_EN | PULL_DISABLE)
+#define PIN_INPUT_PULLUP	(INPUT_EN | PULL_UP)
+#define PIN_INPUT_PULLDOWN	(INPUT_EN | PULL_DOWN)
+
+#define AM62AX_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define AM62AX_MCU_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define AM62X_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define AM62X_MCU_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define AM64X_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define AM64X_MCU_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define AM65X_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define AM65X_WKUP_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define J721E_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define J721E_WKUP_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define J721S2_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define J721S2_WKUP_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#define J784S4_IOPAD(pa, val, muxmode)		(((pa) & 0x1fff)) ((val) | (muxmode))
+#define J784S4_WKUP_IOPAD(pa, val, muxmode)	(((pa) & 0x1fff)) ((val) | (muxmode))
+
+#endif
-- 
2.40.0

