Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E86B5C2A
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 14:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCKNN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 08:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCKNNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 08:13:52 -0500
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6489F0FFA;
        Sat, 11 Mar 2023 05:13:49 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDQm1017523;
        Sat, 11 Mar 2023 07:13:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678540406;
        bh=eYpa+eh8qEfFT016DWnLlGWJJDueQKCLZItt0BSTdwY=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Ox1ko/+8Dn34IzOPaHpZv9cHLrz6pW8oKljstDtPgK9J34KOGI1XmIqPIL9Si6ha1
         PPKfRW98JMP/eKw3jGEW2j5h7yU8B6DCfH9ANGYs2su7tsFx/ZO+YR7g+GP/VnFJJo
         uZpjJMfFu+AHL+EfUsgYTL9inczgAZE/s/0DWbrI=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32BDDQbm012213
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 11 Mar 2023 07:13:26 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Sat, 11
 Mar 2023 07:13:26 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Sat, 11 Mar 2023 07:13:25 -0600
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDQHO007410;
        Sat, 11 Mar 2023 07:13:26 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 2/2] dt-bindings: pinctrl: Move k3.h to arch
Date:   Sat, 11 Mar 2023 07:13:25 -0600
Message-ID: <20230311131325.9750-3-nm@ti.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230311131325.9750-1-nm@ti.com>
References: <20230311131325.9750-1-nm@ti.com>
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

Move the k3 pinctrl definition to arch dts folder.

While at this, fixup MAINTAINERS and header guard macro to better
reflect the changes.

Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
Signed-off-by: Nishanth Menon <nm@ti.com>
---

There is no specific case I can think of at the moment to create a
pinctrl.dtsi for the SoCs.. So, unlike other SoCs, I had not done that
in the series, if folks have a better opinion about this, please let us
discuss.

 MAINTAINERS                                                 | 1 -
 arch/arm64/boot/dts/ti/k3-am62.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-am62a.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-am64.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-am65.dtsi                         | 3 ++-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721e.dtsi                        | 3 ++-
 arch/arm64/boot/dts/ti/k3-j721s2.dtsi                       | 3 ++-
 arch/arm64/boot/dts/ti/k3-j784s4.dtsi                       | 3 ++-
 .../pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h     | 6 +++---
 10 files changed, 19 insertions(+), 12 deletions(-)
 rename include/dt-bindings/pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h (94%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2892858cb040..442ac29e1fce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2933,7 +2933,6 @@ F:	Documentation/devicetree/bindings/arm/ti/k3.yaml
 F:	Documentation/devicetree/bindings/hwinfo/ti,k3-socinfo.yaml
 F:	arch/arm64/boot/dts/ti/Makefile
 F:	arch/arm64/boot/dts/ti/k3-*
-F:	include/dt-bindings/pinctrl/k3.h
 
 ARM/TOSHIBA VISCONTI ARCHITECTURE
 M:	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
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
diff --git a/include/dt-bindings/pinctrl/k3.h b/arch/arm64/boot/dts/ti/k3-pinctrl.h
similarity index 94%
rename from include/dt-bindings/pinctrl/k3.h
rename to arch/arm64/boot/dts/ti/k3-pinctrl.h
index 469bd29651db..6004e0967ec5 100644
--- a/include/dt-bindings/pinctrl/k3.h
+++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h
@@ -3,10 +3,10 @@
  * This header provides constants for pinctrl bindings for TI's K3 SoC
  * family.
  *
- * Copyright (C) 2018-2021 Texas Instruments Incorporated - https://www.ti.com/
+ * Copyright (C) 2018-2023 Texas Instruments Incorporated - https://www.ti.com/
  */
-#ifndef _DT_BINDINGS_PINCTRL_TI_K3_H
-#define _DT_BINDINGS_PINCTRL_TI_K3_H
+#ifndef DTS_ARM64_TI_K3_PINCTRL_H
+#define DTS_ARM64_TI_K3_PINCTRL_H
 
 #define PULLUDEN_SHIFT		(16)
 #define PULLTYPESEL_SHIFT	(17)
-- 
2.37.2

