Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32272561A9F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235041AbiF3MqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiF3MqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:46:12 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E9621E26;
        Thu, 30 Jun 2022 05:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1656593172; x=1688129172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q8OrJ+LOdUykP7MlWQfd+NOw8NB6lS2i1yFMvfCNmJI=;
  b=h46BYjhsaV8ZMDYiQAA3veO0Fq59TEnS9abLguwthMHfm+7GoI2+IMz5
   ++RsS7XDoK5kh6DCsFJoHG/0noJ1T2IjYcCihAsIqrQ6STXiWFiSYQUc3
   UZY4ZJH60ga44bSlVqtAJwBicwh1vj28rx8qm4MWBBEQ7zBS4ch27Hd+O
   o=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="186455684"
X-IronPort-AV: E=Sophos;i="5.92,234,1650924000"; 
   d="scan'208";a="186455684"
Received: from unknown (HELO mucxv003.muc.infineon.com) ([172.23.11.20])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 14:46:09 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv003.muc.infineon.com (Postfix) with ESMTPS;
        Thu, 30 Jun 2022 14:46:09 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 30 Jun
 2022 14:46:09 +0200
Received: from ISCNPF0RJXQS.infineon.com (172.23.8.247) by
 MUCSE807.infineon.com (172.23.29.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 14:46:07 +0200
From:   Hakan Jansson <hakan.jansson@infineon.com>
CC:     Hakan Jansson <hakan.jansson@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH v2 2/5] dt-bindings: net: broadcom-bluetooth: Add conditional constraints
Date:   Thu, 30 Jun 2022 14:45:21 +0200
Message-ID: <3591c206eeccdacb8b4e702494d799792b752661.1656583541.git.hakan.jansson@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656583541.git.hakan.jansson@infineon.com>
References: <cover.1656583541.git.hakan.jansson@infineon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add conditional constraint to make property "reset-gpios" available only
for compatible devices acually having the reset pin.

Make property "brcm,requires-autobaud-mode" depend on property
"shutdown-gpios" as the shutdown pin is required to enter autobaud mode.

I looked at all compatible devices and compiled the matrix below before
formulating the conditional constraint. This was a pure paper exercise and
no verification testing has been performed.

                                d
                                e
                                v h
                                i o
                                c s
                            s   e t
                            h   - -
                            u   w w       v
                            t r a a     v d
                            d e k k     b d
                            o s e e     a i
                            w e u u     t o
                            n t p p     - -
                            - - - -     s s
                            g g g g     u u
                            p p p p t   p p
                            i i i i x l p p
                            o o o o c p l l
                            s s s s o o y y
    ---------------------------------------
    brcm,bcm20702a1         X X X X X X X X
    brcm,bcm4329-bt         X X X X X X X X
    brcm,bcm4330-bt         X X X X X X X X
    brcm,bcm4334-bt         X - X X X X X X
    brcm,bcm43438-bt        X - X X X X X X
    brcm,bcm4345c5          X - X X X X X X
    brcm,bcm43540-bt        X - X X X X X X
    brcm,bcm4335a0          X - X X X X X X
    brcm,bcm4349-bt         X - X X X X X X
    infineon,cyw55572-bt    X - X X X X X X

Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
---
V1 -> V2:
  - New patch added to series

 .../bindings/net/broadcom-bluetooth.yaml         | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
index 71fe9b17f8f1..445b2a553625 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
@@ -117,6 +117,22 @@ properties:
 required:
   - compatible
 
+dependencies:
+  brcm,requires-autobaud-mode: [ 'shutdown-gpios' ]
+
+if:
+  not:
+    properties:
+      compatible:
+        contains:
+          enum:
+            - brcm,bcm20702a1
+            - brcm,bcm4329-bt
+            - brcm,bcm4330-bt
+then:
+  properties:
+    reset-gpios: false
+
 additionalProperties: false
 
 examples:
-- 
2.25.1

