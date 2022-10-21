Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7C5607A2E
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiJUPKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJUPKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:10:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F271E75FF4;
        Fri, 21 Oct 2022 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7H4ttJKRH0pSFYxxGqIOxLFjjfnbU3ChjsIdXUJw408=; b=XF67eeYTOEbEAmiZa/RuSD3vWf
        7CVMCUpT5UzeaendNWLnxqvFZirMd+jVkXk7WiVXVlXq/Kc8wZ5MKUffiE93GJ+KBkHr8C8QoQVWz
        D5w3MKRB7hSj7FGPF72AuUvGK/l9K1NECcgdXi6SAnVOv8cxMPATTmGtbP12S8IFuFYUwnWCan2cd
        mvXgUeBVu/+56NX5lvCbrM6Ni47KV1efK5CeySXjTUpy2J4ja41mArjjesNi5jgE8d4/eWZP89nxZ
        xNTblnaXExpzmhtDcELtAy1L2qQZ5rTbxHnADW91NHZ8spIy62DWDmANHsMDPECtvIVFXOM5lTZaO
        FKjWZ77Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36032 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1olteq-0000Mu-3c; Fri, 21 Oct 2022 16:10:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oltep-00FwxB-EN; Fri, 21 Oct 2022 16:09:59 +0100
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
Subject: [PATCH net-next 5/7] net: sfp: provide a definition for the power
 level select bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oltep-00FwxB-EN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:09:59 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a named definition for the power level select bit in the
extended status register, rather than using BIT(0) in the code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 6 +++---
 include/linux/sfp.h   | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index af676e28ba6a..16bce0ea68d9 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1837,13 +1837,13 @@ static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 	 * all bytes 0xff) at 0x51 but does not accept writes.  In any case,
 	 * if the bit is already set, we're already in high power mode.
 	 */
-	if (!!(val & BIT(0)) == enable)
+	if (!!(val & SFP_EXT_STATUS_PWRLVL_SELECT) == enable)
 		return 0;
 
 	if (enable)
-		val |= BIT(0);
+		val |= SFP_EXT_STATUS_PWRLVL_SELECT;
 	else
-		val &= ~BIT(0);
+		val &= ~SFP_EXT_STATUS_PWRLVL_SELECT;
 
 	err = sfp_write(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
 	if (err != sizeof(val)) {
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index d1f343853b6c..01ae9f1dd2ad 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -489,6 +489,8 @@ enum {
 	SFP_WARN1_RXPWR_LOW		= BIT(6),
 
 	SFP_EXT_STATUS			= 0x76,
+	SFP_EXT_STATUS_PWRLVL_SELECT	= BIT(0),
+
 	SFP_VSL				= 0x78,
 	SFP_PAGE			= 0x7f,
 };
-- 
2.30.2

