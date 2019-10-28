Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC63E7CEF
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbfJ1XfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:08 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729755AbfJ1XfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B54HdrNT6t96hDrfvffG0HsgxSBMkeKfsZddoClE8pUoHch23OFCWAC2HS5aCR1vP8rarSn/1stEVHylVYYrIQYCp8EKRq0DUSr37CckTCBI5QUHt9wmW4n9N5IVKNyAsCXLUHo0Oi8O1gP1KlCKgvihppqEA1A52fNGkuywIuV+0blcDHekam6wlXOStAGP6BNBYfXIItNR/1OBVT2ObqwoyVf9L38IPIs8M+CfB+DzGou4wx8HcjENCu+HYqrN0BpMpQtrgiY71oHflgPm14FrUh8nk2ncd8wWQPTahOwN0HU91e/YE5Uuo2Zkab7PBUT1pznbuT0R75x1jcaRzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lZ004+jajYdoGUXzEXJTXPzBYUYNv0CqCD6EEIzeKo=;
 b=S2TR00zkRmx2r4E7kozto7j7Iou0OZDtQnHkij3PpanNwjHsZUmDT5QfjIF+cbEvssdiZ/n/VVh6QlAT1B3EzQQbAkjZswjOJA/uVItemEcs0bNu+WLCW7LrdrwBqBOIaJjkJEJelqzzqAGeUJg/mb0WjYdEDhrtAcVSFyRFzTiNBhCxEt+tcinTF9xPazMmlBu1FxL++mQq+GmICrlJCoz7BIrMHGuindV5k+b72CrqSKuqbeOBzZus5lOfvhyRIer4NbQU/rqXWE5FKRI117mxfoOyK/zEA9/Xsc2I9diuynb+DIXpH4xiMhroM/W+tH5E3TOnOAiDotZI7dI1uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lZ004+jajYdoGUXzEXJTXPzBYUYNv0CqCD6EEIzeKo=;
 b=c6g+VkPu3ZG6yznKVNHpz4UkvqXPKmE2+XYpK63EC3AQPCrTcOE20GJ23f9N8xJEnODmh31YJjRMOr0+eNuaurowYt8aT2CJavVY9bTAg66IrTD/wnv79LB0Mo/ddtxvehefYlv9uVn2Y4uCynePfz9TY5Cn0LyASBNwChqhlag=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 03/18] net/mlx5: E-Switch, Rename ingress acl config
 in offloads mode
Thread-Topic: [PATCH mlx5-next 03/18] net/mlx5: E-Switch, Rename ingress acl
 config in offloads mode
Thread-Index: AQHVjehRKRQ4e3FVREGdPJBgnR6WBg==
Date:   Mon, 28 Oct 2019 23:35:00 +0000
Message-ID: <20191028233440.5564-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: ded0ad89-cb69-4fb9-1d89-08d75bff737b
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448C057CCA3B3C20AA901A6BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OqR/T80PPik2HjntP/2D7QjHMd/ha5bthY4Y4rxEWRMjvlElPUXpjZzFOP32E2ygzM2uoADUb5kAFGnFP29cqiRulngS13WrWJdC04ORxloIpm1LIgDSFcQwtsPoWsa4RNX6tmjQghy4I5oW1/g3FY6UavmW9XnVqVkW96ltpX1GohZTMX3BU0FVugnAaLamdmfZJk+cjWTNJkDjy6Mg8rNnx+nSaXrb/nu7QHhco7deW9Ab4dTlAQewGRokayvXzxIUzMRaohAsOAHQqf7ItpadmRajm8JxBxjJLqujgQ2EbCF2YcxUsv+wJRSbaqFC101P8qxHl5LgaJ+qklS18ykR8t7vdGjH6AiVam1P0H3Lv7tdM7WrGp3yNu7wxtamRYwwON99McUqaLEKaNGPMynNtHL9cXevrDz8zL9JxX0rhuY1T9GAUiDxY+SJ7GQG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ded0ad89-cb69-4fb9-1d89-08d75bff737b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:00.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ANWG4qdSSe0WqQr3tbFj+IKur7J4BORGY8GhChF9FHOl8vFLaIIpr5zXIA94LU3cHM/KYU61soOCK+5T7eYlAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Changing the function name esw_ingress_acl_common_config() to
esw_ingress_acl_config() to be consistent with egress config
function naming in offloads mode.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 506cea8181f9..48adec168a7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1899,8 +1899,8 @@ static int esw_vport_egress_prio_tag_config(struct ml=
x5_eswitch *esw,
 	return err;
 }
=20
-static int esw_vport_ingress_common_config(struct mlx5_eswitch *esw,
-					   struct mlx5_vport *vport)
+static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *vport)
 {
 	int err;
=20
@@ -1993,7 +1993,7 @@ static int esw_create_offloads_acl_tables(struct mlx5=
_eswitch *esw)
 		esw->flags |=3D MLX5_ESWITCH_VPORT_MATCH_METADATA;
=20
 	mlx5_esw_for_all_vports(esw, i, vport) {
-		err =3D esw_vport_ingress_common_config(esw, vport);
+		err =3D esw_vport_ingress_config(esw, vport);
 		if (err)
 			goto err_ingress;
=20
--=20
2.21.0

