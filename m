Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFA47C8C6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhLUVZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:25:41 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:46320 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbhLUVZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=HO3cs/bAxWQRthzU1+hg6bvoy48ikxmGEMUA2a7K9+w=;
        b=XPKv87IqusJyRBZnCbyca+lIIiq5h7/v3a6+RxyOUMNdV4eKK2q81hAZ1i7H0YolOL3Y
        e0dR1to8dlZyvuREOjYPNX3Ycyydb9a0FYKopLtmLMOl5ukwdekgRD1uUkD3kYX9tjUkal
        ZZINs1qJ57Vnpu4DITTFqhWTqpfNks2X0vAu5E6NROaxdg7rJ9WnYr7YitRyqjJlcAAe2l
        OJj0jROJBW8EDLEgwbAJPUE03GHwRNo2FMg84ZSSFnkvvekghd46Y8T+jxRYu+DO4cYHSu
        EFpR9tWh6qYF2PhEhVDXrP3kPQnJAeDrCG69zngAuta3TDaMgDlT1aijqifp8s5A==
Received: by filterdrecv-75ff7b5ffb-ktk29 with SMTP id filterdrecv-75ff7b5ffb-ktk29-1-61C2464E-50
        2021-12-21 21:25:34.665138902 +0000 UTC m=+9587099.899018923
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id q1v2zsc-RY6pU-ZMXq5ZTQ
        Tue, 21 Dec 2021 21:25:34.472 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id BBA4A7003AA; Tue, 21 Dec 2021 14:25:33 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v7 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Date:   Tue, 21 Dec 2021 21:25:34 +0000 (UTC)
Message-Id: <20211221212531.4011609-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211221212531.4011609-1-davidm@egauge.net>
References: <20211221212531.4011609-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvNkxAMBqlRWJnXBiC?=
 =?us-ascii?Q?dBWzv9OKWVEpA8riEnI5pBRHA1T77DKWuv8JL15?=
 =?us-ascii?Q?yLKrmob=2Fypa=2F=2FDem0v1MT4R9+fBmqTvefqY4gHf?=
 =?us-ascii?Q?iILwjrBSl3aKV2wWqOzY0rNp8QFo2d2KGAXCQ6=2F?=
 =?us-ascii?Q?Kfzn9k+bzNsG59xwZt1PHmxrMXnfYHX=2FPCxQ922?=
 =?us-ascii?Q?=2FRZWa4RmS1LoAZ1M0h3Kg=3D=3D?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>,
        Rob Herring <robh@kernel.org>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the ENABLE and RESET GPIOs that may be needed by
wilc1000-spi.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../net/wireless/microchip,wilc1000.yaml      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
index 6c35682377e6d..60de78f1bc7b9 100644
--- a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
@@ -32,6 +32,21 @@ properties:
   clock-names:
     const: rtc
 
+  enable-gpios:
+    maxItems: 1
+    description: Used by wilc1000-spi to determine the GPIO line
+      connected to the ENABLE line.  If specified, reset-gpios
+      must be specified as well as otherwise the driver cannot
+      ensure the timing required between asserting ENABLE
+      and deasserting RESET.  This should be declared as an
+      active-high signal.
+
+  reset-gpios:
+    maxItems: 1
+    description: Used by wilc1000-spi to determine the GPIO line
+      connected to the RESET line.  This should be declared as an
+      active-low signal.
+
 required:
   - compatible
   - interrupts
@@ -40,6 +55,8 @@ additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/gpio/gpio.h>
+
     spi {
       #address-cells = <1>;
       #size-cells = <0>;
@@ -51,6 +68,8 @@ examples:
         interrupts = <27 0>;
         clocks = <&pck1>;
         clock-names = "rtc";
+        enable-gpios = <&pioA 5 GPIO_ACTIVE_HIGH>;
+        reset-gpios = <&pioA 6 GPIO_ACTIVE_LOW>;
       };
     };
 
-- 
2.25.1

