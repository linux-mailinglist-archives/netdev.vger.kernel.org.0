Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FEC43C9D2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhJ0MlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241931AbhJ0MlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:41:07 -0400
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59A2C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 05:38:41 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:441:6c1a:bc30:46e])
        by andre.telenet-ops.be with bizsmtp
        id B0ef2600N2hfXWm010efZz; Wed, 27 Oct 2021 14:38:40 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mfiCV-008TyQ-Jl; Wed, 27 Oct 2021 14:38:39 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mfiCV-00DsYo-2m; Wed, 27 Oct 2021 14:38:39 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Lechner <david@lechnology.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: ti,bluetooth: Document default max-speed
Date:   Wed, 27 Oct 2021 14:38:37 +0200
Message-Id: <0c6a08c714aeb6dd96b5a54a45b0b5b1cfb49ad1.1635338283.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the default value of max-speed, as used by
linux/drivers/bluetooth/hci_ll.c.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/ti,bluetooth.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,bluetooth.yaml b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
index 9f6102977c9732d2..81616f9fb4935f96 100644
--- a/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
@@ -58,7 +58,8 @@ properties:
     items:
       - const: ext_clock
 
-  max-speed: true
+  max-speed:
+    default: 3000000
 
   nvmem-cells:
     maxItems: 1
-- 
2.25.1

