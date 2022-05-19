Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05752D543
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiESN5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbiESN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:08 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923162AD2;
        Thu, 19 May 2022 06:57:03 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 613DE24001A;
        Thu, 19 May 2022 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QPggy8DjxLmgMYSoeke7qJ+fzc4rcw2qLCr35/LZ95U=;
        b=eXmcVNZEpkG/9pDpy7nmw3FauLQz7qRAEaKixvmmNUMQBykSenPtBG3UJEfzr7Sl1qdNh0
        4lYq4Cdu3XveCT1sIq7Mh6Yn8ZRWBYNjsRFMls4Ql3qNcfIRZNCWS+yaL8Ztu6WUrMpqM+
        r0HfK1/WU2rPdlnyJCNAoyMku+cB6fxpE3rOZLwBXRPyuB3oQNXo3uYFrrhqdI0IQPBxrb
        Z5yiCFORBBwkfnlnuUgK47/n+4dxXh6aYogksPiDd8c9Sa3+Apaj34jIIAvLOjLrSgVDKB
        zvHuJoHFNjTlmn2hBc5U555aLmc6pNa0Z2LOEvdey9wfkN/xQwaymwerCy0aPg==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/6] dt-bindings: net: ethernet-controller: add QUSGMII mode
Date:   Thu, 19 May 2022 15:56:43 +0200
Message-Id: <20220519135647.465653-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new QUSGMII mode, standing for "Quad Universal Serial Gigabit
Media Independent Interface", a derivative of USGMII which, similarly to
QSGMII, allows to multiplex 4 1Gbps links to a Quad-PHY.

The main difference with QSGMII is that QUSGMII can include an extension
instead of the standard 7bytes ethernet preamble, allowing to convey
arbitrary data such as Timestamps.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4f15463611f8..dccde2033697 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -67,6 +67,7 @@ properties:
       - gmii
       - sgmii
       - qsgmii
+      - qusgmii
       - tbi
       - rev-mii
       - rmii
-- 
2.36.1

