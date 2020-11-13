Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413332B153E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 06:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgKMFJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 00:09:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:38774 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgKMFJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 00:09:25 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201113050922epoutp03c4e169f504f768741899c196584d7364~G_Q_M--ol2776927769epoutp03N
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 05:09:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201113050922epoutp03c4e169f504f768741899c196584d7364~G_Q_M--ol2776927769epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1605244162;
        bh=fRB6FdH0gtwsT6IIEjy9W7i5gws73WKHvZQzMaW7nDM=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=c0WLX1KRMdN4LV8/hR9Uv+J9JfB9ItYACYks+A5Drsdzz7y3Rc0Io8v3YEibWjQ51
         9ph4upXYVNjSZKGHgv0JylgdBgjGEHV8nZFSXsNr2ItzTdNCDaURMzRTXVzvYIcozT
         X8fRS6FOFJgRMpHtgBJpx0ufwU0WWcdtAEeE6QMM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201113050922epcas2p1ad2553277168ae80dd793109ed42e926~G_Q94aWJY0969709697epcas2p1U;
        Fri, 13 Nov 2020 05:09:22 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CXRN058VhzMqYkV; Fri, 13 Nov
        2020 05:09:20 +0000 (GMT)
X-AuditID: b6c32a47-72bff7000000d2c4-66-5fae15007543
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        77.7A.53956.0051EAF5; Fri, 13 Nov 2020 14:09:20 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH net-next 2/2] nfc: s3fwrn82: Add driver for Samsung S3FWRN82
 NFC Chip
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201113050919epcms2p7487583bf846376040a9874a7eb39fdae@epcms2p7>
Date:   Fri, 13 Nov 2020 14:09:19 +0900
X-CMS-MailID: 20201113050919epcms2p7487583bf846376040a9874a7eb39fdae
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmhS6D6Lp4gwfLxSy2NE9it5hzvoXF
        Yv6Rc6wWF7b1sVocWyBm0br3CLsDm8eWlTeZPDat6mTz6NuyitHj8ya5AJaoHJuM1MSU1CKF
        1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
        fTubovzSklSFjPziElul1IKUnAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjG1n/rMW9PFU
        LJv5nLWB8QhnFyMnh4SAicTl1ZPYuxi5OIQEdjBKTF7zl6mLkYODV0BQ4u8OYZAaYYFwiWl/
        lrKD2EICihL/O86xQcR1JV78PQpmswloS6w92sgEYosIhEncXHGDGcRmFpjPKDGzKxZiF6/E
        jPanLBC2tMT25VsZIWwNiR/LepkhbFGJm6vfssPY74/Nh6oRkWi9dxaqRlDiwc/dUHFJibf7
        5oHdLyHQzihx/ucPNghnBqPEqc1/oTr0JRafWwF2Ha+Ar8TD94vANrAIqEo8/7EHapuLxKKz
        25ggrpaX2P52DjMoIJgFNCXW79IHMSUElCWO3GKBqOCT6Dj8lx3mrx3znjBB2KoSvc1fmGB+
        nDy7BepOD4kDP/+wg4wREgiUeLXefQKjwixEQM9CsnYWwtoFjMyrGMVSC4pz01OLjQqMkeN2
        EyM4GWq572Cc8faD3iFGJg7GQ4wSHMxKIrzKDmvihXhTEiurUovy44tKc1KLDzGaAj08kVlK
        NDkfmI7zSuINTY3MzAwsTS1MzYwslMR5Q1f2xQsJpCeWpGanphakFsH0MXFwSjUw2fStW8K8
        M9ZWwen/u+BVL9fY3n5s/fAsf83nNclp6lMrLh19P9V4WfkR8dCK+rk7urkMtV14Pl/4uMt/
        u6/2ERVvx/sL/VdcMAo/XWh/V0D/6rw5V3y0pI913tMR9Ql6ZBDmeelDqOeTzpIq/4dq0Usu
        L5UPk06aZ1X1qe+tv8aElX8sxV+umxLwv3XbJ79Tn90lZhw77ukUsmLuY56bmvZFL/Z7X/99
        x/aoeMNhdWnLo0Za5yYbnJngZvnhaNVD1kamT/8sdr0zOsvsXPH93ePbXfF/Fma4ZG1qmMSi
        xrvqiWS5+eo7Pw/d7jvjt2Vvo8PGe6de7QlOFk+RWT33nonzjqXXUlsnefpdyD208YASS3FG
        oqEWc1FxIgD9Mmp/DwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201113050919epcms2p7487583bf846376040a9874a7eb39fdae
References: <CGME20201113050919epcms2p7487583bf846376040a9874a7eb39fdae@epcms2p7>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Add the device tree bindings for Samsung S3FWRN82 NFC controller.
S3FWRN82 is using NCI protocol and I2C communication interface.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 .../devicetree/bindings/net/nfc/s3fwrn82.txt  | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt

diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
new file mode 100644
index 000000000000..03ed880e1c7f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn82.txt
@@ -0,0 +1,30 @@
+* Samsung S3FWRN82 NCI NFC Controller
+
+Required properties:
+- compatible: Should be "samsung,s3fwrn82-i2c".
+- reg: address on the bus
+- interrupts: GPIO interrupt to which the chip is connected
+- en-gpios: Output GPIO pin used for enabling/disabling the chip
+- wake-gpios: Output GPIO pin used to enter firmware mode and
+  sleep/wakeup control
+
+Example:
+
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    i2c4 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        s3fwrn82@27 {
+            compatible = "samsung,s3fwrn82-i2c";
+            reg = <0x27>;
+
+            interrupt-parent = <&gpa1>;
+            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
+
+            en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
+            wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+        };
+    };
-- 
