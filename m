Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC047482C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 17:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhLNQd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 11:33:28 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25444 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235989AbhLNQdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 11:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=yQXnRnX5mAV219nBVUMu6m7E3hTr67JRAHd87199Dpg=;
        b=DXBRUXbnGdklKRKTxORhG97uAouv2hixXJA6lqRz1x7Q7c8ZgDKVlaA8tCIgpdHxxnaW
        jP9wqIQP3WghJgM1CJWSHzstyp/dirsqbPcL3IqMyEwpawc06fX/wGZfJR2oTL9WrUAhZT
        He22ZJFSEaMO43RqzlBrUbLfgvWNc19AAZuRk+rrAV2cPKMfnZoEFppgT0XAJ8kHJiPRt8
        pIFqoR8+cJli0Jp2EUzUdu3yjbzYmJkMBW3JlSTyAUmRRrFVrqd7FRkSH4al6UXxQmYw+c
        hLezr9NTY59CFUI77tnLr0Ql8d5qhbbudkO696BJi78zIDVcFmPDxj04apUrjhXw==
Received: by filterdrecv-55446c4d49-ww7gg with SMTP id filterdrecv-55446c4d49-ww7gg-1-61B8C752-84
        2021-12-14 16:33:22.516521248 +0000 UTC m=+8964793.130447238
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-0 (SG)
        with ESMTP
        id TK2IY_rHQcakZ4T_OtfL8Q
        Tue, 14 Dec 2021 16:33:22.348 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 083CE700269; Tue, 14 Dec 2021 09:33:22 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v4 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Date:   Tue, 14 Dec 2021 16:33:22 +0000 (UTC)
Message-Id: <20211214163315.3769677-3-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214163315.3769677-1-davidm@egauge.net>
References: <20211214163315.3769677-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvH93Xhh=2FYR9spz2Bt?=
 =?us-ascii?Q?A5gO8dpXLqtzVT1vHEwdJSvMWZx2WdZTHyNXu1U?=
 =?us-ascii?Q?E5ARhbnTmdjbrbP9IjXyX8HUoKo0APnF3bVTari?=
 =?us-ascii?Q?yrrLAad+owlWWq57M+ducNXPjw9vYreE5QG0iPK?=
 =?us-ascii?Q?V3msKXkZ8aZrp1LLab+pvSknQjjazUVHGHmrCEE?=
 =?us-ascii?Q?mNud2DlVKD3DOjcPnz0=2FA=3D=3D?=
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
 .../net/wireless/microchip,wilc1000.yaml        | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml b/Documentation/devicetree/bindings/net/wireless/microchip,wilc1000.yaml
index 6c35682377e6..790a774a19ee 100644
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
@@ -51,6 +66,8 @@ examples:
         interrupts = <27 0>;
         clocks = <&pck1>;
         clock-names = "rtc";
+        enable-gpios = <&pioA 5 GPIO_ACTIVE_HIGH>;
+        reset-gpios = <&pioA 6 GPIO_ACTIVE_LOW>;
       };
     };
 
-- 
2.25.1

