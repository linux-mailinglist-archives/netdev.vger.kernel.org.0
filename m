Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5EF475138
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhLODFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:05:23 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27972 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbhLODFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:05:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=n5E/dGiaWc093mMx2isrqIl9xS2diTFoldK85pjdP9U=;
        b=EnnqmqN3JxQA/cuMBO7tEt/6PLEiAcHUzEIqxbueNbdf8uVAGJFD4tpOtBTZgw6oMHvo
        9kOJL4Ont7VUb9rcPeflwFOSlMTtAPDPZrvwBDMs8rMjxzHGogJZIWOFhUWd332ujx1luU
        kEBOy4gOS5mqJOMAdXpOzoBCUeOum71HVvXvKvuOa3I6AUd4hGOpJGy0Rr7+c/crc/P1ci
        5cuZYa/pJRHUT7uxylL/BPAJJCPZNHo8SX9Thut5Ed2xBL2h1PZQ2P5uznoL9C55UvbNdb
        DZMcJWB2fTnomHOq+iPNzgXHEeST5YNqb5wmufg4q/PBa7IiVZHX2YOj25WRsNDw==
Received: by filterdrecv-656998cfdd-bkftm with SMTP id filterdrecv-656998cfdd-bkftm-1-61B95B67-94
        2021-12-15 03:05:12.007490305 +0000 UTC m=+7270674.434639005
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-0 (SG)
        with ESMTP
        id uY3a5_yrR9G7jgcsBnOj4g
        Wed, 15 Dec 2021 03:05:11.797 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 79A74700269; Tue, 14 Dec 2021 20:05:11 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v5 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Date:   Wed, 15 Dec 2021 03:05:12 +0000 (UTC)
Message-Id: <20211215030501.3779911-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215030501.3779911-1-davidm@egauge.net>
References: <20211215030501.3779911-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvAJX2hjXqlZEyi4OX?=
 =?us-ascii?Q?rLApbyobOaAcwna02jHMyQlXVEb6oBIx1uTmA4c?=
 =?us-ascii?Q?4pTGtpKVJWiWyGwTcEunqp1kxe2wSQulgWXNtsq?=
 =?us-ascii?Q?PZJXFl81YiIeGbJ7SbuMq5WARs8dDrS26FUr5Xx?=
 =?us-ascii?Q?vcVQsL2wSy3kpBTy59v4YemuBGUpJGXlc7uG8Hy?=
 =?us-ascii?Q?QbcmiQJ+ilDhdKDapZmFA=3D=3D?=
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
index 6c35682377e6..60de78f1bc7b 100644
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

