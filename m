Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506D3B2ADA
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfINJoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 05:44:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48198 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfINJoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 05:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+RCsecl4XFSAh5od79eQzjyI2W4TVZD7Ov41MQaPwHg=; b=B2O1ieu/xv3HtIIyGDzZTvSIqz
        X1xIwHukl+c0WPyZeT2AojpGit4OTpQksk0kg5HK4EzJFL6iJ4xscjrVqNZhmHbMl1WqHG/TWUOHf
        lrvzGWkqXKqyYHcxJgU9wK8HPPHsGJGXkX7u0DpalRT3h/00Se0TEm6QjmYqsbCylVu2bklWmOu5P
        XDLNmIUMkIREoWS0ZTEpUKb2ttKQuGc1s58ak18oi4xWvQwO9dXyr5h1nHXaIxKRxDe8xFQ3kw2O1
        9VE0vRtUxEvKjf1h61R4z2938X67aqQPKbnwAOZgSHH8APGiggrfk6M4qy+W+lr9iYKBs08pqqfZk
        wqIfNN4A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53340 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1i94b7-00083R-KK; Sat, 14 Sep 2019 10:44:05 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1i94b6-0008TL-IR; Sat, 14 Sep 2019 10:44:04 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] net: phylink: clarify where phylink should be used
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1i94b6-0008TL-IR@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Sep 2019 10:44:04 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the phylink documentation to make it clear that phylink is
designed to be used on the MAC facing side of the link, rather than
between a SFP and PHY.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/sfp-phylink.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index 91446b431b70..a5e00a159d21 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -8,7 +8,8 @@ Overview
 ========
 
 phylink is a mechanism to support hot-pluggable networking modules
-without needing to re-initialise the adapter on hot-plug events.
+directly connected to a MAC without needing to re-initialise the
+adapter on hot-plug events.
 
 phylink supports conventional phylib-based setups, fixed link setups
 and SFP (Small Formfactor Pluggable) modules at present.
-- 
2.7.4

