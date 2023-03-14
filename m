Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5C6B95B6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjCNNM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjCNNMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:12:36 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B6E48E3B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=chZ0p5pooJS4l4YVMMk5XQCw6WQ
        YkRgYzRIcOGy//iI=; b=skYzw9ae+naIVGKOtiCxPExRevoCb639GcELbkWhjEq
        iyQgI1IohL0zZYkNCoEsMiAAlI8UCETPR4aTqMvjhLBdN68cls6j77fcU3hb+JHa
        kQOH2foqvl7cxQQ8IVY+T10liSWGJSyMnuIl5IjCNjueyW2AerZSgyjIAcTIzrb8
        =
Received: (qmail 3103630 invoked from network); 14 Mar 2023 13:48:58 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 14 Mar 2023 13:48:58 +0100
X-UD-Smtp-Session: l3s3148p1@5Cawptv2pOwujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RESEND net-next] net: phy: update obsolete comment about PHY_STARTING
Date:   Tue, 14 Mar 2023 13:48:56 +0100
Message-Id: <20230314124856.44878-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 899a3cbbf77a ("net: phy: remove states PHY_STARTING and
PHY_PENDING") missed to update a comment in phy_probe. Remove
superfluous "Description:" prefix while we are here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
---

Only tag added since last time.

 drivers/net/phy/phy_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 1785f1cead97..c0760cbf534b 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3076,9 +3076,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
  *
- * Description: Take care of setting up the phy_device structure,
- *   set the state to READY (the driver's init function should
- *   set it to STARTING if needed).
+ * Take care of setting up the phy_device structure, set the state to READY.
  */
 static int phy_probe(struct device *dev)
 {
-- 
2.30.2

