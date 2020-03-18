Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C0E18941E
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgCRCsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:14 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRCsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7/fQLehwJJi/aOIOsCcZYrIJd0cJrYThqAVOUw8/L7XY5eziVXt87SRJPTXAZB7zFDiXC6RwXpR0xibzQq9Awx0bdD7rktS5nUdpx40aCkLDjJRNHqGnAYoD7kx72Ei0JUOJBQcSO0QiQiiXJtl44kIbShFIP2HYjC7TSkWFM4I4VeqiguyRlMNvjyGjfS/OnwSyEpKQVx/S+oXcgiiSdwuziCkb9ZoOMvm62CtsFtukdtI2ODncwqp+UcKZ5zokr6xSiuTYUkpYYbCd5HaTcGnIpaL5XVgjqtcgHQuA74eEzswzrYzEzBwvaWMRZR2HEmmcLLWjyvt0+AjZWqYSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiNm4M2ObZyGWrL+8hgn9XlwS7y5t1Dkd3YsTpy3m/w=;
 b=EksJ7s2QV4WCfdSpfZUybgCCDGYaCO401jciSQBeDMIw2/RZwbFUH+LU4yz9xTa0wW22wuleOS2V0UL54kAbF2bWCtwqcm+RQST5l5DRcFQMMDSUEWUxpgnAMrB6/1xgE7Bzq+3cCfB0m2jJ7R4F9pDE6A6an2lcy8mciT2E/K7ZuaPEcRtt9XHbU7SCqRGpQEO9wn2V1SqSbWg5Ng1WUItVmNh6v0JNQrVjlwvPE5mUnrKiMm7tfsi5w+0T1cvZH36WF+nhH6z6igL/DIUXVLPZKsLBdGsqI+aTgO/wsVN2YGmuarXDB7G8GUSEQ/3yJ50iGuT5IukB3HlWoyT8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiNm4M2ObZyGWrL+8hgn9XlwS7y5t1Dkd3YsTpy3m/w=;
 b=h+pSaWBeDlkYTSeSgASTmT7A5cILxNCbO4cgM43Lqqds658r1qK43UrUoju1ZlDcQAwLBKwZKS7oxdJ9DFSu70CobAVhvVnwcy9cV6eGLK7qvL6EyITHguwGAVx9dGsBmT+pURzpISN+7EgumOugE1WiMGKxQ1KTPMZl8D12ifM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        YueHaibing <yuehaibing@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/14] net/mlx5e: CT: remove set but not used variable 'unnew'
Date:   Tue, 17 Mar 2020 19:47:12 -0700
Message-Id: <20200318024722.26580-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:03 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2786f070-bbf5-4cce-9b5e-08d7cae6c88a
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41097207B9710C2D8D75F2CCBEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzJ4WQR00dISSOc0AtG5UwQWmNkRsQXtd79s1o9jYpDPx5LNSbcb3jvvtghShbQhWAHm1RBimkNx1l4j8UohJWIw5my3Qf6ArY1JtC1D+SMn7QLKBr3XXrH549tpbLIEM3qbRAO11Z+Xac3KX7dyzJfWxZ0SKgDUNgY+RCKGgLIjUVaSd7sf8Zn4jvD9livJE35KHYaXz8ozDIYz/BMyuf4BY2obJYHUC5hKl3HOAmC9Xnmlhq3k9mijIFFWeLBSlNUikFFb3t3umgAARLeibUG78+JKAhswazvbjUAUqaNvEjg/pA8PeGuXCv5SiFhgLjbM/RJqBOehNsHdhAUN80GrNbRS4rRLygTGemb98q6BbYvdsCaw4hOa8cCe/SEMD99zCqcHYQc3NTcKZmryfY58pD+wZ9JHIAC1Hf3HVBrB0TGn3nq4grnZKsudH3feICFqHV+2D9GUagwF3dJjyL7a0fyGDDtmSWlliNs9HpgLywkDf6skGQzqjB4e5cfDe4f/Shy4r/dVvnctSloMFaqaMyAwLcokW7nyLsjNtrY=
X-MS-Exchange-AntiSpam-MessageData: 817nrWk5rOlvN43hce/sIBAe6atEYTXMCiKSkyV/XrLZTkP3bnWaGwz+Nsd8hYjR33tsBnEnx2Qhte1fP8RW1xhOrSZlkKXlYh4ravzHggX9WX5Qa8tLJM1Wp/NUpp6icOBxT2KpwIffKVaz6J+6Lw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2786f070-bbf5-4cce-9b5e-08d7cae6c88a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:05.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /jR9we38GZ9Elj1h8LzhVuyrpdyxRWCHlt756Bt2tZx66JZcj7V5Z8ICGGk9W+fgvoKGWfyYRmcC1wscJ8H1ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:
 In function mlx5_tc_ct_parse_match:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:699:36: warning:
 variable unnew set but not used [-Wunused-but-set-variable]

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 956d9ddcdeed..9fe150957d65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -696,7 +696,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
 	struct flow_dissector_key_ct *mask, *key;
-	bool trk, est, untrk, unest, new, unnew;
+	bool trk, est, untrk, unest, new;
 	u32 ctstate = 0, ctstate_mask = 0;
 	u16 ct_state_on, ct_state_off;
 	u16 ct_state, ct_state_mask;
@@ -739,7 +739,6 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	new = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	est = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
-	unnew = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
-- 
2.24.1

