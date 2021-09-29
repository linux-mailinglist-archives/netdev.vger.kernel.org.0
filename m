Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604C341C661
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 16:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343527AbhI2OK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 10:10:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53480 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344382AbhI2OK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 10:10:56 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210929140914euoutp011c5991203e002ab241f799de2cc4c3a1~pUDr2X1DC0156001560euoutp01U
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:09:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210929140914euoutp011c5991203e002ab241f799de2cc4c3a1~pUDr2X1DC0156001560euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632924554;
        bh=Z4IBSKno7o4u2IPtq/oGi8k3geESxSGYf1l5VWz39q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJFF5JDh2gR4dwAi0l3p+Grg5YPMl/aRHfWgIu6pR+C/IKIPmP5jFXiLyBwwCQg2R
         lq46q5y7GU6d9yQjLz4Gpz75dRbkvAGOk3YXcKpqM5Tcni5RfGZ0PdjOgdhxWZDy97
         80VUqV4SuEsbSLL7/i1vW4fZuTYD/9GqzIndv7wc=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210929140913eucas1p2cbed7e470a84688dcfb7576d88cece93~pUDrcUys-1555515555eucas1p2h;
        Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 4A.CB.42068.98374516; Wed, 29
        Sep 2021 15:09:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210929140913eucas1p19ae6de17520916149879be71a33291c7~pUDq6AAux0545405454eucas1p1i;
        Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210929140913eusmtrp1d29ca32d2519ee0d7b0a0c2f2352437b~pUDq5KMgY3235032350eusmtrp1s;
        Wed, 29 Sep 2021 14:09:13 +0000 (GMT)
X-AuditID: cbfec7f4-c71ff7000002a454-ef-615473895320
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 2A.D0.20981.88374516; Wed, 29
        Sep 2021 15:09:12 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210929140912eusmtip277040d10ff0b8d90d7b154f3268ef9a9~pUDqseiwu0168801688eusmtip2F;
        Wed, 29 Sep 2021 14:09:12 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: [PATCH net-next v16 2/3] dt-bindings: net: Add bindings for
 AX88796C SPI Ethernet Adapter
Date:   Wed, 29 Sep 2021 16:08:53 +0200
Message-Id: <20210929140854.28535-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929140854.28535-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djP87qdxSGJBj+3KVqcv3uI2WLjjPWs
        FnPOt7BYzD9yjtVi0fsZrBbX3t5hteh//JrZ4vz5DewWF7b1sVrcPLSC0WLT42usFpd3zWGz
        mHF+H5PFoal7GS3WHrnLbnFsgZhF694j7Bb/9+xgdxDyuHztIrPHlpU3mTx2zrrL7rFpVSeb
        x+Yl9R47d3xm8ujbsorR4/MmuQCOKC6blNSczLLUIn27BK6M5vNP2AvOC1cc3nWXuYFxCn8X
        IyeHhICJxL89s5m6GLk4hARWMEp8XP6IFcL5wijR1fiXGcL5zCjxc8t1RpiWQ7397CC2kMBy
        Rom/uxUhip4zSvzZu4gZJMEm4CjRv/QE2CgRgXvMEp+OHWcDcZgF7jNK3Hu+GqxKWCBFYv2D
        Z0AJDg4WAVWJO1eLQExeAWuJzzdiIJbJS7Rdnw62mFPARuL93wNgNq+AoMTJmU9YQGx+AS2J
        NU3XwWxmoPrmrbPBrpYQOMwpcWL3LqirXSS6Jm+BsoUlXh3fwg5hy0icntzDArJXQqBeYvIk
        M4jeHkaJbXN+sEDUWEvcOfcL7ExmAU2J9bv0IcKOEi+W/4Vq5ZO48VYQ4gQ+iUnbpjNDhHkl
        OtqEIKpVJNb174EaKCXR+2oF4wRGpVlInpmF5IFZCLsWMDKvYhRPLS3OTU8tNspLLdcrTswt
        Ls1L10vOz93ECEx4p/8d/7KDcfmrj3qHGJk4GA8xSnAwK4nw/hAPThTiTUmsrEotyo8vKs1J
        LT7EKM3BoiTOm7RlTbyQQHpiSWp2ampBahFMlomDU6qByTu+7G1sQklAodNkkV2JE9f08Z3b
        qfdEKPdkl+AZbUf1Sg5NZos5Z74GPc59+Ebr7IveAyUbhP6teMO2MGuHVKuzhUxR0lKxukOq
        2zQ2N5h5H5uuYJpcdbS6c9b755bKzV0Panw6Pgo+P89jJJB8ye21ctuHT+zyX2ruXa0Vmz+j
        88VxiwiFRQt/i5ecE4gu2yiWKB0XzNdUt7hp+2m1iXcLIryWXHql0PhDuvdh7s99f3y/XfrV
        6hV+LlxGe3vcP6mtanGpu2oPMV1SSrphu/if5+QPcdOdPi+z89gR1Rjy0ejFc1vHlbYJC74W
        MRbfyG6/ejR96kY3g2DHlnT5pYFPp/ZIGCofNLA5f2y+EktxRqKhFnNRcSIAGfqkkecDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t/xe7odxSGJBl3/bCzO3z3EbLFxxnpW
        iznnW1gs5h85x2qx6P0MVotrb++wWvQ/fs1scf78BnaLC9v6WC1uHlrBaLHp8TVWi8u75rBZ
        zDi/j8ni0NS9jBZrj9xltzi2QMyide8Rdov/e3awOwh5XL52kdljy8qbTB47Z91l99i0qpPN
        Y/OSeo+dOz4zefRtWcXo8XmTXABHlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayV
        kamSvp1NSmpOZllqkb5dgl5G8/kn7AXnhSsO77rL3MA4hb+LkZNDQsBE4lBvP3sXIxeHkMBS
        RoknPUuZuhg5gBJSEivnpkPUCEv8udbFBlHzlFGiY/NddpAEm4CjRP/SE6wgtojAG2aJn71S
        IEXMAvcZJX59esEIkhAWSJJ4vaaHEWQoi4CqxJ2rRSAmr4C1xOcbMRDz5SXark8Hq+YUsJF4
        //cAmC0EUvK8AczmFRCUODnzCQtIK7OAusT6eUIgYX4BLYk1TddZQGxmoDHNW2czT2AUmoWk
        YxZCxywkVQsYmVcxiqSWFuem5xYb6RUn5haX5qXrJefnbmIERve2Yz+37GBc+eqj3iFGJg7G
        Q4wSHMxKIrw/xIMThXhTEiurUovy44tKc1KLDzGaAv01kVlKNDkfmF7ySuINzQxMDU3MLA1M
        Lc2MlcR5TY6siRcSSE8sSc1OTS1ILYLpY+LglGpgmrI4qCatXLx/KqPBAs1v+lzX9E80MJke
        suc67Fa787XoTJeH63TKWz4ZSG3WEVWw1jnG4xJvp7hs/TFDp9t2Ib+/vdW5zD3X/8/0jyts
        L3KaTpKpNNp+Jzs6JuZx4qajorfyGqe+YJ3y+GXz95itChOdvXrDT74t3jdj7YdYI03lmVd8
        btff456uz3tl3b6/edaisR6fdddZaL+4tHrrr0e7F/YyLz1jdyPPvOcYy3ynXa3nNLY9k9sX
        /nzStpjOuuyLc57N0L6sXut//blD4ofnq2+7LX9+03fvvcu7PD8cXNVc5x98rMFH1jDAS3TZ
        U/UbfadO7bZyKFHPF3756N6Es9oeaQvbA49JSjxT6VViKc5INNRiLipOBAD9gsPQdwMAAA==
X-CMS-MailID: 20210929140913eucas1p19ae6de17520916149879be71a33291c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210929140913eucas1p19ae6de17520916149879be71a33291c7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210929140913eucas1p19ae6de17520916149879be71a33291c7
References: <20210929140854.28535-1-l.stelmach@samsung.com>
        <CGME20210929140913eucas1p19ae6de17520916149879be71a33291c7@eucas1p1.samsung.com>
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
2.30.2

