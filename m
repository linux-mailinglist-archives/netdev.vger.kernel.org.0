Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07CB2A494B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgKCPSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:18:34 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54850 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728248AbgKCPPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:15:52 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20201103151540euoutp0206c1f4f884ad578d997559ec7eaa0311~ECFfAtCdw0620306203euoutp022
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 15:15:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20201103151540euoutp0206c1f4f884ad578d997559ec7eaa0311~ECFfAtCdw0620306203euoutp022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1604416540;
        bh=5UX5htxsF3sxtapCvYsUc2mk9vKsqHBXgv87cKNzRyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hd4eK36cIHK/AP1iA5UX2tEOOkK7UYMb+BvI3C6jvsvYQJYOKe+EWiJTEZdBUQI4e
         y8nU+LfwJ9MUWODbDelJRbuT/Ndbs0Me+mxapp2wUSDcRDhP0LurnUhBJjl6YA/KSP
         4Fmp4nZYw4ZXyppsgRV3jGewNBqjAzwbuN0UgKwo=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201103151539eucas1p1a4a1a129362a99c4d1d6dc76a1fa85bb~ECFet0zAe2148421484eucas1p11;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id CE.FA.05997.B1471AF5; Tue,  3
        Nov 2020 15:15:39 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f~ECFeY8aTw2031520315eucas1p2L;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201103151539eusmtrp1a566e3769eb20e410cdacc25ee508b50~ECFeYHq2a0045400454eusmtrp1t;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
X-AuditID: cbfec7f4-677ff7000000176d-9d-5fa1741b02f8
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 46.B9.06314.B1471AF5; Tue,  3
        Nov 2020 15:15:39 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201103151539eusmtip2ab289f8e9b4a0d5f218e035a896899f8~ECFeNlLfi0779607796eusmtip2k;
        Tue,  3 Nov 2020 15:15:39 +0000 (GMT)
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
Subject: [PATCH v5 2/5] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Tue,  3 Nov 2020 16:15:33 +0100
Message-Id: <20201103151536.26472-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103151536.26472-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHe3bv3a7L2fVqddAwWPVBKcu0esIwK6FbFPTFPgxKV11M1Cnb
        NOtLo/dkaU2HNoXWqLY006ZOXSo0zV5WrpLMQpfgS2WopYK9Ubldpb79znP+//M/Bx6aYL1U
        GJ2u0vJqlTJTLpaSjs7vnjXh2usp68pHYrGn30Xge2U1FK7wnCHxtY4uClsmyijcM9ZH4aLB
        zwT2eGol+IWjkMJvXTaE7YM9FO52VohxmadNhF3GVoSrO/oluNO8BJ9t7ZAkBnPdPS8Jrv72
        WxHXbOqXcPbKi2Ku7sZJrrlpSsQV1lcibsoesY9WSLcc4TPT83j12oRU6dEZ3SjKmWTz/3Q7
        kA49CCpAATQwcfDa5CQLkJRmGRsC77hdJBTTCPqso4RQTCEY1r0Sz1suvvmKfMwyVgS1+nBB
        9AGB+fonf0PMbIOim48pXyOU8RJQc34A+QqCaUPQ7C0hfKoQRgFXJu0SH5PMKrC49aSPZUw8
        GL5MUULccjhvbfRHBzBbQFdiFAmaYHhydcivX8REwZ1Tb/xMzOpPN5T79wbGSEOrdZAUBiVB
        be9TicAhMPqofo6XgbvYF0zP8kkoNmwUvHoEjopvc9546Ov6IfZpCCYSapxrhedtYP/+BQnW
        IOgdCxZWCAKDo5QQnmVw4RwrqFfC3aKWuYFhcGnUhi4juem/Y0z/HWD6l2VGRCVayudqstJ4
        zXoVfyxao8zS5KrSog9nZ9nR7K9z/3403YScvw65EEMjeaAskTensJQyT3M8y4WAJuShsu3P
        3QdZ2RHl8RO8OjtFnZvJa1wonCblS2Wxlk8HWCZNqeUzeD6HV893RXRAmA4VRihW747Tvn+6
        debdw5bkO2P5u5pLq1eMG88G5rOp+3W9PxOn8xJHrOfyHlhs7Y6GJcm3CvSb4kQHDNMJ6rY/
        e2bqrFU7oNqRpJ1MOrUhg58ZaLVsam/Yc7MxqjSeHNLHoAuxGVXx5fcnpNKFKuvO8fS9m/nh
        Z4sjDYoFH5Var5zUHFXGRBFqjfIvzpZUNHEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t/xe7rSJQvjDVaulrc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEv43vDK8aCT0IV/y9vY2xgPMjXxcjJISFgItF5/SNjFyMXh5DAUkaJ1pYj
        7F2MHEAJKYmVc9MhaoQl/lzrYgOxhQSeMkrs/BAEYrMJOEr0Lz3BCtIrIvCGWaLp3lt2EIdZ
        YB+jxP6ji9lBqoQFIiRePbnCCmKzCKhKLDrdwwJi8wpYS0z68JkVYoO8RPvy7WAbOAVsJBqm
        TGWC2GYtsevoFjaIekGJkzOfsIAcxyygLrF+nhBImF9AS2JN03WwkcxAY5q3zmaewCg0C0nH
        LISOWUiqFjAyr2IUSS0tzk3PLTbUK07MLS7NS9dLzs/dxAiM623Hfm7ewXhpY/AhRgEORiUe
        XofUBfFCrIllxZW5hxglOJiVRHidzp6OE+JNSaysSi3Kjy8qzUktPsRoCvTmRGYp0eR8YMrJ
        K4k3NDU0t7A0NDc2NzazUBLn7RA4GCMkkJ5YkpqdmlqQWgTTx8TBKdXA2LhDVlpz66oF21d1
        dFw7GWUiplr/s6iKYckb+c3bL+07P0vVtdNzwr8Pt2/mZN0U0E5N6jbP6vsW3fV/X66D5eSn
        J321Nfu3vniS6DPFRPdBdmWfBNO5xDW+gp+b9x3N9Rf7GlO8d1dQ2eEeSdVHu7/rBx/aO3ff
        SUcOc9Vu10NvX/1Xyf5mqsRSnJFoqMVcVJwIAOTvEqMBAwAA
X-CMS-MailID: 20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f
References: <20201103151536.26472-1-l.stelmach@samsung.com>
        <CGME20201103151539eucas1p234b5fe43c6f26272560a7d2ac791202f@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bindings for AX88796C SPI Ethernet Adapter.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
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

