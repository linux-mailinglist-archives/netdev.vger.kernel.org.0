Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA26145C62
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:23:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50456 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgAVTXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 14:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0OAIoUcA6mEBLXETKxlwBD5GmoUZBZ0yYQC4Tu6f3jw=; b=1XBTahJKKNg2l3lJBQBLKaRzhj
        y+ZW7q8XUdaPhgVupWl4NwNEdV9ixqQLLHxA8R4UChcO0T/OmDup5jJVcAU+1uOWYSJTfTaojFI3b
        6YRdQ3S1T53EPxCdla2Jt87GSP3Y+NvsJDl82aWhmXbuyt34dD1G2kwtsRsdd3pZJgpY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iuLb6-0003Q6-Ei; Wed, 22 Jan 2020 20:23:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] MAINTAINERS: Make Russell King designated reviewer of phylib
Date:   Wed, 22 Jan 2020 20:23:15 +0100
Message-Id: <20200122192315.13105-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink and phylib are interconnected. It makes sense for phylib and
phy driver patches to be also reviewed by the phylink maintainer.
So add Russell King as a designed reviewer of phylib.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf6ccca6e61c..714ea9cf9b65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6197,6 +6197,7 @@ ETHERNET PHY LIBRARY
 M:	Andrew Lunn <andrew@lunn.ch>
 M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Heiner Kallweit <hkallweit1@gmail.com>
+R:	Russell King <linux@armlinux.org.uk>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-class-net-phydev
-- 
2.25.0.rc2

