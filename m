Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F18107A41
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKVVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:52:05 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:24062
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfKVVwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:52:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUofummatkSxlkIuqMDkmtGataYF9+9qSdL4FatqpocISCVDTW199vTaxBmMCfB/77E+0dt1IIpvXuPK4XaycadLeXjcCNdhIJGnOPdQ5V3RcSeAzOCUOe65YvELXshEFE0ywaF9IO5HT8SlSyN8RVYhNQKi6/1VSlv5q0+h27OWROGetczgLWOioXHHl2tEcTbpMO9IsS66U1OnyA+MABDxGsraGxBBYoBs/Q5s6yAmKUBKlxrTFJW2DmTUbkhgzLKuTjSL6ZUx2cYFpMqUJMAUrVL0kYhBJ+iUagiuvW5n5HFAcIo7MiTNqlGc/Pb/loSn9kW14Aid3hDBjjwoOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2vWUFmQ/Kyih8dURbCjFUJ+ItxdYZSu51RgdR2f9qQ=;
 b=b4QUBICB6O//zIwhefjM0gldqFvC0QAkvyOG8uTYRjQB266WMc7pcjlP+8x9IrZMEID1foNOBvelV8ARMb0USqBuRL9veuMXwG97Y25brNYEyBT+A31aJrAdJQPdo9RIiCEiepeWbQDyT8sxLTijj8W9t/W/F89WDZhhk5+u92kKOwspXnNg4I9MHco1oWpZJFfewgemOO+jBH15ym55EG7SxPh9w9PjmbWLbAtSlPjAJD8lykqfXHjiRhiSSolFIyEBjMXPdlMsEtIgVxfUxuX01fO22s3HgrjJj5EXsbtqOIezRLIjlS94grJ6dmc5w1w7fPJQPPwjiFG+jACmhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M2vWUFmQ/Kyih8dURbCjFUJ+ItxdYZSu51RgdR2f9qQ=;
 b=Ov/nUsnl2JP+Q/cakKQozu9x7SEYeFfMKs1oog2kStGorHi2L7D76fyR/J/yqrl2kWWgjeskSuYaXWWe97xCvfnOq98FM8N8KvdpQs2NTq3mRdGBcetiZQpMHoZIhrv8A2NLQXb8IGgzMQ1Moqps7Dt0JppK2vS9ewsTI5TnhGI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Fri, 22 Nov 2019 21:51:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:51:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 5/6] net/mlxfw: More error messages coverage
Thread-Topic: [PATCH net-next 5/6] net/mlxfw: More error messages coverage
Thread-Index: AQHVoX8Pcbn/hyV5OEaXZqan1w7cjA==
Date:   Fri, 22 Nov 2019 21:51:56 +0000
Message-ID: <20191122215111.21723-6-saeedm@mellanox.com>
References: <20191122215111.21723-1-saeedm@mellanox.com>
In-Reply-To: <20191122215111.21723-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a1809918-6851-475f-bc3f-08d76f9631a3
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341101C77E43736CB8BDA2FBE490@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:93;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(189003)(199004)(107886003)(8676002)(386003)(6506007)(3846002)(36756003)(6512007)(26005)(478600001)(1076003)(316002)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(71200400001)(71190400001)(99286004)(66946007)(66066001)(25786009)(4326008)(14444005)(256004)(54906003)(50226002)(102836004)(446003)(7736002)(186003)(305945005)(6436002)(6486002)(8936002)(76176011)(11346002)(52116002)(6916009)(14454004)(81156014)(5660300002)(81166006)(2616005)(15650500001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nEsJuV632usTuL5GQLsBXsRqDSXPfq/Vd5NOKW3nMY2jN8wQ8nqMxAfuZgi3cSEOggTenhUhVHXVd7ls/5SBfCGMhkFXz61/+klzf05J6OT85nE4R1XAU+bBgWjNQEJewbBT6kIFEYytmybAqDQskBOhduBCNwoWeJVhX6A2O349cgnu3fAiz8zWspxick6eA0o26HpoS8aVR8QcEcl8mu9LMtuvlBgGmecyJ/9czHpEaMlYTRcJ3aGI2oD1zEqf8ZNTxICT60Es9FXw8GpbkTO5X+QPlsltkjMO4H3haDpvqp3zz9nWCIpiQI0pM55yd+HR66HalDNvn8T4cxuSBZQYqe4BlhSo/Snc/3qySt+FUvENxVldiwkI+1nghEytlU7l2453HWwOvlioWLnr/xGjtc0OoVhZmZ/L+undwlSI1dxOtsuXcQpRL5eQOkbj
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1809918-6851-475f-bc3f-08d76f9631a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:51:56.6495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sZ8Uk/QEIi0BftJx+DnXSaUkQfhA5F6mfeqwg5NRQAYYFHc38FWsvDuj40naQyWjdnmvxVHAwrnxTKtpANAQHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure mlxfw_firmware_flash reports a detailed user readable error
message in every possible error path, basically every time
mlxfw_dev->ops->*() is called and an error is returned, or when image
initialization is failed.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 47 +++++++++++++++----
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/=
ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 204ef6ed7651..c29c385d1dd0 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -108,8 +108,11 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxf=
w_dev, u32 fwhandle,
 retry:
 	err =3D mlxfw_dev->ops->fsm_query_state(mlxfw_dev, fwhandle,
 					      &curr_fsm_state, &fsm_state_err);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "FSM state query failed, err (%d)",
+				   err);
 		return err;
+	}
=20
 	if (fsm_state_err !=3D MLXFW_FSM_STATE_ERR_OK)
 		return mlxfw_fsm_state_err(mlxfw_dev, extack, fsm_state_err);
@@ -149,8 +152,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->component_query(mlxfw_dev, comp->index,
 					      &comp_max_size, &comp_align_bits,
 					      &comp_max_write_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component query failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		return err;
+	}
=20
 	comp_max_size =3D min_t(u32, comp_max_size, MLXFW_FSM_MAX_COMPONENT_SIZE)=
;
 	if (comp->data_size > comp_max_size) {
@@ -168,8 +175,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	err =3D mlxfw_dev->ops->fsm_component_update(mlxfw_dev, fwhandle,
 						   comp->index,
 						   comp->data_size);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component update failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		return err;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_DOWNLOAD, extack);
@@ -188,8 +199,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 		err =3D mlxfw_dev->ops->fsm_block_download(mlxfw_dev, fwhandle,
 							 block_ptr, block_size,
 							 offset);
-		if (err)
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Component download failed, comp_name(%s) err (%d)",
+					   comp_name, err);
 			goto err_out;
+		}
 		mlxfw_status_notify(mlxfw_dev, "Downloading component",
 				    comp_name, offset + block_size,
 				    comp->data_size);
@@ -199,8 +214,12 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlx=
fw_dev,
 	mlxfw_status_notify(mlxfw_dev, "Verifying component", comp_name, 0, 0);
 	err =3D mlxfw_dev->ops->fsm_component_verify(mlxfw_dev, fwhandle,
 						   comp->index);
-	if (err)
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "FSM component verify failed, comp_name(%s) err (%d)",
+				   comp_name, err);
 		goto err_out;
+	}
=20
 	err =3D mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
 				   MLXFW_FSM_STATE_LOCKED, extack);
@@ -235,8 +254,13 @@ static int mlxfw_flash_components(struct mlxfw_dev *ml=
xfw_dev, u32 fwhandle,
=20
 		comp =3D mlxfw_mfa2_file_component_get(mfa2_file, mlxfw_dev->psid,
 						     mlxfw_dev->psid_size, i);
-		if (IS_ERR(comp))
-			return PTR_ERR(comp);
+		if (IS_ERR(comp)) {
+			err =3D PTR_ERR(comp);
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to get MFA2 component, component (%d) err (%d)",
+					   i, err);
+			return err;
+		}
=20
 		mlxfw_info(mlxfw_dev, "Flashing component type %d\n",
 			   comp->index);
@@ -263,8 +287,13 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	}
=20
 	mfa2_file =3D mlxfw_mfa2_file_init(firmware);
-	if (IS_ERR(mfa2_file))
-		return PTR_ERR(mfa2_file);
+	if (IS_ERR(mfa2_file)) {
+		err =3D PTR_ERR(mfa2_file);
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to initialize MFA2 firmware file, err (%d)",
+				   err);
+		return err;
+	}
=20
 	mlxfw_info(mlxfw_dev, "Initialize firmware flash process\n");
 	devlink_flash_update_begin_notify(mlxfw_dev->devlink);
--=20
2.21.0

