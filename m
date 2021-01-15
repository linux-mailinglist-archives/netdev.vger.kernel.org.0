Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAFE2F7066
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbhAOCMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731952AbhAOCMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:12:33 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F48C0613D3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:52 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c7so7895000edv.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=shE2e+r/q0Zwkplc5MH4K6d6HyJC9YIcVauvI0gI4cY=;
        b=j1wpvwGEkECPHNnzS7LWh9ilr/J3bC6YQsI8DDM/NUKsgCbUdJh1THpyr9bBF8/Ay7
         T32qPwF//iNLzaEUBMuJuLUQpsZHexRbRRXZGfNsxvW0si62A1GATqta16V+IuwNP0vi
         z7Rn9cFOyQckQYLZvZoATr5QeV7BWzUvHhOW9X+Gy7QCtOy2KEblhCVy0WxxIoU5l1GA
         PNLzkx6J6HT0OaIfCDZ/MJvgrj+9XHX7XPFWHeH0CX1IyfVsRIKV5ZF8WkK6mNQwR2ef
         0ZVhTfxWEj9WpDkdH3azESthIcWsCgRU+zzQQkU5CmN6ghMANF2vTXO8vlXHR+Rh0uU+
         ov+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=shE2e+r/q0Zwkplc5MH4K6d6HyJC9YIcVauvI0gI4cY=;
        b=a3tNcQ6xE1SfoXifEf9DAkdfc9TYju/U0rCRQs2o8MYSsJ9XIAzrUNibCxoG096K3g
         bnP95E4958HTwnjPa2VDoptluxwMkX28xWd3j69l7BXe0/Vgsnz5vTq9kuFhmdrcm4Ne
         U49cXQz1E3TQYFe2+N9RYAllLn0TvJ5UwBaEvbQMCmWCWXqso81geulBfU2YhGnAagWh
         6tK5n+nfRNLMMuOp5qCRX1m1rQQ9XsjuxPEAse+zABViwD6Vi8Dlb0oyFxL3DP1fCkXq
         RLg5l8Dai7JrOjMRGN+t1y38D0+NDjpOSf3xa8F/XqNTE+PlvLmlqkeqg2C9XqyoRN/r
         cKww==
X-Gm-Message-State: AOAM530W3ZQt3P9gFhdu6QMBALq+NIEZRQym7uAK3v0A9gG8bfeIc64U
        IKV5nsOZwRadZU/G6rv/sBM=
X-Google-Smtp-Source: ABdhPJwFMQO99OjtxX+U/0NdzkrYOOMAgJVKBM8BktQVJNAb1aJOe7j1qxUfdRfwM3dR907rE021rg==
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr7999456edb.231.1610676711399;
        Thu, 14 Jan 2021 18:11:51 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 04/10] net: dsa: felix: reindent struct dsa_switch_ops
Date:   Fri, 15 Jan 2021 04:11:14 +0200
Message-Id: <20210115021120.3055988-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The devlink function pointer names are super long, and they would break
the alignment. So reindent the existing ops now by adding one tab.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

Changes in v5:
Rebase on top of recent series d1c8b6a3dd77 ("Merge branch
'get-rid-of-the-switchdev-transactional-model'") which got rid of
.port_mdb_prepare and .port_vlan_prepare.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 74 +++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index be5c417f39b8..532e038e8012 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -752,43 +752,43 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
 }
 
 const struct dsa_switch_ops felix_switch_ops = {
-	.get_tag_protocol	= felix_get_tag_protocol,
-	.setup			= felix_setup,
-	.teardown		= felix_teardown,
-	.set_ageing_time	= felix_set_ageing_time,
-	.get_strings		= felix_get_strings,
-	.get_ethtool_stats	= felix_get_ethtool_stats,
-	.get_sset_count		= felix_get_sset_count,
-	.get_ts_info		= felix_get_ts_info,
-	.phylink_validate	= felix_phylink_validate,
-	.phylink_mac_config	= felix_phylink_mac_config,
-	.phylink_mac_link_down	= felix_phylink_mac_link_down,
-	.phylink_mac_link_up	= felix_phylink_mac_link_up,
-	.port_enable		= felix_port_enable,
-	.port_disable		= felix_port_disable,
-	.port_fdb_dump		= felix_fdb_dump,
-	.port_fdb_add		= felix_fdb_add,
-	.port_fdb_del		= felix_fdb_del,
-	.port_mdb_add		= felix_mdb_add,
-	.port_mdb_del		= felix_mdb_del,
-	.port_bridge_join	= felix_bridge_join,
-	.port_bridge_leave	= felix_bridge_leave,
-	.port_stp_state_set	= felix_bridge_stp_state_set,
-	.port_vlan_filtering	= felix_vlan_filtering,
-	.port_vlan_add		= felix_vlan_add,
-	.port_vlan_del		= felix_vlan_del,
-	.port_hwtstamp_get	= felix_hwtstamp_get,
-	.port_hwtstamp_set	= felix_hwtstamp_set,
-	.port_rxtstamp		= felix_rxtstamp,
-	.port_txtstamp		= felix_txtstamp,
-	.port_change_mtu	= felix_change_mtu,
-	.port_max_mtu		= felix_get_max_mtu,
-	.port_policer_add	= felix_port_policer_add,
-	.port_policer_del	= felix_port_policer_del,
-	.cls_flower_add		= felix_cls_flower_add,
-	.cls_flower_del		= felix_cls_flower_del,
-	.cls_flower_stats	= felix_cls_flower_stats,
-	.port_setup_tc		= felix_port_setup_tc,
+	.get_tag_protocol		= felix_get_tag_protocol,
+	.setup				= felix_setup,
+	.teardown			= felix_teardown,
+	.set_ageing_time		= felix_set_ageing_time,
+	.get_strings			= felix_get_strings,
+	.get_ethtool_stats		= felix_get_ethtool_stats,
+	.get_sset_count			= felix_get_sset_count,
+	.get_ts_info			= felix_get_ts_info,
+	.phylink_validate		= felix_phylink_validate,
+	.phylink_mac_config		= felix_phylink_mac_config,
+	.phylink_mac_link_down		= felix_phylink_mac_link_down,
+	.phylink_mac_link_up		= felix_phylink_mac_link_up,
+	.port_enable			= felix_port_enable,
+	.port_disable			= felix_port_disable,
+	.port_fdb_dump			= felix_fdb_dump,
+	.port_fdb_add			= felix_fdb_add,
+	.port_fdb_del			= felix_fdb_del,
+	.port_mdb_add			= felix_mdb_add,
+	.port_mdb_del			= felix_mdb_del,
+	.port_bridge_join		= felix_bridge_join,
+	.port_bridge_leave		= felix_bridge_leave,
+	.port_stp_state_set		= felix_bridge_stp_state_set,
+	.port_vlan_filtering		= felix_vlan_filtering,
+	.port_vlan_add			= felix_vlan_add,
+	.port_vlan_del			= felix_vlan_del,
+	.port_hwtstamp_get		= felix_hwtstamp_get,
+	.port_hwtstamp_set		= felix_hwtstamp_set,
+	.port_rxtstamp			= felix_rxtstamp,
+	.port_txtstamp			= felix_txtstamp,
+	.port_change_mtu		= felix_change_mtu,
+	.port_max_mtu			= felix_get_max_mtu,
+	.port_policer_add		= felix_port_policer_add,
+	.port_policer_del		= felix_port_policer_del,
+	.cls_flower_add			= felix_cls_flower_add,
+	.cls_flower_del			= felix_cls_flower_del,
+	.cls_flower_stats		= felix_cls_flower_stats,
+	.port_setup_tc			= felix_port_setup_tc,
 };
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
-- 
2.25.1

