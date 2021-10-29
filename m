Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D854403D6
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJ2ULC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhJ2ULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 16:11:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82032C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d3so18259861wrh.8
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 13:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=QWMjLlQXjdF9YNQ+wHvwkDat+UrWvI63/uGwLg2BuchGhz/FB+OPlmQqNxeDtT2klu
         7TTycmk1i+tYHGpB1R8rYUH2ObbPXIaju52WvpPO14izXzGmTOXxsnxzoLg+p1D75pcJ
         tndUI5PNO+M3n4ttCLPqkiOs1sCsAdqTOVyRZ4qgn12FDvCU/mvnch7sxk3jxakCD7PV
         A/sz0VORH5GtUKENthZqGyiudf6PFF0GTSlnTSgsFbP8R3fe9TDgqhSXMEySvrl54uTn
         wVkIgZdmHGSWR/w0tYml+VGGA/uU2cAnaoqnSWYyzkZxNjLIWpAJzPnR2cwjiroWXxmv
         P9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oXD373T9aSkiJb8JUH3unNEp2ZqiLUDsZE8U/4qlrOo=;
        b=4o7b0sFvUYgDShVpiIzqhgdkYgczHiNPUCb5dpenkqDdJmJkfTEc8d3OFljAiQXWGj
         J8Gkj5q5zER5S8BYjOdJI6sFYkw4TV1Sr3jGWpRYQ33BfWLdBuvtb3hUeXJfCzoX1hGq
         aPyH+LGmbXFtr668AjuEUAw7jTIi0l+SgqUcawGAfsWULp+dUbL9mCQKru6UHpPOr/kB
         B7tsRXxWJO8LBCu8sTutkPJltLCFvLrVuppebBsQqdUW4oyIbtd/gvUmZ/OLVMuFDv3K
         KFvjQVH8X0DE4sdQCTmoM+dGKqdNdcHqF/Xlt0SpM/6TQBZWfFQSKd/zGbd9t4+3vuyC
         EW+A==
X-Gm-Message-State: AOAM530YdLz9F5fhTHPiBOnMvY0fK7yeJvynNsyUoCxnJuxW6RiEdPOQ
        PobdgUql9lzQgjSXXm9gMYY9zA==
X-Google-Smtp-Source: ABdhPJyXEcVUewxEvUrEDt/8qSOuHbXRT8r1+rt2D+7L3n7bSMHuIKCfgzvXb0rCtkPm6BJXpP92AQ==
X-Received: by 2002:adf:e984:: with SMTP id h4mr13269484wrm.149.1635538111160;
        Fri, 29 Oct 2021 13:08:31 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id v3sm6818324wrg.23.2021.10.29.13.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 13:08:30 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 2/3] dt-bindings: net: Add tsnep Ethernet controller
Date:   Fri, 29 Oct 2021 22:07:41 +0200
Message-Id: <20211029200742.19605-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211029200742.19605-1-gerhard@engleder-embedded.com>
References: <20211029200742.19605-1-gerhard@engleder-embedded.com>
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

