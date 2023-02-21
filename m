Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8893269DE4B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 11:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbjBUK5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 05:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbjBUK5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 05:57:23 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A232310F
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 02:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=M7RzLbXZOIllntRuk7Nu120A8Hl
        RD9lJwcHW5xHabrQ=; b=XP5BTuJBK+l6HciE41iy2ZX9Sfxnj+eoP+3wtMENDHv
        luzpy6C5Bp8oeiJyQOSvdOYQCYDvo0QOhT4ftIUBoZjDvKrElhD+gTlwNSzZhXiO
        2ZkfyDCi7+uJ1Rl7708pHJoaDoucD8ejp4IWf1PY+Zmoswcr9pDdcHso3kfrhAko
        =
Received: (qmail 154227 invoked from network); 21 Feb 2023 11:57:16 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Feb 2023 11:57:16 +0100
X-UD-Smtp-Session: l3s3148p1@z0SQpDP16MJehh92
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: phy: update obsolete comment about PHY_STARTING
Date:   Tue, 21 Feb 2023 11:57:11 +0100
Message-Id: <20230221105711.39364-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 899a3cbbf77a ("net: phy: remove states PHY_STARTING and
PHY_PENDING") missed to update a comment in phy_probe. Remove
superfluous "Description:" prefix while we are here.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/phy/phy_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8cff61dbc4b5..3a515955ffd8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3019,9 +3019,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
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

