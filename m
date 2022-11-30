Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E220663E0D9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiK3ThV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiK3ThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:37:17 -0500
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22208B1BC
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dTCsDCK5mkFfnci1vyknheVre0eQw9Eea8H0FLW8N18=; b=tj6OM174YZ5242BmHTXNzkSpDc
        1g/hShAzpm5idkV1Qc5woQzXykTIeKCqxtv70r8ra03gtgpSDhsP+icrW/pSL5AGjFF6CYnx/GA3q
        T8DLB0GGDBL/Si8yBR4S5LSOwsDo53n5bGnhCY5Y0BfNTKMWn6UMkBnRJrfCITVpGgAA=;
Received: from 88-117-56-227.adsl.highway.telekom.at ([88.117.56.227] helo=hornet.engleder.at)
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p0StN-0004tu-Ul; Wed, 30 Nov 2022 20:37:14 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 1/4] tsnep: Consistent naming of struct net_device
Date:   Wed, 30 Nov 2022 20:37:05 +0100
Message-Id: <20221130193708.70747-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130193708.70747-1-gerhard@engleder-embedded.com>
References: <20221130193708.70747-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_ethtool.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index a713a126b227..c2640e88f347 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -250,10 +250,10 @@ static int tsnep_ethtool_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
-static int tsnep_ethtool_get_rxnfc(struct net_device *dev,
+static int tsnep_ethtool_get_rxnfc(struct net_device *netdev,
 				   struct ethtool_rxnfc *cmd, u32 *rule_locs)
 {
-	struct tsnep_adapter *adapter = netdev_priv(dev);
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	switch (cmd->cmd) {
 	case ETHTOOL_GRXRINGS:
@@ -273,10 +273,10 @@ static int tsnep_ethtool_get_rxnfc(struct net_device *dev,
 	}
 }
 
-static int tsnep_ethtool_set_rxnfc(struct net_device *dev,
+static int tsnep_ethtool_set_rxnfc(struct net_device *netdev,
 				   struct ethtool_rxnfc *cmd)
 {
-	struct tsnep_adapter *adapter = netdev_priv(dev);
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
@@ -288,10 +288,10 @@ static int tsnep_ethtool_set_rxnfc(struct net_device *dev,
 	}
 }
 
-static int tsnep_ethtool_get_ts_info(struct net_device *dev,
+static int tsnep_ethtool_get_ts_info(struct net_device *netdev,
 				     struct ethtool_ts_info *info)
 {
-	struct tsnep_adapter *adapter = netdev_priv(dev);
+	struct tsnep_adapter *adapter = netdev_priv(netdev);
 
 	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
 				SOF_TIMESTAMPING_RX_SOFTWARE |
-- 
2.30.2

