Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6766A1FE9
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBXQod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBXQo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:44:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513622ED54
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nXSfiipuTd+Fnhrm3YCd4qbd27V7OVFGbx29QEQMM8M=; b=YP5s9YLKRegYocR9Wsneaak36i
        f228YGwu+zlRNbZRDUD1fXUbXuFuauM2rkSswyyMUoRL9/mDSsM5za3s8BcgGHBpp8GatPxDXDEHA
        9OmZ62ozrljl9oVRX14N8o4j5WAhahtNcqJSp45adlXoDgXlUHCe6I74BmNFB69fOw/f5m8VSumnZ
        LIVevyjPxaEAcIJlfEsD1OQ34kaQaWHkNmMl/qPcdoLL9XlrlM1Z2+wKfHDpUYhARceWuIrGF26i2
        xeTFl0jJpX6+Fk+ihzo/OUX3pfTGE1VvP4scbU4VuVv67Qny/tQErD9o73VSZ6+kMcSa+D4VQX4Fw
        g+9Svqjg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:33252 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pVbBG-0000vV-8e; Fri, 24 Feb 2023 16:44:22 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pVbBE-00CiJn-NK; Fri, 24 Feb 2023 16:44:21 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: ocelot_ext: remove unnecessary phylink.h
 include
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pVbBE-00CiJn-NK@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Feb 2023 16:44:20 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During review of ocelot_ext, it created a private phylink instance
that wasn't necessary. This was removed for subsequent postings,
but the include file seems to have been left behind. Remove it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/ocelot/ocelot_ext.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index 14efa6387bd7..9b66d66ab0a9 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/mfd/ocelot.h>
-#include <linux/phylink.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <soc/mscc/ocelot.h>
-- 
2.30.2

