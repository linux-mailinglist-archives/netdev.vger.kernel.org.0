Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1A29C15
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390896AbfEXQWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:22:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40841 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389765AbfEXQWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:22:38 -0400
Received: by mail-lj1-f193.google.com with SMTP id q62so9172559ljq.7
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CAbrTVrDd+vquw7c4UOJK7pyKOUo+ZWe2OOzzUZ1h+M=;
        b=RRFAbk1/fn6fqVdBDHZv41/1rP4KjDX9MQeZVdh8NwYyLAFLfy0skr1ChyqpbY+K5G
         No/o5iVpmSmFyklKX2LhnjRC4ST4qRTFE5kiFA3A8bpzt7R2qK5Kt35wVM+sTH98lsa4
         DwiOxsxS8p18KonDHsq4slei1wMNcoGQyk/8SaXCm8ib5pomXkq/2lbkLzZYGH8kmrPc
         Fc4T2tNEVlc30enZN1nHCMyhFZoS2TklS0eAQif4WGaVOBulaGFOAO7oD9ihX6P8IOtb
         pxJRm06c/fU/Iq1T8h21rgJmNxqPHfSy9Y4bsUKQm2p0ahwzsHDz/syimvD1/HEfPCxL
         AlHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CAbrTVrDd+vquw7c4UOJK7pyKOUo+ZWe2OOzzUZ1h+M=;
        b=qp6IjjWxqfAbixvbnOyNH0i7UzSYhBguOwJ6Fz1kfMGgpYLODWX5vprem1Dw0Gb7Jv
         XOeMbl7QD4vYivKVbG3UyJinp3tlVlzAc0HQg6vLAlQAEU2KNGcBXho5/vuswZq34Olx
         AQXS1I9fkve5auACW4QAjHsg4EJHCQJVlscwR2A7qV8Ij/mALN0JqE9oZ4jAG/LZjQED
         0TcSHK2FCmCr5F0RpUNrqBeD8i8zxutkgwh70etIc7lennqxlbRBkmsVPEILOVyZuAOF
         r4RL3fMDkGRtiJhfC0t2gQTSfP9nodUiXBzjOJdFRSHcqMEx/IAYJGYu2Tw9q7oFNSIE
         yAkg==
X-Gm-Message-State: APjAAAXPRXuiASeGjFtPQ5y7lTz3E5QmKuHHcv4dto3QdIIKTR1G8B9r
        XgPNJbpjVe42XbD9o7VjAT2yKlYnaBc=
X-Google-Smtp-Source: APXvYqwy5NkOc80dinOLqXFCZ8/kRPvO3QyaNJOiz2pAzMq0eUz0RXeO65cYVIHSM8BvUDQAxq3yNw==
X-Received: by 2002:a2e:2bd7:: with SMTP id r84mr21075134ljr.91.1558714956035;
        Fri, 24 May 2019 09:22:36 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id v20sm702466lfe.11.2019.05.24.09.22.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:22:34 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
Date:   Fri, 24 May 2019 18:22:29 +0200
Message-Id: <20190524162229.9185-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP4xx ethernet.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../bindings/net/intel,ixp4xx-ethernet.yaml   | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
new file mode 100644
index 000000000000..4575a7e5aa4a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel-ixp4xx-ethernet.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP4xx ethernet
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
+    oneOf:
+      - items:
+        - const: intel,ixp4xx-ethernet
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
+required:
+  - compatible
+  - reg
+  - queue-rx
+  - queue-txready
+
+examples:
+  - |
+    ethernet@c8009000 {
+        compatible = "intel,ixp4xx-ethernet";
+        reg = <0xc8009000 0x1000>;
+        status = "disabled";
+        queue-rx = <&qmgr 3>;
+        queue-txready = <&qmgr 20>;
+    };
-- 
2.20.1

