Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FFD103AA6
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfKTNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:21 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbfKTNFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWYPro2W67WFDIdsGBGDHVY0vj91wV3GJW2pRBh4Flrf68QBLbKG1E5B/qeWXSxSizHCVhJpce28IXPGJQ3fTGf9Hm6WmgYzXW8qh8aybPMlJnHE9GLCATT5FJN4EQQ/G4Gd7iPsojoBCYL8yGY4ircsQfqqBXZBC8hSYWTKWpmqY3VI18eQA65ciou53/M6l5XWLqTdGK1UH5Soi60VBCOG3nu8+93Int75gZbCmUgsNnJv7wXda5NPEF7YLYEz4yhxHQlDO6MrOFda37hF9p6cGfrXQ242hQrfzm3CjrR2QI8/ahXHkiBFxoGvFXmME5tBolR33HwOfwj9RObLjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thwBCjwXPuakDJxoAekDb+vPnINmqdPeGm88wBoyAiQ=;
 b=llV0s4q8VAoNeh1R032H8jSMjQjR7Fl6Z+XsSYnCZeEIDljv2IosDY47qDYPgi3doTnVeKoiEtJmjamLEMb9Pd7/fmQVGWLHnI2XFpee8ds+RdkIya5J/WGxNTAH2POvcmeJfUWBBk7faJKxiAEZp8J2mtgZcLZZalrg176utyvPqwswkuUpsPm0gHvbUMMNI6EWmtKmDKQfHd+u1jFCyk1mS5dmpcVI62eCP4/i5v/TYgDcrEkmJurWXFSUSP2+HeOSgW2hvxgl0bPXuOyQAqxfRcKVZjqe6Q1Uch1OaOSaZcEChBXJbzBYY97seNk0GLCaBKGMrDmJ+OW03A2zug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thwBCjwXPuakDJxoAekDb+vPnINmqdPeGm88wBoyAiQ=;
 b=rKuyPlnbEyOihKGOj12ljRn7OT3exalzzI9pB9JV2fNzp6FQWHvHNl2hxatwtmilMPqyf9/3neTRpMvG+MNT2+lD8AGkSWyTBMTt/rTlJpFhXNuhvS/SO1TTfkwnsmPF0mvFJMiT5EaI3hKC3JpMILgeerT7ySEPGO16wn5++iE=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:12 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:12 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 03/10] mlxsw: spectrum: Fix typos in
 MLXSW_REG_QEEC_HIERARCHY_* enumerators
Thread-Topic: [RFC PATCH 03/10] mlxsw: spectrum: Fix typos in
 MLXSW_REG_QEEC_HIERARCHY_* enumerators
Thread-Index: AQHVn6MkFUwV3k8E1EqjnmFrGgI+1w==
Date:   Wed, 20 Nov 2019 13:05:11 +0000
Message-ID: <7cabaddfa0d05d986b7ae99d7a3b629931724ed3.1574253236.git.petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60dc48df-1e5e-4cd1-bbc5-08d76dba46d7
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982E38CA77EE7D1E91F63CCDB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mjt3AwebDAt4FQs9GXWNNhbobI5ndWf4o0OYsEsyYDFaAFioyvygVIyLvF2BfhuRSXAbVmKwbb5XDlnsh3u0uehv50HRzHAO4IdXIESf8cARQpn3th5HFLXtXr8HK+g/6hzw5ghDP9jmxBpjhDRThHM0lU6vQl6VPDr1jvi84tQVAjIK04fLqQ4B3oHsOsQscq7fpITk4lAZJwH1VrB4gfFD25L2mq4taRyoo5iX68OOh0FpEKMoksRNHU35Yp/Lbd0B1+BjV4W9f4PZ/q3vloriUJqKp0g8QigWSFFu/+rxitgzjCHvmPGdXr9vmVYVRJ4umDOX7BuSdyTPlNHF5KLY3twfgkyuEVWJW/v2TgJTu9mm7uKozLpkBRwku0YVbSG3oHfn4OnBTgVDl/oWwyIS+avB8wTVU7rOi5TdweyKODcCK3LJlDicOv6SI25Z
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60dc48df-1e5e-4cd1-bbc5-08d76dba46d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:11.8181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UXbVIAG+OKKrBcf0Q4u/kOlbfF41aAoNT/qUWrWTC8DMM+CWRxxohQF/hAHqy0HaQtImifo0vBBVr8M4fwJEiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current spelling of MLXSW_REG_QEEC_HIERARCY_ complicates searching.
Fix it.

Adjusted some formatting to be 80-char clean in impacted blocks.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 10 ++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 24 +++++++++----------
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 16 ++++++-------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethern=
et/mellanox/mlxsw/reg.h
index 5294a1622643..e43ae1654af1 100644
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
+	MLXSW_REG_QEEC_HIERARCHY_PORT,
+	MLXSW_REG_QEEC_HIERARCHY_GROUP,
+	MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+	MLXSW_REG_QEEC_HIERARCHY_TC,
 };
=20
 /* reg_qeec_element_hierarchy
@@ -3619,7 +3619,7 @@ static inline void mlxsw_reg_qeec_ptps_pack(char *pay=
load, u8 local_port,
 	MLXSW_REG_ZERO(qeec, payload);
 	mlxsw_reg_qeec_local_port_set(payload, local_port);
 	mlxsw_reg_qeec_element_hierarchy_set(payload,
-					     MLXSW_REG_QEEC_HIERARCY_PORT);
+					     MLXSW_REG_QEEC_HIERARCHY_PORT);
 	mlxsw_reg_qeec_ptps_set(payload, ptps);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.c
index 556dca328bb5..cb24807c119d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3602,26 +3602,26 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_p=
ort *mlxsw_sp_port)
 	 * one subgroup, which are all member in the same group.
 	 */
 	err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-				    MLXSW_REG_QEEC_HIERARCY_GROUP, 0, 0, false,
+				    MLXSW_REG_QEEC_HIERARCHY_GROUP, 0, 0, false,
 				    0);
 	if (err)
 		return err;
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
-					    0, false, 0);
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    i, 0, false, 0);
 		if (err)
 			return err;
 	}
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_TC, i, i,
+					    MLXSW_REG_QEEC_HIERARCHY_TC, i, i,
 					    false, 0);
 		if (err)
 			return err;
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_TC,
+					    MLXSW_REG_QEEC_HIERARCHY_TC,
 					    i + 8, i,
 					    true, 100);
 		if (err)
@@ -3633,28 +3633,28 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_p=
ort *mlxsw_sp_port)
 	 * for the initial configuration.
 	 */
 	err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_PORT, 0, 0,
+					    MLXSW_REG_QEEC_HIERARCHY_PORT, 0, 0,
 					    MLXSW_REG_QEEC_MAS_DIS);
 	if (err)
 		return err;
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
-						    i, 0,
-						    MLXSW_REG_QEEC_MAS_DIS);
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    i, 0,
+					    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
 			return err;
 	}
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    MLXSW_REG_QEEC_HIERARCHY_TC,
 						    i, i,
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
 			return err;
=20
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_TC,
+						    MLXSW_REG_QEEC_HIERARCHY_TC,
 						    i + 8, i,
 						    MLXSW_REG_QEEC_MAS_DIS);
 		if (err)
@@ -3664,7 +3664,7 @@ static int mlxsw_sp_port_ets_init(struct mlxsw_sp_por=
t *mlxsw_sp_port)
 	/* Configure the min shaper for multicast TCs. */
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_min_bw_set(mlxsw_sp_port,
-					       MLXSW_REG_QEEC_HIERARCY_TC,
+					       MLXSW_REG_QEEC_HIERARCHY_TC,
 					       i + 8, i,
 					       MLXSW_REG_QEEC_MIS_MIN);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/n=
et/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 21296fa7f7fb..4c335112dfbb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -160,8 +160,8 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp=
_port *mlxsw_sp_port,
 		u8 weight =3D ets->tc_tx_bw[i];
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
-					    0, dwrr, weight);
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    i, 0, dwrr, weight);
 		if (err) {
 			netdev_err(dev, "Failed to link subgroup ETS element %d to group\n",
 				   i);
@@ -198,8 +198,8 @@ static int __mlxsw_sp_dcbnl_ieee_setets(struct mlxsw_sp=
_port *mlxsw_sp_port,
 		u8 weight =3D my_ets->tc_tx_bw[i];
=20
 		err =3D mlxsw_sp_port_ets_set(mlxsw_sp_port,
-					    MLXSW_REG_QEEC_HIERARCY_SUBGROUP, i,
-					    0, dwrr, weight);
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    i, 0, dwrr, weight);
 	}
 	return err;
 }
@@ -507,9 +507,9 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_de=
vice *dev,
=20
 	for (i =3D 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err =3D mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-						    MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
-						    i, 0,
-						    maxrate->tc_maxrate[i]);
+					    MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
+					    i, 0,
+					    maxrate->tc_maxrate[i]);
 		if (err) {
 			netdev_err(dev, "Failed to set maxrate for TC %d\n", i);
 			goto err_port_ets_maxrate_set;
@@ -523,7 +523,7 @@ static int mlxsw_sp_dcbnl_ieee_setmaxrate(struct net_de=
vice *dev,
 err_port_ets_maxrate_set:
 	for (i--; i >=3D 0; i--)
 		mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					      MLXSW_REG_QEEC_HIERARCY_SUBGROUP,
+					      MLXSW_REG_QEEC_HIERARCHY_SUBGROUP,
 					      i, 0, my_maxrate->tc_maxrate[i]);
 	return err;
 }
--=20
2.20.1

