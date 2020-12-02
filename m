Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08352CC921
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgLBVtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:49:10 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35753 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgLBVtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:49:07 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20201202214727euoutp01f7df1359e488f842e2627ca5446a2027~NBI12qXS82906929069euoutp01D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 21:47:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20201202214727euoutp01f7df1359e488f842e2627ca5446a2027~NBI12qXS82906929069euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1606945647;
        bh=27homzhxtOgQquKIw/0+3LoypE6+9O9g4fIKMDgjxBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+361pxpI+SBCS/jLqr3HloRNDCrzCbW0qPRskm0xHhsfQWrfUoqbdIlrVCUMddQN
         11VcsUQ9y58NkXFa9RsRhJq6zsqTgevhCIVjuXc5DP0DYN1o2nj1XwnJ4EVWWpoOWX
         kL6IneOVXb4bev9vqPUNP3Fm1cZzZ+5DYdajcYS8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20201202214713eucas1p174c8325466b270d59a865ea696378352~NBIoN2tyH0122201222eucas1p1V;
        Wed,  2 Dec 2020 21:47:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BF.0A.44805.06B08CF5; Wed,  2
        Dec 2020 21:47:12 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20201202214712eucas1p123a11da20004b01c0d906a0d3d3f947c~NBInYH0e50122101221eucas1p1W;
        Wed,  2 Dec 2020 21:47:12 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201202214712eusmtrp2d1f7f9abd0672115c4a37758a23454b9~NBInXc61e2207722077eusmtrp2l;
        Wed,  2 Dec 2020 21:47:12 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-d5-5fc80b60937b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2F.2E.21957.F5B08CF5; Wed,  2
        Dec 2020 21:47:11 +0000 (GMT)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201202214711eusmtip2907b75f3d54e0e267ed7f8ef7fb0e141~NBInIlA7l2839428394eusmtip2U;
        Wed,  2 Dec 2020 21:47:11 +0000 (GMT)
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
Subject: [PATCH v8 2/3] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Date:   Wed,  2 Dec 2020 22:47:08 +0100
Message-Id: <20201202214709.16192-3-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202214709.16192-1-l.stelmach@samsung.com>
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWy7djPc7oJ3CfiDfYdNrE4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZV4+ZFZwXrljQ+5OpgXEKfxcj
        J4eEgInEn033WboYuTiEBFYwSmzfeo4JwvnCKPH21Dk2COczo8T33cuYYFo+zTrMCmILCSxn
        lDi3WAyi6DmjxIvHL8CK2AQcJfqXnmAFSYgI3GOWWN/+gBHEYRa4zyhx7/lqZpAqYYEoidtr
        N4ONYhFQlZi4+xmQzcHBK2At0fpLHGKbvET78u1sIDangI3Emxfnwcp5BQQlTs58wgJi8wto
        Saxpug5mMwPVN2+dzQyyS0LgMKdEx5wprBCDXCROrV8I9YKwxKvjW9ghbBmJ/zvnM4HslRCo
        l5g8yQyit4dRYtucHywQNdYSd879YgOpYRbQlFi/Sx8i7CixrfEMG0Qrn8SNt4IQJ/BJTNo2
        nRkizCvR0SYEUa0isa5/D9RAKYneVysYJzAqzULyzCwkD8xC2LWAkXkVo3hqaXFuemqxUV5q
        uV5xYm5xaV66XnJ+7iZGYMI7/e/4lx2My1991DvEyMTBeIhRgoNZSYSX5d+ReCHelMTKqtSi
        /Pii0pzU4kOM0hwsSuK8SVvWxAsJpCeWpGanphakFsFkmTg4pRqYpk1ccPFhXSWX87+j2ow9
        X74Vv26J67q755uIvmiGvRt//aZ/vt9Skh56a3NXTbq67bX4hElZgnwOvXobQnn3ML5naGrn
        fDlp9iZTb1v2Ev2Xrx9Z5rNaaLaJ/jhbH5k7y+Pi1Ud7b6YK+6rW/Xc4/27usUl2nfvkJebd
        W2ewtvuqTp9SyaHbFQo8mlfO/T6/zqMqt9b09vZE7ukbe27NVFQ1+HT2CDNj8evTB0UONX0+
        myd8lzHswDMTlu/vfprq89h9yyjtmbTjlYjax5Si6d4Tkrdb+c1+qqQWsem5Zu/ku7fSnLVO
        7bI1yHlVuowr+1/wpoKYxT95T5vtsZjy6vLkygftooLbF9bqMlbEKbEUZyQaajEXFScCAKS3
        1MDnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7rx3CfiDd79sbE4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2C3+79nB7iDkcfnaRWaPLStvMnnsnHWX3WPTqk42
        j81L6j127vjM5NG3ZRWjx+dNcgEcUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFW
        RqZK+nY2Kak5mWWpRfp2CXoZV4+ZFZwXrljQ+5OpgXEKfxcjJ4eEgInEp1mHWbsYuTiEBJYy
        StzZM5upi5EDKCElsXJuOkSNsMSfa11sEDVPGSUO7f3OApJgE3CU6F96AqxZROANs0TTvbfs
        IA6zwH1GiV+fXjCCVAkLREj83fQXzGYRUJWYuPsZK8gGXgFridZf4hAb5CXal29nA7E5BWwk
        3rw4zwpiCwGV7H+1EqyVV0BQ4uTMJywgrcwC6hLr5wmBhPkFtCTWNF0Hu4cZaEzz1tnMExiF
        ZiHpmIXQMQtJ1QJG5lWMIqmlxbnpucWGesWJucWleel6yfm5mxiB8b3t2M/NOxjnvfqod4iR
        iYPxEKMEB7OSCC/LvyPxQrwpiZVVqUX58UWlOanFhxhNgR6byCwlmpwPTDB5JfGGZgamhiZm
        lgamlmbGSuK8W+euiRcSSE8sSc1OTS1ILYLpY+LglGpgmusUbNPU+ir5q/yPkAu3/dtfGOWa
        paqWpnbPmP2n8vlhQd+XfTvYQ+22rjHKF5DS3+9xbcX50FpLiRtLF2h6CWiLu9fWdwomcZzo
        lPwhukj14tLJGf2vWzcau5t+sLx7M+hQcu/1Q+vmHVixrJhT7FXmosrv7e9iPOdN+iruZHdW
        M+b4PNv1qVunf2K2un5jZXsgM890cSPV7VqXjpfZuN8NmSrqO+sJY4mNUrv2QuZpFS9uXuyr
        /7LCmylh6tnbYrIWnI1fBZ/MO6lpXlLYmXS2ZqbyyaY1gfN6rZenLpmgf8z76KTph643hlhK
        XyrhWL/gauSUC5ndh58wfzApP/S9/YyB+dxVCflL1t6rU2Ipzkg01GIuKk4EAKtVSqF4AwAA
X-CMS-MailID: 20201202214712eucas1p123a11da20004b01c0d906a0d3d3f947c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20201202214712eucas1p123a11da20004b01c0d906a0d3d3f947c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20201202214712eucas1p123a11da20004b01c0d906a0d3d3f947c
References: <20201202214709.16192-1-l.stelmach@samsung.com>
        <CGME20201202214712eucas1p123a11da20004b01c0d906a0d3d3f947c@eucas1p1.samsung.com>
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

