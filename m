Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BFD4F537C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356490AbiDFESA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350686AbiDEUP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:15:26 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B20FF9FA0;
        Tue,  5 Apr 2022 12:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YY6foXzBPkeKgwXFtBBUDugou4a7a9Ouq6nJmtz/VTE=; b=HJX9KH3+gWEKbHXeU2u6OfEqLE
        sIY/1dU9ZKoUO9DdUg9FaLMEjlven46KBL0eQMSxoY0sszKgi3vvdiWWiG0pB6RQjYtkUKHsVWkOY
        2nngF51Dr+gE15aqMVzo66OKUnJh4nuksWQz9SwZGodmGvy6AQyYhGNRWstQfMHC8gAc=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJR-00035V-B8; Tue, 05 Apr 2022 21:58:01 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/14] dt-bindings: arm: mediatek: document WED binding for MT7622
Date:   Tue,  5 Apr 2022 21:57:45 +0200
Message-Id: <20220405195755.10817-5-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Document the binding for the Wireless Ethernet Dispatch core on the MT7622
SoC, which is used for Ethernet->WLAN offloading
Add related info in mediatek-net bindings.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../arm/mediatek/mediatek,mt7622-wed.yaml     | 50 +++++++++++++++++++
 .../devicetree/bindings/net/mediatek-net.txt  |  2 +
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
new file mode 100644
index 000000000000..787d6673f952
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek Wireless Ethernet Dispatch Controller for MT7622
+
+maintainers:
+  - Lorenzo Bianconi <lorenzo@kernel.org>
+  - Felix Fietkau <nbd@nbd.name>
+
+description:
+  The mediatek wireless ethernet dispatch controller can be configured to
+  intercept and handle access to the WLAN DMA queues and PCIe interrupts
+  and implement hardware flow offloading from ethernet to WLAN.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - mediatek,mt7622-wed
+      - const: syscon
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      wed0: wed@1020a000 {
+        compatible = "mediatek,mt7622-wed","syscon";
+        reg = <0 0x1020a000 0 0x1000>;
+        interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
+      };
+    };
diff --git a/Documentation/devicetree/bindings/net/mediatek-net.txt b/Documentation/devicetree/bindings/net/mediatek-net.txt
index 13cb12ee4ed6..1c8dc44bbb52 100644
--- a/Documentation/devicetree/bindings/net/mediatek-net.txt
+++ b/Documentation/devicetree/bindings/net/mediatek-net.txt
@@ -46,6 +46,8 @@ Optional properties:
 - mediatek,cci-control: phandle to the cache coherent interconnect node
 - mediatek,hifsys: phandle to the mediatek hifsys controller used to provide
 	various clocks and reset to the system.
+- mediatek,wed: a list of phandles to wireless ethernet dispatch nodes for
+	MT7622 SoC.
 
 * Ethernet MAC node
 
-- 
2.35.1

