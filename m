Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D624196C63
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 12:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgC2KTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 06:19:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35266 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgC2KTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 06:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:To:From:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5WrfeUimojviy2HjJMi7aeH/0NoQUltqxT3CXWVCzx0=; b=eEi88isOmCrBj9ES1hAHC+gaJ7
        eEhhNuFrM4dtxYeUU3UUu9s1U9BAy8HDqUbR8ry41elB/CCz76xZjcj46eMb55KQMCVzbdjJPeOd9
        gz5z4XzRbgRl9vqMcaCJQQwYsaMhd5jXuUAHFBfLV2aDzTZ6E57gE9edSsluerXShmNrfEYtBxrYX
        8Ard77CCUSwjcovug28TCplnTzkDVlye3EdoO/bBpVR2HK76yGRyR5wOeljVMxeaKBFz4OsQatI4M
        EugXmzrcpn7E9BtdkBY3Ri4BNNjIgK/49y3Qow9Yjlt8wirJghmWZhi8tYqZwsveCPD9uKDe43vPK
        7/maUOxw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:37572 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIV27-0004Li-Hd; Sun, 29 Mar 2020 11:19:11 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jIV26-0005X3-RS; Sun, 29 Mar 2020 11:19:10 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] Update my email address in various drivers
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jIV26-0005X3-RS@rmk-PC.armlinux.org.uk>
Date:   Sun, 29 Mar 2020 11:19:10 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Globally update my email address in six files scattered through the
tree.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/armada/armada_drv.c                 | 2 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c | 2 +-
 drivers/gpu/drm/etnaviv/etnaviv_drv.c               | 2 +-
 drivers/media/cec/cec-notifier.c                    | 2 +-
 drivers/net/phy/swphy.c                             | 2 +-
 include/media/cec-notifier.h                        | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
index 3df2dacf4c94..5a82a12cd105 100644
--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -389,7 +389,7 @@ static void __exit armada_drm_exit(void)
 }
 module_exit(armada_drm_exit);
 
-MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
 MODULE_DESCRIPTION("Armada DRM Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:armada-drm");
diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
index e8e3e9339ff9..f6f55776e43e 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
@@ -698,7 +698,7 @@ static struct platform_driver snd_dw_hdmi_driver = {
 
 module_platform_driver(snd_dw_hdmi_driver);
 
-MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
 MODULE_DESCRIPTION("Synopsis Designware HDMI AHB ALSA interface");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index 1f9c01be40d7..d6798f716b77 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -739,7 +739,7 @@ static void __exit etnaviv_exit(void)
 module_exit(etnaviv_exit);
 
 MODULE_AUTHOR("Christian Gmeiner <christian.gmeiner@gmail.com>");
-MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
+MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
 MODULE_AUTHOR("Lucas Stach <l.stach@pengutronix.de>");
 MODULE_DESCRIPTION("etnaviv DRM Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
index 7cf42b133dbc..2d4f7dd7cef7 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -2,7 +2,7 @@
 /*
  * cec-notifier.c - notify CEC drivers of physical address changes
  *
- * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
+ * Copyright 2016 Russell King.
  * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  */
 
diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
index 53c214a22b95..774814714c82 100644
--- a/drivers/net/phy/swphy.c
+++ b/drivers/net/phy/swphy.c
@@ -2,7 +2,7 @@
 /*
  * Software PHY emulation
  *
- * Code taken from fixed_phy.c by Russell King <rmk+kernel@arm.linux.org.uk>
+ * Code taken from fixed_phy.c by Russell King.
  *
  * Author: Vitaly Bordug <vbordug@ru.mvista.com>
  *         Anton Vorontsov <avorontsov@ru.mvista.com>
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 985afea1ee36..e2b1b894aae7 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -2,7 +2,7 @@
 /*
  * cec-notifier.h - notify CEC drivers of physical address changes
  *
- * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
+ * Copyright 2016 Russell King.
  * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
  */
 
-- 
2.20.1

