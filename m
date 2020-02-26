Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E801C16F4DE
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgBZBNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:52 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:6064
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729989AbgBZBNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRbaw1lIFyB8UhIBMYR53iMkRQCgvwFIfXHWiSyuiWpOijogCtBSl3XHUhoLIdOQhUa7s9EZDNfF9+NLx+Ofmk1upOjBIafWKAtf7PNBY8XmHy9Hvb9BCODrp9r3YkxfYNJX94ekgfKoI9OKDIqglrEkxh4O5wI0V2qXqCiFMkf12pmATdwAO+kkJ1JxtIPSBAbfD55t+t4Cczoa3107wDHU4pgzD5/iYiEWHrP8tbK0CL3Q7i1FgkA9tbQr645G7j10IT8hWozbCvtPOG9rKdmAnL5I0kq7C1OQmHbksQqi48ln9d65AWGEZWNIHqA4S54Q6BMzkPvKpHOaXs48cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thM/Bf/TDZ6koqhEd21RZqe/TLjAXzTtW256fj6x7D0=;
 b=FRnApqZWNNcyb5tDuoA/RvmG4HzG5eNfX1o0DRU10e2wid5YXHMMF+brIL4PP9AEziQt54qTZSWky5Pgb8i1YDyYK1wiTeJDIyNfOdjUKPq8m9R83Z5YjZRRmRo+H47R0qd7qolyzNfEVv/HPM3q/sNm0W/ITV+mYNm6cJ9PvrkV9lpH6irwckmymZq8/jNRfc0HXaX5H9iwf7q9XoK8yShabh5O2xntfT0zMFoY8Vv97mHyGk5BptHoact1URBeOicWuKZA75k2ku2/sWCMwrfm0U4udEOR7UepvTvyHF2I4tiNZ/FlUk/iJ4eIjzi7tnORWaPIF4G9+w4878sSnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thM/Bf/TDZ6koqhEd21RZqe/TLjAXzTtW256fj6x7D0=;
 b=W01+qpcHOQB2ubi2YuMG6lSq8awKlylMdDeBvXl7HLA7yM6Mq9l1BXL2ZAatR8C1+jlhDpH1GkNPGU17a8hLn70Wmk5jQObb1wkUxbZO17EFC7qdPtGW81G+oj8D5kSDV48F1X5LjcksXUKux0/6k9J7HsuAwkeX9MlQFVnUp2I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [net-next 16/16] net/mlx5: sparse: warning: Using plain integer as NULL pointer
Date:   Tue, 25 Feb 2020 17:12:46 -0800
Message-Id: <20200226011246.70129-17-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:44 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60bca57d-065e-461a-d019-08d7ba5920cf
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5869ED7518D14288874A5692BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:376;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(4744005)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BbOA65IPD9Ozl2cBbOIsQ8ldwREXHf2YEqporL3T/0pJTSIVFFC56BOG4sme2Ryc6clNRFgMvyjY30Nw38dRMzRhqZf/5SOATVo0HQa+doqcodGcDNIe4/YhvdVhT+i1Qjy/BxjUMd2rpCssjwqi9FnTkhu5pXXt5zTIgyKbQno2JiZlmqwFbYg8WZDnCBDA7NiOK5K1nIQj17pjQikQOXVHOaTrm/jBA7+r+e5hdtU4Hg0O7sPfVgE3V2hdoLIagrqzqhjK5c9aOgcVtLhIc1I87UBNTFnYLkVLhrjnQMcmE5ZDBddlcdLs4hsdASIDJRo+EHd2YEKSJ9RTQtx8Hus11dI3kNG08g5GbSfjZ7tI0A/oLjM1Kix2n9XPwm4sQp2PDy/vJ3FmQC1AA6JctNjYMxYzfQZnB9o79bvGP8GA7lpoQfMOXRz6u47mcx2/3uGRTQr4GJlYjwPP/q3/6J+DU+XvGASG31dksQlPVp2Xx8hYPG3rPkKbYzNS5w0TBp2bW99/dXrlmghToflG3JkEv/rY62DQ2ZJA9PoK53E=
X-MS-Exchange-AntiSpam-MessageData: 2clDs9R07Lqd6jGImfh/WLRmTK1Uw4yMcTx2za6EYQXQNlM+FkzulmEyDRjV5P4PJY/kD/9KTvpdM8VAHLifSgqnlNMUTFaDpsxsS0OttKMYckR9w0RUzsAz9u27lsM/PM/kb8v/MBY02TlJGw7NUw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bca57d-065e-461a-d019-08d7ba5920cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:46.5248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C1Y3NOLS1wHz6NU0NDul/d7qD+Xjx8OEU84GV4G6k03wNmBXsykipjRBSV7M/Kdp4naZ67Ehh5A/DBSNWRTCWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return NULL instead of 0.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index e065c2f68f5a..6cbccba56f70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -21,7 +21,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 	struct mlx5_dm *dm;
 
 	if (!(MLX5_CAP_GEN_64(dev, general_obj_types) & MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM))
-		return 0;
+		return NULL;
 
 	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
 	if (!dm)
-- 
2.24.1

