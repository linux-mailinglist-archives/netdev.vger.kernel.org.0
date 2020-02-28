Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D68172DA5
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgB1Apv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:51 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730378AbgB1Apt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjLTRbynMqE6zQKtDaMkIoNUVAqlKtC/+g3ZIgLCgirvULlbvARr1uP6EcU2yIijmhqHwb/imo1cedVdyuWNWGRegqukIMzyzGq8kEP21fhVgK0iE7JcR12hnPXg126YNmCDgNEMx/LyymBbkdT6LgL+OPB7UECi6K2s8IODSchA8cP+DRc5PkB51Nmhr+ta8/tghHze9/D3RIJsDj2oJuZ1huvRBRj2DjEEozPP6YxkD0OZS2Za7IIyY2iMpDI7yQiBgRdGCQuKbOshve6adqIj+KQTnvX21YhTQGPoRFZUkYPIacbcwx0ZpXKudaJKEexuNUYuvTelc+TtW3vndg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+GggjS49Ms6dL/v2vvI1pjC8dI6Nwb3VFSq1zIH0zI=;
 b=NmiPQFQ2kMnTS8gaDoMN4xY4l2Rsn+V/jLPmZNw76euV263CbJhFQ2FRBXaDLXPKJc8yMRKoFa60+X6APyJuJvOUOVNx6NnpN3DFW8jwiUGDTr3alZWy8zogBaT+SDvHm6OgiJgeJoFibR5d6Y5vhVQR8fDLPyHDVexYd0Km+p7WjXcw7JHlk+nh0tGL1H+1kPJ0kDHcTDJo8GQ9nJ/RvD6xx/cmAE1r7zHz7LBvRvZUU5zaf+Trb0BKtxlwpfas8vxtcjin34c7HzbA2rnAjbjpxEQTLWgCDOiGsoIwotDkCO3l9ant1tyVK+kRAjUPIVtw+wk84AkMIeybYMRvzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+GggjS49Ms6dL/v2vvI1pjC8dI6Nwb3VFSq1zIH0zI=;
 b=MEvujwrvPwkaCsjAR2dvuJ0irLU0ya41L8rIvfX5QWV9s9ojN0BKJ+A16pSkPTD+puJvRInHIBvcMSbGpkuiN5lxe9xA52rGTK4IWJui1esY0fcxPCBZM3c9iC9BJrWZMDN8Hr7EvaITY3+MrMkZG/bevhKGXohGK7JuoUz/N9w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/16] net/mlx5e: Remove unused argument from parse_tc_pedit_action()
Date:   Thu, 27 Feb 2020 16:44:44 -0800
Message-Id: <20200228004446.159497-15-saeedm@mellanox.com>
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
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:38 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f4a59927-a032-4291-7401-08d7bbe7887e
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41896CFDD94877144D51FBC5BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQN6RDLIb43D5G5trnOx6+Ay4a9qc59p5TBdzJ60qNKmxgcROQ7ELXl/U1AiMCnX/tIiYLosNyqqkH0hfumPoPt48XhflgTvgYyRszHc/DjgR9KnhjLV4uqHIEUZq+l4wO2BNweuslQ4MxV2y1Hin5R78FdWADtTu2rbYFLvioaRrjCus4PlmAlt/1IRBZL+uViKU2bF9hKf9a3a1Ig1g6d11QuPhjHMc/JBiHk12jBCHKUPaQo2s6nNZMwyC5RMKgbH+eUFm+A0qBXthhlY6RrbgfDBvmbMyoS4klfX79IPhnA/+QTMMHNRjytph/4nA74fZeO2pQ1IHBmiFxroIsmZ00yj2jYPPq1X65QAvMx2x3/QCW6rryb+PivoVEdNNTgGTPs5hI17ZGbqs43kepmXCiCzZ3Z+WxmEbCMAWFXE9NciRmOph3hIEt1AjsdeJXUtTN8Lp6dDijbIiMduLtmvqxNDOYalvTpyA44nLtp47dGqFJUef2AtlYYfSfNOnQFG5dYGKge8QmkPbw+wjyNyvGxLWJWwh4L04sk9Izo=
X-MS-Exchange-AntiSpam-MessageData: WyrpGvWJ2mtsytzvs+iDDKcCSfZDqGMAOKpni0EqoYuX+RfrlZPYnLyjJ6gxyxx86wBZQ1iwgXP4Pg1+KqXkE05yBPOihCbxhWdsmAEUf8Ko0AF0YrWB9K4v57tE4GyAC5dTxhgUcspgzfxtCG2+/A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a59927-a032-4291-7401-08d7bbe7887e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:40.2889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAx2W3SlBQJlIWtHS70VoTPicx6iooiPk9sYVsoB8AoO91HeOUkp7YzTqdbspIdvWVFTCNwmeEoO3RA4HOFIHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

parse_attr is not used by parse_tc_pedit_action() so revmove it.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1288d7fe67d7..1d62743ec251 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2563,7 +2563,6 @@ static const struct pedit_headers zero_masks = {};
 
 static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 				 const struct flow_action_entry *act, int namespace,
-				 struct mlx5e_tc_flow_parse_attr *parse_attr,
 				 struct pedit_headers_action *hdrs,
 				 struct netlink_ext_ack *extack)
 {
@@ -2839,8 +2838,7 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		return -EOPNOTSUPP;
 	}
 
-	err = parse_tc_pedit_action(priv, &pedit_act, namespace, parse_attr,
-				    hdrs, NULL);
+	err = parse_tc_pedit_action(priv, &pedit_act, namespace, hdrs, NULL);
 	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	return err;
@@ -2902,7 +2900,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_KERNEL,
-						    parse_attr, hdrs, extack);
+						    hdrs, extack);
 			if (err)
 				return err;
 
@@ -3346,7 +3344,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
-						    parse_attr, hdrs, extack);
+						    hdrs, extack);
 			if (err)
 				return err;
 
-- 
2.24.1

