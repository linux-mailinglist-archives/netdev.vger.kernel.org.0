Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E500A47481
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 14:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfFPMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 08:44:05 -0400
Received: from mail-eopbgr00059.outbound.protection.outlook.com ([40.107.0.59]:11011
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfFPMoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jun 2019 08:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMLxMjOgWa9g+34T5f8m9E1V/tJIfnT1FwKxNWO5+8s=;
 b=Qj8BxVKEM48uoxRWeCJUezrXp0GsG7xFkxUOBQHEcUW7va/oLG5p/eHsRc2okyWdL+c8lRgEakt2gksSOyy8KKnJQExCXLYT86w4pQucnjlZ3khEGmVFKyNnIvoF17LBsMZn08o1SisT1RR9RsCHocj/aKcncvTIemGPvmFMZh0=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.186.14) by
 AM4PR05MB3202.eurprd05.prod.outlook.com (10.171.186.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Sun, 16 Jun 2019 12:44:01 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::bc5a:ba8b:1a69:91b6%6]) with mapi id 15.20.1987.014; Sun, 16 Jun 2019
 12:44:01 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Thread-Topic: [PATCH rdma-next v1 0/4] Expose ENCAP mode to mlx5_ib
Thread-Index: AQHVIRk18/J41ozP+EePM2PV1Ubi36aeQCGA
Date:   Sun, 16 Jun 2019 12:44:01 +0000
Message-ID: <20190616124357.GH4694@mtr-leonro.mtl.com>
References: <20190612122014.22359-1-leon@kernel.org>
In-Reply-To: <20190612122014.22359-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0020.eurprd09.prod.outlook.com
 (2603:10a6:101:16::32) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:3::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d238620f-2d37-480c-ed75-08d6f2584e64
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3202;
x-ms-traffictypediagnostic: AM4PR05MB3202:
x-microsoft-antispam-prvs: <AM4PR05MB3202EFE40BC091915C31AF61B0E80@AM4PR05MB3202.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(136003)(346002)(396003)(39860400002)(366004)(376002)(54534003)(189003)(199004)(8676002)(4326008)(52116002)(76176011)(6436002)(73956011)(66946007)(386003)(66476007)(66556008)(64756008)(66446008)(6486002)(81156014)(81166006)(6506007)(186003)(1076003)(6512007)(14454004)(6636002)(26005)(102836004)(25786009)(9686003)(33656002)(3846002)(6116002)(229853002)(107886003)(8936002)(53936002)(99286004)(305945005)(5660300002)(256004)(110136005)(66066001)(2906002)(54906003)(316002)(71200400001)(11346002)(6246003)(478600001)(476003)(68736007)(446003)(7736002)(486006)(71190400001)(86362001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3202;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: khmL8PIeg4pNfvxg84PUpw+Yk6Q90RqSNBqfsBYBddo7FFfUkybDrnHhrotW8DQurubcduArEiNBCfFzyrWlL8+vFsoa3DIWwe4yJ4U7y0+c3xknDeOhX9vymZneEiCG+dLANxIrjo9LR8i+vBZydHcT/lP7LXgM/pVxzk1DT7DjiKFftOGZwGay0vVYdisv5jtrOwBrbKAc6u0CdR3whiSFGeCR1ML3cwCI7X9JlSWJJyVwX9/YASszmo0jk+XUt4A4GLXYJMP7nCOWdcVnn9oysF9xD8lGCr5FgYwMfWO2yNT/ho7LTO/d/GTgujADo/yQjJVG2m8ItCpQ300yCii3NBewccKH18Mryg/J9UbDHqjwhDF/J2i1LZFUGPUMdQuO5jjWtnhFkPICFt8PI4zBI/22RZW46L1rflnoVc8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37A744EF553FF2438A01E5C4BF8E415C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d238620f-2d37-480c-ed75-08d6f2584e64
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2019 12:44:01.2381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leonro@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3202
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 03:20:10PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog v0->v1:
>  * Added patch to devlink to use declared enum for encap mode instead of =
u8
>  * Constify input argumetn to encap mode function
>  * fix encap variable type to be boolean
>
> ---------------------------------------------------------------------
> Hi,
>
> This is short series from Maor to expose and use enacap mode inside mlx5_=
ib.
>
> Thanks
>
> Leon Romanovsky (1):
>   net/mlx5: Declare more strictly devlink encap mode
>
> Maor Gottlieb (3):
>   net/mlx5: Expose eswitch encap mode

Those two applied to mlx5-next
82b11f071936 net/mlx5: Expose eswitch encap mode
98fdbea55037 net/mlx5: Declare more strictly devlink encap mode

>   RDMA/mlx5: Consider eswitch encap mode
>   RDMA/mlx5: Enable decap and packet reformat on FDB

Doug, Jason

Can you please take those two patches in addition to latest mlx5-next?

Thanks

>
>  drivers/infiniband/hw/mlx5/main.c             | 25 ++++++++++++++-----
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++++++
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |  8 +++---
>  .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +++--
>  include/linux/mlx5/eswitch.h                  | 12 +++++++++
>  include/net/devlink.h                         |  6 +++--
>  net/core/devlink.c                            |  6 +++--
>  7 files changed, 59 insertions(+), 15 deletions(-)
>
> --
> 2.20.1
>
