Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EA25DF0E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfGCHjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:43 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727275AbfGCHjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cogv/01jWVbLdH/H8gCBRaURAqQl6ft94grw6u9q930=;
 b=Okl/6zu7/85sICc+4cmS3o6qBSzFm7u7gpMRksaCZNCwdyzszm5lP0SGOy8T8SNcfG9qZAWwGzEhEkFOkhQhgf49JV8V+vUfDSH/Wjfhi7mO2SAbiwq8kY6yJijUfXLW6hJHsXA0YST3wjecXjlBTbFUygwFZz2KEJv/FmIyp08=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Properly name the generic WQE control
 field
Thread-Topic: [PATCH mlx5-next 5/5] net/mlx5: Properly name the generic WQE
 control field
Thread-Index: AQHVMXJ1iRJq1NpHbE60fMU1k+OF7Q==
Date:   Wed, 3 Jul 2019 07:39:34 +0000
Message-ID: <20190703073909.14965-6-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 121c043e-201a-45ec-1be3-08d6ff8997aa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB23091BC0C1FB643E0716C642BEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(107886003)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(66066001)(256004)(99286004)(76176011)(14444005)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(11346002)(446003)(4744005)(14454004)(6636002)(102836004)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KmTWmm59x/tmKLeDqq3DLtyP7zNm4NMO9CANnwoUPWcBQ2OPyANlvI9y42vTxZhY4fUvpGb0RQ+56jmPn/V3/hNZsu/NRqcnoTqklCkfDefHZKEaKG9qsyI9Dyiqhw3DOxg4SMnmLmz4VSBC0bvuVtlQWq/E2p/snnx4NcRSlhc58oTr/WwnsWhpuiViSP1crViT7K6KJfOiA0wmjFvRa3kgGUJaPlK32EivPWfEcs1I9cxJygUdVQpCtA1qT1gQ9DeRrzokIN8Xxn/x0IcLyRwjCTiDHqbY/XxImpP62B56nbyGgtqjoKKI5BplDrIaw4DzTHwLOiydyRBkOCPXNA8eZlRzVHeNM7CtQV0PPC7pttn92uzvSi6Y3blowxoaG+7U9g/B/8wSq/28vlNLGrNpkSO4JlGeFig+mW4lTPo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 121c043e-201a-45ec-1be3-08d6ff8997aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:34.6049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

A generic WQE control field is used for different purposes
in different cases.
Use union to allow using the proper name in each case.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/qp.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d1f353c64797..127d224443e3 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -202,7 +202,12 @@ struct mlx5_wqe_ctrl_seg {
 	u8			signature;
 	u8			rsvd[2];
 	u8			fm_ce_se;
-	__be32			imm;
+	union {
+		__be32		general_id;
+		__be32		imm;
+		__be32		umr_mkey;
+		__be32		tisn;
+	};
 };
=20
 #define MLX5_WQE_CTRL_DS_MASK 0x3f
--=20
2.21.0

