Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49ED47B282
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbhLTSDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 13:03:48 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:64078 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240187AbhLTSDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 13:03:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=QWM9YsbpUa2tq7fJXkCMatPQQZnA34M+sSBg18iyfvg=;
        b=qYfOqHWLIZDUm8S5CLejAgsPW3zvJ8r1g1/gJQEmxx7d+6jnvZP5qvnpKD0LZEi39lGI
        Y8mht/gIMMIIQoFedepzsdIzz1NZ1i4yeP+sjHpxgH1XzsBlwkfJ1skUFBq5NrP0Dhz4LF
        AHkqZUis3rxrkr7MRq+c16AQ83lXGkKrHhB0o7iGbdAx0XJXlLSj1MJKGWy3vqSE/on1pw
        ubd8dCOxlxBZFAeAseRULqBx5XFOZUtIpMDlgiSSo5fO1LNPauUNLp2XTgIUAcAnHygIdO
        qTOEOXsfKPoIYxg9cOh3e9wx+MC8r2v9AXuNMsiSv0HpTbosT92Xel3I+L6Oq3uA==
Received: by filterdrecv-656998cfdd-bkftm with SMTP id filterdrecv-656998cfdd-bkftm-1-61C0C57A-8
        2021-12-20 18:03:38.098190542 +0000 UTC m=+7756580.525339306
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id 2IkVQ0rYSmmaaNjVrWXcYQ
        Mon, 20 Dec 2021 18:03:37.905 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 52DB6700588; Mon, 20 Dec 2021 11:03:37 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v6 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Date:   Mon, 20 Dec 2021 18:03:38 +0000 (UTC)
Message-Id: <20211220180334.3990693-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220180334.3990693-1-davidm@egauge.net>
References: <20211220180334.3990693-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvCZJmChV6WiC1WWND?=
 =?us-ascii?Q?c1LMEiKwYZUaMMEg8c9SpxKE1fHLOQLhUvKxEMi?=
 =?us-ascii?Q?HPcK+WyZBnUilTDsUEOjbOMr6h6h1Yt+DahBGM0?=
 =?us-ascii?Q?ub4+nufxuHm7738czNKItd2NXwwQt=2FkJ=2FBg93lf?=
 =?us-ascii?Q?vzOLeyB6N6cfMEd+wanm1apzxgXqyISLetRNyx?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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

