Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F422964CD9C
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 17:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238923AbiLNQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 11:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238830AbiLNQAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 11:00:47 -0500
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5463B2494B;
        Wed, 14 Dec 2022 07:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1671033588; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=4NhwIP1EYuB9o1p4snNxdHuVCBjGwkTQ0rJ5X1104AM=;
        b=dEFG1uFRBh+iRwWenUkNKoN1N/94+NmU146l9kRG2NEHooacOxA90JXH5jUuf+58m4uz/w
        4rxRT6jp9WA6dA/5cpFDY3Vki/RpBDJ9p3g1qpKbKDwlFg84lmMxwE2LjTFsdOpWmOF7zL
        MeHTsV/XcNRKS/ObuAU3R4avl1N+NBc=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <arend@broadcom.com>
Cc:     list@opendingux.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH] dt-bindings: bcm4329-fmac: Add ingenic,iw8103-fmac compatible string
Date:   Wed, 14 Dec 2022 16:59:43 +0100
Message-Id: <20221214155943.15418-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MIPS CI20 board has a Ingenic IW8103 chip, which is supposedly just
a rebranded Broadcom BCM4330.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 .../devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml      | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
index fec1cc9b9a08..d092c1e7f3ef 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
@@ -40,6 +40,7 @@ properties:
               - brcm,bcm4359-fmac
               - cypress,cyw4373-fmac
               - cypress,cyw43012-fmac
+              - ingenic,iw8103-fmac
           - const: brcm,bcm4329-fmac
       - enum:
           - brcm,bcm4329-fmac
-- 
2.35.1

