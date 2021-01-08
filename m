Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3932EF6E5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbhAHSDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbhAHSDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF13C0612FE
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:37 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cm17so12090520edb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0H+/CrGOqkHdl+2RnJ+7vuPp1WMci7E5bQKhlm/uHiI=;
        b=jXaavkuKe417LMlinttxVWBOY7qBuGIpJUhcGLno9hhqncIUGdeHlbgvfBZsWs3TxI
         xnxsZbn+1BvQeY281T7UjtndwLOEyLE0bzCrZyHaUe8nIYrfWEH0m+0LALyL32Q1IWuN
         08J7XTo4MdXJvWLdAiHmnCeWERxYjCTlyjUf3Ou0UqLWXZ6UksIn+4MBEDeIXc7VrSZp
         kRTrQWEntIhgPxwn4LAgZQ6M/lRPBf7MRhmhLyRfIsE+v8gb1Rg3wUlO1mLdI4cKX+5Z
         /gBL5h/eyoaEcJwTnHcKkkTV5xeg7aUhWc+i+DVPqP4w7SxTjLzPFfmQ+NfT4d2DhluV
         KwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0H+/CrGOqkHdl+2RnJ+7vuPp1WMci7E5bQKhlm/uHiI=;
        b=t8JOQDRhm8SsGLRsRkoKTqemYDI8wE3z2hRg/HA/dMz0MmUlFk40iI88+z/WYhEk0J
         Q00PEycByaGXuq2AEeAfH+9JmNA1OkS1EN9H20aTlGWq5a3Ftt53Rob5eQoKIz8k490i
         djjXAaZ4QpcdsOCZJ/3YdKs+PnqOfWRR7Fb3sO3t9K13GrjG+GA5CRSulp6PLVbKCQdw
         Wdx2VauIvJPBPtRBmvUvQO0gADZ9LLgW7Z9PiSVChFobtspE6Wpgot5AV7TEljKQOUML
         lfpSBX2pyYilv9uW8zvhC/r4L+VGzStlST1OwRzApoy2e9IJG0NtbqeH6EAMTWjWkvFi
         9Pag==
X-Gm-Message-State: AOAM533JiXeIcQ7ooq2az3g0lq75Az4N6Jw1RRboXkW70HyG3LxrELII
        mtG0nSzcdEyNl5RhpHEflTrkErkFOE0=
X-Google-Smtp-Source: ABdhPJycvqI5YiFcD+cctqdoIShK55bPvyBV54ONfDloMyNeME4P8jY6XiGohWMJqn+/nM872vfdLQ==
X-Received: by 2002:aa7:c813:: with SMTP id a19mr5855214edt.192.1610128956169;
        Fri, 08 Jan 2021 10:02:36 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 04/10] net: dsa: felix: reindent struct dsa_switch_ops
Date:   Fri,  8 Jan 2021 19:59:44 +0200
Message-Id: <20210108175950.484854-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The devlink function pointer names are super long, and they would break
the alignment. So reindent the existing ops now by adding one tab.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
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

