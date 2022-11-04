Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B219619DDF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiKDQy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKDQye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:54:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FBE42F4A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 09:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3CK19zpWOT/4sAgJfr4neb05V7OTeQD2vO9+boCNt3M=; b=XQv4DFQYxFqJp/wsqOR5S4UR2c
        z4BOcRSLvV1EmiPYj9sORxsdkJZO5T9rLUa36fUIxpkelu2ldPdwSXh93k0NiwxeovehfpFli0qRs
        aGyTluuDWHgJLc1CNgPBR7nT3EDXgZSB6Pq3c6biKiXh2JpH20h5kxihldZRFdEP44B5upIlIg3Ye
        /TRJeWXfxggbqfv13tJE5sKQcIY1ng3JJiDYDgRq+SZ17SxKB3fj3VMTP/ONXQqvBd3Q7aQb1qs/W
        8ogPrqAPhNLRyt9sR7MYTu6OMfqOZ2culNv/bNXbMpEurUjtxfzrb2YbRRL6To8O2k12SVXm0dkst
        2rYBcrJg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:58112 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oqzxA-0007sx-42; Fri, 04 Nov 2022 16:54:00 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oqzx9-001r9g-HV; Fri, 04 Nov 2022 16:53:59 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: lan966x: move unnecessary linux/sfp.h include
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oqzx9-001r9g-HV@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 04 Nov 2022 16:53:59 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lan966x_phylink.c doesn't make use of anything from linux/sfp.h, so
remove this unnecessary include.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
index e4ac59480514..f9579a2ae676 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
@@ -5,7 +5,6 @@
 #include <linux/device.h>
 #include <linux/netdevice.h>
 #include <linux/phy/phy.h>
-#include <linux/sfp.h>
 
 #include "lan966x_main.h"
 
-- 
2.30.2

