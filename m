Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD366BC512
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504345AbfIXJmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:11 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:4229
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504288AbfIXJmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuziTFW4mr7hzYod+GdHDUFGSfjQJiGhqA1LPNBo7PeqZingUPzHrKfXGGAsiMqADLFguwhz/NvORyDjgzr4/iEtdNrJghweFyawSA9cGLx31gqLUUg9Lv03D48+bO6uYfjVGfLHYE8vGtg04hd+P013L8A3vTaWFXkRz5eWj8l45GfC+aIcdeA2UA0EhYqZJuNa/T9vbmWNdXvtSvqypcHhUgmieo3uye84Xmtsj/0D1Y9edh5TtQD8dfnW7F8Idfcj7B+7j7lmUWx+Bn2cvjcmhro8AmL5ErgkKqAAPNQYW7BrgbntXV5KvUqk9f8sRJ+mSDJAlsPrZw07KymnRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exOaQ1FJZwGbUkO2JA7Iye5kcAA+MiM4jeeldt/hQPg=;
 b=Bh9fcG9CI9VpgPKLRvYXdOut7t8sZzhjqHKSLRiW2EypcV6kHV3uyputeX6qyyVW8L00DxriTWYzehz6yUsk3uYcKRI6hLezdRr+4J+isQauGV4sYnjCLlE9a5OTAmqTaxOlKUQHKOPuXM54ofkZFeHZ31HgBrHq857DLwUzQcqy2Ct4XWfZo8o8bTa4B/oWDuX4UEDF40svOqk4NI+XEeMQFD/EGkQHSOKDVFcPeQoc8iouWnWbvxwgpy0hO/syBdCUF3CGnuaLXuxMIPZR0rhfZ4zFiBSSmmWtibybueCBLfUHSHbu4ENFb7IISdOZj6DrMt0xlTz3KXRhwjm+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exOaQ1FJZwGbUkO2JA7Iye5kcAA+MiM4jeeldt/hQPg=;
 b=EG5ejFwMcXEE62p5VCWYV24AYTCNIfF+jnLS5cPtZ8btMfErGF72EMD/ArPZ1kEWcUQpDg4kiNKpt1MT9P9x51sI6yYPdqR6hiog89TcXQhXaFT+O1SoMWJYkE6/1klwfZViYj37PtPkDAZFmNgiN2dZRPt/k/NS/pCIbR4dpgI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:37 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/7] net/mlx5: Add device ID of upcoming BlueField-2
Thread-Topic: [net 5/7] net/mlx5: Add device ID of upcoming BlueField-2
Thread-Index: AQHVcrxCdT0ZU1piv0mBZkfDVYBK/Q==
Date:   Tue, 24 Sep 2019 09:41:37 +0000
Message-ID: <20190924094047.15915-6-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a9e3026-6459-4e52-1d43-08d740d364ff
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2671D1A0AEDA071E72F0D823BE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:299;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(14444005)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IO3gE9o4ZAnhZWxJX0Q1Mg+1drQ38eCn4jawa1vlQ8qnwFwtwqRTQgTfoxH3XDhEbUdN9AJYwV1fBfU69881WEXOyc5OPZUFvbX1a6zgCaZ+knT185gj/ECcHjQOE4DcymZjA7Tu/5qLTo0dbb4IyIQFeNz8Sx+n+1XuzlVhpx3UGX9agrtWDynHFW0k17aHht/xAzLymUEhFueriwNs6Ery0EOLiyc2Qx+uGyUq2ycSpqw3XvfZJbBsKT8NzMF0ArKcxHeXg5DcZp44g2aASIC5MoWH1QXk4/3vVkBw1GkLl9Txdeo6dPjvhqtBtYCBJ0k2QgOP0dp7TkSIjxYWrO63uVqWZxuFcZ+quTVU+JvQRE8FDkBRGSjmshpNW+jIk/Q0lffczmDgZUSSWQq7kyN82n0sCZzzFbt813o3npc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9e3026-6459-4e52-1d43-08d740d364ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:37.8789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Elv5krekhATlqVOPl6pprOWgkU/pC3DjWocKK5g4BVwkGVybPTD/StPB29oCVoquUuOIjOhMABUXkvrnRWDNLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

Add the device ID of upcoming BlueField-2 integrated ConnectX-6 Dx
network controller. Its VFs will be using the generic VF device ID:
0x101e "ConnectX Family mlx5Gen Virtual Function".

Fixes: 2e9d3e83ab82 ("net/mlx5: Update the list of the PCI supported device=
s")
Signed-off-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 9648c2297803..e47dd7c1b909 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1568,6 +1568,7 @@ static const struct pci_device_id mlx5_core_pci_table=
[] =3D {
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family =
mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 n=
etwork controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integr=
ated ConnectX-5 network controller VF */
+	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6=
 Dx network controller */
 	{ 0, }
 };
=20
--=20
2.21.0

