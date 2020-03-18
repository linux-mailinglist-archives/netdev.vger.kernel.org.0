Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325EF18941B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgCRCsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:06 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbgCRCsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i29B+hHTbuV+n44H9OhNkTl3n6y2FPFpEJ/yMLpUgdcd5S03zcH4+jnAX/DAgwN46Ed6ZXewg9D/eeGjiuW/tUugW3lHAfIOunQHUsFXL2TQJqa+av+b+X2Ia77D5DrM2W5ojlBvKmNecyKBSilBl1+tL8ryGYFeB7D6CtHTGppnAMJwrzxL1sA2vDPT3JnECrEQ2AXhIZ2wvTVnUzALss4aOCfgDl5oTdmPazdP6VJqEGdHhBNTmd8dQcoWJuQyHioKKK/M4j8EPYwG4WaDF/1xzH1xvPVMqyuaTRquy9nxrMrrsWaIlyEEX0zM4Ft5wz9GuquN7dEKZ4XE/uKX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+s3TlkBkc/Xj65k/6uz8DO9eAGpdLwBIfgbD3Jwb7eY=;
 b=WxkG01ODnUXLVvrUJmz+A0ZFH540od8eBQe68ZC0c63sCUf4iYfx7TFS6wZvSGv9TE4Qajx1lzM8DKQQlUQDvOJQ8/+RLEeluwYuw09ZnfPgmfRf9cVPO/vBjoYgIBEB/jwCBCIpoX46ddG8uF8GxAUOIV20AG0ApgDEE430yL3psb2q7LtEFlnB2wYxfxkzfm0GrqfN0hqsemAxYkcKew9t1J9LBhmMS4SIyKttEq4cOBZGCHUtYj87T1vVQl5mjo5Ks9LZSdZV6hOt5dQGTk/bcrWBe4l+USWGE05SpOnMJ6I/jL2tOErQ1PvH5yl0ebYkAyXn1uKrVUDyd6i08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+s3TlkBkc/Xj65k/6uz8DO9eAGpdLwBIfgbD3Jwb7eY=;
 b=H9VOoiFEBwN7tGCwpsxeul5+0Apjv+z3j00uJnZWBMYy8losiS6DkqVm4KqMG/xQzO7H/LlZ5gxn36R8O6WPZFUzIpY05GJKJVfeyfRqGV4iMd9AH/Xytj0X9YmssN4jvrStUpewuoTLNVLj8zcrbZmrGj6uJrW77ulxe0g8lcI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:47:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:47:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/14] net/mlx5: Add missing inline to stub esw_add_restore_rule
Date:   Tue, 17 Mar 2020 19:47:09 -0700
Message-Id: <20200318024722.26580-2-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:47:56 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 561ff051-8b8d-454e-bc33-08d7cae6c491
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109CC1EF799562E60E30C50BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:23;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ne2xIIgZ94YrvuImXygY7lqqL9d7qYKAHbYe0lT13L9rn7rmKUIbiWvW1culJSeHE4RICEiitJEVroAtRD/RccEiA67jtqER1n85SEDIA1m6b0W1muW9rtIHJL3IDS0GKYSxuXsVmO/vHIrD3Fz48sxXoBRJEJ2Nw3SJr+SQCr++1dilcarDgWaIJGEtdfjCnfp9CqUq+AsITuD5Mm+tVWXbUUjLSPFc10AsifX4JI+Z9+x9VdylC1l5p6LgvDeDlMZHCjHRh1HGqMdgWdIYJZC9nutFwhYdOoWl3MIJikKpUmw2PZ0LXwEiHPh3E/QTxPxQY/K4kpvNldNEwV7qoY5SBsaNTRjK8JaqzgaEvPy/Roh7i5hUauOBIAOkXjWTHbdKGuOTkDKFr3gPQ31tka9oo9z3EmsEvxPrfdk4enQhGvnkVSgPvzkF/Loh6e0eCUvuP33UEGpoNytIZ20RvwElJUmqkCf6i3VQnbcIzuQMxFseJa4fNGRMPdJh/yr9Az4gz87D8dS85xOlk41TBooLCYAwh8e+5cNXej5xm+Q=
X-MS-Exchange-AntiSpam-MessageData: CnSH0SkhyZsJ+ydao1qmeLk53CS32DIgx6JeqyonGQh0/K0k6UTdOy+Se2jR13JXCn8S54RqbsRVQ5MvOS3+LeT1Fx/6+sZ46lv5D9/dpU0Ibn+/hkv2Y00fTitYTI/4EHFqaIY/tOjP7Suph158/Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561ff051-8b8d-454e-bc33-08d7cae6c491
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:47:58.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fE68E3L5ToLFRBWLbUiHxqjg+/wg1BLsdEMMxGf8iI0PYlO5fqZjSkTzjEvnYfwxeEUjgbkcQtdTO3Ll9TCW8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

When CONFIG_MLX5_ESWITCH is unset, clang warns:

In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:58:
drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:670:1: warning: unused
function 'esw_add_restore_rule' [-Wunused-function]
esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
^
1 warning generated.

This stub function is missing inline; add it to suppress the warning.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 91b2aedcf52b..2318c1cfc434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -677,7 +677,7 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
 
-static struct mlx5_flow_handle *
+static inline struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.24.1

