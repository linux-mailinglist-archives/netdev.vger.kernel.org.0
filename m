Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EA4646516
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLGX2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiLGX2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:28:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C167C89319;
        Wed,  7 Dec 2022 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670455716; x=1701991716;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=QKPsoAzxeNvFl5hmsKWF6pwp2BAjkHgHkpdCaHRvKJM=;
  b=da9GYtBrFyeQ5MspGJfHE4fwBniPl8V3tKInYgpyiz8aGlQDEbsbLHOW
   3E4P0fjVq4qLOTPCtk0Kk8l6I0vhxV5fJjllAzoBW21TakK0PdZxf4KuZ
   wOxwMXU4SFJvXpEQFDV4fq3rNIuEz93ILHAsKbON5dRTg4SiRTfX3e+Si
   95+qJ7jcMTlP6iFseuK4aFSEGZ2SKL66+de/I9H8rO/mLQZn9h5ZAH54n
   bLxyeZHAw/VY+BYu3xvh6qHH8QQ6GHBKamikSu4CpSl+8H3iFi/Qp+NNi
   nRb7xgTUf4p2nFlxpb45ps+9aUbwp3QwlL9pBvCE9fzmkqTKkF6XrgJUi
   A==;
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="127028537"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2022 16:28:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Dec 2022 16:28:30 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 7 Dec 2022 16:28:29 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v4 1/2] dsa: lan9303: Whitespace Only
Date:   Wed, 7 Dec 2022 17:28:27 -0600
Message-ID: <20221207232828.7367-2-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207232828.7367-1-jerry.ray@microchip.com>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whitespace preparatory patch, making the dsa_switch_ops table consistent.
No code is added or removed.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..d9f7b554a423 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1280,16 +1280,16 @@ static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops lan9303_switch_ops = {
-	.get_tag_protocol = lan9303_get_tag_protocol,
-	.setup = lan9303_setup,
-	.get_strings = lan9303_get_strings,
-	.phy_read = lan9303_phy_read,
-	.phy_write = lan9303_phy_write,
-	.adjust_link = lan9303_adjust_link,
-	.get_ethtool_stats = lan9303_get_ethtool_stats,
-	.get_sset_count = lan9303_get_sset_count,
-	.port_enable = lan9303_port_enable,
-	.port_disable = lan9303_port_disable,
+	.get_tag_protocol	= lan9303_get_tag_protocol,
+	.setup			= lan9303_setup,
+	.get_strings		= lan9303_get_strings,
+	.phy_read		= lan9303_phy_read,
+	.phy_write		= lan9303_phy_write,
+	.adjust_link		= lan9303_adjust_link,
+	.get_ethtool_stats	= lan9303_get_ethtool_stats,
+	.get_sset_count		= lan9303_get_sset_count,
+	.port_enable		= lan9303_port_enable,
+	.port_disable		= lan9303_port_disable,
 	.port_bridge_join       = lan9303_port_bridge_join,
 	.port_bridge_leave      = lan9303_port_bridge_leave,
 	.port_stp_state_set     = lan9303_port_stp_state_set,
-- 
2.17.1

