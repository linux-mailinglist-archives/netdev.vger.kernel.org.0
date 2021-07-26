Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FB53D67A6
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGZTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:06:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0297EC061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:33 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c16so2578318wrp.13
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 12:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILATnZqRiQY9FgPagP60p+Si5ORzJlVbPQeLM6Ax6lg=;
        b=OoNb/0rNSjn+ZGLef7e/ORsuq+Vfv38GXcvIpqJMpLAOt+3PHHf34SG2lLk/jRLKzd
         rSeQHmXJf6wied9ry7uRr8orm408g5LXU18ItLivPx3//gD88U8tVl9D3JiNRm7xWd3e
         q3i6d+EN19vD+XSJEtPvPollISMjKJxHbCU1b549ivnO93Mx2eUCzn4Bl9hmRKEZHgFv
         7XOeOfDi/AjzMYGeLiYv+IHs8AODsBjHvDKN1BIXehmtuWNEUnnF2TzFjr1alvOCIEL8
         gBBoBHVXO/4gCjlv+ms/PSQoBOfhLOdFsiNl6KC0quJ6HDFOhZgaU7ys2FIBfkhDbr+H
         GvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILATnZqRiQY9FgPagP60p+Si5ORzJlVbPQeLM6Ax6lg=;
        b=Fca6fmtdf2GmAqeuJLKqxX4MmhBsm3oeHxe+q7mgXaLw9nLyAJ9RGudKY6nn/vCtnD
         IafyHvahMsQvPr8Qx++ozu33ppm9yZItoC1ed/mpTWyfMusNulV8VJMT76bq7Wy1fsMf
         tjLrzJetxo68lsO+1ktdgIcVZHMdr6R66xy/YflDchHjg3pDZvio1KUF/71chn9jDEj7
         tKkiCzTGjVe0+12QJg7XtxgAdVFfMICqjWH5vEVTWqw0tr/cddLRhfnRkTurwWKyED0K
         UOP+Uj8Ax/nhnVTjM6fY4jKcqWZU8RNOkuj8i5ClNybCJtYTmmxJ5i1v2CVsGzAseVZ6
         gTWQ==
X-Gm-Message-State: AOAM531hiWj9orzF5Gh/B6dbfpm0tdjIBX/ksMYcETC/aIdj4Wd0YZhZ
        kx4AfHC17OPfq3nrQ/onbRJO3Q==
X-Google-Smtp-Source: ABdhPJwI6OEvQvCCFaNr9SXq75cDadkBkFE80tcs9OmqxInS0S694912t298vdjU4TUtL8xPQNyPRA==
X-Received: by 2002:adf:d225:: with SMTP id k5mr10956276wrh.10.1627328791657;
        Mon, 26 Jul 2021 12:46:31 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2f5ziwnqeg6t9oqqip-pd01.res.v6.highway.a1.net. [2001:871:23d:d66a:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id r4sm741528wre.84.2021.07.26.12.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 12:46:31 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 2/5] dt-bindings: net: Add tsnep Ethernet controller
Date:   Mon, 26 Jul 2021 21:46:00 +0200
Message-Id: <20210726194603.14671-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210726194603.14671-1-gerhard@engleder-embedded.com>
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC is a FPGA based network device for
real-time communication.

It is integrated as normal Ethernet controller with
ethernet-controller.yaml and ethernet-phy.yaml.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 .../bindings/net/engleder,tsnep.yaml          | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml

diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
new file mode 100644
index 000000000000..ef2ca45d36a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
@@ -0,0 +1,77 @@
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
+    oneOf:
+      - enum:
+        - engleder,tsnep
+
+  reg: true
+  interrupts: true
+
+  local-mac-address: true
+  mac-address: true
+  nvmem-cells: true
+  nvmem-cells-names: true
+
+  phy-connection-type: true
+  phy-mode: true
+
+  phy-handle: true
+
+  '#address-cells':
+    description: Number of address cells for the MDIO bus.
+    const: 1
+
+  '#size-cells':
+    description: Number of size cells on the MDIO bus.
+    const: 0
+
+patternProperties:
+  "^ethernet-phy@[0-9a-f]$":
+    type: object
+    $ref: ethernet-phy.yaml#
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - phy-mode
+  - phy-handle
+  - '#address-cells'
+  - '#size-cells'
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
+            #address-cells = <1>;
+            #size-cells = <0>;
+            phy0: ethernet-phy@1 {
+                reg = <1>;
+            };
+        };
+    };
-- 
2.20.1

