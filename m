Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19408E7CED
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbfJ1XfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:05 -0400
Received: from mail-eopbgr60072.outbound.protection.outlook.com ([40.107.6.72]:18405
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729755AbfJ1XfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/0rygoGDveQrjqA9QbovEM5Vz87d1iLQ0KKpRMor8KKXRu7Fmm68jPz6z93+/PlYmYyvUYHkkC/37AFr/gTpVBTUAQfGbpxOiUCgMkdHCIn901Bo4PYtr0H+nfg8KOvhQ0/O9VaLzulQ3KLUOYeQhGSEEPc3jmHkxNctnWnTDo7fxXvhXWZmFbjWCthumWMSPpJmchbLQlNljRAxGsHel3R6ewBl9x2dgsl+afDs03GXqN9hMqKT8QggblDrIZ38nIphbThJMZnzHlPCsldeG8WEDBOrzr7JqgENAXY6WxxalzEpexlMovVkwz9veqLAqedk70bxpPfxtI4gcHYcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Huvd7XkPVTJgmOsF2JpozXdErgZLmzW1TDPUfGfvLe0=;
 b=COnJCKIPyQ4/53gFFz/yHZPFmRDQog+E9kGhi+8d/BV6+5TRMHMz0JebVwA7nIoJjJKL0nZBFIdNlqWpSXBFHpSGePvtGMFPSweD1MQwJMXD6H0TW2nJCB8fNwOBmXr79yJWpgeb+ozuBli++bcgGof1xWto9phB8y93MVNYfpTqfB0ssOvVG7UgNrrPauMGQmG2sHL15jkN7DpniWYEs3ez44Lfpoq7L4Y+NtYzDzNCSSFiNPx4CfARDP9Md6xGtgpNTAMT3xvnFPYreoO/wTy/PnthonKSQ8E53IiP65K7KtP+tBe6vQsKlBnh6d9K9ht/evfp65GVtenna83yFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Huvd7XkPVTJgmOsF2JpozXdErgZLmzW1TDPUfGfvLe0=;
 b=EnqrY+RYKC57Bt1E8mYkXTG7XEBlbT7vfegbqiwEDQfavBa4ntYUdSTXlKNnthRiqix/njcDuAvpBHB4z92bRYar9o0KBQxZvnZr4qNDXigMYIWK3IKjX1uxKJB2XfjI1vggvs4JSUCxnpI59k+VpMQPUP7IYzjuJ2OpW+x0g6g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:34:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:34:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 02/18] net/mlx5: E-Switch, Rename egress config to
 generic name
Thread-Topic: [PATCH mlx5-next 02/18] net/mlx5: E-Switch, Rename egress config
 to generic name
Thread-Index: AQHVjehPab8k71U10EaRmd+t2sLGRw==
Date:   Mon, 28 Oct 2019 23:34:58 +0000
Message-ID: <20191028233440.5564-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 14e15610-96ce-41e8-0e8a-08d75bff721c
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB644835C4E6635EBEE158C754BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cvo8HdI3BIrS/WeVibRHfXZCN1tU5TRMftQZtTw5Q7yo5aiN4obBaud42X64Yv5qBCkFvyI3KY/CXHaxurCwF4QPeYAzcetqeai9SJbNkaj4Z/TymhZqTXYrLCzT66yF772XDYpfivfXeyElW8Le2E9I6xRySinsiv5RTKHLvEB6rHNTPpQkD5CxeutTTpNFaM8sDWXUIkTNo8AfLt+GoVfTc6eg13KOcZbUAB/wIthi8LcLSZEzPOd3+nHiChAND5LX15w5rtjBr1yX0Od5YFfZTCDvR6OxeIlkmgR4gC/bMYmVnls4BtIuwXuNmqTUOh9ClRsbENXmk35KQz8Woei52h0byf7HfIhQg9AU6B04RD/0BQybv+KsJ4BLBbjvi967rAOz3W8oueHIIvEwKHWp51h7iGVx0WYsq0KWcKzQkVSt+hfARhLgsaK5RlZr
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14e15610-96ce-41e8-0e8a-08d75bff721c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:34:58.8795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pCReuOVkB4h90JwyXppMLoQTpqQ2QH8chnqXieiB/FfrvJ44RjWOTyOMMgY6pXlja7VkbR3JRc0dFoj8GKV8Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Refactor vport egress config in offloads mode

Refactoring vport egress configuration in offloads mode that
includes egress prio tag configuration.
This makes code symmetric to ingress configuration.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 50 ++++++++++---------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 00d71db15f22..506cea8181f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1864,32 +1864,16 @@ static int esw_vport_egress_prio_tag_config(struct =
mlx5_eswitch *esw,
 	struct mlx5_flow_spec *spec;
 	int err =3D 0;
=20
-	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
-		return 0;
-
 	/* For prio tag mode, there is only 1 FTEs:
 	 * 1) prio tag packets - pop the prio tag VLAN, allow
 	 * Unmatched traffic is allowed by default
 	 */
-
-	esw_vport_cleanup_egress_rules(esw, vport);
-
-	err =3D esw_vport_enable_egress_acl(esw, vport);
-	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "failed to enable egress acl (%d) on vport[%d]\n",
-			       err, vport->vport);
-		return err;
-	}
-
 	esw_debug(esw->dev,
 		  "vport[%d] configure prio tag egress rules\n", vport->vport);
=20
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err =3D -ENOMEM;
-		goto out_no_mem;
-	}
+	if (!spec)
+		return -ENOMEM;
=20
 	/* prio tag vlan rule - pop it so VF receives untagged packets */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvl=
an_tag);
@@ -1909,14 +1893,9 @@ static int esw_vport_egress_prio_tag_config(struct m=
lx5_eswitch *esw,
 			 "vport[%d] configure egress pop prio tag vlan rule failed, err(%d)\n",
 			 vport->vport, err);
 		vport->egress.allowed_vlan =3D NULL;
-		goto out;
 	}
=20
-out:
 	kvfree(spec);
-out_no_mem:
-	if (err)
-		esw_vport_cleanup_egress_rules(esw, vport);
 	return err;
 }
=20
@@ -1961,6 +1940,29 @@ static int esw_vport_ingress_common_config(struct ml=
x5_eswitch *esw,
 	return err;
 }
=20
+static int esw_vport_egress_config(struct mlx5_eswitch *esw,
+				   struct mlx5_vport *vport)
+{
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
+		return 0;
+
+	esw_vport_cleanup_egress_rules(esw, vport);
+
+	err =3D esw_vport_enable_egress_acl(esw, vport);
+	if (err)
+		return err;
+
+	esw_debug(esw->dev, "vport(%d) configure egress rules\n", vport->vport);
+
+	err =3D esw_vport_egress_prio_tag_config(esw, vport);
+	if (err)
+		esw_vport_disable_egress_acl(esw, vport);
+
+	return err;
+}
+
 static bool
 esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 {
@@ -1996,7 +1998,7 @@ static int esw_create_offloads_acl_tables(struct mlx5=
_eswitch *esw)
 			goto err_ingress;
=20
 		if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
-			err =3D esw_vport_egress_prio_tag_config(esw, vport);
+			err =3D esw_vport_egress_config(esw, vport);
 			if (err)
 				goto err_egress;
 		}
--=20
2.21.0

