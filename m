Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8BC2F1CD7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389854AbhAKRo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389724AbhAKRoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:44:21 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA66C0617A4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:38 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id 6so839874ejz.5
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4aWyxvzlFdDiguqtgzua44Y34g4NesrY17Od0FDJYHE=;
        b=rcoI91gkk0QvSIAOjhrr+NoZjVhHfnloKiMtgIkzy1Ho+QokQ7Q8ePG1iIUNCNYLhl
         9Kx4Aq2qgTQCTHqBXW2ZAAoeBkLM/F2w+PO8nf1iDhr/dYerSXJF0emJneZzlTBuf/hk
         YV1WOa7WFWfK6g49b6u/OQ/IJiO+VzlXJDbEkBk04sUT+HHfuGtwr/h2NO9wc7Iswsn4
         FOIlYsYn4IHEwgSJl2Zn49yzhzMfGOAmBRhs5WlYCcBj9rdnHjwZhSXLeG0dRvK8l1vC
         OZ4/PT/DHjOcRlCIFvZpg3gjXhfd+o0QfzX1NF6OOihjS4q+1sz/7fVg/BTPYSVVQNUe
         f9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4aWyxvzlFdDiguqtgzua44Y34g4NesrY17Od0FDJYHE=;
        b=DQFPSjjeRaZnmzJ/ePvBDy55AFXBg8xHN9nMYu4RTTkJkZ/8o85YJsc0sbEOIq/Oo2
         ZhICbHW++8BvoWd4aFljLjPFJgDRmyKOS6JG/eyx92Cjl4Z+YoK62ZCoi2HCgJUpxv6r
         7dkiTB8WK+uHHpOa3rtY2zBHXLJa7rmOLTmVF0tRBjXwjDg5KI6g61H3U+qTPIVUb5s8
         PxBmgaa932uvfI0K1E6kjLL9BYBVyP/NT1GJFVtDrpVC2XaLk0+2tojDuw85SDKG6nOm
         sRAffX8vAOh6sD3bnqVkFkmx0Pt9mV3VpgJs9vN/H3dVdQFGmTSBoC0PoUbjT+syOVZ/
         Al5Q==
X-Gm-Message-State: AOAM532yDk48LCvcPKieRE+gOfSnZkkbYbAPgU9sOp2mMRl9nTnabUOq
        bqBWoJGUzW12RtLsNVoxtsY=
X-Google-Smtp-Source: ABdhPJxhHP+WhxAGNxgWQI0OdPZM6jIpMTq4SMajthAk2WkQ1T+5eIYjK0fHIAZagHuupb566RKhWQ==
X-Received: by 2002:a17:906:3999:: with SMTP id h25mr439193eje.146.1610387017631;
        Mon, 11 Jan 2021 09:43:37 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j22sm111132ejy.106.2021.01.11.09.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:43:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 04/10] net: dsa: felix: reindent struct dsa_switch_ops
Date:   Mon, 11 Jan 2021 19:43:10 +0200
Message-Id: <20210111174316.3515736-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111174316.3515736-1-olteanv@gmail.com>
References: <20210111174316.3515736-1-olteanv@gmail.com>
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
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c | 78 +++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a2e06a0d1509..79d0508e5910 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -781,45 +781,45 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
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
-	.port_mdb_prepare	= felix_mdb_prepare,
-	.port_mdb_add		= felix_mdb_add,
-	.port_mdb_del		= felix_mdb_del,
-	.port_bridge_join	= felix_bridge_join,
-	.port_bridge_leave	= felix_bridge_leave,
-	.port_stp_state_set	= felix_bridge_stp_state_set,
-	.port_vlan_prepare	= felix_vlan_prepare,
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
+	.port_mdb_prepare		= felix_mdb_prepare,
+	.port_mdb_add			= felix_mdb_add,
+	.port_mdb_del			= felix_mdb_del,
+	.port_bridge_join		= felix_bridge_join,
+	.port_bridge_leave		= felix_bridge_leave,
+	.port_stp_state_set		= felix_bridge_stp_state_set,
+	.port_vlan_prepare		= felix_vlan_prepare,
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

