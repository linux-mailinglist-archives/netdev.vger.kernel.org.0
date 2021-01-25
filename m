Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C844F3049C7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbhAZFYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:24:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40182 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbhAYQzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:55:21 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210125165423euoutp01a5214dc6b8473fd33b1898244bf2db4e~dh_Xk84dz1860418604euoutp01U
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 16:54:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210125165423euoutp01a5214dc6b8473fd33b1898244bf2db4e~dh_Xk84dz1860418604euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611593663;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIf7UYTIH5IDCW+fbwT4b49jWJVb2q6Xa34mLdc0Hrr0bwihhdcR/AY4SmHO5x4vG
         0BYLGOkBqUlnk7OS3QabvVVDygLucPZ/Xc5jZpBTYXiAOxT4qFwB64sF+anAFzSra/
         fu//+o0cbSXzu/hkoJFYHRnTKQQdCnaiiOsUogOY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210125165422eucas1p297009fa0b2a769716bde6b409b0c6cd8~dh_W1YjJ41974219742eucas1p2i;
        Mon, 25 Jan 2021 16:54:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F7.BF.45488.EB7FE006; Mon, 25
        Jan 2021 16:54:22 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210125165421eucas1p16dc1839cfabb66a1049b92daf0c7d483~dh_Wefovo2390323903eucas1p1H;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210125165421eusmtrp2ae4537855e94205cf444148ac71d11ad~dh_WdzYlC0209902099eusmtrp2E;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
X-AuditID: cbfec7f5-c5fff7000000b1b0-35-600ef7bee532
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 0D.D5.21957.DB7FE006; Mon, 25
        Jan 2021 16:54:21 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210125165421eusmtip2b1638da4f06d38dfd36bb10f31a1c214~dh_WM4J3Q2870728707eusmtip2B;
        Mon, 25 Jan 2021 16:54:21 +0000 (GMT)
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
Subject: [PATCH v11 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Mon, 25 Jan 2021 17:54:05 +0100
Message-Id: <20210125165406.9692-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210125165406.9692-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsWy7djP87r7vvMlGFzr57c4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZV4+ZFZwXrljQ+5OpgXEKfxcj
        J4eEgInEgSOrGLsYuTiEBFYwSuw4cYgFwvnCKHFr5mo2COczo8SpF6tZYFo2PloDZgsJLGeU
        WD3DDqLoOaPE3Jt3mEESbAKOEv1LT7CCJEQE7jFLrG9/ALaEWeA+o8S956vBqoQFoiX+9rcz
        gdgsAqoSJ9qvsILYvAJWEg/eb2SGWCcv0b58OxuIzSlgLfHk8HwmiBpBiZMzn4CdwS+gJbGm
        6TqYzQxU37x1NjPIMgmBU5wS6z71MkIMcpH48mEG1A/CEq+Ob2GHsGUk/u8EGcoBZNdLTJ5k
        BtHbwyixbc4PqHpriTvnfrGB1DALaEqs36UPEXaUOLOpmxGilU/ixltBiBP4JCZtm84MEeaV
        6GgTgqhWkVjXvwdqoJRE76sVjBMYlWYheWYWkgdmIexawMi8ilE8tbQ4Nz212DgvtVyvODG3
        uDQvXS85P3cTIzDlnf53/OsOxhWvPuodYmTiYDzEKMHBrCTCu1uPJ0GINyWxsiq1KD++qDQn
        tfgQozQHi5I4766ta+KFBNITS1KzU1MLUotgskwcnFINTB0Rx/XnZRQz+ThvYo2wl/qZMu+c
        wqTsJNmnz5gOJ96JrlyVE2DVecg9pZ9fIEX/9Kb3JmlurZL9ThPiF2Te7LbdLCFRuWOfm3+e
        LbPvtp9umXIik36ISZSdeVTXs++e17+0fP6zeSZPLiV32b7s39ttWTxpbVqOQ2PDVi6RWnGF
        1xs9D/4MnucvXhJ5ZOust4t8V17xj2Jxe5HzQPQsQ0L2RsalR9yUnmz8vEFKJmPJguOfL4cv
        O2HrtEBg25Gd0hMz2t+f82f5vLveOTxLbfmZPe/7hSuDH2t6bVZTE3vCfkSCNUbWzsbtc78M
        X+/XG1b/hO8t+8XUNM1UiXenqdpX5QJv3qDy5N69KoFKLMUZiYZazEXFiQDnJIRQ6AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t/xe7p7v/MlGCz7om9x/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsFv837OD3UHI4/K1i8weW1beZPLYOesuu8emVZ1s
        HpuX1Hvs3PGZyaNvyypGj8+b5AI4ovRsivJLS1IVMvKLS2yVog0tjPQMLS30jEws9QyNzWOt
        jEyV9O1sUlJzMstSi/TtEvQyrh4zKzgvXLGg9ydTA+MU/i5GTg4JAROJjY/WsHQxcnEICSxl
        lDix/xdTFyMHUEJKYuXcdIgaYYk/17rYIGqeMkpsfP2BHSTBJuAo0b/0BCtIQkTgDbNE0723
        7CAOs8B9Rolfn14wglQJC0RKbD/zlRnEZhFQlTjRfoUVxOYVsJJ48H4jM8QKeYn25dvZQGxO
        AWuJJ4fnM4HYQkA1519+Y4OoF5Q4OfMJC8h1zALqEuvnCYGE+QW0JNY0XWcBsZmBxjRvnc08
        gVFoFpKOWQgds5BULWBkXsUoklpanJueW2yoV5yYW1yal66XnJ+7iREY4duO/dy8g3Heq496
        hxiZOBgPMUpwMCuJ8O7W40kQ4k1JrKxKLcqPLyrNSS0+xGgK9NlEZinR5HxgiskriTc0MzA1
        NDGzNDC1NDNWEufdOndNvJBAemJJanZqakFqEUwfEwenVAPToq/PL976f+9T2i1rZlerJ+J3
        JNgZdt45tXy7+uXNDyTcbqxZJSvcFFSr5B7IbbP86xyfwpo/Ek+u3wjwLytRXcv1ZaL/Zpa7
        Zbne89f/mOWdW1V6wLrxudCenw8qfYynKDXo1ihYcNRra029GH77j8z/N4y8czK1X0xqb9uU
        4Kp7TOPnQ9N/X69qmalWiSqmCpqav5rBeeHU0myRiYZPnxVrnWxbn5xt+cf5jPTc1a3fOefG
        pDG63m+5wfE1dd+DcNYZU6NO7zoe8LjN2zKXSTv7tvCDt4nKsz5eP1TpdXzRo2v725LvKXAz
        XDQ8Pz9CjClJ9SBfJteteWnPl6zcc/XSvk2ci/SDY9IPGwZ3KrEUZyQaajEXFScCAJitDCF5
        AwAA
X-CMS-MailID: 20210125165421eucas1p16dc1839cfabb66a1049b92daf0c7d483
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210125165421eucas1p16dc1839cfabb66a1049b92daf0c7d483
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210125165421eucas1p16dc1839cfabb66a1049b92daf0c7d483
References: <20210125165406.9692-1-l.stelmach@samsung.com>
        <CGME20210125165421eucas1p16dc1839cfabb66a1049b92daf0c7d483@eucas1p1.samsung.com>
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

