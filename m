Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD1A121071
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLPRBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:01:51 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfLPRBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:01:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQFjj9z+Yw/jYrfvebbfekO3cdbQAHB+MIGV0BO22oCjzpq9LlGWlxyWk6sWColg2l3gE/Xv99Dz8zV3WHZGuAhfWX051ib5EtGehHM0y3RpZGbn4Wo2jGsKi3g7qkkCJvookFNXSaT0qiX3oVlhnKZMJKiCHnYjGIRJfTb68tLds6bjupV30MADf0FwhBzEJHum/9HssGUzGkKOSj+wvDOKQ/XeXUjkg6LYlUh4z+Od30oZK7nhsO5T6BiHRFhaL9sFP8Atz0LD/7vAqNPhDdYmbHS7WMgPOgOpJAMTLw+K7ghcInQWOw+h+XCKNFyeKEhEDmrMFYJqoawLHBx2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gA8EirxYJozVilpxNVs7j1DPKE5lvVsjznxiSRzS1w=;
 b=h10EKjAttmtTJNaZxz/ME0MaK22tAgDrNY7V0ak/UBhbT3dRdg7MwiL4aT5AFL0Wy16f/mgegy7ThRMoISoyvUuTmG3rmkgDpy9MAUUQPiStBYIIrIjb2+xn6mA4LNlCkaiSdYYp6Yq+GLRcpitKhvQA7LPlIGoOqSvtGEjM6hDYKdsO/MyWb0gndQRA0CbVqEVPr3D7AijWn7RZ/KeDrqQQhdVhpxs9PR0sw1Ie1jAjP8MYSFGX0Enlnl3M1ZsWWGnFLF8itS1s6W2F8Ow5NyF8OF1OgckMJJ3hsQGPlXidp8PV87Zh3M3QRBMLa8c7xAUlqR8CmmMIrf/Ar9UUrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gA8EirxYJozVilpxNVs7j1DPKE5lvVsjznxiSRzS1w=;
 b=r0qVrXdwjv3qdESCgKPbN3jb/xWYZEcG2x2ZObcl8UKasZ2liw6BfQS7jKU+4u6cy0Ruu5acPXr+TrdOPfwlN90EYq+xfxiFh4+4Wuyby9mnb6WzCXSSyLPHKOm/OdSLSySaE70g+vKdXNfwIPvaJZTe/Vh5YNxscaeG+kgQDrM=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:44 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:44 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 03/10] mlxsw: spectrum: Rename
 MLXSW_REG_QEEC_HIERARCY_* enumerators
Thread-Topic: [PATCH net-next mlxsw v1 03/10] mlxsw: spectrum: Rename
 MLXSW_REG_QEEC_HIERARCY_* enumerators
Thread-Index: AQHVtDJ+pEk7Zc1Ju0ix3UEKC4w2Tg==
Date:   Mon, 16 Dec 2019 17:01:43 +0000
Message-ID: <c1623d711caeee204582fc5a829773d804c76a6b.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e9512955-bdf0-4d14-5af6-08d78249a0b4
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3014310DE7436E0359CA330DDB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KiSRJQQzFDrTBHfNh50EzIRtG27Wl9hm7wQrPweycQc9qpuHpu+6BJoTTTXbT+Zii15ijOPO9Gf9Cjm/oHURx4451M2vQxt0oQZoQaYYxbaXGststnmpOQ+2kuTnHs3ixqRQ7C7TFae4dPOeCnRaE1GOJoyKaYYbCJgLgkGEbzuW9uyYcy55ZJDYA32JI4ynrm1jyu7w1SyHQIEX+uLJJKFCy3KAedfLt0KBhe58Q6K8R8oUAQoMYHEZeRPglQDjiuQEeHIqI4slBXTnDyIhGldippYLBAVjZ/M87aZWb+LnHkW6SbIdmZNs6HXILdsV95ZElY3SGRBlbG0wjpnj41pHt7cO3tOawxXp9Ai3nzKYZpDxpOxaWpjI/f/E7rh3p504JuXH10HLD5tMMWfF/fC/yWWC7pNIjq+Pd4c89vbp0I93zm/aaAojBm8DO6jF
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9512955-bdf0-4d14-5af6-08d78249a0b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:44.0170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQWtkPCrlxClMKzr6//8rnJHP5Nab5LF0fDI5MxQj6ucbkdAycGHl5yCJpTwCzuciJ9oEAtX9k0k27wLFeVpaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
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

