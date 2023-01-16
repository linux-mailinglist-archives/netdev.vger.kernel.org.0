Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28D266BBEB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjAPKi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjAPKiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:38:04 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2B21C333;
        Mon, 16 Jan 2023 02:37:39 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B73DD1BF205;
        Mon, 16 Jan 2023 10:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673865458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8IX0izh2qofZ81a22loEnqRs/JS0gZcUvR46cRLlzA4=;
        b=Ul2TaPHJ72dnl9AUb/svtGLqKtHwaC9hu+8cfbE58IJMFk7P8p2Q9ki/B2PYcCI//1fC8h
        YDr6I12YRfabH7sEZ1OR2zVo53NdyddkAJ7KNl4ayzug5fkZhmGyfwX/SrfU88U7OpvbsI
        0hR2D4PO0H451Edzvtl3jkoSGAddyX4dGf8sAKdE8S9041RvxxSHgaENf1hr2i1K5I9nIo
        a7o232pHJVjebRULTZ2+/ugoExFg1wDHnWH57wNBvBe9FWGx2bEf7SRRfiQ4P7JgE6Xym9
        PfP34jYmx+zlNodo9OcpcjO4XPDoQp7k76+ik2h8i7nBQbvRdMmPLvOZ/SH2xg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 4/6] dt-bindings: net: renesas,rzn1-gmac: Document RZ/N1 GMAC support
Date:   Mon, 16 Jan 2023 11:39:24 +0100
Message-Id: <20230116103926.276869-5-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116103926.276869-1-clement.leger@bootlin.com>
References: <20230116103926.276869-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "renesas,rzn1-gmac" binding documention which is compatible which
"snps,dwmac" compatible driver but uses a custom PCS to communicate
with the phy.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 .../bindings/net/renesas,rzn1-gmac.yaml       | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml

diff --git a/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
new file mode 100644
index 000000000000..effb9a312832
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
@@ -0,0 +1,71 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/renesas,rzn1-gmac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Renesas GMAC1 Device Tree Bindings
+
+maintainers:
+  - Clément Léger <clement.leger@bootlin.com>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - renesas,r9a06g032-gmac
+          - renesas,rzn1-gmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    additionalItems: true
+    maxItems: 3
+    items:
+      - enum:
+          - renesas,r9a06g032-gmac
+          - renesas,rzn1-gmac
+    contains:
+      enum:
+        - snps,dwmac
+
+  pcs-handle:
+    description:
+      phandle pointing to a PCS sub-node compatible with
+      renesas,rzn1-miic.yaml#
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+required:
+  - compatible
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@44000000 {
+      compatible = "renesas,rzn1-gmac";
+      reg = <0x44000000 0x2000>;
+      interrupt-parent = <&gic>;
+      interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
+             <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
+             <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+      interrupt-names = "macirq", "eth_wake_irq", "eth_lpi";
+      clock-names = "stmmaceth";
+      clocks = <&sysctrl R9A06G032_HCLK_GMAC0>;
+      snps,multicast-filter-bins = <256>;
+      snps,perfect-filter-entries = <128>;
+      tx-fifo-depth = <2048>;
+      rx-fifo-depth = <4096>;
+      pcs-handle = <&mii_conv1>;
+      phy-mode = "mii";
+    };
+
+...
-- 
2.39.0

