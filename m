Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9760479D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbiJSNmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbiJSNlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B1B190E47;
        Wed, 19 Oct 2022 06:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S60rxcbm9SKKnx03gyUf4MEo4iXOvL9J8IAsBwwkSM4=; b=jlXviFSMe9bp3Ao33itgTN4Qah
        z2TyP1pvVlValbpJ2PDxf9zoCjjVTyXXPN0/GT2Fq5DX89jwBWXz0gKBfpiS5jkXTUpvH9gKnrDJH
        LQt2qcf66rPixTV362DcPvcC7tLK77R6RhY+cY4pT/3mjCVOtbOzpLIGtTTWRuJ75qGGPhFL6rP7V
        luj6yOh8hLVWYAKhZVKdzn12lX9dnfHrD+hlMjxzXGxIfZztWgWdIJPurMyFaMyJk56l3nIqBm0kp
        41PO8nJts1ng5EE3mCcfGBTEl7nuWl6vw8l8Djr7CoGilqNAgXm5Nx3lopJtgaDnWEUwfuHlbAyTo
        HUXDI1HQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57648 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ol97m-0005j2-N4; Wed, 19 Oct 2022 14:28:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ol97m-00EDSR-46; Wed, 19 Oct 2022 14:28:46 +0100
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 19 Oct 2022 14:28:46 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
index 06c66ab81c01..20d30cccc95e 100644
--- a/Documentation/devicetree/bindings/net/sff,sfp.yaml
+++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
@@ -23,6 +23,8 @@ title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
 
   maximum-power-milliwatt:
     maxItems: 1
+    minimum: 1000
+    default: 1000
     description:
       Maximum module power consumption Specifies the maximum power consumption
       allowable by a module in the slot, in milli-Watts. Presently, modules can
-- 
2.30.2

