Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87579172D9C
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbgB1Apc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:32 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730431AbgB1Apb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkeJABFaldlIXdw1xs8zLnBx64lP0EDhh4ied1FNgWtt/MmVNuy7FVTacE5UWf1fZKtrdNVviIbq/6WHipfurWt7lrUdrMLDr3Epc61XNw4Nmjq1wXXPvHGgmLR9S11AOS08UmGf6esaSFKUvI8ONegkHmFSldRbt40wfhUbHVd+vq/Ly+ehuHOk2GKA9s+4indhiVYDIkGShoLPAtvvtSEruv2/LM7xpYrqClkLPBvimb9UaCDxA2wmaylDcBfo9V0raONmen3bxXnc6UGKvxgcK2JTlov6vIWIqlldC1iBVQEcxnSR/nVgllrfi2H30ajx1ugzUurdAZmhP799QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f1YikxCty35sER2ouX6LfXcS9jz0vraxHxOUmqJWnY=;
 b=ir3/E/Lh5fTsbqi4mzV92s3lFnhoZPPAdM4ZMVIHCrDKfLhWQSIpBjmbvb3yLNE/Fuo9lf1MjUtDCJQIT+AV+R7zNequKrNo5UPaw5n3xOQ4OunuLTElOREdv4Metn/Fl8Io5pFxPq4TGyHiKQ+58q6XT5RuDUkPwjwp8dX6R0/4+PNYWTs8qWxuMZop/YcgvyBxJcmZkd6eZbamyOu4wIYaZKjbF5++BMBs2Y0+tBPqIltK3uBL1y08CfShDT19p3TSbJpe2TYWBTczYvL9a/+cRovNGC0BlMmFcIiG/NaT6SLS4mihN27Ok2VIuhDyHbPwKeODeXdlpbTBsA4ChA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5f1YikxCty35sER2ouX6LfXcS9jz0vraxHxOUmqJWnY=;
 b=UN+l6jt4VM2Nj99UPkPe/q3bKX+t+ITvBagBM/L4gERNQh8Jaq5qzhSzMZ08YLXr2ynURYlyIPuWAS+fmdfv+KBW+9p6JcqqfSqaqDEI22TYPiztVU7ClAbfCefxz6Y0VKNfg+tVbL6U+o2bxaeIzuPBKOg65CZCvoIo6kJY61o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/16] net/mlx5e: Rename representor get devlink port function
Date:   Thu, 27 Feb 2020 16:44:35 -0800
Message-Id: <20200228004446.159497-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:20 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f512e2c4-03f7-4370-e909-08d7bbe77dd3
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41893867E241E5474C568F3CBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReRAkfyLlh4PNy9/T4jtt3BX97u2wfriqsmLifzBqRgDRmtKalOZejDTla29opJRCu3dDoO1t66CMGP8abygA6eqHPT2t0cAsh9prC3HuwXMRHstLMYcEvgYkjfM+NEyAqWZxbf6aqLiuRLrzU17Fefnv5WJGvRVvJ8CoiVoTGaO3ZWX0BRZNUFn5WT3MrG3R3K6prRbfHiSqmRKLKq4K52wZ++z6ZpSSKf4GxAapo44hw6lf4CP18TKR4ThVL2PuBPR22qcW4rIAqllwIZbvGJbXrd/Vgu1/9p54HMqvGuaEwdwYHWZzhwTUHoyGTwz+GfYt/RrtGdHvahuJUFxbY4BS8wBU8h6xAvZQlWrnImx+mSJtZ45l9vc7C2nrG5Lg4DTuUUsm8dcWwubI5n6vPvWu8bQRRu4FLTT5nStBCmKAw4k7lVGXvZDz5LjNshpWPnGJjnw3HY1U8D/aYBgX2El9ELJEmtLvgaLmeCm/LesG6WsTm9/Uh8VS8GLE2dP8EzguYLlHowELSw++6arPa2rNzkAGwvGv8t4DIsusQo=
X-MS-Exchange-AntiSpam-MessageData: FqRnUfOhQef2kAM9w9x3yYMeJTyjgIheuIlXN8kEhO3EQoIuWoDEU4w2GE8tc6s7sRrFO7L3VZgInUm82NlV2ceReOhIBA4iCrmevRi+fmyPuBgCIlXYaQTF5oGBxxA5lgYpJKGptqI/q2XMcNGmjw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f512e2c4-03f7-4370-e909-08d7bbe77dd3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:22.0842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9L9Hmy1HlqNgGTTTdO7N/WssAG/QSrZ4J5eVDq7PzZPmso8ec7HbxHYyr8FGVU3J1PRiR7h1zOn2JsrvGYs2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>

Rename representor's mlx5e_get_devlink_port() to
mlx5e_rep_get_devlink_port().
The downstream patch will add a non-representor mlx5e function called
mlx5e_get_devlink_phy_port().

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3557f85f611d..045a40214425 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1422,7 +1422,7 @@ static int mlx5e_uplink_rep_set_vf_vlan(struct net_device *dev, int vf, u16 vlan
 	return 0;
 }
 
-static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
+static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -1435,7 +1435,7 @@ static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_stop                = mlx5e_rep_close,
 	.ndo_start_xmit          = mlx5e_xmit,
 	.ndo_setup_tc            = mlx5e_rep_setup_tc,
-	.ndo_get_devlink_port = mlx5e_get_devlink_port,
+	.ndo_get_devlink_port    = mlx5e_rep_get_devlink_port,
 	.ndo_get_stats64         = mlx5e_rep_get_stats,
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
@@ -1448,7 +1448,7 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_start_xmit          = mlx5e_xmit,
 	.ndo_set_mac_address     = mlx5e_uplink_rep_set_mac,
 	.ndo_setup_tc            = mlx5e_rep_setup_tc,
-	.ndo_get_devlink_port = mlx5e_get_devlink_port,
+	.ndo_get_devlink_port    = mlx5e_rep_get_devlink_port,
 	.ndo_get_stats64         = mlx5e_get_stats,
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
-- 
2.24.1

