Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2281E831D2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbfHFMu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:50:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35203 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731525AbfHFMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:50:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so1921602wrq.2
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 05:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rhTOUZ9G7ELcHR5mtsthMEB7VhP+u0SW/0dpZjG88nw=;
        b=MKX6IROW92n4YJCICK7Z5132q8RXqctROHpc1cBlzIZQOHSErqQyMunY4sVaqJTun+
         RmX13sjfFcbLHGyNWw5lyGRgfc0a02Ux+KXHadnISQw4EQBDKpI62Bb2gJ9iO6CYsOzV
         2CujX4p2uzhNpoVr6abEMtY0vrw/LkRI49+C1du6eH2raUGq//m9ZJJG44utyl6LQhZI
         KAbQQqnRAloRiKOD0g6HWg3Rlm8HDc+DjNHSxXbZNUPQZVs+FFCVR7517VChq63r/B9A
         SkLVVVgcpIFjjAqbTZPAu2ueMvATHVc6NNAd7vi/UBoinQkRrrMEEqBd2hrU8xvMJxAR
         YouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhTOUZ9G7ELcHR5mtsthMEB7VhP+u0SW/0dpZjG88nw=;
        b=OIxGyK9jjfeSvsGk1DljA4QdTrcWt7KEKIFMVTlNFEsj4zwIa+SYb3FsvVyS/xpTG2
         Zbdiev3qkLzXIZlT63VS9GgRIdb1nt2b31IVEnnWbpRt8G8unksChEzn0zH+u9at29+p
         qMSmcUnwfm9ehvg8UV3HtZDm61rO8ebNpmLbCS/0Ai1EFaPX9Rz4rT7UuonH+8p7QwP3
         2WyomFcZC8CaT7Li6dbcfXPfI9xkC86HIDLKbtvXL8tf9NUY/H8MZZ91mqjBqk7rTlzI
         v4lH3ErR17AJZAJ4L2jk0OSXkpX425jJEj3qAJ6Yw7SGd9lvgXU/WGKowzyybjyN5a7Z
         8tbw==
X-Gm-Message-State: APjAAAWRDoTBRT+miBBu+rEPQ8Bwk6SYnwqN81OJrU/HsfpBW2jDOgaH
        m54HsuXkIYNi5mhGmiXaD3VOeQ==
X-Google-Smtp-Source: APXvYqw4A2VBYRl3e+Ck3oSFj9yirouitKGOppjo38AXUHMP3e9+WGl+28hBO07Q2q0frmKt8/X98Q==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr4917882wrv.207.1565095845680;
        Tue, 06 Aug 2019 05:50:45 -0700 (PDT)
Received: from bender.baylibre.local (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id e3sm109049221wrs.37.2019.08.06.05.50.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 05:50:44 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     robh+dt@kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        martin.blumenstingl@googlemail.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] dt-bindings: net: meson-dwmac: convert to yaml
Date:   Tue,  6 Aug 2019 14:50:41 +0200
Message-Id: <20190806125041.16105-3-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806125041.16105-1-narmstrong@baylibre.com>
References: <20190806125041.16105-1-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the DT validation in place, let's convert the device tree
bindings for the Synopsys DWMAC Glue for Amlogic SoCs over to a YAML schemas.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml     | 113 ++++++++++++++++++
 .../devicetree/bindings/net/meson-dwmac.txt   |  71 -----------
 .../devicetree/bindings/net/snps,dwmac.yaml   |   5 +
 3 files changed, 118 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
new file mode 100644
index 000000000000..ae91aa9d8616
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -0,0 +1,113 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2019 BayLibre, SAS
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/amlogic,meson-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Amlogic Meson DWMAC Ethernet controller
+
+maintainers:
+  - Neil Armstrong <narmstrong@baylibre.com>
+  - Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+
+# We need a select here so we don't match all nodes with 'snps,dwmac'
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - amlogic,meson6-dwmac
+          - amlogic,meson8b-dwmac
+          - amlogic,meson8m2-dwmac
+          - amlogic,meson-gxbb-dwmac
+          - amlogic,meson-axg-dwmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - amlogic,meson8b-dwmac
+              - amlogic,meson8m2-dwmac
+              - amlogic,meson-gxbb-dwmac
+              - amlogic,meson-axg-dwmac
+
+    then:
+      properties:
+        clocks:
+          items:
+            - description: GMAC main clock
+            - description: First parent clock of the internal mux
+            - description: Second parent clock of the internal mux
+
+        clock-names:
+          minItems: 3
+          maxItems: 3
+          items:
+            - const: stmmaceth
+            - const: clkin0
+            - const: clkin1
+
+        amlogic,tx-delay-ns:
+          $ref: /schemas/types.yaml#definitions/uint32
+          description:
+            The internal RGMII TX clock delay (provided by this driver) in
+            nanoseconds. Allowed values are 0ns, 2ns, 4ns, 6ns.
+            When phy-mode is set to "rgmii" then the TX delay should be
+            explicitly configured. When not configured a fallback of 2ns is
+            used. When the phy-mode is set to either "rgmii-id" or "rgmii-txid"
+            the TX clock delay is already provided by the PHY. In that case
+            this property should be set to 0ns (which disables the TX clock
+            delay in the MAC to prevent the clock from going off because both
+            PHY and MAC are adding a delay).
+            Any configuration is ignored when the phy-mode is set to "rmii".
+
+properties:
+  compatible:
+    additionalItems: true
+    maxItems: 3
+    items:
+      - enum:
+          - amlogic,meson6-dwmac
+          - amlogic,meson8b-dwmac
+          - amlogic,meson8m2-dwmac
+          - amlogic,meson-gxbb-dwmac
+          - amlogic,meson-axg-dwmac
+    contains:
+      enum:
+        - snps,dwmac-3.70a
+        - snps,dwmac
+
+  reg:
+    items:
+      - description:
+          The first register range should be the one of the DWMAC controller
+      - description:
+          The second range is is for the Amlogic specific configuration
+          (for example the PRG_ETHERNET register range on Meson8b and newer)
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - phy-mode
+
+examples:
+  - |
+    ethmac: ethernet@c9410000 {
+         compatible = "amlogic,meson-gxbb-dwmac", "snps,dwmac";
+         reg = <0xc9410000 0x10000>, <0xc8834540 0x8>;
+         interrupts = <8>;
+         interrupt-names = "macirq";
+         clocks = <&clk_eth>, <&clkc_fclk_div2>, <&clk_mpll2>;
+         clock-names = "stmmaceth", "clkin0", "clkin1";
+         phy-mode = "rgmii";
+    };
diff --git a/Documentation/devicetree/bindings/net/meson-dwmac.txt b/Documentation/devicetree/bindings/net/meson-dwmac.txt
deleted file mode 100644
index 1321bb194ed9..000000000000
--- a/Documentation/devicetree/bindings/net/meson-dwmac.txt
+++ /dev/null
@@ -1,71 +0,0 @@
-* Amlogic Meson DWMAC Ethernet controller
-
-The device inherits all the properties of the dwmac/stmmac devices
-described in the file stmmac.txt in the current directory with the
-following changes.
-
-Required properties on all platforms:
-
-- compatible:	Depending on the platform this should be one of:
-			- "amlogic,meson6-dwmac"
-			- "amlogic,meson8b-dwmac"
-			- "amlogic,meson8m2-dwmac"
-			- "amlogic,meson-gxbb-dwmac"
-			- "amlogic,meson-axg-dwmac"
-		Additionally "snps,dwmac" and any applicable more
-		detailed version number described in net/stmmac.txt
-		should be used.
-
-- reg:	The first register range should be the one of the DWMAC
-	controller. The second range is is for the Amlogic specific
-	configuration (for example the PRG_ETHERNET register range
-	on Meson8b and newer)
-
-Required properties on Meson8b, Meson8m2, GXBB and newer:
-- clock-names:	Should contain the following:
-		- "stmmaceth" - see stmmac.txt
-		- "clkin0" - first parent clock of the internal mux
-		- "clkin1" - second parent clock of the internal mux
-
-Optional properties on Meson8b, Meson8m2, GXBB and newer:
-- amlogic,tx-delay-ns:	The internal RGMII TX clock delay (provided
-			by this driver) in nanoseconds. Allowed values
-			are: 0ns, 2ns, 4ns, 6ns.
-			When phy-mode is set to "rgmii" then the TX
-			delay should be explicitly configured. When
-			not configured a fallback of 2ns is used.
-			When the phy-mode is set to either "rgmii-id"
-			or "rgmii-txid" the TX clock delay is already
-			provided by the PHY. In that case this
-			property should be set to 0ns (which disables
-			the TX clock delay in the MAC to prevent the
-			clock from going off because both PHY and MAC
-			are adding a delay).
-			Any configuration is ignored when the phy-mode
-			is set to "rmii".
-
-Example for Meson6:
-
-	ethmac: ethernet@c9410000 {
-		compatible = "amlogic,meson6-dwmac", "snps,dwmac";
-		reg = <0xc9410000 0x10000
-		       0xc1108108 0x4>;
-		interrupts = <0 8 1>;
-		interrupt-names = "macirq";
-		clocks = <&clk81>;
-		clock-names = "stmmaceth";
-	}
-
-Example for GXBB:
-	ethmac: ethernet@c9410000 {
-		compatible = "amlogic,meson-gxbb-dwmac", "snps,dwmac";
-		reg = <0x0 0xc9410000 0x0 0x10000>,
-			<0x0 0xc8834540 0x0 0x8>;
-		interrupts = <0 8 1>;
-		interrupt-names = "macirq";
-		clocks = <&clkc CLKID_ETH>,
-				<&clkc CLKID_FCLK_DIV2>,
-				<&clkc CLKID_MPLL2>;
-		clock-names = "stmmaceth", "clkin0", "clkin1";
-		phy-mode = "rgmii";
-	};
diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 4377f511a51d..c78be15704b9 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -50,6 +50,11 @@ properties:
         - allwinner,sun8i-r40-emac
         - allwinner,sun8i-v3s-emac
         - allwinner,sun50i-a64-emac
+        - amlogic,meson6-dwmac
+        - amlogic,meson8b-dwmac
+        - amlogic,meson8m2-dwmac
+        - amlogic,meson-gxbb-dwmac
+        - amlogic,meson-axg-dwmac
         - snps,dwmac
         - snps,dwmac-3.50a
         - snps,dwmac-3.610
-- 
2.22.0

