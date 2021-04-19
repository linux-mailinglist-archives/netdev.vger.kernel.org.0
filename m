Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD8C364DDA
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhDSWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDSWwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:52:17 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C69C06138A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:46 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h36so4361846lfv.7
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRmZK9+uf+fZtxPOtr/Jm881SXcXvuSAx594PbZFhW4=;
        b=Py09nIfFDrvcZu9qx8JKpdaEpfY1vFnQg+G3M2RQycLPJPbDnP4LM9lowezTQk2PT6
         qNy8/hxg+5uIWAfjPQgomI3VrFcAKRNtw4jwZGhnRDTydLlwmqnshMvSCJqIcdckfqtJ
         9dhiT+OEoHerlixJq9ZRSe9jB+e955l0yii6LgKxdNGLIhRqlJspDr0rgM+ihBYvBXSG
         Ghww2BbogHZ20OcgyKY7vTskWGe4wB9Y3UHGk8DxC6F11/dxYiMd6OZMriqDGLq22awd
         EM5nql5qYE/XF/TJoSB72YbJUMryuKvWh0d1jhZSja6RcFYModilAo7ow60Comklq5ii
         kI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hRmZK9+uf+fZtxPOtr/Jm881SXcXvuSAx594PbZFhW4=;
        b=m1KHkx0HCmL2dwM5FiyQnR7RdU8LuaeFbAprmk6kiilONofU+XUqadnZbrukq9WLCC
         fNpEekmiTEpS6S8dML5y+65SgXM0x70i3RdegSTn5nfPLRiP3YkCZGhrA79ey9gDT7aj
         RFiFZb2pPPOCoUYDFAj5c7flabfTagpimpLKBmiOPw+sqThthAH+uO12DlfiMd6mGvsS
         IiAXEVxxEXdrT8VESotnKhzo+mi91lpPga41kG/CvuwqoiNpQrSdfb3gLfyXqERjrY4d
         RAuUjttQ2pi1lq3yHzAYhlTEvhiewuTsBVwKJ0vhaZCpxqN/c4YfEB2dafNPG8JSFV0U
         kzjw==
X-Gm-Message-State: AOAM531JqceC3A5Ec9fCIRuh/gbb606kyH8sjPTg+YIf/66t9wPbKpGw
        hnPiXJ4FG6g0xNEqbAw8PSYqO4N/YH3+0g==
X-Google-Smtp-Source: ABdhPJzIyB3PJLWF9guTTw8yfc8EyNCajD14vOz7iwvnc6gAxxFoE1pWxryPsUdTl1pVH+5LAofX3Q==
X-Received: by 2002:ac2:48ac:: with SMTP id u12mr13390767lfg.604.1618872705352;
        Mon, 19 Apr 2021 15:51:45 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p5sm1950179lfg.183.2021.04.19.15.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 15:51:45 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: [PATCH 1/3] net: ethernet: ixp4xx: Add DT bindings
Date:   Tue, 20 Apr 2021 00:51:31 +0200
Message-Id: <20210419225133.2005360-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP4xx ethernet
controller with optional MDIO bridge.

Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Add schema for the (optional) embedded MDIO bus inside
  the ethernet controller in an "mdio" node instead of just
  letting the code randomly populate and present it to
  the operating system.
- Reference the standard schemas for ethernet controller and
  MDIO buses.
- Add intel,npe to indentify the NPE unit used with each
  ethernet adapter.
---
 .../bindings/net/intel,ixp4xx-ethernet.yaml   | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
new file mode 100644
index 000000000000..55ef6ff7d171
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel,ixp4xx-ethernet.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP4xx ethernet
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
+  Processing Engine) and the IXP4xx Queue Mangager to process
+  the ethernet frames. It can optionally contain an MDIO bus to
+  talk to PHYs.
+
+properties:
+  compatible:
+    const: intel,ixp4xx-ethernet
+
+  reg:
+    maxItems: 1
+    description: Ethernet MMIO address range
+
+  queue-rx:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the RX queue on the NPE
+
+  queue-txready:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the TX READY queue on the NPE
+
+  phy-handle: true
+
+  intel,npe:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2, 3]
+    description: which NPE (Network Processing Engine) this ethernet
+      instance is using
+
+  mdio:
+    type: object
+    $ref: "mdio.yaml#"
+    description: optional node for embedded MDIO controller
+
+required:
+  - compatible
+  - reg
+  - queue-rx
+  - queue-txready
+
+additionalProperties: false
+
+examples:
+  - |
+    ethernet@c8009000 {
+      compatible = "intel,ixp4xx-ethernet";
+      reg = <0xc8009000 0x1000>;
+      status = "disabled";
+      queue-rx = <&qmgr 3>;
+      queue-txready = <&qmgr 20>;
+      intel,npe = <1>;
+      phy-handle = <&phy1>;
+
+      mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy1: phy@1 {
+          #phy-cells = <0>;
+          reg = <1>;
+        };
+      };
+    };
-- 
2.29.2

