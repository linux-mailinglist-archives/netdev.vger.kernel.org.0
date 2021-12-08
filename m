Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D13346CD8E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhLHGTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:19:47 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:45806 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbhLHGTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=9O84YlDTJBrDvppEZlV/mmasG/m+M/ZBthbQsXfcgJM=;
        b=AI2On6MNhsKORHTwS7K/yPsiVBkKzciZzGu0Zscuh62HCqAHeLZS6AYmxT4R/1jKWt6j
        kjezu1NxlPypWdapEX8UUdlfN9Xt03E4Iyd9aV7mzcqXDMkVaoND+S66qno3MYxXGEHWol
        fdYGaJx8lzodHVsqCYq2EyQAVdTR7jR0d9XmfC+1xMqzdYOW6B4/GrJCGNe9gwxpvUa5go
        TI7l+uyigUJLaObsEPSGkQ8Hic1l7OEX+uRYYgli/mjjGmsAP960Xuh959aFc+W3OUaXjT
        nFwZ9LPhdB2z+L9yOyxXN9rmFQEVXA4X4Rx6aJZpLZ99nC5LSV/BY8TGWc67hg+w==
Received: by filterdrecv-64fcb979b9-tjknx with SMTP id filterdrecv-64fcb979b9-tjknx-1-61B04DAC-5
        2021-12-08 06:16:12.120358724 +0000 UTC m=+7366714.923877139
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id fktlyEjKRAOSgOxelA7WCA
        Wed, 08 Dec 2021 06:16:11.911 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 649C2700371; Tue,  7 Dec 2021 23:16:11 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Date:   Wed, 08 Dec 2021 06:16:12 +0000 (UTC)
Message-Id: <20211208061559.3404738-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208061559.3404738-1-davidm@egauge.net>
References: <20211208061559.3404738-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvHDkHtRhmBzQDo+NU?=
 =?us-ascii?Q?s0KNI7fyoAERCfLen8t3LrrHc2oVhzYWo0vWwGP?=
 =?us-ascii?Q?TscrxfSDDs5HaTjLzmPLRN39PI=2FULZ+HctC1jyL?=
 =?us-ascii?Q?h+8GsB=2FgRBGfM57ol+xPCimlk0P9JUvduJOGr7L?=
 =?us-ascii?Q?h6qftNxdhbLKxyHCgqqfCQZfmX6CEFc6j+5vQv?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        devicetree@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the ENABLE and RESET GPIOs that may be needed by
wilc1000-spi.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../bindings/net/wireless/microchip,wilc1000.yaml | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
index 6c35682377e6..e4da2a58fcb2 100644
--- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
@@ -32,6 +32,19 @@ properties:
   clock-names:
     const: rtc
 
+  enable-gpios:
+    maxItems: 1
+    description: Used by wilc1000-spi to determine the GPIO line
+      connected to the ENABLE line.  Unless special external circuitry
+      is used, reset-gpios must be specified when enable-gpios is
+      specified as otherwise the driver cannot ensure the proper
+      ENABLE/RESET sequence when enabling the chip.
+
+  reset-gpios:
+    maxItems: 1
+    description: Used by wilc1000-spi to determine the GPIO line
+      connected to the RESET line.
+
 required:
   - compatible
   - interrupts
@@ -51,6 +64,8 @@ examples:
         interrupts = <27 0>;
         clocks = <&pck1>;
         clock-names = "rtc";
+        enable-gpios = <&pioA 5 0>;
+        reset-gpios = <&pioA 6 0>;
       };
     };
 
-- 
2.25.1

