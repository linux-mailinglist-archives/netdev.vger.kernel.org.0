Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2BF671A29
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjARLNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjARLMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:12:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD9D9B10E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s7R11vXC8jCEXzNre3obdbv7penBql3BMKvWFGkkcQw=; b=sllu7q1eZrQFQGLPjOi8T3dNmR
        m95dpDFw1SOSDgk+t/P+WYqONEjVXQ5Z545bchYHf0viQn1C9qx81r8hYJqdS221EQaKvKbkIOORP
        viXkHbP8b6Objd4gwoCW6CMKbxaBELRcDsg0gJdbouieUCwo6SMsX1gzER19ussGKbjnA9ifT8kTN
        cNbKLuq/n94B4Bh7V5VtB73Is+SnTcOWgydJ94TWAIoxow6SZdOy9aVRhkUbZhxxNvqv83Lj2rKwC
        +XYt6lejD+8iVNqHHasA9n1IlnaW+PpkHQF/DoFAbCsmAzTAF/am+yA2qY/60INQKP07GCEPd0y7p
        /y+rOPPA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41622 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pI5ZH-0001QO-Eb; Wed, 18 Jan 2023 10:21:19 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pI5ZG-006Gog-Gy; Wed, 18 Jan 2023 10:21:18 +0000
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 5/5] net: sfp: remove unused ctype.h include
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pI5ZG-006Gog-Gy@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 Jan 2023 10:21:18 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An include of linux/ctype.h was added in commit 1323061a018a
("net: phy: sfp: Add HWMON support for module sensors") but nothing
was used from this header file. Remove this unnecessary include.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 99cd2b538126..c02cad6478a8 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
-- 
2.30.2

