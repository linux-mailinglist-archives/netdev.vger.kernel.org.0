Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2823C8F504
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbfHOTq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:27 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:39650
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726865AbfHOTqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8lsCio4S/D3YR9CBVG5li5REHpof7SS/JTcu4X2Oa5PmFGGANPJhP+ZJTJnVQMIW20Cxrd4cIrJEmBJKj2AohiU39cu6pVlyYf7MLHeXbvPXP2KUqEcrKjimRgwiqTTiIozEFygoslieVwSyOblD0GQx3LLdMtOXW9mggJsAP6sPR9N6V+VPWD7qqz65sqSUFJegkP2VLfQhGmqFecoN4FZg61geK07sm2oqHFNkxpfwGd6DkIS6G5GFSFhWqu93pUNegOfOHZA9jeA8OyOp++yWwq9U8sOdlNBc3tkcXo4D0zPj7hMIMgNfEH5y5DHh1IM3pNyYcoMb/cCD7eulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlY/r5hsQIngbkewnoULg+6Xid6HvNNnyVheigOmuHM=;
 b=TTjZ6x5poDa69LRLuDmvnoMem+S0AweckERgcWXuyH/kmvBGnPu5/fBMNT42Kfo67a6eewSAAkNlZukt2faKW4pD6v5IMZyHZSrgDl/XzHZvu7g70SpPthpcCBva8OZA1jd3+FJiZaJdLi4ib+mE1zyAXcslNeQYyS19fHLHu5h4I5XGyA+YrBSG+1d9Htnmjuj/RkHzIVku71jyew70i6NFZkK+8ls3ePRrD5QrhsSHbvx8MkygrGoHWmvqt3cx83kteBzzTbakEOZqQGY3vKxuFOSQFJUfpnhfV+qM2PorwsIZ7QAYRjq//3u1x5Di1BK2TsZRnAih1U1clI1nkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlY/r5hsQIngbkewnoULg+6Xid6HvNNnyVheigOmuHM=;
 b=Nw86v7ERU9+Vt6f4EjFiL5v0fCJfFqybGkL0gR/2+DLyysaC3kb3+vDWOAzHm/y38u2ZgDLK4bK8Maj6bTJ9tLq3NDDfB4c0HYFkMLyaTmnZ91eGcg1JTv61MLeEIlQyLqGKHFXrOPYOD2Z5AiAjL2OSGDuphZBCTqEVs5mB0xM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 15 Aug 2019 19:46:16 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Improve functions documentation
Thread-Topic: [PATCH mlx5-next 2/5] net/mlx5: Improve functions documentation
Thread-Index: AQHVU6IWym9ok89PuUSo5KPVSHYOiA==
Date:   Thu, 15 Aug 2019 19:46:09 +0000
Message-ID: <20190815194543.14369-3-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6732dba7-7a30-43a5-d8bd-08d721b9389d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB275997D34BC694E8DD79E0CBBEAC0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(5660300002)(25786009)(7736002)(110136005)(14454004)(66476007)(66556008)(64756008)(66446008)(2906002)(305945005)(54906003)(6486002)(316002)(66946007)(14444005)(256004)(6636002)(76176011)(478600001)(1076003)(52116002)(99286004)(3846002)(2616005)(102836004)(6512007)(6116002)(6436002)(6506007)(386003)(4326008)(36756003)(186003)(26005)(8676002)(81156014)(81166006)(71200400001)(86362001)(66066001)(50226002)(11346002)(446003)(53936002)(6666004)(450100002)(8936002)(476003)(71190400001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Mz0pBYG5yx2pHIHbllFp4QqXV4XhwGVLqu6fT2dZId7nqwJDXdcFtfipie6idh7nkJbRR1Ir9wrlRuMVUDEznV/NqiDN0taKXOy8zxyuDY+7dAueV+ae4yLrODe3R8+U96iaBkMbEFG0YSbuhRidiP1Rqr/q96dtjsTCs8QLPOrqFN7yzEP18RTPN+gpYoz8UHncQ+QPnPW1We0+b78J3qN6qgLSR8cyHQD2kgmCA1fBxpghj7QgurYjzBwXEJ02sYMyiRq9cPBrUuff6mm+5hbkkEdT+UCsNzB/6XIv/0RfuqT7fTX3YwW6RnBips61tHad7u654Hv+iqJZj1OZ1uuP+AISzj7kGE2U09qx+w3mDdpPBb/r4yrWGfRce16yubFoGbs0hBqk5OUrljBEtExsGQFYexr0jOFkBH78JDk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6732dba7-7a30-43a5-d8bd-08d721b9389d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:09.9939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43yp0sX7RhXIT1Lqpso/33NWlWg83jZh2cN1Jq8bd9671k0IrNmvdUzTd7zGNuEvq1ssnG5bWH48xJJaA1lhMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix documentation of mlx5_eq_enable/disable to cleanup compiler warnings.

drivers/net/ethernet/mellanox/mlx5/core//eq.c:334:
warning: Function parameter or member 'dev' not described in 'mlx5_eq_enabl=
e'
warning: Function parameter or member 'eq' not described in 'mlx5_eq_enable=
'
warning: Function parameter or member 'nb' not described in 'mlx5_eq_enable=
'

drivers/net/ethernet/mellanox/mlx5/core//eq.c:355:
warning: Function parameter or member 'dev' not described in 'mlx5_eq_disab=
le'
warning: Function parameter or member 'eq' not described in 'mlx5_eq_disabl=
e'
warning: Function parameter or member 'nb' not described in 'mlx5_eq_disabl=
e'

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 22 ++++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 2df9aaa421c6..a0e78ab64618 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -324,10 +324,13 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_=
eq *eq,
=20
 /**
  * mlx5_eq_enable - Enable EQ for receiving EQEs
- * @dev - Device which owns the eq
- * @eq - EQ to enable
- * @nb - notifier call block
- * mlx5_eq_enable - must be called after EQ is created in device.
+ * @dev : Device which owns the eq
+ * @eq  : EQ to enable
+ * @nb  : Notifier call block
+ *
+ * Must be called after EQ is created in device.
+ *
+ * @return: 0 if no error
  */
 int mlx5_eq_enable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		   struct notifier_block *nb)
@@ -344,11 +347,12 @@ int mlx5_eq_enable(struct mlx5_core_dev *dev, struct =
mlx5_eq *eq,
 EXPORT_SYMBOL(mlx5_eq_enable);
=20
 /**
- * mlx5_eq_disable - Enable EQ for receiving EQEs
- * @dev - Device which owns the eq
- * @eq - EQ to disable
- * @nb - notifier call block
- * mlx5_eq_disable - must be called before EQ is destroyed.
+ * mlx5_eq_disable - Disable EQ for receiving EQEs
+ * @dev : Device which owns the eq
+ * @eq  : EQ to disable
+ * @nb  : Notifier call block
+ *
+ * Must be called before EQ is destroyed.
  */
 void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 		     struct notifier_block *nb)
--=20
2.21.0

