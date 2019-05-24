Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E881D29C0F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390967AbfEXQVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:21:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46046 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390308AbfEXQVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:21:03 -0400
Received: by mail-lf1-f67.google.com with SMTP id n22so7561242lfe.12
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CAbrTVrDd+vquw7c4UOJK7pyKOUo+ZWe2OOzzUZ1h+M=;
        b=jKHxlc1G0LUY1Zxsau5zBjmYumkEqZpUDKPeKmrfDlfbyK4pY1ZLdr3f/jHIIvJJxW
         P1WUYhGmq+YaBWXbFOoGpwK1rDvhOcxQ0JZD8ISWhl0gYOpSjkrBVStaNgj7GfYQm2z7
         NILG1Gg2kuQgzu41xJbHuJ1ADG1RAhsyqYNiJoa6YNmJ5q7SVQ4KhczK4cTHILv8U+Ih
         N13AGZhL9L4rlgHckHag7JCjgnbkUPuIU88pTsJaDUUUBPYvZKbynWOvPgDgD12xU3Lj
         LlI6JZuiK1FLBU7FkMpl1HworzXTzzqLqOvDc8rLWlA3P696jpy+xXOy3o3TZzie7L0G
         60PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CAbrTVrDd+vquw7c4UOJK7pyKOUo+ZWe2OOzzUZ1h+M=;
        b=sXJqA5tRMUNgLZc6VZJahnrLUbj8kwskbvKyk6lQ2asfkBxh/S5U49mFH/OXF1RiQX
         6igwIqvWBnuJrr7cPRsTMEEPIdxQ3OofkenwsxFJwEvON9qzEQ6+JAjIk4MOFrwiADMb
         MUQ6GZgccJ/R/I7xmMFM+eLfv/T4i1lkAkPdBEsPvVk1z5Bq8/BdvAzcr6yOJZjHsUHF
         3rJtlaaWUTBuwobHWB086aRKoVLxPGS8vQnnK/sBKKdzcOs4B6fkQM6qK2llg7/SqkxM
         wmL+W9xGyJUkA1BIDQlalOxWT/tryvIboR0OfkhFUQ93Bp4gBLpIuKD3av+y+lzs/M69
         jrOw==
X-Gm-Message-State: APjAAAWgIH8XFZm4wBSwpUkMY2PtXCj9W7IAa2PBYWW+5eSVnJKhZkT1
        T6GMB8bIqPoYGjV091iC2WWLVliF2Kk=
X-Google-Smtp-Source: APXvYqys3iTt/2thnzFGgd97nOy6riZ/LPK7Jdn3XJi/k6rf/8FvRWndTyHm37c1A4X8iDNSkMvZZQ==
X-Received: by 2002:ac2:5546:: with SMTP id l6mr20486653lfk.50.1558714861395;
        Fri, 24 May 2019 09:21:01 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-d2cd225c.014-348-6c756e10.bbcust.telenor.se. [92.34.205.210])
        by smtp.gmail.com with ESMTPSA id y4sm618075lje.24.2019.05.24.09.21.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 09:21:00 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
Date:   Fri, 24 May 2019 18:20:22 +0200
Message-Id: <20190524162023.9115-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162023.9115-1-linus.walleij@linaro.org>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
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

