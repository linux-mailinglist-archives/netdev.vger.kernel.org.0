Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BAB2F62E2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbhANOQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbhANOQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:36 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B12C0613D6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b6so5379224edx.5
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+PQQR+pbN78MJUePLDN44X0j2BBjusPk7oXjgD5J+LQ=;
        b=CHFkHepJdmCSFoVLfvfl3AQwUNgqj0AHvhko6MueY0OO5LQo61Pp+eDHlgmBph1p2G
         pBZhJlumKxgCG0K5mgnuktI6eku2YnVnMiO/XQ1C9dcHIj75u1pMEE0QMc3bQOhDPmzU
         omB00nD/b/0AW1x+xw13vUE/Pkyzh4o/zSjHwhkNxXpiZLZ2ygGRzAm8mwwikRI1m/UU
         ess5QL8szpHaK6d8wS97GHO0xW3McDBExt/Bw7Pp+O9MDhyAUTC5eDQ5UqlHidCZb8Np
         u6pQCh848mDyy1SpdTk0y/QD83yGLXigY3Eq8C2IYupGmSwRqjhlTqXWiYD1PmSVbziB
         VWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+PQQR+pbN78MJUePLDN44X0j2BBjusPk7oXjgD5J+LQ=;
        b=fZsegAhiWgR/+uLNgPkzWc7KAKGVr6oEBxE7lJq6E1u48lH0BetZzhdoatMrz/MZyT
         w5zFV164CyiAKtWtNo4Lo+2I/VzxgBgWckB6OXr46nvBHxt4rniLoyMpjb6+Rpt9KP41
         JQ/nkAZh4eWKK4BPZFk0ufl2cOnhOoYKMNoZZu+2hgaXDACmMrfawdWBRhwjF4x85AlT
         HRiMH2/r9cAIMLD7MqKUZ2fyG49MrgjwukNnxszDseTxlPRC3DBgQZHD1O+XnrBI7JlY
         If0JDkAG54480o1gR5ZmZPDLEDH3H+5xpZAI6GzHGqEDKjPHkvDVMiKQehNlaXP+s3Pk
         UwPg==
X-Gm-Message-State: AOAM532G/3k8YE+AFfwqxARC9NISk+MGKwtC1/yZzXUPU0ENOPvfI28V
        b22x6OquWbaxpIzezNeyJxA=
X-Google-Smtp-Source: ABdhPJxCfAHgc5PXZap5pL3mtl3HOk7WhZgVs02lFMh0Kafq9Ew+yGBPkL8Ptc2UKPY3hOcTfcB6bg==
X-Received: by 2002:a05:6402:129a:: with SMTP id w26mr6108905edv.355.1610633745818;
        Thu, 14 Jan 2021 06:15:45 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 04/10] net: dsa: felix: reindent struct dsa_switch_ops
Date:   Thu, 14 Jan 2021 16:15:16 +0200
Message-Id: <20210114141522.2478059-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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

