Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F1F376694
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhEGOCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:02:40 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25768 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbhEGOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:02:16 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210507140115euoutp02109267570b056211c0847dc666aaa370~8zaUfFaQz1987119871euoutp02n
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 14:01:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210507140115euoutp02109267570b056211c0847dc666aaa370~8zaUfFaQz1987119871euoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620396075;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxsd1cuWhqwR5wOy3zM4kgFoivTnwQLJHz+/lanV2uOIG7Q02aySASmjeoueQ3mDd
         NcOLJGlNpqYpW+LDSySiodPmadM1KperOq6ZP1CYNImByFCg3y2O3Vn61Z4/viyrp3
         hoDrqht7LC63IGccQCoFf35RvYy33BWylPfgwyuo=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210507140114eucas1p296246a65a9378a29407a8fecd389be22~8zaT7fwaE1975719757eucas1p2V;
        Fri,  7 May 2021 14:01:14 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C6.CD.09452.A2845906; Fri,  7
        May 2021 15:01:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210507140113eucas1p135a114200d194a8fa9d52987b7725fa4~8zaTeVBbc1676016760eucas1p1j;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210507140113eusmtrp16d88a8e1a5a2d0bf57d96ce0051b291f~8zaTdeq8G3079830798eusmtrp1d;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
X-AuditID: cbfec7f2-ab7ff700000024ec-fd-6095482ac8d1
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 94.49.08696.92845906; Fri,  7
        May 2021 15:01:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507140113eusmtip21f63e086457492f0b38ebb264ea5ed88~8zaTORvp02651326513eusmtip2Z;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v12 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Date:   Fri,  7 May 2021 16:01:09 +0200
Message-Id: <20210507140110.6323-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507140110.6323-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87paHlMTDC7PELE4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZV4+ZFZwXrljQ+5OpgXEKfxcj
        J4eEgIlEc/8f1i5GLg4hgRWMEtu29jFDOF8YJU43tLBAOJ8ZJd4f72OBadl5fj8ziC0ksJxR
        YvksUYii54wSJ1/8YgJJsAk4SvQvPQE2V0TgHrPE+vYHjCAOs8B9Rol7z1eDtQsLpEg83PEY
        KMHBwSKgKrF1TzZImFfASuLjl7WsENvkJdqXb2cDsTkFrCUefLrLDlEjKHFy5hOwi/gFtCTW
        NF0Hs5mB6pu3zgb7QULgMKdE48V2JohBLhLv3y1jhLCFJV4d38IOYctInJ7cwwJyg4RAvcTk
        SWYQvT3AwJjzA+pla4k7536xgdQwC2hKrN+lDxF2lPh7ayEbRCufxI23ghAn8ElM2jadGSLM
        K9HRJgRRrSKxrn8P1EApid5XKxgnMCrNQvLMLCQPzELYtYCReRWjeGppcW56arFhXmq5XnFi
        bnFpXrpecn7uJkZgwjv97/inHYxzX33UO8TIxMF4iFGCg1lJhPf0oskJQrwpiZVVqUX58UWl
        OanFhxilOViUxHlXzV4TLySQnliSmp2aWpBaBJNl4uCUamCaIF6svdVdf+kP0R0BG1VzefdO
        jtqxW2xPxuLNG2Ku79a9x9v2ZcL8zx+ZVBk/zC3Xuhp1U2D9Ob/LeZmyAlzZUbqBX2cx7Dos
        bH5xxXTJhfeTPS3ELl4LEeB1nfk2rr9+wSp9/2e8cx2Fs5X3sW/sDHe+aLIuqLnzK+fHFxO+
        zVjizGdlN6u/71jLSubXHSf/ZCiwfVi5efLFBwVT93x/WXvzUfKjumkmp1Ke2/uecGXedkCX
        reFu0rYVJ+y9vi2VUj23/xVDhWKq4dpLchZuOgbm/M5vryYdXeDSvvrr0USjX65NT77IVJ44
        nzOpUYTnYmfwC58Vk6+80b7zUS76bkbMXW7L0sVx+77Ofl48XYmlOCPRUIu5qDgRAOiuHZTn
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7qaHlMTDO49MLA4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZV4+ZFZwXrljQ+5OpgXEKfxcjJ4eEgInEzvP7mbsYuTiEBJYy
        SlztnQTkcAAlpCRWzk2HqBGW+HOtiw2i5imjRPvdu4wgCTYBR4n+pSdYQRIiAm+YJZruvWUH
        cZgF7jNK/Pr0AqxKWCBJYta9DhaQqSwCqhJb92SDhHkFrCQ+flnLCrFBXqJ9+XY2EJtTwFri
        wae77CC2EFDNxE2dTBD1ghInZz4BG8MsoC6xfp4QSJhfQEtiTdN1FhCbGWhM89bZzBMYhWYh
        6ZiF0DELSdUCRuZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgfG97djPLTsYV776qHeIkYmD
        8RCjBAezkgjv6UWTE4R4UxIrq1KL8uOLSnNSiw8xmgI9NpFZSjQ5H5hg8kriDc0MTA1NzCwN
        TC3NjJXEeU2OrIkXEkhPLEnNTk0tSC2C6WPi4JRqYJJlfnx1wzqGlXW3L7DqxCxg3jxDemvP
        qyamySpy+Q9vZD9m397WGK8+64Th7XmapXpW5RNeX6zaqmZu07rxxMxglt+1InN2CHIohL1+
        VG67jY2b+1D1ZNXjnPOvHesyO5XfnaZ47U3s1LdLDswKk5H5pMpTKJEuu30P/+Ly09VNhik3
        o629F93ofdKdstGTi2W2xt8pEx50PA4WEpHWMRUM+e/YmHVeuHgBj8qFFe5PctLiBA4u2sAk
        xh257tABy7xvhvHbZqz6/Hb7jRP/rzWG7G29zrM9/9LNldM8n79eLFXXclOfq0ou5pbz4hLb
        ILYpOR8fHq/m+Wh65IWg+Lvl6T+rPb7POKtauTe2rUaJpTgj0VCLuag4EQCermsweAMAAA==
X-CMS-MailID: 20210507140113eucas1p135a114200d194a8fa9d52987b7725fa4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210507140113eucas1p135a114200d194a8fa9d52987b7725fa4
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210507140113eucas1p135a114200d194a8fa9d52987b7725fa4
References: <20210507140110.6323-1-l.stelmach@samsung.com>
        <CGME20210507140113eucas1p135a114200d194a8fa9d52987b7725fa4@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../bindings/net/asix,ax88796c.yaml           | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
new file mode 100644
index 000000000000..699ebf452479
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
@@ -0,0 +1,73 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/asix,ax88796c.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: ASIX AX88796C SPI Ethernet Adapter
+
+maintainers:
+  - Łukasz Stelmach <l.stelmach@samsung.com>
+
+description: |
+  ASIX AX88796C is an Ethernet controller with a built in PHY. This
+  describes SPI mode of the chip.
+
+  The node for this driver must be a child node of an SPI controller,
+  hence all mandatory properties described in
+  ../spi/spi-controller.yaml must be specified.
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: asix,ax88796c
+
+  reg:
+    maxItems: 1
+
+  spi-max-frequency:
+    maximum: 40000000
+
+  interrupts:
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
+  - reset-gpios
+
+additionalProperties: false
+
+examples:
+  # Artik5 eval board
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    spi0 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet@0 {
+            compatible = "asix,ax88796c";
+            reg = <0x0>;
+            local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
+            interrupt-parent = <&gpx2>;
+            interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+            spi-max-frequency = <40000000>;
+            reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+        };
+    };
-- 
2.26.2

