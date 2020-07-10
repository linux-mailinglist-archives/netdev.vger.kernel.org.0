Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22CB21ADB2
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgGJDsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:48:31 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbgGJDsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:48:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUVfdmY92ZZ7qcBjKwuAQqiRQUJhQ4jMhpoWGSBLs+odYp1Io20ksAMmy47lnZjHalx5lsffjnnjd91/Is9Gm2jQOGcBX8ktkw7vEwAgk5KXzgzNjph6InNjmOkgUvMK4InVH4cH1LfzEDBUiYdG+v0y57ykF9Rt220g7jbM7eyQh/UvGG5ELYxDVF2bLkQlPLYIJCr/CfmT1/RNil7CSJ18dwt9k6msBmTd7Ms8hGyKW3OEN0ePiJyAJ7/RnRODVorlfvwltOuwM/CD/ZT17mUUhFqqk8v3Zr9Vm3ELTypLF7BA2PxetZFPMDG3TAMPzTKAXzyfl023gIxTZbRJsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv4xDTDySQMB3NgZYueTzpfn6+jNy8kzGLChQzDzI2c=;
 b=XEp5kGM591CCvc3g0g6nOOXaDX7tCKgwByzA3v/uBd+iEioNmaNCUJEAiReBr1OCqqeWeds6TjmHkKAo4rBVGGxv5IgnsVRFOBjT3lWN/zRX+8QlHomUrBiKk2wQUEUJYujBa8RJ4m2ofXffANKJ3nKuB5+3bEYhhawPqzQ8QOkCwKshb77PnA/+KFBSYtLfQ6iXNZBMy3FE+CJ4MqxgRWh3BvOAOauMleVKsy/3yAqxtGd3AERzm8lsbIAHNagjmCR+iWm7HPkPymGYvg6qygk288PsynCqAUPngQH2q6Y/Ow05AXfuAHYw8w2zccEyXf1lKlf7wtZMXT4O6FUrRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xv4xDTDySQMB3NgZYueTzpfn6+jNy8kzGLChQzDzI2c=;
 b=M5paGSl7X/tqYa5nomB651rWIpzeHPsHiRlfxKWspaXOot6W9z2SVeJd4YAFrhF2gmBrppxWQh2dEnSaE2/GOvL32XGWXL+JynWy3J2z8hJkVpvi3wcdix9Ft9EGU7MNp3o35PwOMNhNe9oWVypYnSU9RLeuhXo+/i8eFtuVvMA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:48:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:48:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [net-next 12/13] net/mlx5e: CT: Remove unused function param
Date:   Thu,  9 Jul 2020 20:44:31 -0700
Message-Id: <20200710034432.112602-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:48:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e4ff9f82-56b5-4a0d-e196-08d824840e66
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512C4366F99766453AA9089BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6n2T/AZqRZYcFMrFyqaNgl7ZK4aT2WCfIcIOZvG0oHGHXfbg4wrHIh93w4TUBWfmdtYHbm2no7h73XpYi/b3fx1qSTUJEWZSyV3OcsS8oCFd1hM77MGmxFAn2hM4Px80kucjkon2Gq+6GGgPw0iY+AJDKJB74tni+ESeSmyqig3aRhnQocLs3QiS8QGC5n0LfkJOZ1cKl6mlG35YizDciQeSwMa3SU/+XFXJQQ3FPifMEWNeJk2P9hJTCvidxwChDVCRufjDy58vh1JPcM2mOlj8+GqK5u3RIzO/Ffe7UVbjEGg2ppIIukMD83qEzE3a2LPNchoaphbtHp8k5KHUdMZ60Jl03YeyhkFvgO+k7kHY7DBn/ohU/SY1pXn2VGG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bybbEN/9xnZvdHcY8t83u1gX6Q6cQdKvMb1QyON24CZqOavS/bH9GC0KEPo+xzQrfKRKclmnL4Lj7/smr+L6Ahh4MXwiiYe7kSgQvpDXLqs9BfeEekWkP8c3rRF5XXVWkydvfaglIsPhH3XtKIZjf3Cs7+jlZvE6WBhDSoqllXu7WgF1ZkUSbZl54l0Tg4UP28jH2oMsvfP0E5Fln+9je7XJ/vFXmqFK08K4RIKmPSdSZZhQykZUG/uNuPzfTl+lLZofe9qE30115vHfgVkWe1Qm0WDo304LLaM5/DtBJBkg48mfmeqzv5Y+zG5fDRIdgHaR+TZjSlvv/9dRVeA1kslrSQ9V+vl6ZTr6zb8KpodbXsagbsFMEF0PKvHdgcOc5rd+NNmTbOYMQ2irG9XMEGTCvOmlH5h4f1mc/IpDW3l2DQQf6OUGe+mifLja8I7M8ADKv6kWlqbSa36LaEdy6k+/lZBKlaTv+kMLCB4uSWk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ff9f82-56b5-4a0d-e196-08d824840e66
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:48:07.2559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmVJzk+zLF0qCBt0BIKqVrFx93AIAiMOvJ/HW+TtHiqWhs4Sv0sCDrkvi4LFfwX7CTOhZ63hZcyUklzeIxSQAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"flow" parameter is not used in __mlx5_tc_ct_flow_offload_clear(),
remove it.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 709ad0012c24..96225e897064 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1571,7 +1571,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 
 static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload_clear(struct mlx5e_priv *priv,
-				struct mlx5e_tc_flow *flow,
 				struct mlx5_flow_spec *orig_spec,
 				struct mlx5_esw_flow_attr *attr,
 				struct mlx5e_tc_mod_hdr_acts *mod_acts)
@@ -1648,7 +1647,7 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 	mutex_lock(&ct_priv->control_lock);
 
 	if (clear_action)
-		rule = __mlx5_tc_ct_flow_offload_clear(priv, flow, spec, attr, mod_hdr_acts);
+		rule = __mlx5_tc_ct_flow_offload_clear(priv, spec, attr, mod_hdr_acts);
 	else
 		rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
 	mutex_unlock(&ct_priv->control_lock);
-- 
2.26.2

