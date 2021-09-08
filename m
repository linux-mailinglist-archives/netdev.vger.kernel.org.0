Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7794040E5
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 00:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbhIHWOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 18:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235320AbhIHWOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 18:14:32 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD47DC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 15:13:23 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a4so5496096lfg.8
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 15:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zW8ymdnwoRxgJDfYAsbf37kQ0O4knM0WphAGB0owGQ=;
        b=pHDpEIhoTWdgz6pvptS3InaotYM1RiTcjS2x/gOXrbMcEoGiXbzcQVurRoDughiFNF
         krhDD2ioa9d1dyrcF+wjSPsugEDGxYWYiObQb2ZQ0UWFIG1muouJuS3nH1SAg0JSezhz
         d+VV6kJMS4Zko+lSGq5Jg/Hj0BPCzVURURmtt8M/AiUKuza3QBr3Nu17kBADxmjfY/3L
         OUp7foJixk9hWxp3HG3sUCNcmeLs5u7Kn1NyyNSEQd+aGTONyKRRoa8q7PJueOnJPMRk
         KoDDfuhKktzflwtn72/o+LdVD0gAftSw9q966IdrNiG4u7KkJyiYm5zLvTFnknSg+n0j
         bnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5zW8ymdnwoRxgJDfYAsbf37kQ0O4knM0WphAGB0owGQ=;
        b=i9Jt1vSuxk/4Ct9w7bLRRt7fdxorHlJSAUiSwSkqrSdogt9VNPdD84YOfv+NUZ4Vfp
         iGjc17BKp36u/L/B03oydVZcxTAzE29gNBGZNq+N8QXc+WKHQGBCIwK5ItmzPjSY6yG8
         TCb3+ko+iU5KA0sueKxH2jOZMelniFfkmednKtWnS2+sc+vifizqJpH2P462C2wCBR2t
         60+uFidbRAkNCLzibiKa0HPUM6Fh+x05x4ziyzzeg8BOyWBLXJvhgEqG8LwjSSAeXrPu
         jHXUFnRr2V5HjDovggNedZsVxVWPSiFm/ryAyJI+ziCH157+Trp4eXQ+17gRFfUYyKpy
         3u4A==
X-Gm-Message-State: AOAM5325E47GcFHld33oCHs2PGl/w3q60yONjUTvcXf0zmZoNLX7tk6i
        OFbOWznE0VmDqX2dXGMWRg2VG+gPCDcQnQ==
X-Google-Smtp-Source: ABdhPJxBE+H7w77sPUvXCO9oRuAd/EjFBNsdxGVZJabxCQNiyCp5nPZfxikB6p0mq15O3v6Sv9f8yg==
X-Received: by 2002:a05:6512:6f:: with SMTP id i15mr238185lfo.20.1631139201858;
        Wed, 08 Sep 2021 15:13:21 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r5sm33267lfm.2.2021.09.08.15.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 15:13:21 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH] dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
Date:   Thu,  9 Sep 2021 00:11:18 +0200
Message-Id: <20210908221118.138045-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP4xx V.35 WAN high
speed serial (HSS) link.

An example is added to the NPE example where the HSS appears
as a child.

Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Currently only adding these bindings so we can describe the
hardware in device trees.
---
 ...ntel,ixp4xx-network-processing-engine.yaml |  26 ++++
 .../bindings/net/intel,ixp4xx-hss.yaml        | 129 ++++++++++++++++++
 2 files changed, 155 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml

diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
index c435c9f369a4..179e5dea32b0 100644
--- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
+++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
@@ -45,9 +45,35 @@ additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/gpio/gpio.h>
+
     npe: npe@c8006000 {
          compatible = "intel,ixp4xx-network-processing-engine";
          reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
+         #address-cells = <1>;
+         #size-cells = <0>;
+
+         hss@0 {
+             compatible = "intel,ixp4xx-hss";
+             reg = <0>;
+             intel,npe-handle = <&npe 0>;
+             queue-chl-rxtrig = <&qmgr 12>;
+             queue-pkt-rx = <&qmgr 13>;
+             queue-pkt-tx0 = <&qmgr 14>;
+             queue-pkt-tx1 = <&qmgr 15>;
+             queue-pkt-tx2 = <&qmgr 16>;
+             queue-pkt-tx3 = <&qmgr 17>;
+             queue-pkt-rxfree0 = <&qmgr 18>;
+             queue-pkt-rxfree1 = <&qmgr 19>;
+             queue-pkt-rxfree2 = <&qmgr 20>;
+             queue-pkt-rxfree3 = <&qmgr 21>;
+             queue-pkt-txdone = <&qmgr 22>;
+             cts-gpios = <&gpio0 10 GPIO_ACTIVE_LOW>;
+             rts-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
+             dcd-gpios = <&gpio0 6 GPIO_ACTIVE_LOW>;
+             dtr-gpios = <&gpio_74 2 GPIO_ACTIVE_LOW>;
+             clk-internal-gpios = <&gpio_74 0 GPIO_ACTIVE_HIGH>;
+         };
 
          crypto {
              compatible = "intel,ixp4xx-crypto";
diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
new file mode 100644
index 000000000000..a5a9a14a1242
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
@@ -0,0 +1,129 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2021 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel,ixp4xx-hss.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP4xx V.35 WAN High Speed Serial Link (HSS)
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP4xx HSS makes use of the IXP4xx NPE (Network
+  Processing Engine) and the IXP4xx Queue Manager to process
+  V.35 Wideband Modem (WAN) links.
+
+properties:
+  compatible:
+    const: intel,ixp4xx-hss
+
+  reg:
+    maxItems: 1
+    description: The HSS instance
+
+  intel,npe-handle:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the NPE this HSS instance is using
+      and the instance to use in the second cell
+
+  queue-chl-rxtrig:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the RX trigger queue on the NPE
+
+  queue-pkt-rx:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RX queue on the NPE
+
+  queue-pkt-tx0:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet TX0 queue on the NPE
+
+  queue-pkt-tx1:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet TX1 queue on the NPE
+
+  queue-pkt-tx2:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet TX2 queue on the NPE
+
+  queue-pkt-tx3:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet TX3 queue on the NPE
+
+  queue-pkt-rxfree0:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RXFREE0 queue on the NPE
+
+  queue-pkt-rxfree1:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RXFREE1 queue on the NPE
+
+  queue-pkt-rxfree2:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RXFREE2 queue on the NPE
+
+  queue-pkt-rxfree3:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RXFREE3 queue on the NPE
+
+  queue-pkt-txdone:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet TXDONE queue on the NPE
+
+  cts-gpios:
+    maxItems: 1
+    description: Clear To Send (CTS) GPIO line
+
+  rts-gpios:
+    maxItems: 1
+    description: Ready To Send (RTS) GPIO line
+
+  dcd-gpios:
+    maxItems: 1
+    description: Data Carrier Detect (DCD) GPIO line
+
+  dtr-gpios:
+    maxItems: 1
+    description: Data Terminal Ready (DTR) GPIO line
+
+  clk-internal-gpios:
+    maxItems: 1
+    description: Clock internal GPIO line, driving this high will make the HSS
+      use internal clocking as opposed to external clocking
+
+required:
+  - compatible
+  - reg
+  - intel,npe-handle
+  - queue-chl-rxtrig
+  - queue-pkt-rx
+  - queue-pkt-tx0
+  - queue-pkt-tx1
+  - queue-pkt-tx2
+  - queue-pkt-tx3
+  - queue-pkt-rxfree0
+  - queue-pkt-rxfree1
+  - queue-pkt-rxfree2
+  - queue-pkt-rxfree3
+  - queue-pkt-txdone
+  - cts-gpios
+  - rts-gpios
+  - dcd-gpios
+  - dtr-gpios
+  - clk-internal-gpios
+
+additionalProperties: false
-- 
2.31.1

