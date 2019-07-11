Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4A66016
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 21:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfGKTkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 15:40:02 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:33188
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfGKTkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 15:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu3eRp2TZYCrkg3dOkHfCXgqNPqc1usXja3TT3rLuHE=;
 b=eTonrSsDut3/2fK8HNOi5TGsI//5WZWiZLmD9RmvAjfzW4JXgfZBwOdFl6alDvFnIua+XEm3Rz4Q58bfjvW/psBDBU4Gf9aBJSsOgbebi6r2r7p8Bf7hZtFNLzQWUsd4Teq2j7ot0EjDIdJ802ktt0kbykvw4+zpX4QgYM2rm9k=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2851.eurprd05.prod.outlook.com (10.172.216.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Thu, 11 Jul 2019 19:39:57 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 19:39:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH net-next 2/3] net/mlx5e: Fix unused variable warning when
 CONFIG_MLX5_ESWITCH is off
Thread-Topic: [PATCH net-next 2/3] net/mlx5e: Fix unused variable warning when
 CONFIG_MLX5_ESWITCH is off
Thread-Index: AQHVOCBrp8vVHpzR1kSUoTkxLWuzNg==
Date:   Thu, 11 Jul 2019 19:39:57 +0000
Message-ID: <20190711193937.29802-3-saeedm@mellanox.com>
References: <20190711193937.29802-1-saeedm@mellanox.com>
In-Reply-To: <20190711193937.29802-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be63c8db-dd00-4daa-1357-08d706378de4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2851;
x-ms-traffictypediagnostic: AM4PR0501MB2851:
x-microsoft-antispam-prvs: <AM4PR0501MB28511020227AAA3ED67FBAF5BEF30@AM4PR0501MB2851.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(199004)(189003)(66946007)(66066001)(26005)(66446008)(71200400001)(66476007)(71190400001)(186003)(81156014)(8936002)(6506007)(5660300002)(1076003)(305945005)(66556008)(36756003)(99286004)(81166006)(86362001)(25786009)(14444005)(52116002)(102836004)(64756008)(53936002)(8676002)(386003)(478600001)(76176011)(446003)(6436002)(476003)(3846002)(11346002)(54906003)(6486002)(6916009)(2906002)(2616005)(6116002)(6512007)(486006)(68736007)(256004)(4326008)(7736002)(316002)(14454004)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2851;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t4ptftzT0xQjfLj1f7WaJHmLdE3SCaMHcuhnGrCRCK0JpGkeb4O+108IUCrco0CsdJ08I/ZCzZuHMZ74RjtOqzF+MA0q27SSZufI7Oz5USzJK6pkyWV+9MESx9m7rQpKNVAzRQprVMNziosVyaLZsSx5ZMxJINA6EShPFA+jZFGw4iqyVnJ8lwZ/ZtE4GddOip9pd0R2A4P30ApNw/pSoQHfIQJNYu8PVoUtC6HhrqKVAF20V8dve7cQJNvo4n135WIGeacmK/PWT0n0cN4h+YL/+tKutLzDgB8WJamp3m1kvAgxVB7MJNr29JJAQi7ZH2hmhfFveL9HHoIes99vAb3WZeYfV4e8maP+bp2tpMWptOS/S0Hey7ihZaYt/FaRVD8Uk/U9yFALi3yi517RY54oQon/MQYbK+ThmNbRO04=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be63c8db-dd00-4daa-1357-08d706378de4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 19:39:57.3745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2851
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mlx5e_setup_tc "priv" variable is not being used if
CONFIG_MLX5_ESWITCH is off, one way to fix this is to actually use it.

mlx5e_setup_tc_mqprio also needs the "priv" variable and it extracts it
on its own. We can simply pass priv to mlx5e_setup_tc_mqprio instead of
netdev and avoid extracting the priv var, which will also resolve the
compiler warning.

Fixes: 4e95bc268b91 ("net: flow_offload: add flow_block_cb_setup_simple()")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
CC: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 6d0ae87c8ded..9163d6904741 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3390,10 +3390,9 @@ static int mlx5e_modify_channels_vsd(struct mlx5e_ch=
annels *chs, bool vsd)
 	return 0;
 }
=20
-static int mlx5e_setup_tc_mqprio(struct net_device *netdev,
+static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 				 struct tc_mqprio_qopt *mqprio)
 {
-	struct mlx5e_priv *priv =3D netdev_priv(netdev);
 	struct mlx5e_channels new_channels =3D {};
 	u8 tc =3D mqprio->num_tc;
 	int err =3D 0;
@@ -3475,7 +3474,7 @@ static int mlx5e_setup_tc(struct net_device *dev, enu=
m tc_setup_type type,
 						  priv, priv, true);
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
-		return mlx5e_setup_tc_mqprio(dev, type_data);
+		return mlx5e_setup_tc_mqprio(priv, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
--=20
2.21.0

