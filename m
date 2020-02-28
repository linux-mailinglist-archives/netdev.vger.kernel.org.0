Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79254172DA1
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgB1Apr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:47 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730431AbgB1App (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlZtqX9iGs6pqFcYwexEomKRfpPEn3gzt3gv4yndSx9s2acQyk+7uXmcxlMEF9cC6zu8qJLFWDiSGSXH51KxGsQdvO8eiFkNY3Bn/c7cxS44iO7OIZoiaDzOcvBv4acRDjlArioRd5ZaHyGI4Q1VPoOvPxJ90ex9b22EXUyvNy0xfZDL/vPZrUfuSxcKMv+qZ663+o4fVIkASJPmBNym9JYRUmFRBdaeTl/8LbqsU5Ha6RSb1sLwyoQ/px4jD/JLW30OLFBc63ehB2bPfU9+i/L7AwciyumG49irJiRivCzCQ56r9VGip6f1N+PVlBQzqVwHLc6M92ULHooRpjSSbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2sLnHDip2ruuh8PhH6YAQz7T+vE5LRu53tSgo7zxp4=;
 b=ePHpXZGAOt8HEWZEKQZLu4qn5PSzFBmkQAI+pQ8t290NoUnDX7rzE7tApRA83IC5OWLQLi1oJoKEigbTzhpXmBK6TTrRBj87AZO+0ENoMXgyE4T3UDV/w6amidpb8OXZ/lTjJkpO+yUfz8nRB5alBq8f4j4cO+f+k9lTDbZUa05gcw7WlDSFbLruwwK27lbfKfpTvgcVYqlpj15fA2CoieYb2W1Pr+V9WJwlCaVSkcoFYjoJbpoapzYAskxJyb6xq3t4uOnovE8mopmKJiUI4+SX6QNrRvee2Z4sHQNcVQPpH83ZJJjBffxGD8mgsyoHEr9uVYnBpJutSwXZmn7Vaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2sLnHDip2ruuh8PhH6YAQz7T+vE5LRu53tSgo7zxp4=;
 b=hdMNB/ZXUdqlg72J1t8S8zNMYfzsPcj+NWT/YRJYya7XyQHElH55q+3iSOAKjofqHX2TITlXzQGTDzwXlkso6smXq6IhLdizSPIwtrNGW51EhQjA6SU56mxIZX0bPTGbVO0ZgGzXs2q5t2kRS831b272CiG5yCZg9RqPUiBbbXU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5: DR, Improve log messages
Date:   Thu, 27 Feb 2020 16:44:40 -0800
Message-Id: <20200228004446.159497-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:30 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ab95a8cf-c2be-4bb0-6a47-08d7bbe783d7
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189F6D6AC2BAA01A1DD16C9BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:497;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(30864003)(6666004)(81166006)(15650500001)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34/ozSkUwL7JNg4xC9TmzIGhxpFG3nseFLPuT8yHWACUPZvex69QZ/bJ6aPFo+KH5DtKFdMNHbADZJQmDH/1PxoqK084qKJwhx7gZnv8DPhZu0lYjQXFcGuG4DZCMPA7ETlnrmeAzM4Wt1TISUB0i2nzmPzKoMCdZn3J9LUdJ29D8F5lcbLnTEDuG9yOUGJ6K+MnithN2fLU7x1hUiJ7nfWv/v4djvu6urltL8ur++cTb9Q4QFfcli4mksgF4wJcsSKTRiqkcXAW67h2sz9rouBVQ4XwMTUYLhUUHXLJyahU8TxgaSBfQgEDRf7x3tW+J51wkyFeQShshDut519Ad5dSTB390kxDhhmmsHPBFkDB7JQPUTYIBnaWQqZEmrEvk7ajSLB0fvSGKbBdSs8zwLWzsxd+PIF4rD37N6DZ0vplpRrZZL9CLEJ+exAhB5olIe0CVwf4YJfJVn4tcFZVshDLazs6PfYn81MXbflebjFkq0J6g3DugolQ8hmaOYJ+Ux+6QknSe8FRdOuTf4do6CzwGchB3mpj2fVU8YsaUO4=
X-MS-Exchange-AntiSpam-MessageData: 53elJ/6ixpAuyB4esvYtsx+NDBCPIb+M+09eFD4aBQofFY40cHDKrRfp351h96aJt61SFeF6aTUqVM9DCY7sPKPdVwTvSdHGSQPwcnhUNmNS7oGTYlBGCSx4wefiknzCHKPCBQ42XGFEwjGypEpdkQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab95a8cf-c2be-4bb0-6a47-08d7bbe783d7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:32.3744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/6L9pl3EHc/Ap5anDtSis6HR9gKDXO17SU/AeJVbE9n1xXDKli5CMpMwd7/dv9mth2NUbQXNGlxRaVqTDFnVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Few print messages are in debug level where they should be in error, and
few messages are missing.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c    | 10 +++++-----
 .../mellanox/mlx5/core/steering/dr_domain.c    | 17 ++++++++++-------
 .../mellanox/mlx5/core/steering/dr_icm_pool.c  |  2 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c   | 10 +++++-----
 .../mellanox/mlx5/core/steering/dr_rule.c      | 18 +++++++++---------
 .../mellanox/mlx5/core/steering/dr_send.c      | 16 ++++++++++++----
 .../mellanox/mlx5/core/steering/dr_ste.c       |  2 +-
 .../mellanox/mlx5/core/steering/dr_table.c     |  8 ++++++--
 8 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 6dec2a550a10..f899da9f8488 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -672,7 +672,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			dest_action = action;
 			if (!action->dest_tbl.is_fw_tbl) {
 				if (action->dest_tbl.tbl->dmn != dmn) {
-					mlx5dr_dbg(dmn,
+					mlx5dr_err(dmn,
 						   "Destination table belongs to a different domain\n");
 					goto out_invalid_arg;
 				}
@@ -703,7 +703,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 						action->dest_tbl.fw_tbl.rx_icm_addr =
 							output.sw_owner_icm_root_0;
 					} else {
-						mlx5dr_dbg(dmn,
+						mlx5dr_err(dmn,
 							   "Failed mlx5_cmd_query_flow_table ret: %d\n",
 							   ret);
 						return ret;
@@ -772,7 +772,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 		/* Check action duplication */
 		if (++action_type_set[action_type] > max_actions_type) {
-			mlx5dr_dbg(dmn, "Action type %d supports only max %d time(s)\n",
+			mlx5dr_err(dmn, "Action type %d supports only max %d time(s)\n",
 				   action_type, max_actions_type);
 			goto out_invalid_arg;
 		}
@@ -781,7 +781,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		if (dr_action_validate_and_get_next_state(action_domain,
 							  action_type,
 							  &state)) {
-			mlx5dr_dbg(dmn, "Invalid action sequence provided\n");
+			mlx5dr_err(dmn, "Invalid action sequence provided\n");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -797,7 +797,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	    rx_rule && recalc_cs_required && dest_action) {
 		ret = dr_action_handle_cs_recalc(dmn, dest_action, &attr.final_icm_addr);
 		if (ret) {
-			mlx5dr_dbg(dmn,
+			mlx5dr_err(dmn,
 				   "Failed to handle checksum recalculation err %d\n",
 				   ret);
 			return ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index a9da961d4d2f..48b6358b6845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -59,7 +59,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 
 	ret = mlx5_core_alloc_pd(dmn->mdev, &dmn->pdn);
 	if (ret) {
-		mlx5dr_dbg(dmn, "Couldn't allocate PD\n");
+		mlx5dr_err(dmn, "Couldn't allocate PD, ret: %d", ret);
 		return ret;
 	}
 
@@ -192,7 +192,7 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 
 	ret = dr_domain_query_vports(dmn);
 	if (ret) {
-		mlx5dr_dbg(dmn, "Failed to query vports caps\n");
+		mlx5dr_err(dmn, "Failed to query vports caps (err: %d)", ret);
 		goto free_vports_caps;
 	}
 
@@ -213,7 +213,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 	int ret;
 
 	if (MLX5_CAP_GEN(mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) {
-		mlx5dr_dbg(dmn, "Failed to allocate domain, bad link type\n");
+		mlx5dr_err(dmn, "Failed to allocate domain, bad link type\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -257,7 +257,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		dmn->info.tx.ste_type = MLX5DR_STE_TYPE_TX;
 		vport_cap = mlx5dr_get_vport_cap(&dmn->info.caps, 0);
 		if (!vport_cap) {
-			mlx5dr_dbg(dmn, "Failed to get esw manager vport\n");
+			mlx5dr_err(dmn, "Failed to get esw manager vport\n");
 			return -ENOENT;
 		}
 
@@ -268,7 +268,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		dmn->info.tx.drop_icm_addr = dmn->info.caps.esw_tx_drop_address;
 		break;
 	default:
-		mlx5dr_dbg(dmn, "Invalid domain\n");
+		mlx5dr_err(dmn, "Invalid domain\n");
 		ret = -EINVAL;
 		break;
 	}
@@ -300,7 +300,7 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type)
 	mutex_init(&dmn->mutex);
 
 	if (dr_domain_caps_init(mdev, dmn)) {
-		mlx5dr_dbg(dmn, "Failed init domain, no caps\n");
+		mlx5dr_err(dmn, "Failed init domain, no caps\n");
 		goto free_domain;
 	}
 
@@ -348,8 +348,11 @@ int mlx5dr_domain_sync(struct mlx5dr_domain *dmn, u32 flags)
 		mutex_lock(&dmn->mutex);
 		ret = mlx5dr_send_ring_force_drain(dmn);
 		mutex_unlock(&dmn->mutex);
-		if (ret)
+		if (ret) {
+			mlx5dr_err(dmn, "Force drain failed flags: %d, ret: %d\n",
+				   flags, ret);
 			return ret;
+		}
 	}
 
 	if (flags & MLX5DR_DOMAIN_SYNC_FLAGS_HW)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index d7c7467e2d53..30d2d7376f56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -468,7 +468,7 @@ mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 			err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
 			if (err) {
 				dr_icm_chill_buckets_abort(pool, bucket, buckets);
-				mlx5dr_dbg(pool->dmn, "Sync_steering failed\n");
+				mlx5dr_err(pool->dmn, "Sync_steering failed\n");
 				chunk = NULL;
 				goto out;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 2ecec4429070..a95938874798 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -388,14 +388,14 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 		mlx5dr_ste_build_empty_always_hit(&sb[idx++], rx);
 
 	if (idx == 0) {
-		mlx5dr_dbg(dmn, "Cannot generate any valid rules from mask\n");
+		mlx5dr_err(dmn, "Cannot generate any valid rules from mask\n");
 		return -EINVAL;
 	}
 
 	/* Check that all mask fields were consumed */
 	for (i = 0; i < sizeof(struct mlx5dr_match_param); i++) {
 		if (((u8 *)&mask)[i] != 0) {
-			mlx5dr_info(dmn, "Mask contains unsupported parameters\n");
+			mlx5dr_err(dmn, "Mask contains unsupported parameters\n");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -563,7 +563,7 @@ static int dr_matcher_set_all_ste_builders(struct mlx5dr_matcher *matcher,
 	dr_matcher_set_ste_builders(matcher, nic_matcher, DR_RULE_IPV6, DR_RULE_IPV6);
 
 	if (!nic_matcher->ste_builder) {
-		mlx5dr_dbg(dmn, "Cannot generate IPv4 or IPv6 rules with given mask\n");
+		mlx5dr_err(dmn, "Cannot generate IPv4 or IPv6 rules with given mask\n");
 		return -EINVAL;
 	}
 
@@ -634,13 +634,13 @@ static int dr_matcher_init(struct mlx5dr_matcher *matcher,
 	int ret;
 
 	if (matcher->match_criteria >= DR_MATCHER_CRITERIA_MAX) {
-		mlx5dr_info(dmn, "Invalid match criteria attribute\n");
+		mlx5dr_err(dmn, "Invalid match criteria attribute\n");
 		return -EINVAL;
 	}
 
 	if (mask) {
 		if (mask->match_sz > sizeof(struct mlx5dr_match_param)) {
-			mlx5dr_info(dmn, "Invalid match size attribute\n");
+			mlx5dr_err(dmn, "Invalid match size attribute\n");
 			return -EINVAL;
 		}
 		mlx5dr_ste_copy_param(matcher->match_criteria,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index e4cff7abb348..cce3ee7a6614 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -826,8 +826,8 @@ dr_rule_handle_ste_branch(struct mlx5dr_rule *rule,
 						  ste_location, send_ste_list);
 			if (!new_htbl) {
 				mlx5dr_htbl_put(cur_htbl);
-				mlx5dr_info(dmn, "failed creating rehash table, htbl-log_size: %d\n",
-					    cur_htbl->chunk_size);
+				mlx5dr_err(dmn, "Failed creating rehash table, htbl-log_size: %d\n",
+					   cur_htbl->chunk_size);
 			} else {
 				cur_htbl = new_htbl;
 			}
@@ -877,7 +877,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 	if (!value_size ||
 	    (value_size > sizeof(struct mlx5dr_match_param) ||
 	     (value_size % sizeof(u32)))) {
-		mlx5dr_dbg(matcher->tbl->dmn, "Rule parameters length is incorrect\n");
+		mlx5dr_err(matcher->tbl->dmn, "Rule parameters length is incorrect\n");
 		return false;
 	}
 
@@ -888,7 +888,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 		e_idx = min(s_idx + sizeof(param->outer), value_size);
 
 		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Rule outer parameters contains a value not specified by mask\n");
+			mlx5dr_err(matcher->tbl->dmn, "Rule outer parameters contains a value not specified by mask\n");
 			return false;
 		}
 	}
@@ -898,7 +898,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 		e_idx = min(s_idx + sizeof(param->misc), value_size);
 
 		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc parameters contains a value not specified by mask\n");
+			mlx5dr_err(matcher->tbl->dmn, "Rule misc parameters contains a value not specified by mask\n");
 			return false;
 		}
 	}
@@ -908,7 +908,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 		e_idx = min(s_idx + sizeof(param->inner), value_size);
 
 		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Rule inner parameters contains a value not specified by mask\n");
+			mlx5dr_err(matcher->tbl->dmn, "Rule inner parameters contains a value not specified by mask\n");
 			return false;
 		}
 	}
@@ -918,7 +918,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 		e_idx = min(s_idx + sizeof(param->misc2), value_size);
 
 		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc2 parameters contains a value not specified by mask\n");
+			mlx5dr_err(matcher->tbl->dmn, "Rule misc2 parameters contains a value not specified by mask\n");
 			return false;
 		}
 	}
@@ -928,7 +928,7 @@ static bool dr_rule_verify(struct mlx5dr_matcher *matcher,
 		e_idx = min(s_idx + sizeof(param->misc3), value_size);
 
 		if (!dr_rule_cmp_value_to_mask(mask_p, param_p, s_idx, e_idx)) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Rule misc3 parameters contains a value not specified by mask\n");
+			mlx5dr_err(matcher->tbl->dmn, "Rule misc3 parameters contains a value not specified by mask\n");
 			return false;
 		}
 	}
@@ -1221,7 +1221,7 @@ dr_rule_create_rule(struct mlx5dr_matcher *matcher,
 	dr_rule_remove_action_members(rule);
 free_rule:
 	kfree(rule);
-	mlx5dr_info(dmn, "Failed creating rule\n");
+	mlx5dr_err(dmn, "Failed creating rule\n");
 	return NULL;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index c7f10d4f8f8d..a93ed3c3b6c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -136,7 +136,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	err = mlx5_wq_qp_create(mdev, &wqp, temp_qpc, &dr_qp->wq,
 				&dr_qp->wq_ctrl);
 	if (err) {
-		mlx5_core_info(mdev, "Can't create QP WQ\n");
+		mlx5_core_warn(mdev, "Can't create QP WQ\n");
 		goto err_wq;
 	}
 
@@ -651,8 +651,10 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 
 	/* Init */
 	ret = dr_modify_qp_rst2init(dmn->mdev, dr_qp, port);
-	if (ret)
+	if (ret) {
+		mlx5dr_err(dmn, "Failed modify QP rst2init\n");
 		return ret;
+	}
 
 	/* RTR */
 	ret = mlx5dr_cmd_query_gid(dmn->mdev, port, gid_index, &rtr_attr.dgid_attr);
@@ -667,8 +669,10 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 	rtr_attr.udp_src_port	= dmn->info.caps.roce_min_src_udp;
 
 	ret = dr_cmd_modify_qp_init2rtr(dmn->mdev, dr_qp, &rtr_attr);
-	if (ret)
+	if (ret) {
+		mlx5dr_err(dmn, "Failed modify QP init2rtr\n");
 		return ret;
+	}
 
 	/* RTS */
 	rts_attr.timeout	= 14;
@@ -676,8 +680,10 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 	rts_attr.rnr_retry	= 7;
 
 	ret = dr_cmd_modify_qp_rtr2rts(dmn->mdev, dr_qp, &rts_attr);
-	if (ret)
+	if (ret) {
+		mlx5dr_err(dmn, "Failed modify QP rtr2rts\n");
 		return ret;
+	}
 
 	return 0;
 }
@@ -861,6 +867,7 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 	cq_size = QUEUE_SIZE + 1;
 	dmn->send_ring->cq = dr_create_cq(dmn->mdev, dmn->uar, cq_size);
 	if (!dmn->send_ring->cq) {
+		mlx5dr_err(dmn, "Failed creating CQ\n");
 		ret = -ENOMEM;
 		goto free_send_ring;
 	}
@@ -872,6 +879,7 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 
 	dmn->send_ring->qp = dr_create_rc_qp(dmn->mdev, &init_attr);
 	if (!dmn->send_ring->qp)  {
+		mlx5dr_err(dmn, "Failed creating QP\n");
 		ret = -ENOMEM;
 		goto clean_cq;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index aade62a9ee5c..c0e3a1e7389d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -728,7 +728,7 @@ int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 {
 	if (!value && (match_criteria & DR_MATCHER_CRITERIA_MISC)) {
 		if (mask->misc.source_port && mask->misc.source_port != 0xffff) {
-			mlx5dr_dbg(dmn, "Partial mask source_port is not supported\n");
+			mlx5dr_err(dmn, "Partial mask source_port is not supported\n");
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index 14ce2d7dbb66..c2fe48d7b75a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -128,16 +128,20 @@ static int dr_table_init_nic(struct mlx5dr_domain *dmn,
 						  DR_CHUNK_SIZE_1,
 						  MLX5DR_STE_LU_TYPE_DONT_CARE,
 						  0);
-	if (!nic_tbl->s_anchor)
+	if (!nic_tbl->s_anchor) {
+		mlx5dr_err(dmn, "Failed allocating htbl\n");
 		return -ENOMEM;
+	}
 
 	info.type = CONNECT_MISS;
 	info.miss_icm_addr = nic_dmn->default_icm_addr;
 	ret = mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
 						nic_tbl->s_anchor,
 						&info, true);
-	if (ret)
+	if (ret) {
+		mlx5dr_err(dmn, "Failed int and send htbl\n");
 		goto free_s_anchor;
+	}
 
 	mlx5dr_htbl_get(nic_tbl->s_anchor);
 
-- 
2.24.1

