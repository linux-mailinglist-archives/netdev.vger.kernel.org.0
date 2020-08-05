Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F360823CF90
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgHETWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbgHERlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:41:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A27C008696;
        Wed,  5 Aug 2020 07:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gd1cvJcf7uborbbKx0aO1kHmrhM0AMk3ZC07sorW0mo=; b=DviZDtxx2MHlNyWGdaIVddIrjV
        7sJq9PcnuQ4ZdiSVXe1EAuAlrE0jvzCn7CK8//Wq1vSfIkN1vGuKV473qQp451A+CsMXa7cmLdq8i
        EKx+j5bAPfmngqlFK7fdD44UxDgf+cyAy3yJljPRuaUamb2Wu75O5ibPQuDI7JnWiwKP1459ADvbq
        yCCSB3ey+lYFK+fUvUdESznHyu583fr2rv2dCmR/8VSGohwFQzjHR0RrUzCtkWqtw7Nwg9ZA9Xm2j
        j2eG9/eRe+UXPbBeVvjqaa5PvHi/EuSjSmsA6ss3gtsTILcA/4P+AFdKF1DqosTFRnLlktoG0mwQX
        9WIV39tQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53382 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1k3KUx-0003br-SU; Wed, 05 Aug 2020 15:34:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1k3KUx-0000da-In; Wed, 05 Aug 2020 15:34:31 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
Date:   Wed, 05 Aug 2020 15:34:31 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has revealed that the "phylink" keyword exists in non-phylink
related contexts in the bluetooth stack. To avoid receiving
inappropriate notifications, change the keyword matching regexp to
something which avoids this, while still allowing changes to networking
drivers that make use of phylink to be detected.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Linus,

Is this something you're willing to merge directly please?

Thanks.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e2698cc7e23..3b11a8b84129 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15431,7 +15431,7 @@ F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
 F:	include/linux/phylink.h
 F:	include/linux/sfp.h
-K:	phylink
+K:	phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
 
 SGI GRU DRIVER
 M:	Dimitri Sivanich <sivanich@sgi.com>
-- 
2.20.1

