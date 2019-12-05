Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD661141D9
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 14:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfLENpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 08:45:08 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:60908 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfLENpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 08:45:08 -0500
Received: from ramsan ([84.195.182.253])
        by xavier.telenet-ops.be with bizsmtp
        id aDl52100X5USYZQ01Dl5nK; Thu, 05 Dec 2019 14:45:05 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1icrRJ-0002Bj-EY; Thu, 05 Dec 2019 14:45:05 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1icrRJ-0001i6-CG; Thu, 05 Dec 2019 14:45:05 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: ravb: Document r8a77961 support
Date:   Thu,  5 Dec 2019 14:45:04 +0100
Message-Id: <20191205134504.6533-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document support for the Ethernet AVB interface in the Renesas R-Car
M3-W+ (R8A77961) SoC.

Update all references to R-Car M3-W from "r8a7796" to "r8a77960", to
avoid confusion between R-Car M3-W (R8A77960) and M3-W+.

No driver update is needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,ravb.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Documentation/devicetree/bindings/net/renesas,ravb.txt
index 5df4aa7f681154ee..87dad2dd8ca0cd6c 100644
--- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
+++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt
@@ -21,7 +21,8 @@ Required properties:
       - "renesas,etheravb-r8a774b1" for the R8A774B1 SoC.
       - "renesas,etheravb-r8a774c0" for the R8A774C0 SoC.
       - "renesas,etheravb-r8a7795" for the R8A7795 SoC.
-      - "renesas,etheravb-r8a7796" for the R8A7796 SoC.
+      - "renesas,etheravb-r8a7796" for the R8A77960 SoC.
+      - "renesas,etheravb-r8a77961" for the R8A77961 SoC.
       - "renesas,etheravb-r8a77965" for the R8A77965 SoC.
       - "renesas,etheravb-r8a77970" for the R8A77970 SoC.
       - "renesas,etheravb-r8a77980" for the R8A77980 SoC.
@@ -37,8 +38,8 @@ Required properties:
 - reg: Offset and length of (1) the register block and (2) the stream buffer.
        The region for the register block is mandatory.
        The region for the stream buffer is optional, as it is only present on
-       R-Car Gen2 and RZ/G1 SoCs, and on R-Car H3 (R8A7795), M3-W (R8A7796),
-       and M3-N (R8A77965).
+       R-Car Gen2 and RZ/G1 SoCs, and on R-Car H3 (R8A7795), M3-W (R8A77960),
+       M3-W+ (R8A77961), and M3-N (R8A77965).
 - interrupts: A list of interrupt-specifiers, one for each entry in
 	      interrupt-names.
 	      If interrupt-names is not present, an interrupt specifier
-- 
2.17.1

