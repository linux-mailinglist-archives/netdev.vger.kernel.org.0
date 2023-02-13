Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EBF694566
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjBMMKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjBMMKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:10:32 -0500
Received: from smtp-out-12.comm2000.it (smtp-out-12.comm2000.it [212.97.32.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F35C65B;
        Mon, 13 Feb 2023 04:10:20 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-12.comm2000.it (Postfix) with ESMTPSA id E2E69BA18AA;
        Mon, 13 Feb 2023 13:09:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1676290173;
        bh=ZBdd6jReF6OGzDkpDCBEFnRQ9Nb4Kiy4J3ULuyTX7jY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=f55vHz1ax0tmhIrCkpjDnVCpoUnpTgbqOZPVRXyRp4O0FW8ruGEZGZZd8vBBp9WO6
         4c5OpytwGmmEM15H+SQlyOJl0dYH+qp6ELo3yA1oMGw6QwC84f8EKUbYej1qG5XOL1
         1M99jCtCmWRp8vWfidd26DDt/CN/K8J78U+8M89ZtjcSBHtxGwoFksdw+B5W/JFNX5
         2BaTgrIwIVfvL3Y2kKhG45TYwraCndbOQiAVVC+0VubfyuHsLf1sGBva96rcUDSSgk
         453gcXU3LfAbrADOMvQC2/V/SluKAuMXdb1oEAj9IUjwiQ3fJTEooYp5I/09oTK/gl
         z4NM6W1HEmRLQ==
From:   Francesco Dolcini <francesco@dolcini.it>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 2/5] dt-bindings: bluetooth: marvell: add max-speed property
Date:   Mon, 13 Feb 2023 13:09:23 +0100
Message-Id: <20230213120926.8166-3-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213120926.8166-1-francesco@dolcini.it>
References: <20230213120926.8166-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

The 88W8997 bluetooth module supports setting the max-speed property.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v3: add Reviewed-by Krzysztof
v2: fixed indentation
---
 .../bindings/net/marvell-bluetooth.yaml          | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
index 83b64ed730f5..516c63ad165a 100644
--- a/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
@@ -19,9 +19,25 @@ properties:
       - mrvl,88w8897
       - mrvl,88w8997
 
+  max-speed:
+    description: see Documentation/devicetree/bindings/serial/serial.yaml
+
 required:
   - compatible
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: mrvl,88w8997
+    then:
+      properties:
+        max-speed: true
+    else:
+      properties:
+        max-speed: false
+
 additionalProperties: false
 
 examples:
-- 
2.25.1

