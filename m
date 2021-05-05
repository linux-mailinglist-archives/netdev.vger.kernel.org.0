Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F324F374978
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhEEU30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhEEU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 16:29:21 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38B6C06174A
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 13:28:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n205so2167053wmf.1
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 13:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yx57mU4aQc2ITOlbPXwjrloHYYT8kysHbI0JwKKxnZY=;
        b=AUzbJDgtPrlzxA7QPdXC27JKGKfhevz4Jhux8iYpvWnmAlQ6qIEXxoJ4xJ30cgHDTt
         Uc/888YOgW43DHWzxl1rdVdoiBzP6vdalF550RHG1QRXKjAANYqM/Xt7wo9ma/T4kwPU
         6kNdPs8z5iabEtHJxQDb8YCil7ip8tq7YV5PxgpjaU6Xw6opTaA1v99BoB4Qz3twVJ9f
         TpjHwFtZrkZ1vabTYJBZV+w5PDZI6jYU72zxSVis6n7DmXFXxRkNYgjPbKd7YbrG/Fiu
         GbHouzmxcn4FMtYrtLqf87JiNz3HhMQjHniYZ5W/SvoBEH60Nd9JDtB9dgc7e7+txJBB
         WfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yx57mU4aQc2ITOlbPXwjrloHYYT8kysHbI0JwKKxnZY=;
        b=h0CR9r4j0REphi/rGBRrhGZwQVV1j+AaQGRO/8b8A4Mj+1d0JMgb+UJxLxRRdb2sxf
         0TcJ43EwtdPCcY2uKxrpf5D1oG2WSqqJMs3a6SNcpKrtgdoDkYWHUfAhp3TdZTiNzmYV
         xSeN4oQ36JrjI71QomQ40+7QtQdxJOu/0/mx4XWS44QxNpyf3e6W4ZGHuvUx9P+EyUxk
         JWcbOBDBNw4HheRPdDQmTnSlHwW41s/ZgOf1ldxfgkeH5broR7EQReUCKWdjMywSalZU
         tG1meaWkOaArjVdzzUsVOOvzqWJ/L70upvjtEnDvdkCfCQQgiX3ihQDIiFWsriqcb8pE
         lc8g==
X-Gm-Message-State: AOAM532QDC240oapvwO8PBI0/VaGCGf5vMdbyHr6CpkAP4w5e+DUB9+V
        g8mYO3/428G8dFmNH0NFMbMKVA==
X-Google-Smtp-Source: ABdhPJzd9O9OZv0JGCmTqFcm74RTrrRCeFAHixyv7Gv+80vKt5uI49Ph8bX6vnJNdFFd93xoKs6F6A==
X-Received: by 2002:a1c:e345:: with SMTP id a66mr11648751wmh.109.1620246502622;
        Wed, 05 May 2021 13:28:22 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id q20sm8713972wmq.2.2021.05.05.13.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:28:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5] dt-bindings: net: Convert mdio-gpio to yaml
Date:   Wed,  5 May 2021 20:28:15 +0000
Message-Id: <20210505202815.2665920-1-clabbe@baylibre.com>
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

Changes since v4:
- fixed maintainers list

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
index 000000000000..7c15a508af5b
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
+  - Heiner Kallweit <hkallweit1@gmail.com>
+  - Russell King <linux@armlinux.org.uk>
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

