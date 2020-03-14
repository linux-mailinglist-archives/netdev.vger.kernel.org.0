Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B601853C9
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgCNBRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:23 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbgCNBRV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8inrUYfneSdbnPKnaGAuzafk1skoRz2cdqnIK1GzUDhV6tY5GSFZ2WNUBXjsOIxUxuCBjkREco+xaLdjg1J/BDhWwsQx1/EwCwQz3jY9gaNC+ua+5SSZ8bFTZUc3G+sgr//vUtZqZYShqXjK/hJJo7SrcMizvhjM5bFSaGZ3R5XEjmeXTk38fkG+YL4rdbsvFRB2aVjLhcBWi/ql0CggWuR0LLGpwSieXUnGVT4otuvUleO2Vmuz2Fx/0RvTI3YngAdeWGO9C77kqsqGtDBqKFISrCo7vk+gOy+VZGikXHnsPeHGfUNtEDMW53/UMMqJ1A9dvpLrIygwgEuM6SyoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8eXUsqeJFRgwq5tkFQ2sGQzhgwjoxEaeHbqz+geEHY=;
 b=HJPbwY69TcNJMY6F6Sfx27XQ4tmIlVeF0qrKM+9o/iY1iWwoUaEnZeWg4Pvna4lTo1g8x/nsXrhibB7D9i1Q2CTcnvjVm6iaUCoWyvCumk34pYGyiahLHJOhL4d02yP+QQBkLy+tZqU0t9CPvu43yYzjOZXrBRngfnZFeUnkpowoDXYNwN5RhwLR2n9mb+27sOR4ibIwzpmBxt53NZ1g9CQkIWeGFCh/KJJaQj/AGhpEbJLWpjUKInw8k2CXXUMoFwaZa5vC2jGXp2xNVSGNzgJbV2oNoO05Yl/BjnBlit/PQw0sHdt+JXG5GfEngGTRu+oCB2XiVeYLmfj8bDECMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8eXUsqeJFRgwq5tkFQ2sGQzhgwjoxEaeHbqz+geEHY=;
 b=hQ43I0RU1aFjBsbjAaEEwbL4ebeUBLiSxRi05/yw/QPJBkJn2HZP8fSd44XmdlRs5SZsYNPX13SJINxo8MKIVOdV3FwRm1C5yMYz6MEW2bptzn5TMVlmCTfxQUuu1TcxNCfE6YM5p1BP76nTfpC7MVzURLsZKlQpjFbGMup0cOY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/14] net/mlx5: DR, Remove unneeded functions deceleration
Date:   Fri, 13 Mar 2020 18:16:22 -0700
Message-Id: <20200314011622.64939-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:13 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 230effdd-cb07-4d2b-fbe0-08d7c7b56e66
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845D27C77FDA90A3A58AF25BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7U5VNZ6n+55eR1MoLlqGyGMbHFQh1NGX1fLenlhMA4mXD7KKepV6N5cCghLEv0SALmOe1YC5GzvmgecknUKMc7gpNHb2uQWe3zWyllm0KK44wJvJE7MHBaCiYB77fEt4B5uP0RykWjcU4XNXRThdh2UcbiyruYXKWB2dXuZFFGygypnzXKalKIIM13iQjkLW/lxbP28oZNZShFxnK+ZQ/VzfLIJRvVnO60yDDECOTTYoBsIb/F20tzSFDp5Qq7hD/i9TZbETUbDOIkx12Kw2uRKNLybHHNnlSuT5g3rS8wrQx4AxZrox3Z3DgsVCvJrzHdqZIf74kxPLYysi6maekovr2RISzN+wLSGDROgVQDHY0gc4LBFlYzCpTng4iIrHFrYRbXQabSY4hawB0eTK1Uh+s8Zt53IvlGpJ3Moe2W8kJhCWinP8r+ltGcw3SCZkjeqlc0hJAOIjFnZxjWInlYt0oLj6wjod8QVyVDiO9u02RVVP8m0YYgxDPNUalcLodpSFMo6OXI58HYHsHB2cJncaFiv+61KDPJUQHsKhGzQ=
X-MS-Exchange-AntiSpam-MessageData: IFzD7zAhEu1urYk9XeJ7gayDUuEFzax+p3LDRkc8Q6/DvXMt/PhPlMgxyNi21zmGct6Nogmom210RxY7Z6x0MB0Y/gvgK1GuV+QD+/BKVltTAvTUAE4T3ABjRtTT/tTi2ohTeo8ZgjbtspI9PY3lyA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230effdd-cb07-4d2b-fbe0-08d7c7b56e66
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:15.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YXgvtO2Ye0Je8NEeW504uANnX7rCOd0SPFkNworma5GKMWQu3Vsn19iWQkuoHq3V6U3DwVjFoQ3MmACS4ZNAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

Remove dummy functions declaration, the dummy functions are not needed
since fs_dr is the only one to call mlx5dr and both fs_dr and dr files
depend on the same config flag (MLX5_SW_STEERING).

Fixes: 70605ea545e8 ("net/mlx5: DR, Expose APIs for direct rule managing")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/mlx5dr.h      | 101 ------------------
 1 file changed, 101 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 1ee10e3e0d52..7deaca9ade3b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -38,8 +38,6 @@ struct mlx5dr_action_dest {
 	struct mlx5dr_action *reformat;
 };
 
-#ifdef CONFIG_MLX5_SW_STEERING
-
 struct mlx5dr_domain *
 mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type);
 
@@ -128,103 +126,4 @@ mlx5dr_is_supported(struct mlx5_core_dev *dev)
 	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
 }
 
-#else /* CONFIG_MLX5_SW_STEERING */
-
-static inline struct mlx5dr_domain *
-mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum mlx5dr_domain_type type) { return NULL; }
-
-static inline int
-mlx5dr_domain_destroy(struct mlx5dr_domain *domain) { return 0; }
-
-static inline int
-mlx5dr_domain_sync(struct mlx5dr_domain *domain, u32 flags) { return 0; }
-
-static inline void
-mlx5dr_domain_set_peer(struct mlx5dr_domain *dmn,
-		       struct mlx5dr_domain *peer_dmn) { }
-
-static inline struct mlx5dr_table *
-mlx5dr_table_create(struct mlx5dr_domain *domain, u32 level, u32 flags) { return NULL; }
-
-static inline int
-mlx5dr_table_destroy(struct mlx5dr_table *table) { return 0; }
-
-static inline u32
-mlx5dr_table_get_id(struct mlx5dr_table *table) { return 0; }
-
-static inline struct mlx5dr_matcher *
-mlx5dr_matcher_create(struct mlx5dr_table *table,
-		      u32 priority,
-		      u8 match_criteria_enable,
-		      struct mlx5dr_match_parameters *mask) { return NULL; }
-
-static inline int
-mlx5dr_matcher_destroy(struct mlx5dr_matcher *matcher) { return 0; }
-
-static inline struct mlx5dr_rule *
-mlx5dr_rule_create(struct mlx5dr_matcher *matcher,
-		   struct mlx5dr_match_parameters *value,
-		   size_t num_actions,
-		   struct mlx5dr_action *actions[]) { return NULL; }
-
-static inline int
-mlx5dr_rule_destroy(struct mlx5dr_rule *rule) { return 0; }
-
-static inline int
-mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
-			     struct mlx5dr_action *action) { return 0; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_dest_table(struct mlx5dr_table *table) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *domain,
-					struct mlx5_flow_table *ft) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
-				u32 vport, u8 vhca_id_valid,
-				u16 vhca_id) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
-				   struct mlx5dr_action_dest *dests,
-				   u32 num_of_dests)  { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_drop(void) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_tag(u32 tag_value) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_flow_counter(u32 counter_id) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
-				     enum mlx5dr_action_reformat_type reformat_type,
-				     size_t data_sz,
-				     void *data) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_modify_header(struct mlx5dr_domain *domain,
-				   u32 flags,
-				   size_t actions_sz,
-				   __be64 actions[]) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_pop_vlan(void) { return NULL; }
-
-static inline struct mlx5dr_action *
-mlx5dr_action_create_push_vlan(struct mlx5dr_domain *domain,
-			       __be32 vlan_hdr) { return NULL; }
-
-static inline int
-mlx5dr_action_destroy(struct mlx5dr_action *action) { return 0; }
-
-static inline bool
-mlx5dr_is_supported(struct mlx5_core_dev *dev) { return false; }
-
-#endif /* CONFIG_MLX5_SW_STEERING */
-
 #endif /* _MLX5DR_H_ */
-- 
2.24.1

