Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC4693730
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjBLMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBLMQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:16:36 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4638E10A9F;
        Sun, 12 Feb 2023 04:16:34 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id A702E26F76E;
        Sun, 12 Feb 2023 13:16:32 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Sun, 12 Feb 2023 13:16:31 +0100
Subject: [PATCH v2 3/4] dt-bindings: wireless: silabs,wfx: Use
 network-class.yaml
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230203-dt-bindings-network-class-v2-3-499686795073@jannau.net>
References: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v2-0-499686795073@jannau.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Ley Foon Tan <lftan@altera.com>,
        Chee Nouk Phoon <cnphoon@altera.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1118; i=j@jannau.net;
 h=from:subject:message-id; bh=ovshDuNDGC464wNETrmVoRhcUISyfcSallBxPCefdv4=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuQXN+alx3CxLI9rfcnzdlVo2Kd/120/62z43rp4tvDjA
 9uXMd3i6ShlYRDjYJAVU2RJ0n7ZwbC6RjGm9kEYzBxWJpAhDFycAjCRKxcYGVo+Nn9T+74grP+U
 uoHg2Rdb37GsEXnLd2eN7dKEyIeLunUZ/in8fMH7j2dh5ZTtPd+P6uwXY5N/8N1Cu7LQfGfe9Lx
 9elwA
X-Developer-Key: i=j@jannau.net; a=openpgp;
 fpr=8B336A6BE4E5695E89B8532B81E806F586338419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead listing local-mac-address and mac-address properties, reference
network-class.yaml schema. The schema brings in constraints for the
property checked during `make dtbs_check`.

Signed-off-by: Janne Grunau <j@jannau.net>
---
 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
index 583db5d42226..2ce50b57c096 100644
--- a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
@@ -72,15 +72,12 @@ properties:
       "Platform Data Set" in Silabs jargon). Default depends of "compatible"
       string. For "silabs,wf200", the default is 'wf200.pds'.
 
-  local-mac-address: true
-
-  mac-address: true
-
 required:
   - compatible
   - reg
 
 allOf:
+  - $ref: /schemas/net/network-class.yaml#
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 unevaluatedProperties: false

-- 
2.39.1

