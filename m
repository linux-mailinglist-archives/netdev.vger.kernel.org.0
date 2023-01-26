Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8402C67C50C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbjAZHpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbjAZHpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:45:11 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC401E5F8;
        Wed, 25 Jan 2023 23:45:10 -0800 (PST)
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 6954956120E;
        Thu, 26 Jan 2023 08:45:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1674719109;
        bh=AcuDn/4mWlB8IF8cO+Min+OObHg8XcxrIBL9Fg4uitM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=0NawDJc6T3hiQeotNnTwdGWgHHfUf6nd7aQkITUaggeki+qeC1TtdEm/5DbABaYWi
         DLKlXSzP12CB9atu9v9i8TZvUsljq03VvJuvJF+H5ojTSUfhzyEdu/ykSfVOJCBzkT
         QaS83AZgYzuhQks7Fh66zkzxZ7Uv2nbpVU4vJd/dNS6SMfTmLNYZecq+zVOCjrh508
         RthFp3SkAWdKW2wRvDolij6AZDx207iktwqxeBgLbV94FFggGc3l06KR8R8AkuqsBj
         dBQ97wIuT1QL966LDW2puKHtmIOiosTQkqpPGRS1nrXlnhU4v7SOvlCMaQeToFBfR2
         X87wpnfijFxQA==
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
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [PATCH v2 2/5] dt-bindings: bluetooth: marvell: add max-speed property
Date:   Thu, 26 Jan 2023 08:43:53 +0100
Message-Id: <20230126074356.431306-3-francesco@dolcini.it>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230126074356.431306-1-francesco@dolcini.it>
References: <20230126074356.431306-1-francesco@dolcini.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

The 88W8997 bluetooth module supports setting the max-speed property.

Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
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

