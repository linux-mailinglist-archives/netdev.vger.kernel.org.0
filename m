Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C74172D9D
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgB1Api (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:38 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730431AbgB1Api (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVQd1mMI85shFRSW2xa8IM5mInjz8EFe9AQOM3UgdD2yTUpIRwgjfeW/H/uhHFrDEdWQzf2N4+6eck4XllgDyFXNcbnEB94wTf6KP5eA4vHGQl3meqlyK8I5JO1oYqyR/RqimZao+IFOVdiuuzt6Yv1jAlHorvPPwu8P5TQQZVO1CmjlPiE0jtkb5K5Z8EcsMd255P/1IQIaaD4GLCZSE8fZXDLj2FLuMiT2tDxrmEUerYxqqtQlGoWvjPZ9iYn+1G3XOfIBPpzG3QBtJqcS1AJNAjdOuMxgZXq9sRDhHoRWMfl/9sNZe+Aft4WbyZ/Y9WFQmMAfcFqC9o6caHaYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykxbtmV1W2TkmjHQWk9NeTLdlap8SQ4j6+cXSpLF9r8=;
 b=Aj1ttDkOES+1MS97H+AJZdrCyKdsjbmGvYVr8VS9+lDpo+weCWbASnZL93oK9PfWdKGi4LyPG5l2CZn0DXDJJt4VpT0YGjIfcuQ6qYv90MXUtViQG8BTpMITP8lBWZesIbHG5WB7aORrMx9qeot58QPW1IFr+9ktCc4yS8upVBZVioqnyj1d3etCkLdBbtKfBi0gZ3ZbJEA+eXxogc7+lfRab/SPChEOCV00clU8Puy3u0foMgrvHYpcY6BaqFXzA6mzNIJ/mph5XuHl4jKknvIWye/n6pAqVI0FzSk0//UUL3PqgmKdDoI74UI+lomeNVXm/CvxW47kstwJYpAScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykxbtmV1W2TkmjHQWk9NeTLdlap8SQ4j6+cXSpLF9r8=;
 b=IpqsyOMqP6RIEaJqO34k0g+HykYmdBjBou6IGniusC5x7VLfOFdoo6fA0ddd7wYLZxfkxQPjk5ZeCQ3EzoY20eBVUDCmQiF4Qj7p1trEsUhAme1sC+EupKPiPNIxtGMnl+W+rFJ6DXFgm9Bz07pyhHxxeAo6igMBhW+5+or3NGk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jianbo Liu <jianbol@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/16] net/mlx5: Change the name of steering mode param id
Date:   Thu, 27 Feb 2020 16:44:37 -0800
Message-Id: <20200228004446.159497-8-saeedm@mellanox.com>
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
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:24 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 744f969e-41a6-4870-6f5d-08d7bbe78052
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41896157E9CEFC19F56DB444BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fC1vfcqTF+p+WUBggXpu6BYMJ6sWUxkSigZmOi3ZBkDNKHJxznDlQoueG4vckMp4zPdz4H5CYJlSniW1Pq8GPoaQZ1nnGS/TWqnLLtsTvDliZvw//ptLuMxGsq7v//PB6S0PP+fTWiQb+sEX/jkzx+U3lCSKe4GK0jv1vtVa/JeKWj2Y0gggpGDsZyNeVa4bhPZ8aCAcNUaTuT73orySlqnu0HmFbeaypC9oHniQD85Rs7K+bcApS8PPxniIFiKKHvhyICXPmGbJhNzU0yBk3mZi99zkzkURs1FQOFm2SCCJD36srJi6aMMQ0xezzm7t/VempLTdRedcLB0/DYeLzULA8lyz/2ROxXoGMl6w58666tLXxfaoYM1S51QHeNH9H39XW/1QnCapHRpEflA+eDL6xkvXc10DkjlFInyq2gp/PCYonj/UHRSauZjedUYxWXZEEw/HBv7WxA5cctBJMULRNVQhzKGuEFGh31UrkOGX8lbl7k1C7g06ExcrI6mBEb/o4Tn3SST8RpQvd7Sw6tafmxvnB4A/eRxDVu7Lytw=
X-MS-Exchange-AntiSpam-MessageData: I8+dOf9Ov2ICWqFG9k2cLmg3DgbBRUucPIi0ko4Ss0knf5xHvdJIhOvJ0s/wjZt2koZLwkmwOGhM7jGqpyEhgYMXM9RgO7wUFXD4wrl9a+82V3wc82Ewa/8DwPWA2GSLxk9vQt3QghDF1KiKvt3H2A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 744f969e-41a6-4870-6f5d-08d7bbe78052
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:26.3228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7x0Tnoz292N0657YrwWE3fJtl5B6qwT6+w4ADf1EB6dGKg9e5bfNxjN8MkUi7XLOdCrxe7nXVs4XWzvQjNOlJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

The prefix should be "MLX5_DEVLINK_PARAM_ID_" for all in
mlx5_devlink_param_id enum.

Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ac108f1e5bd6..ca7f08513174 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -192,7 +192,7 @@ static int mlx5_devlink_fs_mode_get(struct devlink *devlink, u32 id,
 
 enum mlx5_devlink_param_id {
 	MLX5_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+	MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 };
 
 static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
@@ -211,7 +211,7 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 }
 
 static const struct devlink_param mlx5_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
 			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			     mlx5_devlink_fs_mode_get, mlx5_devlink_fs_mode_set,
@@ -230,7 +230,7 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	else
 		strcpy(value.vstr, "smfs");
 	devlink_param_driverinit_value_set(devlink,
-					   MLX5_DEVLINK_PARAM_FLOW_STEERING_MODE,
+					   MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 					   value);
 
 	value.vbool = MLX5_CAP_GEN(dev, roce);
-- 
2.24.1

