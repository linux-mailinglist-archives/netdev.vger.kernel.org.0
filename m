Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C63371FD1
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 20:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhECSmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 14:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhECSmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 14:42:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FDAC061761
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 11:41:07 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z6so6641595wrm.4
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 11:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n8/Px2QFYE/jiv5S56bnSLpfOUhvhXNDZdvfzZY71CM=;
        b=w8YxWHm/DNz+izh8bKyu/dKy3r7hK6/lDO3huz8+7707XiMuyX5tRSv4YT9b+mYrks
         t8T6RHCWlqEXT5bIZv1xKSHnjhXDEEA8WRR3g/ZSuO3VvnamtrvM23m58mY+Cg30YlZD
         d5Ai46bGMTR2do/v2hfoh+sM6OOFGPl3W5CZzic8Ilx2G7pz++10Jv8a74ENZWiOlRN+
         SaDAirERPcw0BvM434bvf3KjtO+GJBTsc259L/O99+c4RBIgGO4tlQrRRm3manK5VcA6
         xPj8qjpakytXagK+GTH2yruaSdev0xUffZ7QZ16KoOt/86PLKvpwCg/pNB89flfQqHFS
         V//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n8/Px2QFYE/jiv5S56bnSLpfOUhvhXNDZdvfzZY71CM=;
        b=NZA6XrUhQFzhzS42MJy5OAxwUmDSHXMYYWPmMiiPpZMFecZdjjlu0H9Q/sOqqF30vH
         Xk66KfIAorYeti0uO+Eb8dXK+SZ54NCJg4uhrYiUYsgy2iPqKcI33ftZJrHCskYKPV9n
         5MQM246fYjv0Yeuo5qek3qyQbR4x4lcU6EyX61+s9/IFFp8zscJNAd2Ix8Vx25wMYxHt
         Tzk4twi3446nE8QMBXryK6wkQK56wj6SO7Hse2KhMI6Ji/HRGLNC/L9uTa/6S5EIluAB
         sf0W+YINf+0Yf4riE7pCqTXT7wBTc0HpJD6P5w8cqQNBFi9h6e1u4yRsbduOJnZVda6H
         cbTw==
X-Gm-Message-State: AOAM530+7LHhlDgu32rF9cFWhuoT9Jdb1DxNorhHrHF7EZNhPUKRZ3JT
        Zo9IAqGF4Yn3mp7pHoaIqqZquw==
X-Google-Smtp-Source: ABdhPJxp0ZPitqCUNRt3lroqfpwL6dMh/fQvnk7GiUU091Jx0DOk5sMffsvcRsfeAAY5aumNBF2T9w==
X-Received: by 2002:adf:fc42:: with SMTP id e2mr5034212wrs.302.1620067266290;
        Mon, 03 May 2021 11:41:06 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o62sm647647wmo.3.2021.05.03.11.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 11:41:05 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4] dt-bindings: net: Convert mdio-gpio to yaml
Date:   Mon,  3 May 2021 18:41:00 +0000
Message-Id: <20210503184100.1503307-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Converts net/mdio-gpio.txt to yaml

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Changes since v1:
- fixes yamllint warning about indent
- added maxItems 3

Changes since v2:
- fixed example (gpios need 2 entries)

Changes since v3:
- fixed gpios description
- added additionalProperties/type: object

 .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
 .../devicetree/bindings/net/mdio-gpio.yaml    | 58 +++++++++++++++++++
 2 files changed, 58 insertions(+), 27 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.yaml

diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
deleted file mode 100644
index 4d91a36c5cf5..000000000000
--- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-MDIO on GPIOs
-
-Currently defined compatibles:
-- virtual,gpio-mdio
-- microchip,mdio-smi0
-
-MDC and MDIO lines connected to GPIO controllers are listed in the
-gpios property as described in section VIII.1 in the following order:
-
-MDC, MDIO.
-
-Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
-node.
-
-Example:
-
-aliases {
-	mdio-gpio0 = &mdio0;
-};
-
-mdio0: mdio {
-	compatible = "virtual,mdio-gpio";
-	#address-cells = <1>;
-	#size-cells = <0>;
-	gpios = <&qe_pio_a 11
-		 &qe_pio_c 6>;
-};
diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
new file mode 100644
index 000000000000..236a8c4768e2
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
@@ -0,0 +1,58 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mdio-gpio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MDIO on GPIOs
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Heiner Kallweit <hkallweit1@gmail.com>
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - virtual,mdio-gpio
+      - microchip,mdio-smi0
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  gpios:
+    minItems: 2
+    maxItems: 3
+    items:
+      - description: MDC
+      - description: MDIO
+      - description: MDO
+
+#Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
+#node.
+additionalProperties:
+  type: object
+
+examples:
+  - |
+    aliases {
+        mdio-gpio0 = &mdio0;
+    };
+
+    mdio0: mdio {
+      compatible = "virtual,mdio-gpio";
+      #address-cells = <1>;
+      #size-cells = <0>;
+      gpios = <&qe_pio_a 11>,
+              <&qe_pio_c 6>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+      };
+    };
+...
-- 
2.26.3

