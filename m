Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0531029D354
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgJ1Vk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:40:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60054 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbgJ1Vkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:40:53 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201028214029euoutp024ce0801c6015e325e5ac50d6805ca54b~CRdwzBHY50334203342euoutp02Q
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 21:40:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201028214029euoutp024ce0801c6015e325e5ac50d6805ca54b~CRdwzBHY50334203342euoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603921229;
        bh=I+o/56XtJST5vLryEFJ4j4MJlOOh9NA3qyon+YC57NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fO6gSQpW7/t2aCmwaikTo7TEAEPzjxhN4x8tgLU495b1aWdbV9Z/S8HgqGnvTjwZe
         sjTHCfsmEqiOAhDkqsK5hJe7i6RmupaoFTpk4wAvJg93AmcwzHkmrcj/s0jX5TkJKp
         T8BAlKbzc1fP0JK73LNjlUi6KfAmKVXIVIwvTDYk=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201028214018eucas1p123197ce91702ead337ae9c1a01f95899~CRdm8nSlO3058230582eucas1p1h;
        Wed, 28 Oct 2020 21:40:18 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E2.5C.06318.245E99F5; Wed, 28
        Oct 2020 21:40:18 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13~CRdl4ckua2482524825eucas1p2c;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201028214017eusmtrp1a59ef10948a3e87798153ce60a73992c~CRdl3enLh3223832238eusmtrp1k;
        Wed, 28 Oct 2020 21:40:17 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-03-5f99e54282a3
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7F.8E.06314.145E99F5; Wed, 28
        Oct 2020 21:40:17 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201028214016eusmtip238e663beef7e55250b77e6e510a55b27~CRdkqqha-2543225432eusmtip2n;
        Wed, 28 Oct 2020 21:40:16 +0000 (GMT)
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
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v4 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Wed, 28 Oct 2020 22:40:09 +0100
Message-Id: <20201028214012.9712-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201028214012.9712-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+e3eu92NZtdpeVhSMQxSUXv3I8Myglb0h1L0h6A29aKSs9jU
        NCLFd2ouNUmXlUmSzfem85FKLrHCaj5CjZxpapZiElpk2sPtGvXf95zz+Z4HHJqQjFJSOjI6
        hlVFK6JkfBFp7F4yexyZKg7eMV7ngc0WE4Hri2opXGJOJfHdrlcULpsvovDg3AiFNROzBDab
        6wS415hL4TemCoT1E4MUHmgt4eMicwcPmwrbEa7usghwd+lGnNbeJThsLx8Y7CPkDQ/f8OQt
        WotArtdd5csN9xPlLc0LPHlugw7JF/Sb/egA0cEwNioyjlV5+ZwVRXxMS6UuXJfEZy8uUUmo
        3C4LCWlg9kDn7WcoC4loCVOBoG92iuCCRQTvs+vXggUETeNG4q9luDVlrfAAgeVFNckF06v+
        jj4bxWd8QVP+jLIWHJlRAmozxmxTCKYDQcvoDRvlwASALuX1KkXTJLMN2goOWdNi5gBczXmJ
        uHFbIONBE9+qhYw3TC4+ojjGHp4XT5JWvZ5xg6rkIZsmVvmUxlu29YAppOHL8k8e1+golHV9
        ozjtADNPGwScdoaeghzSugMwiVCQv4/z5iAwlnwnOcYbRl794FsZgnGF2lYvLu0Lv+cNPM5q
        B8Nz9twKdpBvvElwaTFkpks42gVqNG1rDaVwbaYCXUcy7X/HaP87QPtvVikidMiJjVUrw1n1
        7mj2oqdaoVTHRod7hp5X6tHq1/X8evq1GXWshJgQQyPZOnHv2+JgCaWIUycoTQhoQuYoPvKy
        J0giDlMkXGJV54NVsVGs2oQ20aTMSby77FOghAlXxLDnWPYCq/pb5dFCaRIyBHxgQwOXXSzv
        9uw9lrSSfM8+XFi0Paj25C3Xxv6YJ/Fvz/Tyc/THK09n1uwq98/qPVG5IXCoqVNb+jt9e0LE
        aefmTkeFdEzXHyaedjcsKAurXDRS0anm4Pt5d1JbxpRBV8QbRsZZP6GPZutUiL9f/Oc8b+F+
        Q8Bc/Q73uctuj91kpDpCsdONUKkVfwBOpoN6cQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7qOT2fGG7yaoGhx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJexovWFtaCCUIV3V9+sjYwLuXrYuTkkBAwkbixq5m5i5GLQ0hgKaPE06d7
        WboYOYASUhIr56ZD1AhL/LnWxQZR85RR4uTTfcwgCTYBR4n+pSdYQRIiAm+YJZruvWUHcZgF
        9jFK7D+6mB2kSlggQuLh1YOMIFNZBFQl9ky2BwnzClhJdPacZYTYIC/Rvnw7G4jNKWAt8eTL
        blYQWwio5ue3NnaIekGJkzOfgB3HLKAusX6eEEiYX0BLYk3TdRYQmxloTPPW2cwTGIVmIemY
        hdAxC0nVAkbmVYwiqaXFuem5xYZ6xYm5xaV56XrJ+bmbGIFxve3Yz807GC9tDD7EKMDBqMTD
        e+H2zHgh1sSy4srcQ4wSHMxKIrxOZ0/HCfGmJFZWpRblxxeV5qQWH2I0BfpyIrOUaHI+MOXk
        lcQbmhqaW1gamhubG5tZKInzdggcjBESSE8sSc1OTS1ILYLpY+LglGpgDCt9ZrtOvH6CgeyJ
        Pxc7Umf0t4pUz1Se3P/xeL/j07OdR/x/XvNeJLwg63eVWt48Zd2PnU9lqsPC5/YvLvr5oOvl
        19cvpeS229/k7HrkKyi3K+XKnI2COntDNk8/wcq3TGTPD+0e3YrAn29eaOyId4/nWmnAdHiN
        3t9Ti6z3TOEOKn0THzvxuxJLcUaioRZzUXEiAMXn3HUBAwAA
X-CMS-MailID: 20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13
References: <20201028214012.9712-1-l.stelmach@samsung.com>
        <CGME20201028214017eucas1p251d5bd9f5f9db68da4ccefe8ee5e7c13@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 .../bindings/net/asix,ax88796c.yaml           | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml

diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
new file mode 100644
index 000000000000..05093c1ec509
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/asix,ax88796c.yaml
@@ -0,0 +1,69 @@
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
+  - interrupt-parrent
+  - reset-gpios
+
+additionalProperties: false
+
+examples:
+  # Artik5 eval board
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/gpio/gpio.h>
+    ethernet@0 {
+        compatible = "asix,ax88796c";
+        reg = <0x0>;
+        local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
+        interrupt-parent = <&gpx2>;
+        interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+        spi-max-frequency = <40000000>;
+        reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
+    };
-- 
2.26.2

