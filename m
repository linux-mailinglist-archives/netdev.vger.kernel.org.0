Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58B4597C4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 23:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbhKVWks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 17:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhKVWkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 17:40:45 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42376C061714
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:37:38 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 13so6963812ljj.11
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 14:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ydu+4HLpgha7ihZEZBxulYd0TdMhjqhogvMnUMO0Biw=;
        b=N8PAW/1FsKfjBH1xImssFNq13U+m10cLP6y4B9ec486TRqx85Zf7kcfY4HLKwVVN92
         GpYU77aX9pWOmb86KOn4wi3jPAB2iASzsCL9KvTq/o7lYel/OgkOGGQmInY220Mzd98A
         Ucqacb3t13ZkxQwQSP//Pl5eNWVDE5eXuwY1r/Odio6q0AeOFzpCwrOCENjrim84wyTI
         20NXkxq8GHrkDXJ4L9FA7PIZ8zWnjFk2K1XXhXYfdJ4El9ZiI5KsdL0czwrnoJ3+YJi1
         CXyp9BYxQUqs0j0pPWMR9VVBdPoCExu0pam2pKxIg5+bfF/wmfYrjFjWnW+QzUT0N0S4
         6FXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ydu+4HLpgha7ihZEZBxulYd0TdMhjqhogvMnUMO0Biw=;
        b=Q+M9JlydZXu0LcBst2aMvHxKo+jVcpoT/NK8Axj7i7qNL6MhU7gnV/d+Fpuf6QfedO
         Es5tnFlXKod/10wUTQof6CpbgCj5VHhXiTjwrAjJKf70dYD9YUveXuf2u129MhKH58H/
         qvcj3AW240czQF3gH1U1nd9BDp4WKj71f3xAJ44p2TJcr166C6mzAbVY5JV5ISq0RWkb
         u0VHhX+wAcA1j/9MvHcmSnHfejTzIrkx/I7AEU5/1+aXPaK6mAj63AiQm2L80xZ8rCSD
         TAoCpKXlJwVuy1ehv7HHaZDgME2B6uWFOobuWinNyPREsQu1sWK09kpM4afBjhJi9a69
         W6Lg==
X-Gm-Message-State: AOAM530QlBOh7hIVnz13FFrlB93rkVkHx3viDaJhS/RMQ4/z+4jOYv3Z
        2Ik8Off0aHP/Q9jzFV3joD+iLhs9JobdCw==
X-Google-Smtp-Source: ABdhPJyd1KBWga/2rIMGTI8Km1mQJ7+BHMaeP0/md8EkzMqn/Y++X67W/MYGPlS+BXsySqTK1B/m2Q==
X-Received: by 2002:a2e:a90a:: with SMTP id j10mr132304ljq.271.1637620655920;
        Mon, 22 Nov 2021 14:37:35 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id n7sm1091689lft.309.2021.11.22.14.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:37:34 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 1/2 v3] dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
Date:   Mon, 22 Nov 2021 23:35:29 +0100
Message-Id: <20211122223530.3346264-1-linus.walleij@linaro.org>
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
ChangeLog v2->v3:
- Add address-cells and size-cells to the NPE node so we
  can number the instance with reg = <>;
- Add a patternProperties for the HSS nodes to match and
  reference the HSS schema from there.
- Found one more queue that was passed using platform data:
  intel,queue-chl-txready. Add binding for this and add it
  to the example.
- Resend along with the driver conversion.
ChangeLog v1->v2:
- Add intel vendor prefix on custom queue handle bindings.
- Make the pkt-tx and pkt-rxfree into arrays of handles.

Currently only adding these bindings so we can describe the
hardware in device trees.
---
 ...ntel,ixp4xx-network-processing-engine.yaml |  35 ++++++
 .../bindings/net/intel,ixp4xx-hss.yaml        | 100 ++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml

diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
index c435c9f369a4..9a785bbaafb7 100644
--- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
+++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
@@ -37,6 +37,20 @@ properties:
       should be named with the instance number of the NPE engine used for
       the crypto engine.
 
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  hss@[0-9]+$:
+    $ref: /schemas/net/intel,ixp4xx-hss.yaml#
+    type: object
+    description: Optional node for the High Speed Serial link (HSS), the
+      node should be named with the instance number of the NPE engine
+      used for the HSS.
+
 required:
   - compatible
   - reg
@@ -45,9 +59,30 @@ additionalProperties: false
 
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
+             intel,queue-chl-rxtrig = <&qmgr 12>;
+             intel,queue-chl-txready = <&qmgr 34>;
+             intel,queue-pkt-rx = <&qmgr 13>;
+             intel,queue-pkt-tx = <&qmgr 14>, <&qmgr 15>, <&qmgr 16>, <&qmgr 17>;
+             intel,queue-pkt-rxfree = <&qmgr 18>, <&qmgr 19>, <&qmgr 20>, <&qmgr 21>;
+             intel,queue-pkt-txdone = <&qmgr 22>;
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
index 000000000000..4dcd53c3e0b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
@@ -0,0 +1,100 @@
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
+  intel,queue-chl-rxtrig:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the RX trigger queue on the NPE
+
+  intel,queue-chl-txready:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the TX ready queue on the NPE
+
+  intel,queue-pkt-rx:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the packet RX queue on the NPE
+
+  intel,queue-pkt-tx:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 4
+    description: phandle to the packet TX0, TX1, TX2 and TX3 queues on the NPE
+
+  intel,queue-pkt-rxfree:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 4
+    description: phandle to the packet RXFREE0, RXFREE1, RXFREE2 and
+      RXFREE3 queues on the NPE
+
+  intel,queue-pkt-txdone:
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
+  - intel,queue-chl-rxtrig
+  - intel,queue-chl-txready
+  - intel,queue-pkt-rx
+  - intel,queue-pkt-tx
+  - intel,queue-pkt-rxfree
+  - intel,queue-pkt-txdone
+  - cts-gpios
+  - rts-gpios
+  - dcd-gpios
+  - dtr-gpios
+  - clk-internal-gpios
+
+additionalProperties: false
-- 
2.31.1

