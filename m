Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA66C30AE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCULrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjCULra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:47:30 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C600125956
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=4CSu9xMPWM+eFxOVPsRfLMFc6kq
        Mw0cf0OnDqlkwByY=; b=Mdn6sMDG0YOGHdiYIC0cUTUH/zQA1/Vk2tT40vCv8RF
        ABeS/Va1JGhP/tZ9poahTmTt6qvH2uL75+yXtAWFUskB35V/P+iab0YMsvXV9ViA
        7RFURdov8Cp5pLk4hU25ivVxGVLwWUpsxTkRw/CI96bJoR4kxTPpFAXKugYR0MrM
        =
Received: (qmail 1264852 invoked from network); 21 Mar 2023 12:47:24 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 12:47:24 +0100
X-UD-Smtp-Session: l3s3148p1@qwBmm2f33Icujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] smsc911x: remove superfluous variable init
Date:   Tue, 21 Mar 2023 12:47:20 +0100
Message-Id: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
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

phydev is assigned a value right away, no need to initialize it.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 25e867b74185..037a2b6b89d7 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1016,7 +1016,7 @@ static void smsc911x_phy_adjust_link(struct net_device *dev)
 static int smsc911x_mii_probe(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	struct phy_device *phydev = NULL;
+	struct phy_device *phydev;
 	int ret;
 
 	phydev = phy_find_first(pdata->mii_bus);
-- 
2.30.2

