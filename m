Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8155C5C2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiF1HKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbiF1HKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:10:13 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46362715A;
        Tue, 28 Jun 2022 00:10:12 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 177E922238;
        Tue, 28 Jun 2022 09:10:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1656400210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hI1N+58h3v2qQDIx3pFvKLdYmLIkz3PRy8MDOW/QKAQ=;
        b=trK3jS0NekTSZyUApYuRpAox2op308hN6Fnfrd25RoO1w+tTsthQ12Iz8NvD0XXgieiWZ0
        LYor0Fnh/b+JRtMMKKdBF6L3B7fLYV4iPXaM+ZVRyy/XJKThT6AnHkG/e28UPUYnaE0Z0+
        p+zRXg0XBK4ieGlNcyT12X0CX8+T8pc=
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH] dt-bindings: nfc: nxp,nci: drop Charles Gorand's mail
Date:   Tue, 28 Jun 2022 09:09:59 +0200
Message-Id: <20220628070959.187734-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mails to Charles get an auto reply, that he is no longer working at
Eff'Innov technologies. Remove the entry.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
index e381a3c14836..b2558421268a 100644
--- a/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml
@@ -7,7 +7,6 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: NXP Semiconductors NCI NFC controller
 
 maintainers:
-  - Charles Gorand <charles.gorand@effinnov.com>
   - Krzysztof Kozlowski <krzk@kernel.org>
 
 properties:
-- 
2.30.2

