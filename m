Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1966836DD07
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbhD1QcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD1QcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:32:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B63C0613ED
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:31:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i129so7216658wma.3
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s37poLb+YU/j8PS1vBOf/p0j3PbxlMcEPm2Cc7PyPFc=;
        b=lAYP6D/xe5gDXAPQP7KVnwObFqfRXHFY5GwBElU671lGEh2PLg8GkgZQYIEWFZED8n
         ICkiqNuM1cYoOK846RRK+9QOjGnxHTEqsRwC4h+NRG51WOu20qb1k/cFss7HQrwFVlEa
         C28uwYS783D4w2SrsBZulhZ6uLoOgfvyDaDy7kyhqotdjC1sCnGD2iV1K7Y/gOJxlacD
         /IZkgCG35q3uJ961iPnjWviyWb3zd9tdyIIAwbMjBo3rUbrq3HLfGgAIFf81DpKCj4Qz
         EZPkZGatRmZdkGoLYQHUMFZHyBQbolAsdpewylqJrn0CaDkCBd1PSoWrPazfBj7Jowe3
         EkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s37poLb+YU/j8PS1vBOf/p0j3PbxlMcEPm2Cc7PyPFc=;
        b=pQjSx8EasjsNMEdDKuVMJRWEMlgIHmALmeBEcz108Qk8LenQJuBuKK7L8J0C0jrcEq
         cJUyg3FJpG4k2Rs+UgjoP4vc7re4HF/vjtr0ufeG5RrgCbrwz3oUh6aFk86Nz+Oz0Z0F
         NFZAfhpe16tXGxUL89YCOGT2M14hjpk7hZdbe0f/4PsZO3Iz1VAQkPsscYpwxDhnlc14
         AJdh9kyq8dGEt2Ril4bwWpcYlwMrpFFYkT8NFzqwKvDa2i3OCcdG+r/+KjKe91mvFeRJ
         +gsbCSJMC44H3QykSm0owtXUoUGBy+GNnaVfqHA+66a3d/QchXdWSwZ92kMR+whdgVjR
         0DKQ==
X-Gm-Message-State: AOAM532ew3Hb1iLG0jvS7T7E5cne8lQkbEEVkJxgGOvwdO0jqi3D1iNn
        ElQU1+3WawendPI9Ml7F9PIztA==
X-Google-Smtp-Source: ABdhPJzK3CHvftOyllCnQgS/edlWXyrWZ90fvwsLji8SZm5+vWo5D+eg38Vg7Z849JFODpMYYpMe2w==
X-Received: by 2002:a7b:c74d:: with SMTP id w13mr5753522wmk.25.1619627487898;
        Wed, 28 Apr 2021 09:31:27 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id c15sm380339wrr.3.2021.04.28.09.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:31:27 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, linus.walleij@linaro.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] dt-bindings: net: Convert mdio-gpio to yaml
Date:   Wed, 28 Apr 2021 16:31:20 +0000
Message-Id: <20210428163120.3657234-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Converts net/mdio-gpio.txt to yaml

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
This patch is a part of the work on fixing all DTs on gemini platform.

 .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
 .../devicetree/bindings/net/mdio-gpio.yaml    | 56 +++++++++++++++++++
 2 files changed, 56 insertions(+), 27 deletions(-)
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
index 000000000000..55c629cb5e57
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
@@ -0,0 +1,56 @@
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
+    description: |
+      MDC and MDIO lines connected to GPIO controllers are listed in
+      the gpios property as described in section VIII.1 in the
+      following order: MDC, MDIO.
+
+#Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
+#node.
+unevaluatedProperties: false
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
+      gpios = <&qe_pio_a 11
+               &qe_pio_c 6>;
+      ethphy0: ethernet-phy@0 {
+        reg = <0>;
+      };
+    };
+...
-- 
2.26.3

