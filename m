Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E4639B674
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhFDKDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:03:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54872 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhFDKDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:03:49 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210604100200euoutp0191e1df80ca79b1a46183da312112adc7~FWNbxRKWv1917119171euoutp01e
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 10:02:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210604100200euoutp0191e1df80ca79b1a46183da312112adc7~FWNbxRKWv1917119171euoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622800920;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNR9h5oXiN92cVH/l6s/FBWMEnlMCIh4CIKcqjgby1E4XhF1ABQnmY+sWTyDiWned
         fTCmfJvhXrMjYR9jZZjRwjcKsjy9XHlKG5Sif+z/efofXkOSLt+xyMxWKE7lf5YWCG
         7jYWtvjmaRYV5IOKhnM9FDnoUOWeuWUokbp+gxUc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210604100200eucas1p12509818bed569065ed63949d8eb69710~FWNbS35yV0748907489eucas1p1Z;
        Fri,  4 Jun 2021 10:02:00 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id B7.38.09439.81AF9B06; Fri,  4
        Jun 2021 11:02:00 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210604100159eucas1p121bc7a925a67e6d2e777859da012ccf2~FWNa1fEmO1855318553eucas1p1y;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210604100159eusmtrp2c3cf297a840b6be694d857c184b8e5fc~FWNa0lMzy1054110541eusmtrp2G;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-ae-60b9fa18f72d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id BA.A7.08705.71AF9B06; Fri,  4
        Jun 2021 11:01:59 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210604100159eusmtip2d8e86fe43e64b76b7c98150b77ae2df4~FWNamotsl2310823108eusmtip2X;
        Fri,  4 Jun 2021 10:01:59 +0000 (GMT)
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
Subject: [PATCH 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Fri,  4 Jun 2021 12:01:47 +0200
Message-Id: <20210604100148.17177-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604100148.17177-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87oSv3YmGEzdImJx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4orhsUlJzMstSi/TtErgyrh4zKzgvXLGg9ydTA+MU/i5G
        Dg4JAROJvotRXYxcHEICKxglNvRvZYZwvjBKNE/tYoJwPjNKdH/rYO9i5ATreLqogxEisZxR
        ounOWzaQhJDAc0aJ1ZdUQGw2AUeJ/qUnWEGKRATuMUusb38A1sEscJ9R4t7z1cwgVcIC4RIX
        rkxjAbFZBFQljm25DxbnFbCWuPq4hRlinbxE+/LtYBs4BWwk5sz+xwpRIyhxcuYTsF5+AS2J
        NU3XwWxmoPrmrbPBnpAQOMwpsXLBKSaIQS4Se2cuZ4GwhSVeHd8C9Y+MxP+d85kgoVEvMXmS
        GURvD6PEtjk/oOqtJe6c+8UGUsMsoCmxfpc+RNhR4t2epawQrXwSN94KQpzAJzFp23RmiDCv
        REebEES1isS6/j1QA6Ukel+tYJzAqDQLyTOzkDwwC2HXAkbmVYziqaXFuempxcZ5qeV6xYm5
        xaV56XrJ+bmbGIEJ7/S/4193MK549VHvECMTB+MhRgkOZiUR3j1qOxKEeFMSK6tSi/Lji0pz
        UosPMUpzsCiJ8+7auiZeSCA9sSQ1OzW1ILUIJsvEwSnVwGRWp+hi6h13pH/+dz+PmMcL+c/L
        6tglty1u7sw73SKzWXj/tf2Lni7WeT1xw522hXHzV3ovY67dmnfp8JVXF+5dPet/rir5tGuB
        NqvpgpO/55by/hfmFXh24tQ/0TWi6oLf5s2p0jLy/vZ1ZXH4kefb2eJ/bJ1++sKqzW/jNPbs
        YbT0yU+335PkPf354rtL7ef33t1jtW2KRGhKUSx36+plv3muL33Q/snf7P8dO5eqXwt1H2Qs
        u5h0dEtgf4zEfckrOlu9I7T5Nz5JS1/hq3+5Pt3eadetP/NSp1zyUuAL/LD1tdZ+N+ErIeby
        RpedL/nfvjh3/tfUqpzGy59l0p/PrnSXPX6J4f3PHafjk5l/KrEUZyQaajEXFScCAGWDTNvn
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7riv3YmGByfY2Rx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyrh4zKzgvXLGg9ydTA+MU/i5GTg4JAROJp4s6GLsYuTiEBJYy
        StzuPc/excgBlJCSWDk3HaJGWOLPtS42iJqnjBI9/ecZQRJsAo4S/UtPsIIkRATeMEs03XvL
        DuIwC9xnlPj16QVYlbBAqMTmt1fBbBYBVYljW+4zg9i8AtYSVx+3MEOskJdoX76dDcTmFLCR
        mDP7HyuILQRUc2DZT0aIekGJkzOfsIBcxyygLrF+nhBImF9AS2JN03UWEJsZaEzz1tnMExiF
        ZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucWGesWJucWleel6yfm5mxiBEb7t2M/NOxjnvfqod4iR
        iYPxEKMEB7OSCO8etR0JQrwpiZVVqUX58UWlOanFhxhNgT6byCwlmpwPTDF5JfGGZgamhiZm
        lgamlmbGSuK8W+euiRcSSE8sSc1OTS1ILYLpY+LglGpg6ip+6CDofnKFtO9OHVFm6+AXfP/e
        +CjqvN8Qnfkzd+r+xQ6T2g9pHWAMPqhe2ibM5hBdmrHz/LRdAQXy3jLNC/KYcjaZOMS3TYq7
        IhZ30W5Js+yj7u9L91rOXuRcbc0d1XdtpxubsDejMF9iInMr4+4rsvE7OtdEPrfwdnppVPSv
        qv/KysBv/q92PbRcXMsQan65Iz3ij8SHKZeYxC9v8dVea3EmoPVUcOFEj0zz/5/YwhJ6H0jm
        nZ/Hkrjr/22H60kTYpr9MpjunV1TqZstUtKx/6/a4ctNNoFWR9UfXS2WDlzyr3QNz4cNOyty
        C+ZPv/P/7oaNrc3X9gYv85Y0fLzyBNu7mDvnN2jsmq2ixFKckWioxVxUnAgARGanGXkDAAA=
X-CMS-MailID: 20210604100159eucas1p121bc7a925a67e6d2e777859da012ccf2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210604100159eucas1p121bc7a925a67e6d2e777859da012ccf2
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210604100159eucas1p121bc7a925a67e6d2e777859da012ccf2
References: <20210604100148.17177-1-l.stelmach@samsung.com>
        <CGME20210604100159eucas1p121bc7a925a67e6d2e777859da012ccf2@eucas1p1.samsung.com>
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

