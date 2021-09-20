Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB32D411239
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhITJxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:11415 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhITJw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131492; x=1663667492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZEHpommCSL8ojew2FKcV/eSvyPSOisfjZXiNWmXORXQ=;
  b=uAxNDDin+q8p2ErUHeNFaepLceXUxu4NJkNTk7Hc5hF0Qtz05/JsKYXY
   qauiAuzbaxGC0sTtdK+Ht3kr9nS7oPKRsgTaLTBsj7kCxrZUwJFHCrAfy
   TfY6vdMIhbKQXYJ4FwHFtKPyGblhGBsX/lRPeLOL5Sv6ZB0hIWVGcPsT0
   l1YroYFFAzs8gUbB4fxqkzrZwZLdEsOovO0QHetWXv7ZZAkbuk/YTTqlr
   xlohoi5dL6jdmQ9qr/u5L2MQGRGIC7k7YDREY0HNV4eqRH8F3neI9ir3U
   tfMfpYGM41mkIn/LMjVQtUFoq11dQACq6/FLhx2EIQtfkDTc9SKNY91fA
   w==;
IronPort-SDR: /VIa/E1EPeAc4amqqBCs797uYYeQ+iKJohFqTZvxAroYcVpxBMbeOkpgo292OGc3PMDu71kYZ1
 U03DqAils8YMz5lDMtCUjWg8/gxs56rcJBiIruPTIOI4+UrDi1Njpmn7mEiYAU1DTI6t4+9HZX
 o7ZCp8EpBlYpC16ddMldHeonBlQZVMzQQqDFhGKG0yuOH+F/sy+DvYBtwLueRguTD2Ulg7ryVN
 sQTl5n7X3jNDuB09rCIppRhF7lj3dqHabddfb0II40yH0b7qz01PcHMdI/CHHYky4usJgHPFge
 +1wI3BT7DaGSVuJJTAbIlkKF
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="137192394"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:31 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:31 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:28 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 06/12] dt-bindings: reset: Add lan966x power reset bindings
Date:   Mon, 20 Sep 2021 11:52:12 +0200
Message-ID: <20210920095218.1108151-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the lan966x power reset device driver bindings

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../bindings/power/lan966x,power.yaml         | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/lan966x,power.yaml

diff --git a/Documentation/devicetree/bindings/power/lan966x,power.yaml b/Documentation/devicetree/bindings/power/lan966x,power.yaml
new file mode 100644
index 000000000000..d10eec10089b
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/lan966x,power.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/power/lan966x,power.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Microchip Lan966x Power Reset Controller
+
+maintainers:
+  - Horatiu Vultur <horatiu.vultur@microchip.com>
+  - UNGLinuxDriver@microchip.com
+
+description: |
+  The Microchip Lan966x SoC provides power reset control.
+
+properties:
+  $nodename:
+    pattern: "^chip-controller$"
+
+  compatible:
+    const: microchip,lan966x-chip-reset
+
+  "#reset-cells":
+    const: 1
+
+  cpu-syscon:
+    $ref: "/schemas/types.yaml#/definitions/phandle"
+    description: syscon used to access CPU reset
+
+  switch-syscon:
+    $ref: "/schemas/types.yaml#/definitions/phandle"
+    description: syscon used to access SWITCH reset
+
+required:
+  - compatible
+  - "#reset-cells"
+  - cpu-syscon
+  - switch-syscon
+
+additionalProperties: false
+
+examples:
+  - |
+    reset: chip-controller {
+        compatible = "microchip,lan966x-chip-reset";
+        #reset-cells = <1>;
+        cpu-syscon = <&cpu_ctrl>;
+        switch-syscon = <&switch_ctrl>;
+    };
-- 
2.31.1

