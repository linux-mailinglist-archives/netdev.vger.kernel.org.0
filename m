Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B915C88581
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfHIWEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:47 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:23013
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfHIWEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4twqyaSrDYwMolGlR5dNSYbeQ1MOnjPom3ADFTOrUr0pwj7YSpM4vJXX23FPEJeoc9FQc446zc7LQ9G9dzcS2gF6DCC7slteA8rKrrpMmwPZFZQP21RSVHnMTdXZ7pL2W45UBX61yYrtpEonCgMTuHe8B7JQ3inPKmiwr39fmfrUzlzrUSncq7xbQpGQhTe2i509nTUbXqubE8twIr3eLoMh0iFX3moWRhsgCvBJSgW8P6xWbF5Y39/oM1iYc4T5Sy32VVRMjViBYmBvib/rJqfhdDjOCsx+lBZ4inhQNXSSF0iHdQEh36Pnemo8oS8/sbanDbzhGW/6Xmpd8Un7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFJIkHjY33VOC5/cJV3w2PMZh8M6YpX+tZCqoVSwhgE=;
 b=XMRcbrTsgRyIm5JIE+m/05PRdS/P0NWaEm3GHiUM6GpAeem7/rOBPkK5/wNYgjVCPjy52xLlY0of7ljL3/fQyqQHCVWhu3H6U/Ie201okXx2DBjsD1Nhynn9RcVUxsUenwYEOKVvhkHKFa3tJYfCW+2gwDEBTzw1vDIQp+7ffoPHS6fUIoUsA50PWR1Be+9dhbAWVopc4UKeDXyjpSyOAPgSKzbAdiMRGGtesI1J8IvZ+OW0mqaJJoRx/6AZ1B4psj5Mvn/px8Jbfs+BZtprG9p882sPGCAOIBRO8R7pgke3ZFoz5qBMLzvUDC9h75Yq7fJHubcByv+CNg7DFXvTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFJIkHjY33VOC5/cJV3w2PMZh8M6YpX+tZCqoVSwhgE=;
 b=delfEZ15+B5Z2pk62LFV1TCI5MiFNaPwoC/lwNxZYJ303g1DvwZEwGDi6M0JxDyvOHVH5oRkOgYvPr3ZOgbVUBccovO/srxzT3vXBKrgT4uRwsqDvQlnuKbrWc8BVppQ2nKrQCpLgFyaevzJHGgJTMuqbwlq0qF3nWjwjxCMZ2Q=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2405.eurprd05.prod.outlook.com (10.168.71.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Fri, 9 Aug 2019 22:04:39 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5: E-switch, Removed unused hwid
Thread-Topic: [net-next 12/15] net/mlx5: E-switch, Removed unused hwid
Thread-Index: AQHVTv5wJyFkikyWMUqHz4lBVt3aug==
Date:   Fri, 9 Aug 2019 22:04:39 +0000
Message-ID: <20190809220359.11516-13-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8333b873-79cc-42fb-1fc2-08d71d1592ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2405;
x-ms-traffictypediagnostic: DB6PR0501MB2405:
x-microsoft-antispam-prvs: <DB6PR0501MB2405F8FA0EA70D101C59A9F8BED60@DB6PR0501MB2405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(189003)(199004)(446003)(66556008)(36756003)(6512007)(6436002)(99286004)(66476007)(26005)(102836004)(53936002)(478600001)(5660300002)(316002)(8936002)(4326008)(486006)(71190400001)(11346002)(2616005)(386003)(66446008)(66946007)(6506007)(186003)(64756008)(6916009)(3846002)(6116002)(256004)(52116002)(305945005)(1076003)(476003)(81156014)(8676002)(107886003)(81166006)(86362001)(7736002)(14454004)(50226002)(71200400001)(66066001)(54906003)(2906002)(25786009)(6486002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2405;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wchUTjppgP817QilhKFvETX4YoEGrdp9jRQuZHU51PxmuwuQsmBL2aFizJWmHb7sMgi2s8QJCI+kgRs9HzT2uj/m3mkrZQpB68z2rCJ9uhtokbq6xyppARMBgYO00NXHMDU+4eDS9mjkbz4K31OZVwsktbvi4H111fJh72EDQ0bOvyT3e5ItJWtqjtf+5N8m5cvCEAqJUv20N79N7T8vpmHZa5OlXZnnlEa6piuHvi4iMiZD7j53Q7WSm88EBbC91wuekfUvR1u0pl9djTzMYyD+0vQE6pSOBwExpQqMmXXH7qAkJZEloAvMFgNlHw/Lenlk0JByAjnHfyBA72S2qcsAdDdsA06peVF/Xwl2QRVEgKeEYBidbPhXSAApwyg3WX95whDi18bvrwNRnT4rB0HsfxzxE4WjZwdUv0lYczs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8333b873-79cc-42fb-1fc2-08d71d1592ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:39.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gr11BCj3ZhkIgwe1HUita3g4A2srohIwxNW1yji7ZlaT11x4B+rCcMqwF69ZntkE1pSaawrIC1uUO5Omq3RGrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently mlx5_eswitch_rep stores same hw ID for all representors.
However it is never used from this structure.
It is always used from mlx5_vport.

Hence, remove unused field.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 6 +-----
 include/linux/mlx5/eswitch.h                               | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8fe5dddf18d0..42cc5001255b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1393,10 +1393,9 @@ void esw_offloads_cleanup_reps(struct mlx5_eswitch *=
esw)
 int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 {
 	int total_vports =3D esw->total_vports;
-	struct mlx5_core_dev *dev =3D esw->dev;
 	struct mlx5_eswitch_rep *rep;
-	u8 hw_id[ETH_ALEN], rep_type;
 	int vport_index;
+	u8 rep_type;
=20
 	esw->offloads.vport_reps =3D kcalloc(total_vports,
 					   sizeof(struct mlx5_eswitch_rep),
@@ -1404,12 +1403,9 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 	if (!esw->offloads.vport_reps)
 		return -ENOMEM;
=20
-	mlx5_query_mac_address(dev, hw_id);
-
 	mlx5_esw_for_all_reps(esw, vport_index, rep) {
 		rep->vport =3D mlx5_eswitch_index_to_vport_num(esw, vport_index);
 		rep->vport_index =3D vport_index;
-		ether_addr_copy(rep->hw_id, hw_id);
=20
 		for (rep_type =3D 0; rep_type < NUM_REP_TYPES; rep_type++)
 			atomic_set(&rep->rep_data[rep_type].state,
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 46b5ba029802..38a70d16d8d5 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -44,7 +44,6 @@ struct mlx5_eswitch_rep_data {
 struct mlx5_eswitch_rep {
 	struct mlx5_eswitch_rep_data rep_data[NUM_REP_TYPES];
 	u16		       vport;
-	u8		       hw_id[ETH_ALEN];
 	u16		       vlan;
 	/* Only IB rep is using vport_index */
 	u16		       vport_index;
--=20
2.21.0

