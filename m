Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A200B9C0C6
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 00:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfHXWfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 18:35:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbfHXWfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 18:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JrgFcN+3hF6fPV54YEas4uJ+A4FjeYJ7pymyBidX3jY=; b=H9tKmL7Gmd5/kmgtL7n0Au3Zf5
        4+aaYyqkH8vf3+l6pi0HpNx4yIMaw2PlO2u3ffMDsASizxIflqh/c/4EmGjCI8wtmxxJcF8Bv5WQf
        TXGxv8rEejdljikVaB9RUQKPaKpYWS+7pLL1g7XvgTFyNE6bmZXDjQyLXaZBftnaUwDU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1ece-00049d-UP; Sun, 25 Aug 2019 00:35:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     Russell King <rmk+kernel@arm.linux.org.uk>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] MAINTAINERS: Add phylink keyword to SFF/SFP/SFP+ MODULE SUPPORT
Date:   Sun, 25 Aug 2019 00:34:54 +0200
Message-Id: <20190824223454.15932-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell king maintains phylink, as part of the SFP module support.
However, much of the review work is about drivers swapping from phylib
to phylink. Such changes don't make changes to the phylink core, and
so the F: rules in MAINTAINERS don't match. Add a K:, keywork rule,
which hopefully get_maintainers will match against for patches to MAC
drivers swapping to phylink.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 986085351d79..20913acea658 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14491,6 +14491,7 @@ F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
 F:	include/linux/phylink.h
 F:	include/linux/sfp.h
+K:	phylink
 
 SGI GRU DRIVER
 M:	Dimitri Sivanich <sivanich@sgi.com>
-- 
2.23.0

