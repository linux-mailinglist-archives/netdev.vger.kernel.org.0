Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1010453C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKTUgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:45 -0500
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:41697
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726852AbfKTUgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b28H/kxA5lZHm3sG87U2CyRoD9BJLoJ+Tv5YWXllJsNB+CzbjbSjLJY/R79Tqv4MgRvGRs2HNtS8nDW7Q+jsOEThGo3QLpYemVmuAZPmfnfntXNX/sxXvDAv87obHub5ZmyTgv3k8rzLM7+mW37iKCw46IngZAukJgU17mlvX3DvTzdH8eJWY1QlQCuzqJj+uuzAZ+B8m8qeEfkvXGWMeoiLiiWggOVeT6a5p5XcVjsbOQuf5lmOPmcQQoDLcs04iAwx/nX86c11uXqPCIQ5qfJAigbM/RdXz5jGvMeugZxCeqmINHmqnhNgLz97odLkqfId+u3StiUMUWa9l2rzCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPn94xc3ZVDpfYw7jCOKkOhcIG7OJf5BI/miSQpT7eY=;
 b=EcVDIJpahxbNJYP8BRfb/0WobquKKqMtCqoeG/rX7hACi6p5TDaMjDxrSdJBQxoeTR+sMTv3ocVuU8P0GkSBAik+Kjr8WMzKL09mk30qZDpcFMCioueHN41+2FJKjojdEhe7t+fhmG2UFE5UHkC3chNjRYwMK3APQuvLF2xFfhQJmghwEICjtgrhnc7IgUGXHh7l8D1RU4u/qveBJl7zYzrmBKGBZ/0cuM1G5G9uF8To3HOGNo56/E/15531ushlPgL7lu2/gsIwGGAedOo32vsNV10L1PPBi9F6vTFtJrPqIz5ErHtfrAOl07HbfvoKmDtpJfALcUeugbYl2fVHLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPn94xc3ZVDpfYw7jCOKkOhcIG7OJf5BI/miSQpT7eY=;
 b=tS8EhBMdYrzOf/DhFQMQ+tqsHhm9PnAw/sJB7XmdGc6vuuP/pBinCUKVIHdlL55w9FK0JJNhp2EU40OQAfhB/cY36reYVZ6Eg+0C1G5AlfztIPlb0a4yArNCgq+dDNEO8eEfYs2jza7pn3tFWrBZSV66BErCv0jwdBt60AFpX8g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:36:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:36:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shani Shapp <shanish@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/12] net/mlx5: Update the list of the PCI supported devices
Thread-Topic: [net 11/12] net/mlx5: Update the list of the PCI supported
 devices
Thread-Index: AQHVn+IfllGwT5QO5U2rZffMKqHt8A==
Date:   Wed, 20 Nov 2019 20:36:02 +0000
Message-ID: <20191120203519.24094-12-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: db95df20-8503-4f50-2be7-08d76df94239
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61106AA2413A1CF281C783B5BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(15650500001)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BsFNjHx6qPazP+Te2YRuc0iJmY5lmF/TIe13JtsAzffUi21MHrwwejRpauNtGafIZOxz0eLh2ZNdjjWmN5+WxOZEuo5QjBnUDRVnyoQ3A7pNSu9+BSsQbvoMm8Eh66F4HZNFr/ynf43FfjN9A4oqY4y5zD7QDtN+8Ct4feP2EcaIvkBMj/yAjWADwpkvflJ/Hoi32d1FWKomrexTH0whBAGRav781Vz/chMPyI5jNoq9HpoQkAIcDC/9LsjhhRbg/Q4MMciZ2ClDcxfzg83Cxcq3V9F0p+REDxZXjK9DfKch2ZNc3P333rh0WquEcCxZkVko8Mr3Asx4ZfgY62XPJnVUHgdfLBdF/H4mDnBZ9i10ARLg9O2TinXaUCa78Ltvh1fNMJZscK45Y4Z1CyS/DedJXnu5liTYrQd2Lz0IwxXFxrHoLtFX4asPRAGexKGX
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db95df20-8503-4f50-2be7-08d76df94239
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:36:02.5509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 67p7seK30SoqzC2ENwfgYbtFVkH5N33vXEou/Sr5MQaJNfiVrW6z/hvUk+9q8x82n4SgCPk1DM0kSr6bpc1d4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shani Shapp <shanish@mellanox.com>

Add the upcoming ConnectX-6 LX device ID.

Fixes: 85327a9c4150 ("net/mlx5: Update the list of the PCI supported device=
s")
Signed-off-by: Shani Shapp <shanish@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index e47dd7c1b909..50ab88d80033 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1566,6 +1566,7 @@ static const struct pci_device_id mlx5_core_pci_table=
[] =3D {
 	{ PCI_VDEVICE(MELLANOX, 0x101c), MLX5_PCI_DEV_IS_VF},	/* ConnectX-6 VF */
 	{ PCI_VDEVICE(MELLANOX, 0x101d) },			/* ConnectX-6 Dx */
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family =
mlx5Gen Virtual Function */
+	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 n=
etwork controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integr=
ated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6=
 Dx network controller */
--=20
2.21.0

