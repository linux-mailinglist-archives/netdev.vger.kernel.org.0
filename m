Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51576689B59
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjBCOQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjBCOQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:16:35 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689E71E292;
        Fri,  3 Feb 2023 06:15:52 -0800 (PST)
Received: from robin.home.jannau.net (p579ad32f.dip0.t-ipconnect.de [87.154.211.47])
        by soltyk.jannau.net (Postfix) with ESMTPSA id 69B0C26F705;
        Fri,  3 Feb 2023 14:56:34 +0100 (CET)
From:   Janne Grunau <j@jannau.net>
Date:   Fri, 03 Feb 2023 14:56:28 +0100
Subject: [PATCH RFC 3/3] dt-bindings: wireless: silabs,wfx: Use
 network-class.yaml
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230203-dt-bindings-network-class-v1-3-452e0375200d@jannau.net>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
In-Reply-To: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?utf-8?q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Janne Grunau <j@jannau.net>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1118; i=j@jannau.net;
 h=from:subject:message-id; bh=ovshDuNDGC464wNETrmVoRhcUISyfcSallBxPCefdv4=;
 b=owGbwMvMwCG2UNrmdq9+ahrjabUkhuS7QhOy9Zrt/ltu1Wy+49587t9Hpdrn/u5+ZZsyE67X3
 FhyVEe+o5SFQYyDQVZMkSVJ+2UHw+oaxZjaB2Ewc1iZQIYwcHEKwETMPzIybG6xaS/Y62gZKpC4
 6eA33uAl4alrQ7d4X9sXF+b0OnzRbkaGdz3PZutbz31cU/VTYf+bsFUht/az9jxa9zx2Qb/Nl4+
 9rAA=
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

