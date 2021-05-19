Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA991388E90
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbhESNEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344580AbhESNET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 09:04:19 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5817C06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 06:02:59 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:c161:a89e:52bd:1787])
        by laurent.telenet-ops.be with bizsmtp
        id 6d2y25007446CkP01d2yG4; Wed, 19 May 2021 15:02:58 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljLqj-007FLT-N7; Wed, 19 May 2021 15:02:57 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ljLqi-007dcy-U4; Wed, 19 May 2021 15:02:56 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: renesas,ether: Update Sergei's email address
Date:   Wed, 19 May 2021 15:02:53 +0200
Message-Id: <15fb12769fcfeac8c761bf860ad94b9b223d3f9c.1621429311.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update Sergei's email address, as per commit 534a8bf0ccdd7b3f
("MAINTAINERS: switch to my private email for Renesas Ethernet
drivers").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,ether.yaml b/Documentation/devicetree/bindings/net/renesas,ether.yaml
index 8ce5ed8a58dd76e6..c101a1ec846ea8e9 100644
--- a/Documentation/devicetree/bindings/net/renesas,ether.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,ether.yaml
@@ -10,7 +10,7 @@ allOf:
   - $ref: ethernet-controller.yaml#
 
 maintainers:
-  - Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
+  - Sergei Shtylyov <sergei.shtylyov@gmail.com>
 
 properties:
   compatible:
-- 
2.25.1

