Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0B607A24
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiJUPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiJUPJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:09:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196BF357F8;
        Fri, 21 Oct 2022 08:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dJnfrd9PAQikF9AnaX83iDIDtvEV0H9qvFXsF0c/yNc=; b=GHp4OD5Qwe/AEjWlJ/50d28rQh
        F+jnP5LqHDO34lwl3PCDIcKLZV2hHrUUJPWRyeNxr0gHvTi4zl9IUUK3Y4KTrE9BBJXyg6vzYOuYu
        hNrfrGwn5CLYV17y850rXtq5xPD8eBg6tqAwgIIwpAVBrHxt4LY7jaGezhI3H7S+chxci+s0tREO9
        5uhwvaJUXvO28yJ1OTnEU2SX38RX1N6oz6N0PR790OAJv/Ltqyu/rMpW7Ba547ZLwCZJXVu0H0q3t
        cXKpQ7usHQU1ZNWZdnLxLL0/+57JjXv6OypqJyR9QWNG55skUHDrfBwsMgFoLlBt3PUEN44jlQixL
        LV4NGeQA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52004 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1olteV-0000M2-EX; Fri, 21 Oct 2022 16:09:39 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1olteU-00Fwwi-PT; Fri, 21 Oct 2022 16:09:38 +0100
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1olteU-00Fwwi-PT@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:09:38 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a minimum and default for the maximum-power-milliwatt option;
module power levels were originally up to 1W, so this is the default
and the minimum power level we can have for a functional SFP cage.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 Documentation/devicetree/bindings/net/sff,sfp.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
index 06c66ab81c01..231c4d75e4b1 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.yaml
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -22,7 +22,8 @@ title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
       phandle of an I2C bus controller for the SFP two wire serial
 
   maximum-power-milliwatt:
-    maxItems: 1
+    minimum: 1000
+    default: 1000
     description:
       Maximum module power consumption Specifies the maximum power consumption
       allowable by a module in the slot, in milli-Watts. Presently, modules can
-- 
2.30.2

