Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC0124A6E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfLROz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:27 -0500
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:9171
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727384AbfLROz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF2MaIPFNZEmE/4CBQ101cb6oV4GTAtE7ZMdzZxwYPTYTdmfpd0QnPTHLS54/vXIa5Ao/1anwLO7DQgemRIceR5wHPQcOMNlpFZ6UZCRSgVjGouecYdpBzbqNvPWR9Wu8Io0YijxT+HKfaNlpSuRfg2cOCF4u+lE625gK4LgSwYiHbfTFc50B6YQXCl5Q3Or7as405syGlmdLVszqWWow1rnsOyPQzVshs78hgclX4jIuRmvkDVkmov/vLVUd6MI4ylrTGAA2+2X/idDpiHalAoPjXKZ2d/gL4zoiI0HlJszeKeMsIDcpLYZKgSBDmE8vvZCwDERtGbPpOPg+YmQIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gA8EirxYJozVilpxNVs7j1DPKE5lvVsjznxiSRzS1w=;
 b=G3o8mpX0Vg7HEhdpmfCzOmhuLsPdgYc3ZykAWf8kXIrPcYVeAfH2XoET/vU7X5cFi98QF1Gns8JIPItibxY2fB/8oeMwgUPhFPnw7DPGXT4Kdr65nDMOpsoy0IdK72mnxE/4L5S9ZlnFPpOnDihACJpSV/NB0h1D2NDlykgLIVv/Bt4np4bk88MRlc5/Z0/bAghjJdjMZp9TN8qfL6E5MsWLdvQ1FcfTt2GxKK/T6BTlAUYF92JR+4wyUbuRv7EjP06nOlXrVRBFwoMQMEBhZ/GRdO+HHDZEDfe+8+54RZXhpnVl9MbnfFx9v/QQNdK6UznIRhzNRsYtphQzXnd73w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gA8EirxYJozVilpxNVs7j1DPKE5lvVsjznxiSRzS1w=;
 b=LcpVYDbY3M/x3gJYqVPOBZfQz7E453Ahsr4Lt3Tib4se+LsdOnz7DP/EnGkfYtkcmojeKdgqzyhps62DZ6AYOlnktp+f9t1VuMuCJySgb/wUJd5Tk0in4RIUbwjY+yLw4s408/2MRYq7YhQ6kqAvj+sJlzcq8f7QxWBYIb9tatc=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:12 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:12 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 03/10] mlxsw: spectrum: Rename
 MLXSW_REG_QEEC_HIERARCY_* enumerators
Thread-Topic: [PATCH net-next mlxsw v2 03/10] mlxsw: spectrum: Rename
 MLXSW_REG_QEEC_HIERARCY_* enumerators
Thread-Index: AQHVtbMl82NHvn0PCUaO09bmYYpAUA==
Date:   Wed, 18 Dec 2019 14:55:11 +0000
Message-ID: <a3cf59ff15d2df8c7b48b65c41d6460797f82488.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6c8576d3-7a0c-41bc-25df-08d783ca4844
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3048C85B863210608583FD18DB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sJggYyj7wGIGLwDU3TibS/DWXyQV5NXJQ00DHqLA4Feh6fpCuN34CTA6qAvM02gmSA2iGjmfqEE5aXw/nQOT606JNA9lgtswwBRlMiCpsQ4ORviAw0bx7KLefffWq64gDYnKSqv5akWHcma4MGtFOx8nY8bX4o3jHgDeDShkEGL5pp1UCCmbittbAr59H5XO5r0jtDmynSp1h7JkFo1BLmJG8Sl7pPB/nX6D9gywNVEN7wb8dXJDuqZ7cmlJeTH9rx8VVvuP94ZuwVZvVp+pMNdt0yHU/T7X4iIcdnpWmqwLC+HrbWZgp3ItOIOHsyZlAIpfZUlJ/2K+o7rG4NCxXomWtE/VoMuPeM9Maq6aMmrUrEkkMjQKzbs6oN6rxjbak/D7W4utMxboLbajdbIlL+TBGYUBpVG1//ibHDxwYvdQGrAbpGO8pMT9i75HT99Q
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8576d3-7a0c-41bc-25df-08d783ca4844
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:11.8671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4+zPKWmuPKjYK8Dg7tYV3oGq67dGldHzHBGka7EV8B0Ivek8PXRdqlWmuOWz0+9xSvcOKrLOs94aQ5QC6uw8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These enums want to be named MLXSW_REG_QEEC_HIERARCHY_, but due to a typo
lack the second H. That is confusing and complicates searching.

But actually the enumerators should be named _HR_, because that is how
their enum type is called. So rename them as appropriate.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---

Notes:
    v3 (internal):
    - Rename to _HR_ instead of to _HIERARCHY_.

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 11 +++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 19 +++++++++----------
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    |  8 ++++----
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethern=
et/mellanox/mlxsw/reg.h
index 5294a1622643..86a2d575ae73 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -3477,10 +3477,10 @@ MLXSW_REG_DEFINE(qeec, MLXSW_REG_QEEC_ID, MLXSW_REG=
_QEEC_LEN);
 MLXSW_ITEM32(reg, qeec, local_port, 0x00, 16, 8);
=20
 enum mlxsw_reg_qeec_hr {
-	MLXSW_REG_QEEC_HIERARCY_PORT,
-	MLXSW_REG_QEEC_HIERARCY_GROUP,
-	MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
-	MLXSW_REG_QEEC_HIERARCY_TC,
+	MLXSW_REG_QEEC_HR_PORT,
+	MLXSW_REG_QEEC_HR_GROUP,
+	MLXSW_REG_QEEC_HR_SUBGROUP,
+	MLXSW_REG_QEEC_HR_TC,
 };
=20
 /* reg_qeec_element_hierarchy
@@ -3618,8 +3618,7 @@ static inline void mlxsw_reg_qeec_ptps_pack(char *pay=
load, u8 local_port,
 {
 	MLXSW_REG_ZERO(qeec, payload);
 	mlxsw_reg_qeec_local_port_set(payload, local_port);
-	mlxsw_reg_qeec_element_hierarchy_set(payload,
-					     MLXSW_REG_QEEC_HIERARCY_PORT);
+	mlxsw_reg_qeec_element_hierarchy_set(payload, MLXSW_REG_QEEC_HR_PORT);
 	mlxsw_reg_qeec_ptps_set(payload, ptps);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 556dca328bb5..0d8fce749248 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3602,26 +3602,25 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_p=
ort *mlxsw_sp_port)
 	 * one subgroup, which are all member in the same group.
 	 */
 	err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-				    MLXSW_REG_QEEC_HIERARCY_GROUP, 0, 0, false,
-				    0);
+				    MLXSW_REG_QEEC_HR_GROUP, 0, 0, false, 0);
 	if (err)
 		return err;
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
+					    MLXSW_REG_QEEC_HR_SUBGROUP, i,
 					    0, false, 0);
 		if (err)
 			return err;
 	}
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_TC, i, i,
+					    MLXSW_REG_QEEC_HR_TC, i, i,
 					    false, 0);
 		if (err)
 			return err;
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_TC,
+					    MLXSW_REG_QEEC_HR_TC,
 					    i + 8, i,
 					    true, 100);
 		if (err)
@@ -3633,13 +3632,13 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_p=
ort *mlxsw_sp_port)
 	 * for the initial configuration.
 	 */
 	err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_PORT, 0, 0,
+					    MLXSW_REG_QEEC_HR_PORT, 0, 0,
 					    MLXSW_REG_QEEC_MAS_DIS);
 	if (err)
 		return err;
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
+						    MLXSW_REG_QEEC_HR_SUBGROUP,
 						    i, 0,
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
@@ -3647,14 +3646,14 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_p=
ort *mlxsw_sp_port)
 	}
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    MLXSW_REG_QEEC_HR_TC,
 						    i, i,
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
 			return err;
=20
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    MLXSW_REG_QEEC_HR_TC,
 						    i + 8, i,
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
@@ -3664,7 +3663,7 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_por=
t *mlxsw_sp_port)
 	/* Configure the min shaper for multicast TCs. */
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_min_bw_set(mlxsw_sp_port,
-					       MLXSW_REG_QEEC_HIERARCY_TC,
+					       MLXSW_REG_QEEC_HR_TC,
 					       i + 8, i,
 					       MLXSW_REG_QEEC_MIS_MIN);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 21296fa7f7fb..fe3bbba90659 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -160,7 +160,7 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp=
_port *mlxsw_sp_port,
 		u8 weight =3D ets->tc_tx_bw[i];
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
+					    MLXSW_REG_QEEC_HR_SUBGROUP, i,
 					    0, dwrr, weight);
 		if (err) {
 			netdev_err(dev, "Failed to link subgroup ETS element %d to group\n",
@@ -198,7 +198,7 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp=
_port *mlxsw_sp_port,
 		u8 weight =3D my_ets->tc_tx_bw[i];
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
+					    MLXSW_REG_QEEC_HR_SUBGROUP, i,
 					    0, dwrr, weight);
 	}
 	return err;
@@ -507,7 +507,7 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_de=
vice *dev,
=20
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
+						    MLXSW_REG_QEEC_HR_SUBGROUP,
 						    i, 0,
 						    maxrate->tc_maxrate[i]);
 		if (err) {
@@ -523,7 +523,7 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_de=
vice *dev,
 err_port_ets_maxrate_set:
 	for (i--; i >=3D 0; i--)
 		mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					      MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
+					      MLXSW_REG_QEEC_HR_SUBGROUP,
 					      i, 0, my_maxrate->tc_maxrate[i]);
 	return err;
 }
--=20
2.20.1

