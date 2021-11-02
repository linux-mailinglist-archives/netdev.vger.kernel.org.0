Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E50443752
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhKBUcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhKBUcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 16:32:06 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69759C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 13:29:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c4so337060wrd.9
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 13:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=m4EuB6oG3I/xvCepl40ylD5/1r8jl6oqUW7PGR3FjaIbwWS5GxeS8KKHfW8cOXhC9I
         SdFA/lDCrd/gKkSc+KR3zPxBW0s30v8sPC1whyl9LXdNGU7J/qE0Zf0FSavryBBrmkvb
         2H+hRQhVATADsa4XoNilF3KL//QVqgx4asdAc7PH6So9TgeeeT50GEE1hZjK0fmf7KYg
         cQNRVf79CMuvgS9bT829tuGqnsu9jsfXSX+x+8X3NRuK17CK2t+PqNHSpicvRg9lDq0r
         NUKWJxAO5r+NZfPTRpIrLERdPFwFGai4N74xr9IFIhy9DiFcmRInGmAC3WhHGIr4Ciiy
         cVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=i64FBOGAu27QiYcrzLXZyIIjb35/q6avE3XCiug5bOSLSXMpDIQDdg75Bs7pWgNZYs
         G2116PtB4s78F0CPSLsx9ncmQj90zs8EuhBsgtl4vIpYueozENbAmPxfAhNT4oKa1LGr
         QanfDVok8shnCHpZ02tSxEXbhZeuFrte7lhjDLKkHC+50+N6VzM6YCY4uqRZDS7xoEGx
         c156S80VFeB1f9EKWdp6SAz//APuTDlR/uYPB4hvvLeRFLthmvGBX+jQPniB6+VNDAqR
         5ITTES36YOcBCr8OSOIqZ2c+HumvwotlsAb55Jg++L8iFP7ECg/WbYxL7qOk6ANAgXL9
         uBAQ==
X-Gm-Message-State: AOAM533j5HuObDQvaaA47PmegrIK5xcL3ubZj4Eh0AN62w7qoE0UksiA
        O7lamv6RF4pPqULb0N16J7sjZw==
X-Google-Smtp-Source: ABdhPJxp6An5WIh4Q2xyfLD4z8P+2baF3YpebJcZe61qMp9mOMQxAq12JQwgzWZ6vdSv3mu9Gvp/iw==
X-Received: by 2002:a5d:5986:: with SMTP id n6mr29816400wri.297.1635884969102;
        Tue, 02 Nov 2021 13:29:29 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id 6sm31914wma.48.2021.11.02.13.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 13:29:28 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v4 2/3] dt-bindings: net: Add tsnep Ethernet controller
Date:   Tue,  2 Nov 2021 21:28:46 +0100
Message-Id: <20211102202847.6380-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211102202847.6380-1-gerhard@engleder-embedded.com>
References: <20211102202847.6380-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC is a FPGA based network device for
real-time communication.

It is integrated as normal Ethernet controller with
ethernet-controller.yaml and mdio.yaml.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/engleder,tsnep.yaml          | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
new file mode 100644
index 000000000000..d0e1476e15b5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -0,0 +1,79 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/engleder,tsnep.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TSN endpoint Ethernet MAC binding
+
+maintainers:
+  - Gerhard Engleder <gerhard@engleder-embedded.com>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: engleder,tsnep
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+  nvmem-cells: true
+
+  nvmem-cells-names: true
+
+  phy-connection-type:
+    enum:
+      - mii
+      - gmii
+      - rgmii
+      - rgmii-id
+
+  phy-mode: true
+
+  phy-handle: true
+
+  mdio:
+    type: object
+    $ref: "mdio.yaml#"
+    description: optional node for embedded MDIO controller
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
+    axi {
+        #address-cells = <2>;
+        #size-cells = <2>;
+        tnsep0: ethernet@a0000000 {
+            compatible = "engleder,tsnep";
+            reg = <0x0 0xa0000000 0x0 0x10000>;
+            interrupts = <0 89 1>;
+            interrupt-parent = <&gic>;
+            local-mac-address = [00 00 00 00 00 00];
+            phy-mode = "rgmii";
+            phy-handle = <&phy0>;
+            mdio {
+                #address-cells = <1>;
+                #size-cells = <0>;
+                suppress-preamble;
+                phy0: ethernet-phy@1 {
+                    reg = <1>;
+                    rxc-skew-ps = <1080>;
+                };
+            };
+        };
+    };
-- 
2.20.1

