Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A9E33165E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhCHSlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhCHSlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 13:41:06 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B08EC06174A;
        Mon,  8 Mar 2021 10:41:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j2so12537177wrx.9;
        Mon, 08 Mar 2021 10:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Bd7FSKc4QEiWZ8cjfgbpQ3k9JXqnCheOmPT4Gp/P7p4=;
        b=SaOhxnqe6K7xUtpr4rX645rAcbYdBVuE3prgyuL/5PcP55j1FCtFJOwPBrsEJTcyTG
         jLH/05i2cVa82ULtrKGQUvOu8xzUwwsL/wQ07SAgIjBrk/ZZ0kJoidIUVLF2KRaabfok
         jRVgiljriO7fzpOi6qW5lC1fEUDonLq/9yiDFsqkP0svJPHUc69l2rWLD7M70Ux5vVLl
         s+RUO4YUjsn84Cn8m/uKq6VhSjzR4kTFXxGsspnT2bKG0BkEq9l3KoVdZzaigPkVpdHX
         RGjKvVDvQL6aabuq9cqEiyJXdeYU+dtZh7D0NLenV1s18qTS4+nn+vh+AhEExcUIO7/p
         Agjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bd7FSKc4QEiWZ8cjfgbpQ3k9JXqnCheOmPT4Gp/P7p4=;
        b=r7KvwYenCwXh1wmd3HUQQIN960tp9jplI0Q72K6KgfBoOf9uFC54AKSH3igJyMfAYa
         KI31Nx01s1iAcEe60+KwzQVWU5J3exDQGeorsMGJ6/uVL1ukPiIwC6kT1hxkqgEvVNI7
         /Xcy5kfgxAImdYBCdLdn34bJIp8N2SLeRan8GLLRvKGu3XkG3JENTpeUWb60f/WucQxM
         mGfkY8Kf+t2fTRcEcW5pVMq+2SMZzckE6qCmDLMo9p67DWgwOe4Rn4hy79dm327lACkP
         mayhFB7KmCyvILIhg4PzQjz4h4PgLGUlUGnosWQ1et9Opu2L0yQVl4wEGxdOYmeB+1Jr
         661g==
X-Gm-Message-State: AOAM531xhZe6UVr5RFdH+mcMCh1L7BaU0PnVbvSBu+ydj1Dxz1uXiLev
        dnGG65WTWF1EAweMUQ9DFvA=
X-Google-Smtp-Source: ABdhPJyh/Rh1NwquvTh4038sAgUr6C9/zJ8//YColLGwVjlf6lVSKJAYAJ/AokgwRqBZdH20ht+1cw==
X-Received: by 2002:a05:6000:18f:: with SMTP id p15mr24414191wrx.23.1615228864883;
        Mon, 08 Mar 2021 10:41:04 -0800 (PST)
Received: from skynet.lan (224.red-2-138-103.dynamicip.rima-tde.net. [2.138.103.224])
        by smtp.gmail.com with ESMTPSA id d29sm20146067wra.51.2021.03.08.10.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 10:41:04 -0800 (PST)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: net: Add bcm6368-mdio-mux bindings
Date:   Mon,  8 Mar 2021 19:41:01 +0100
Message-Id: <20210308184102.3921-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210308184102.3921-1-noltari@gmail.com>
References: <20210308184102.3921-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentations for bcm6368 mdio mux driver.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 .../bindings/net/brcm,bcm6368-mdio-mux.yaml   | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
new file mode 100644
index 000000000000..d3481d1c59ae
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm6368-mdio-mux.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM6368 MDIO bus multiplexer
+
+maintainers:
+  - Álvaro Fernández Rojas <noltari@gmail.com>
+
+description:
+  This MDIO bus multiplexer defines buses that could be internal as well as
+  external to SoCs. When child bus is selected, one needs to select these two
+  properties as well to generate desired MDIO transaction on appropriate bus.
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    const: brcm,bcm6368-mdio-mux
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+patternProperties:
+  '^mdio@[0-1]$':
+    type: object
+    properties:
+      reg:
+        maxItems: 1
+
+      "#address-cells":
+        const: 1
+
+      "#size-cells":
+        const: 0
+
+    required:
+      - reg
+      - "#address-cells"
+      - "#size-cells"
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio0: mdio@10e000b0 {
+      #address-cells = <1>;
+      #size-cells = <0>;
+      compatible = "brcm,bcm6368-mdio-mux";
+      reg = <0x10e000b0 0x6>;
+
+      mdio_int: mdio@0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <0>;
+      };
+
+      mdio_ext: mdio@1 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        reg = <1>;
+      };
+    };
-- 
2.20.1

