Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8DAE63AF9D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiK1Rnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiK1RnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:43:12 -0500
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18A72934E;
        Mon, 28 Nov 2022 09:40:36 -0800 (PST)
Received: from g550jk.arnhem.chello.nl (unknown [62.108.10.64])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 9705BD05C0;
        Mon, 28 Nov 2022 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1669657204; bh=8fCUumEsdqkqA0wdfT7gwwUflnlTnVBWF8E3m/S4G+k=;
        h=From:To:Cc:Subject:Date;
        b=C1YfUKwJjRSvqFiT7zSYcoesmxWpiWZDRgiaMceSoXhL8CB9w7/jX6B1v5IfSVaq/
         dhS2i0ShYcHgilXERHm1MRBysnYeusAznSUtS1rj+sn6JQ82x7Fwr+lJuE2X9TJdCB
         GI1Gv5HDJhQEMzN0Lpjo5t1Dwro4x6uvtVrjsszQ=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca@z3ntu.xyz>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 1/2] dt-bindings: nfc: nxp,nci: Document NQ310 compatible
Date:   Mon, 28 Nov 2022 18:37:43 +0100
Message-Id: <20221128173744.833018-1-luca@z3ntu.xyz>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NQ310 is another NFC chip from NXP, document the compatible in the
bindings.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
---
RESEND to fix Cc

 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
index b2558421268a..6924aff0b2c5 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -14,7 +14,9 @@ properties:
     oneOf:
       - const: nxp,nxp-nci-i2c
       - items:
-          - const: nxp,pn547
+          - enum:
+              - nxp,nq310
+              - nxp,pn547
           - const: nxp,nxp-nci-i2c
 
   enable-gpios:
-- 
2.38.1

