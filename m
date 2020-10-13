Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA17028CF77
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbgJMNt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:26 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387781AbgJMNtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8j49O9qDqr9mobG6SBw/DnGNXmAO9OCKYpbmDRCrvtfahrSLrAeH0VJ/ZUP3xuee5quYs5Pznih84mIREHX5YoCHhW/ithJOEGKAWPsT65Bjm6RiGDFLPy4zfLWCzMMcF6dJjYO5vfS0ZhyO8JMNXhyIvvqr6Zo8JtyDXLZI/rS2+9kYTkk/wgM/6xusmDCUGqyQQXjyi8N7aIja6yJxUCBUs2z/7xbgmPRXSEjjZKhD5OFgZ3e0XPAy21GZ3YR2xHWSIUoSXljZFHpMb1BDhzfF4JdECLtgM8uXvJSuhqLmB+TbsMhf/WYDveRBl/hCThHqAf38VvVS8G5W6qvpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJgcB183x+zqN+DC/iS1/xreuApNdq3NilkKJA66fXU=;
 b=jxcIzalj9uislfWNc1KG6Nyc/9LhVDDYwLszNVWITrCbmmVAjQ2d6e68tzTs3obaj1ieSTj8YN+eRA5p87UoVz3l6BoxXlR/BrHxTfCuBJfPgPsnb2mJOyTIaNJUBro/NCz6gL3FWTnU+m2XYqyjF+B5XBNWEnFuCHYs7VJj+Rh92FPNqoEOsZPJS6UFY0/bbGdBdohWeS+AhW5FqjYRrgqtrSKthGCqFw8YW+8DqJWwmg01zihDcQxoHd0BIENL/d3c7Flmv7qVhirs1dHp3D+h9ujAXARZGkrXlcUgNfAsoU7lj/n2JsLKpIWdYjvAEAji0t31IZO+BB6sQV1/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJgcB183x+zqN+DC/iS1/xreuApNdq3NilkKJA66fXU=;
 b=FrJjtTZ1Hkw7Ta6tEe/nhiqYGQa0+aiBx+tfD1s5fCKxx2/LgPl9maW8lr51Qv7HvhjFLThqDdhfEJ31vM72QfgFKh7+PPlBAcA83QxuyEuaeIdvh7g4TqfYPLy7WhYeXOuJObQ6nHCovpYNNe+XaAYdKdpb9m8J2dXsRuApDFc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:14 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 04/10] net: dsa: felix: reindent struct dsa_switch_ops
Date:   Tue, 13 Oct 2020 16:48:43 +0300
Message-Id: <20201013134849.395986-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8471e5ae-624e-4ad4-9724-08d86f7ec51c
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB710496C84592C13011C6DAD8E0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bg38q3+9YHXQvq8xzevMy0k5Xl3kFEtqd2hLdja9ytaOaX+omhHA3WYJblfz47muK7KQLZHejiHV3V4Y2FgHmbtpunpfJA9B4u/HNXUKoXMOfiSRKIDGtCJ73GD1UgOX3rOWfu2e6UG6huCL4Z3sZ0QlGMRJ5rj5/tUae0v4TeYkGV2c27SMCvV6T98ysYNJ5iTNMHmioLHy7BMlSvE3qsUyGKx57ILi4YwhesTkEA58Of19By85T5focy3/RJyluJgJGzcUbIgCzVyDOaJCTwWq2FRjAaQOtG/oGkyRkCNapUSoWZQqdqpHEIp2LrxkM2pWuFolVgrUcu0uY3NdWuaUFQKRhy1RxeXQqnOp8c+I8VS4vLdoXR3L2OrTR1/B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S3xjEP5U4kd3qwklXJTZwgDb4/r3eQEXzf1KoYpANpklkN521iDuvA0BYpmPe+0ccP5Wr8PTNBJ2QjCV5Xi5xnVePBp1z3iXU15S3p27lW7feuT1CvrNM9OZHhCz9lTAX4AHU/v40nuISQrpH/qSVwIQkguPDrjsk3wLSPg1CQNL1Pact5LzpihMwEcoHwldD5xmJDN0eUHmkpuXGGBxhJ3KbbbVbstwHqV7OW1g04gNrNSzQoL58UCRwY40xdmBUpraHbRgQeeRM2Ows1GNUcqBKYomPlRg7zCrho/DAZFdZYH2S4U9AeqpRB5dvDYsFfoXY0XUWp85akTwutcW1CjGLaw2qDFWkoPRA8cEVQgEHYHZUv22e6kW04PNIwRLLmcmF+8Mqjt3MniNg/NSsrrMpZllcWlHrdxQjM0gJIBTDSvcnPhYM0n081Lo+vIs1S4G/AaVnwm9qQRZuRi8a8jLtlJZgpwBl4g6zV/28asywkVCxKuHcNngs0w5ztrV2tWc+LGH4AaoxP6Sk0XAw5P1LF4PelTJCPaZZYw6xvsBPthuvJOv7FMSMOUW5SaZm7oDc9vD5DuoAsC42bAZxRBIVwpe9M8o5uaxaMkcYi7ssRh3ZPY6uCgE1t/nOv+EvxVs69yYgnfZCARToSHcOg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8471e5ae-624e-4ad4-9724-08d86f7ec51c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:14.1619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qXy7XlpAlTFkl9Y//K0hyziJedZDuodM9L4/JitlblW3WWMemNHStJx/cXEZopFt7xWxZB8dRAy9pdzE3eYskg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink function pointer names are super long, and they would break
the alignment. So reindent the existing ops now by adding one tab.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 78 +++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 29ccc3315863..184e3f79f579 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -768,45 +768,45 @@ static int felix_port_setup_tc(struct dsa_switch *ds, int port,
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

