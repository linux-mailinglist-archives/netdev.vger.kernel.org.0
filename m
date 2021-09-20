Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD03411230
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhITJx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbhITJww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131486; x=1663667486;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=epnho9O5xG1dOE7FuOlq6UtUNvkMiFANBOevGHC00ZQ=;
  b=I0qijL1BWMDeavkjxwrzwgDme1eXZmK+QkAVSvg4/jugJmGZkKtrfbDv
   tk3qySqot45MVJbWV2WQ99NUTZ10+lER8Omo6O8UhqD4OBlHS91rIfYNc
   B100JO/BjgqR4EpJuJTgfaoWAd46h7iPe1ZRHKC7r5fFpqrZ36XLQ/5Nv
   LQX/Q7wsSBktiNxPTxe51uXUz4kfnaTST4ZwRh26dlwdFoSrCbRz9xCMj
   VhE5Jx5dJzkm9S/XaR4fYFeyNj8B2fvEdnakr+zw4WRC8R1Ith9JN9w3Y
   10f5Vn1iumwFrufoaIcJLfCEwQkruOi1XGse3uEaegROUZMgp5VJXnnJX
   w==;
IronPort-SDR: NN3n1DQFdaLsdSeLWhSkemH3KPp5v4kIcA2aZjl1TUXQfM+F0zlmBw1AYGV2p3a8IznIpGn2E6
 4Jy6VUPoAhOx/JX/hTvf6jV0HCVg9jq+/Y8e29JK2eE9dmEmJ8wvLvQ4PYbO1ICBn7n+S3dxa/
 g5aZYnWUrmXcrGOCWtP9KK/oQUszWHRM19sGUnj25ym2+4h7wQf2F/22GWIvviwJkWXb1xGloo
 u9Dzzezr/K0ke8F1ms2Wfr56Yxiqwnuspy7L4JKq/SLPaqbXLSKmDRxmRWYoEsyMUY61rZsLML
 11nXe+A1CFal8t9WMXe6JlA2
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="137192382"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 04/12] dt-bindings: reset: Add lan966x switch reset bindings
Date:   Mon, 20 Sep 2021 11:52:10 +0200
Message-ID: <20210920095218.1108151-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the lan966x switch reset device driver bindings

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../bindings/reset/lan966x,rst.yaml           | 58 +++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/lan966x,rst.yaml

diff --git a/Documentation/devicetree/bindings/reset/lan966x,rst.yaml b/Documentation/devicetree/bindings/reset/lan966x,rst.yaml
new file mode 100644
index 000000000000..97d6334e4e0a
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/lan966x,rst.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/reset/lan966x,rst.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Microchip lan966x Switch Reset Controller
+
+maintainers:
+  - Horatiu Vultur <horatiu.vultur@microchip.com>
+  - UNGLinuxDriver@microchip.com
+
+description: |
+  The Microchip lan966x Switch provides reset control and implements the
+  following
+  functions
+    - One Time Switch Core Reset (Soft Reset)
+
+properties:
+  $nodename:
+    pattern: "^reset-controller$"
+
+  compatible:
+    const: microchip,lan966x-switch-reset
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
+  chip-syscon:
+    $ref: "/schemas/types.yaml#/definitions/phandle"
+    description: syscon used to access CHIP reset
+
+required:
+  - compatible
+  - "#reset-cells"
+  - cpu-syscon
+  - switch-syscon
+  - chip-syscon
+
+additionalProperties: false
+
+examples:
+  - |
+    reset: reset-controller {
+        compatible = "microchip,lan966x-switch-reset";
+        #reset-cells = <1>;
+        cpu-syscon = <&cpu_ctrl>;
+        switch-syscon = <&switch_ctrl>;
+        chip-syscon = <&chip_ctrl>;
+    };
-- 
2.31.1

