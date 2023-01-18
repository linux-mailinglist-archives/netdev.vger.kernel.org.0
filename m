Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69703671A27
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjARLMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjARLLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:11:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664C2798E6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nfq8arK8lAT1I690b2UJZQYZp8sTGHxxbY98Iym0lwg=; b=JVjpai36ZqRNcQrTR0hXL6rlH4
        RoZUkRxlV9uhD3CFQx99bfdZ3rBP4Fa1PnC+ocFJVyKYEwczls7pX4BJPldB9qS7ujd9Wf6ALoWx/
        WmOF6KyD2hJj0tG5Zy8nyvDyBwFOoz+PLrqfAWtaUacjoyub1X6fi4vkScrDKLf8d3KwwJmvPvXI/
        JIjF3rl1C8sq+N4pXkbX3ECrqHVOKarU7teqDmNrpauStYw67KcOfxeEqlPjhaD8Ppi5y0cfmFB3J
        DETg/DLOXRZ/4YUqtlpI2CD6gaO+GqOnvjFtnGlxFO2TyH5e9Xpb3WCse1GbO47zjvKozCqxp9K5F
        uMPLoznw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60644 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pI5Z7-0001Q0-96; Wed, 18 Jan 2023 10:21:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pI5Z6-006GoU-Am; Wed, 18 Jan 2023 10:21:08 +0000
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/5] net: sfp: rename gpio_of_names[]
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pI5Z6-006GoU-Am@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 Jan 2023 10:21:08 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's nothing DT specific about the gpio_of_names array, let's drop
the _of infix.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 402dcdd59acb..64dfc5f1ea7b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -144,7 +144,7 @@ static const char *sm_state_to_str(unsigned short sm_state)
 	return sm_state_strings[sm_state];
 }
 
-static const char *gpio_of_names[] = {
+static const char *gpio_names[] = {
 	"mod-def0",
 	"los",
 	"tx-fault",
@@ -2563,7 +2563,7 @@ static void sfp_check_state(struct sfp *sfp)
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
-			dev_dbg(sfp->dev, "%s %u -> %u\n", gpio_of_names[i],
+			dev_dbg(sfp->dev, "%s %u -> %u\n", gpio_names[i],
 				!!(sfp->state & BIT(i)), !!(state & BIT(i)));
 
 	state |= sfp->state & (SFP_F_TX_DISABLE | SFP_F_RATE_SELECT);
@@ -2698,7 +2698,7 @@ static int sfp_probe(struct platform_device *pdev)
 	for (i = 0; i < GPIO_MAX; i++)
 		if (sff->gpios & BIT(i)) {
 			sfp->gpio[i] = devm_gpiod_get_optional(sfp->dev,
-					   gpio_of_names[i], gpio_flags[i]);
+					   gpio_names[i], gpio_flags[i]);
 			if (IS_ERR(sfp->gpio[i]))
 				return PTR_ERR(sfp->gpio[i]);
 		}
@@ -2753,7 +2753,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 		sfp_irq_name = devm_kasprintf(sfp->dev, GFP_KERNEL,
 					      "%s-%s", dev_name(sfp->dev),
-					      gpio_of_names[i]);
+					      gpio_names[i]);
 
 		if (!sfp_irq_name)
 			return -ENOMEM;
-- 
2.30.2

