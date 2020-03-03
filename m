Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA25177703
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgCCN3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:29:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgCCN3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bHX1b2/1S5EkvQkNQ9zS/cLGZRGrR/qQ+LJlvoJKItU=; b=SzS5KFygidT4fdT2l+S426X6VR
        yG7WR1V6n4zvLvjx08lYcfm0/rfT0af24O8meIy1dTPGA8JmObRGjpNQpOXmkVpVdRfRQhV1PTrf8
        NS8NQjBx57VsinMkpkzMlEt5jXApz1R8X0+TcPz7FDxfFiNeskX0y8bs/Z9rMsHOv/znT8bRIF5zv
        X6kVjWx4vOS/aUGhkkC+TkCA9GKOXosK25hPl4ok9F+PsNf7vONF8L3gNXnfEyQHzFm0qaGbwwr8b
        ejAQPnFluj4ymWejQWnBxc5d3gk/YXLhvJuYplJNu78GtrVJ0GiemU/F9vGvQy/dnoONChk8Jq42b
        teTiFtkg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:33522 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j97cF-0008DD-Ig; Tue, 03 Mar 2020 13:29:43 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j97cE-0004aW-Ur; Tue, 03 Mar 2020 13:29:42 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH net-next] doc: sfp-phylink: correct code indentation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j97cE-0004aW-Ur@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 13:29:42 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using vim to edit the phylink documentation reveals some mistakes due
to the "invisible" pythonesque white space indentation that can't be
seen with other editors. Fix it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/sfp-phylink.rst | 32 ++++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index 8d7af28cd835..5aec7c8857d0 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -138,27 +138,27 @@ this documentation.
 
    .. code-block:: c
 
-    static int foo_ethtool_set_link_ksettings(struct net_device *dev,
-					     const struct ethtool_link_ksettings *cmd)
-    {
-	struct foo_priv *priv = netdev_priv(dev);
-
-	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
-    }
-
-    static int foo_ethtool_get_link_ksettings(struct net_device *dev,
-					     struct ethtool_link_ksettings *cmd)
-    {
-	struct foo_priv *priv = netdev_priv(dev);
+	static int foo_ethtool_set_link_ksettings(struct net_device *dev,
+						  const struct ethtool_link_ksettings *cmd)
+	{
+		struct foo_priv *priv = netdev_priv(dev);
+	
+		return phylink_ethtool_ksettings_set(priv->phylink, cmd);
+	}
 
-	return phylink_ethtool_ksettings_get(priv->phylink, cmd);
-    }
+	static int foo_ethtool_get_link_ksettings(struct net_device *dev,
+						  struct ethtool_link_ksettings *cmd)
+	{
+		struct foo_priv *priv = netdev_priv(dev);
+	
+		return phylink_ethtool_ksettings_get(priv->phylink, cmd);
+	}
 
-7. Replace the call to:
+7. Replace the call to::
 
 	phy_dev = of_phy_connect(dev, node, link_func, flags, phy_interface);
 
-   and associated code with a call to:
+   and associated code with a call to::
 
 	err = phylink_of_phy_connect(priv->phylink, node, flags);
 
-- 
2.20.1

