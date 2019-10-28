Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C15E7CF5
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731377AbfJ1XfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:18 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729402AbfJ1XfR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN2MVKf/Fp+AglF5iMB4xN7UyeTMC/fJTd8hyialT9OPJNVCcqhmPIvcFVglSIQh5qe40cVg0qN0/wgY1WYZAx6Vh12NbJv3GsUlEPRTUOEDXxmJdzUOUhw6BlhpccLgCxL5cRZCNmawzQNyP78SGRztZTB6FuWiyTTwXXojJ74ddhSs8BUhAw+Ou0/JocpyG/F2553r47B6RZAY7I5Lz2xVqIuC3pGOmu/NMgxVgav1hTQzGf52fXIuuSt3t9C4TO57NlircIKeu7tYUTSsfCV2CUPWsMpmpZK40R57LULlvI0NVUTaNLdM6PgpLCgsV/r+64u3SzW67+0uZjd8Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoPaI+ekp0FcMFqnbuBmO5DafkXUYABgPNosUTW1XQQ=;
 b=S7ENATvystQ88G93zVDGzgfVXqjWONvOz3jfZbCn4MysI1dq8JZuE3rd5DwdLaDQi8Cw3fwyT7QEE9yoZ0cjGxCtXU+mMSzdJckJ2ZLFLphMIHXF18HwHzTFTf+AVvu7EsNdARkJcLree2G82yJbPukF2XWx/oiX1HpTM10ptTbTk10UH0AqTfSpZOpps8J67kkvk4TsqgZmlXe00kmwS4tInVljN4nwn2aBKqIPGm7FBheucrVN1T617/LH/nT8c85Wvq9gXxdWqi3goWYCL25oWydd+q7oZTgfAXVfwjYIH1hZDCat1zVr36Ir+x+c5mZHMWkoaYvM8T9f7pOEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoPaI+ekp0FcMFqnbuBmO5DafkXUYABgPNosUTW1XQQ=;
 b=tDPjoeGPpXSsDubAjxdAu5ZXlbpYPjxwwjvrtR7B1LI8TcD1ixC+GzYauVN/WGRXvl/gPTI9YtJGJWDsJDqu8sATBxqN2EdgSHDHJbI8SEo9BSwa59pe6adtboUlf18N3WlFi0HYkdDHLJmyo9MzKb5okkSQJnicFTWH+/kkZ+0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 06/18] net/mlx5: Correct comment for legacy fields
Thread-Topic: [PATCH mlx5-next 06/18] net/mlx5: Correct comment for legacy
 fields
Thread-Index: AQHVjehVcVHh4RmFukOtlhJYREEdZg==
Date:   Mon, 28 Oct 2019 23:35:07 +0000
Message-ID: <20191028233440.5564-7-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 84c2ad0b-207a-4133-0eef-08d75bff7787
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448F96A85DD8DC1EDE981C2BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bbpUa1iD1GyfsfVl0JtFG9kWCoDpDGiUMwT3hFKZgLNEtGFMNCFABVl0eitwhnx5MZ/B+7wEFRMZzFzJwdvFSdAiOvAjRAsC9G0Qpv58P+vLPfKeHb/319ZDXwymht8k7tvmbmgWD4EBq/pO4uLj648IdTvoWgJodzivayzvvuZcWbxeE0JS0ANUGCpcrOJGK3iFmVv0xOqiy7hXzUfMAR+7ZVx9Ca+P775weAeUOtvEqItcXZ1jveSeoO30vEPmVF7xgia3yZeRCLMcB2KtFh/OrVrPSpQVDEVUMJV2uj6ofKACMmcgnqgc77kZGdmAvJA1YkJ+g3iBMgqa7taN7kACxW6zhLIGB+G9oEbjYPfD7jAA5xkebPrBio/WcYt3AfUbMeOvMcDDkNnCaVXzcUX8jphd4B4ZBcJ+fcVFiJLetpG3MdwwdVB2hd6EsLC7
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c2ad0b-207a-4133-0eef-08d75bff7787
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:07.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gWKNZhwBqr7vnAPyo9Wd0kLU1hr6nsa4S25dkZcnea/rOyVZN7rXfJ0YwylPMGv4H/qmknqYsi+bjiXbCeNvuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

fdb_table is used for both legacy and offloads mode.
It was incorrect to comment that fdb_table is legacy specific.
Hence, fix the comment to reflect that fdb_table is used in legacy and
offloads mode.

Fixes: 131ce7014043 ("net/mlx5: E-Switch, Remove redundant mc_promisc NULL =
check")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 75e69644d70e..a41d4aad9d28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -217,8 +217,8 @@ enum {
 struct mlx5_eswitch {
 	struct mlx5_core_dev    *dev;
 	struct mlx5_nb          nb;
-	/* legacy data structures */
 	struct mlx5_eswitch_fdb fdb_table;
+	/* legacy data structures */
 	struct hlist_head       mc_table[MLX5_L2_ADDR_HASH_SIZE];
 	struct esw_mc_addr mc_promisc;
 	/* end of legacy */
--=20
2.21.0

