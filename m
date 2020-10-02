Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6778281BAB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388462AbgJBTWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:22:23 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40084 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388459AbgJBTWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:22:19 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201002192216euoutp0258e6ea4304c4df6f5c1215a6bc61913c~6Qzq1_y5v0516305163euoutp02Z
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201002192216euoutp0258e6ea4304c4df6f5c1215a6bc61913c~6Qzq1_y5v0516305163euoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601666536;
        bh=fKNIzhnGzJdvS5RU/Nj7qeDTjzN/JzjzeSMvxgS0jug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn59qbxHxpubVW1Y6ZL2Pn5f1UQZvno4J1csWo4tvMlcCUN2owM2GWM31v6xIpZoM
         FAtl0i9D3X0bQVjFXtOy5rnxGS2SKTaiOSPhuq2E/HxcaL2JfMopvAgdJN6A5sx57D
         uveLPaq9t0JAL9PNP048YTcR8+MvQpBspfWOEVE8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20201002192216eucas1p2fedd19b6a8ab63f62dac20b9914efae1~6QzqNwkBs1913419134eucas1p2n;
        Fri,  2 Oct 2020 19:22:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 5D.37.06318.8ED777F5; Fri,  2
        Oct 2020 20:22:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea~6Qzp5Usdx1922419224eucas1p2q;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201002192215eusmtrp2b96bec70f05e6c69c5f07b79106819e8~6Qzp4n3td3070930709eusmtrp26;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
X-AuditID: cbfec7f5-371ff700000018ae-22-5f777de8aef7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 95.3F.06314.7ED777F5; Fri,  2
        Oct 2020 20:22:15 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201002192215eusmtip15019de3bb672fd09c81028ca4f3c2987~6QzpqllvK3257332573eusmtip18;
        Fri,  2 Oct 2020 19:22:15 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 1/4] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Fri,  2 Oct 2020 21:22:07 +0200
Message-Id: <20201002192210.19967-2-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002192210.19967-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0zMcRjHfe77s1unr6vp2TG2E5v8KIo+lsnPORub/2xMufTd1fqh3ZVk
        syikWzryo5wo1e1OpFSOisx1iuGOlX5RWG04XeFixHDfvhr/vd+f5/U87+fZPiwh76EUbEJK
        Gq9NUScpaSlpbfvuWPTuQEZMaPU4g539NgJfL66hcInzMIlL7Q4Kd7lfUtgw+IHATmctg59a
        Cyjca7MgXDfYReGOphIaFztbJNh25g7C1fZ+BreVTcdH7tiZ1Zyqo+sZoWq43CtRNRr7GVVd
        VR6tqq/MUjXe8khUBQ1VSOWpm7WV3S5dGccnJezltSGrdknjmwsjUu/DvksDV+iDqMFfj3xY
        4MLBVe8m9EjKyjkLghbjIUo0YwiGersZ0Xi8lVwLmmzpH2n/S5kRfMwRCoJ5i6Bz7AslUDS3
        BgymBxNUAGclYLi+nBQMwbUgaBw4TQiUP7cdzCN3GUGT3FxwjRZPZMi4SHjX3SkR82ZDrvkm
        LWgfbiU0ZdcyIjMNHp4bIgXtxwXD1ezuCU14+Zwb5ydOAi6PhV7Tc1octB7GCyyEqP3B1d7A
        iHom/G4s9YaxXp0FpwqXi735CKwl30iRiYSXjnFaYAhuPtQ0hYj4GjhX7SfKqdDjniZuMBUK
        rUWE+CyDY0fl4owguGa4/XeeAo67LOgEUhr/u8X43/7Gf1FliKhCgXy6LlnD68JS+IzFOnWy
        Lj1Fs3j3nuQ65P1vj361f7mFWn7G2hDHIqWvjA3NiJFT6r26zGQbApZQBsjWPnkULZfFqTP3
        89o9Mdr0JF5nQzNYUhkoCyt/v1POadRpfCLPp/LayaqE9VEcRFkmPZXmLhrqVHyq8Phd6HRs
        fNq6Sr/D93xE+IK7UV+j3YcdsXFB9RX0ifYf80KHO5b2KFJR8+Nm1zbTMmu0ue1s6IYq8nOG
        LNFT9CLq3rpyTf7PzSuujBuKYk9a9T19q/sqR3NaY6XmKTjox+uFl1+N2Oe8sV80bFo3W/ok
        V1O7RUnq4tVLggmtTv0Hy65SE2sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t/xu7rPa8vjDS60GFicv3uI2WLjjPWs
        FnPOt7BYzD9yjtXi2ts7rBb9j18zW5w/v4Hd4sK2PlaLm4dWMFpsenyN1eLyrjlsFjPO72Oy
        ODR1L6PF2iN32S2OLRCzaN17hN1BwOPytYvMHltW3mTy2DnrLrvHplWdbB6bl9R77Nzxmcmj
        b8sqRo/Pm+QCOKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLL
        Uov07RL0MnZPMi84KlGx8N5qtgbGLcJdjJwcEgImEnffHWftYuTiEBJYyijx9PZCti5GDqCE
        lMTKuekQNcISf651sUHUPGWUeHT6FTNIgk3AUaJ/6QmwZhGBQ8wS356cYQFxmAX2MUrsP7qY
        HaRKWCBC4u+p/YwgNouAqsSr9zPAbF4Ba4kX168wQayQl2hfvp0NxOYUsJHY1bQBrFcIqOby
        zaNQ9YISJ2c+YQG5jllAXWL9PCGQML+AlsSapussIDYz0JjmrbOZJzAKzULSMQuhYxaSqgWM
        zKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECo3nbsZ+bdzBe2hh8iFGAg1GJhzfBqDxeiDWx
        rLgy9xCjBAezkgiv09nTcUK8KYmVValF+fFFpTmpxYcYTYHenMgsJZqcD0w0eSXxhqaG5haW
        hubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGMW/bFVn+DF1xpX5J69FlV1OkOaf
        XXJo2ZJm/ZCwIr94ibMLTq097X9Pvsbtn32qagPvvd03bVLSTwkwHvfk3jgt6FTVn8Ufelwn
        9GexJ6ZUZB1TyIzYPF+na/3OJn51nU3PhA+dnKFzyshosY93k2IBq1pky+/VDAYtd6ddnLa7
        Zs/enpUuSkosxRmJhlrMRcWJAI7NKEX8AgAA
X-CMS-MailID: 20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea
References: <20201002192210.19967-1-l.stelmach@samsung.com>
        <CGME20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 .../bindings/net/asix,ax88796c-spi.yaml       | 76 +++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
 2 files changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
new file mode 100644
index 000000000000..50a488d59dbf
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88796c-spi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ASIX AX88796C SPI Ethernet Adapter
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+description: |
+  ASIX AX88796C is an Ethernet controller with a built in PHY. This
+  describes SPI mode of the chip.
+
+  The node for this driver must be a child node of a SPI controller, hence
+  all mandatory properties described in ../spi/spi-bus.txt must be specified.
+
+maintainers:
+  - Łukasz Stelmach <l.stelmach@samsung.com>
+
+properties:
+  compatible:
+    const: asix,ax99796c-spi
+
+  reg:
+    description:
+      SPI device address.
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 40000000
+
+  interrupts:
+    description:
+     GPIO interrupt to which the chip is connected.
+    maxItems: 1
+
+  interrupt-parrent:
+    description:
+      A phandle of an interrupt controller.
+    maxItems: 1
+
+  reset-gpios:
+    description:
+      A GPIO line handling reset of the chip. As the line is active low,
+      it should be marked GPIO_ACTIVE_LOW.
+    maxItems: 1
+
+  local-mac-address: true
+
+  mac-address: true
+
+required:
+  - compatible
+  - reg
+  - spi-max-frequency
+  - interrupts
+  - interrupt-parrent
+  - reset-gpios
+
+examples:
+  # Artik5 eval board
+  - |
+    ax88796c@0 {
+        compatible = "asix,ax88796c";
+        local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
+        interrupt-parent = <&gpx2>;
+        interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+        spi-max-frequency = <40000000>;
+        reg = <0x0>;
+        reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+        controller-data {
+            samsung,spi-feedback-delay = <2>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2baee2c817c1..5ce5c4a43735 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -117,6 +117,8 @@ patternProperties:
     description: Asahi Kasei Corp.
   "^asc,.*":
     description: All Sensors Corporation
+  "^asix,.*":
+    description: ASIX Electronics Corporation
   "^aspeed,.*":
     description: ASPEED Technology Inc.
   "^asus,.*":
-- 
2.26.2

