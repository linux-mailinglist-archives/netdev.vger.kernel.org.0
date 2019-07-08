Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C49625CF
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391501AbfGHQJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:09:08 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:23910
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729062AbfGHQJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 12:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et7pwJyRWqYJ5CEjQoBXXF01Y0fuJFtFXwGpth3tND4=;
 b=n0JiqngRF/OmUAYT/JKcV0etP7CE2BmqObVVgApCErhcIhHh06kAkGv7PRbg/5DDUm7eNI3Sx6KZheHu84cDzWJHugNd7g2xZ1rFDpnV7BXS29o5EkRQH+0F3qPTz3dDzJYEvHyfCaxc18hCAwiZvebjIcqLRqxhO/we48qi0Wc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6061.eurprd05.prod.outlook.com (20.178.204.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Mon, 8 Jul 2019 16:09:03 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 16:09:03 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: manual merge of the mlx5-next tree with the rdma tree
Thread-Topic: linux-next: manual merge of the mlx5-next tree with the rdma
 tree
Thread-Index: AQHVMhLbwhSrvM/Tf0CjT+DAZZSBmqbAFk+AgADUcAA=
Date:   Mon, 8 Jul 2019 16:09:03 +0000
Message-ID: <20190708160858.GI23966@mellanox.com>
References: <20190704124738.1e88cb69@canb.auug.org.au>
 <20190708132837.5ccb36ed@canb.auug.org.au>
In-Reply-To: <20190708132837.5ccb36ed@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YQBPR0101CA0063.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e4cd52c-0d9d-4218-a2bc-08d703be9865
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6061;
x-ms-traffictypediagnostic: VI1PR05MB6061:
x-microsoft-antispam-prvs: <VI1PR05MB606176D0A80635B04900A619CFF60@VI1PR05MB6061.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(53754006)(199004)(189003)(43544003)(4326008)(5660300002)(476003)(33656002)(102836004)(478600001)(99286004)(66066001)(25786009)(68736007)(6436002)(229853002)(6486002)(6116002)(186003)(6512007)(52116002)(54906003)(3846002)(446003)(66446008)(64756008)(66556008)(66476007)(11346002)(26005)(305945005)(73956011)(66946007)(6506007)(7736002)(76176011)(6916009)(386003)(86362001)(36756003)(316002)(8936002)(256004)(486006)(14454004)(71190400001)(71200400001)(1076003)(81156014)(53936002)(81166006)(2906002)(2616005)(6246003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6061;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PVlAFGBhyHpAejxwVOw6dZwotDxViEgt09wRmIOpfzZi60yAy+Ud9Van2nW25qYPyalMrbbgDYPLU/fpOKcjRocDJsKTPmXNP/aX7jam5hORPGIVGg3dsZAzTA3LEhmT2O8D4DgiTp+uSCrPO8hjAdp/CooOa2aNpYvSC4yhLbJa6fEMOcluTGELhc1fLzJUIY2TlWC0ENkHUb6ESjuAjpd47Nk0TsOKUNQUyj5GzNvdoC0gF83VFRARL8me08WCKyZ3VzgZKQ1VRUi8n7xO2oJLNWbZgvctiJMvbwTZBGqBFUTLHcqoxE1nxdyUE6cLTLwoa/UVpcaK7TDOM61JUsTewohgE/zD1cnWzM0aX8uIQUA0U07m3nzkSuV3f29jN1COMJraAraIkb+fnZgNFp8h18cLSVq7Y7r7WROXF8E=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F041F5A654C82B408AAFE3221C2B5B14@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4cd52c-0d9d-4218-a2bc-08d703be9865
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 16:09:03.3900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 01:28:37PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> On Thu, 4 Jul 2019 12:47:38 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > Hi all,
> >=20
> > Today's linux-next merge of the mlx5-next tree got a conflict in:
> >=20
> >   drivers/infiniband/hw/mlx5/cq.c
> >=20
> > between commit:
> >=20
> >   e39afe3d6dbd ("RDMA: Convert CQ allocations to be under core responsi=
bility")
> >=20
> > from the rdma tree and commit:
> >=20
> >   38164b771947 ("net/mlx5: mlx5_core_create_cq() enhancements")
> >=20
> > from the mlx5-next tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tre=
e
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularl=
y
> > complex conflicts.
> >=20
>=20
> This is now a conflict between the net-next tree and the rdma tree.

You'll see the mlx5-next merge with rdma tomorrow that will take care
of this

Thanks,
Jason
