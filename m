Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0496D16F4DD
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730229AbgBZBNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:50 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:6064
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730214AbgBZBNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhbQl6QUEqIwdF8UIV29W5lmeYU5raBDWbiYPBk89QkVc2Y0wbS485MrYkKA0+dv92jR893zHT9t1kQ+7y9/Z6uAjraWNCoHD98qkFVkKcXm/BtUjkgDrTTmcDL8jhwfO3gqVZk7wxI+rgH3f+hneds7ALaGwQNudhHm+QVMUvLK2zZhyFR/Rze4MZ4/sWfed16/jWBxY2rM4w/bbtHKAY/lrY1ydxcE8zXP2TZqfbF+64Svi9PiC7bzRMjW6txgJGwHRhkkp/g/b/P6StpzDzdYUCMU2PUCgMzlgbFcnzGQ/FTgeT9IFNBNCmyK+QvRbU+EDLXSAKKwHzappnb0+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=947OOm5r7wqKGVaNh+G9u4wWdJ8OfHzb1sHC2wjD5Cw=;
 b=J/j6ljUuRxlHLfv+I2Uv5FIrC/qTzS7Ne5jB4pwcERPCk7UTq1ZZ/dJZtlMTRSx2jdvZfj0iu8hE12X72829UcITHowqrwTqh6AoK+hb+++IO5uytN5GbJmispVMsbaaN3vw8xWNJiHO02NoPPXGyAk5Jx68W4csZng6Si/rALCMOXbxbTyh36UflEeSnTKXWFTLMzDB6zu0eeIhZZJQeIet4BCaFeWV8VEjm7oUYHbs36/qTnyC9FUzaVn71kcn2KFD2iWUivEea9xXDB4j9GmK/u7zlw1h26BbAjDS3vcgcEWe8FgksoPobkEyv/449fl2dP+z9fqIVgBsjmMg7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=947OOm5r7wqKGVaNh+G9u4wWdJ8OfHzb1sHC2wjD5Cw=;
 b=ADSg9ZCTMJ0VZxdXlilrwTAGkvyk4Z02OemLJxKtw3qchtdmRaGmEN4DpHZodjEwLIxnOUxKnNwWVlzNLXAhkA6W0iRpELR5//dyHSKG0JWK9bUCknATdwnrHaU1qeL8bx2doxxUjrdp326pnHjuk0t4Y23jSE0u25oZhBcZRLY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [net-next 15/16] net/mlx5: sparse: warning: incorrect type in assignment
Date:   Tue, 25 Feb 2020 17:12:45 -0800
Message-Id: <20200226011246.70129-16-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:42 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ba058e5-9585-461d-2c0d-08d7ba591f87
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58691DC197344C1A8F79A1E8BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:478;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qc+LYzxxav19WwlpfDSDELOrzP8nXGwJ9rntTrN335vFRHfTOxlwZ7jyMBbdyZGVLO6L5OqroiVvtRR3M/CP2FzuZSqmcaJFrjBsDGbO6m86MRREjFUGgjrnxQRqGWwyIwn6/PDqUlQ5cOtJsUZ2AvFBy1Dg3PJdbTCqkNWTp6R1wPguJloOCfKUPI90n1D2zukKoHl9h5GcpAbxaAZ+whAUK5VpflTLJgK5pmUhOjLfF6HeeiM0asUp1n/irSx9KtmKLaAEPWeLfbpCqsH+/h4awK0UAVIvY9En4zOKLdzIoN/pge7qNsCmgXlgWVUstLSRc4b4wLbakt1QqvfTK39x/vzYw8kLKq/rYgBzOp2Jb01VgGpEs68u599uU7cS4Qb9wNGz0/UMiEev3fN7vu8NRGz6UkwLqviMfTk2a4EBPUQCEN0seGURzRv0J7TqQkLzk4zSTyxB+Kqdr9VpGoTnZdksC6R44Hm+F0Qvh8jsYAB+uHWQ7JThYlGaJdqZsAhO0qjnsaLchGI4Qgq3xrl1cSDmjVx4Tx/FUiAPS4Y=
X-MS-Exchange-AntiSpam-MessageData: NWs13mScPSZ+v+9CQZt/mr5kbdKkBy+7xkxABraRRrcvx4hskGgmbwuY6nok0jG6NN0YEJ/a69hz5Z6XCriaML3R+h2FKEGSQ+JfPK6+9VO+qmZRpgJNMd5i+Y0pDgVIyWyNL8slPPXsDi4aIW/NgA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba058e5-9585-461d-2c0d-08d7ba591f87
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:44.3750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8xQ5/mZfZEIRZ2hmlZGM4yoIOFs3Bic4KG7C9bUjEA4tvuPSadhjip7l6KMRGbMp1ra+BMarYG5KT0WTDBChSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:191:13:
sparse: warning: incorrect type in assignment (different base types)

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 94d7b69a95c7..c9c9b479bda5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -188,7 +188,7 @@ static int mlx5_fw_tracer_create_mkey(struct mlx5_fw_tracer *tracer)
 
 	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 		 DIV_ROUND_UP(TRACER_BUFFER_PAGE_NUM, 2));
-	mtt = (u64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
 	for (i = 0 ; i < TRACER_BUFFER_PAGE_NUM ; i++)
 		mtt[i] = cpu_to_be64(tracer->buff.dma + i * PAGE_SIZE);
 
-- 
2.24.1

