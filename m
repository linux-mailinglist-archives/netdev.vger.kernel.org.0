Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBFF5F7DE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbfGDMTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:19:40 -0400
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:60390
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727662AbfGDMTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:19:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTKihjsLkWA9SnbKWlgwAUmYXD0vJjTsQU/wPJcMprc=;
 b=VfSylTOuDjMeKcwiwDX+KRoBgo/uOra0IWWdPChnb13ZgMjZRZid2UwmPw2fN7n2FVOLrzVzxLXiuHXppgG3NZeBLSwFSPNoEYxqi9y4lfdcoWpp6QEEDiTwIorJoowi7kjDPjlMwZ99gdsaewCtamjBYYCOqVoN/h5A0cz94t0=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4237.eurprd05.prod.outlook.com (52.133.12.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 12:19:36 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:19:36 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHVMg3xm+d1qAoGS06soOrLwK8W6aa6E1uAgABOAoA=
Date:   Thu, 4 Jul 2019 12:19:36 +0000
Message-ID: <20190704121933.GD3401@mellanox.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
In-Reply-To: <20190704074021.GH4727@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR01CA0027.prod.exchangelabs.com (2603:10b6:208:10c::40)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dd27356-63c6-44e9-d77f-08d70079e13c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4237;
x-ms-traffictypediagnostic: VI1PR05MB4237:
x-microsoft-antispam-prvs: <VI1PR05MB42371E8EB5A258DDECC8605ECFFA0@VI1PR05MB4237.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(199004)(189003)(25786009)(76176011)(478600001)(54906003)(6512007)(99286004)(102836004)(52116002)(73956011)(66556008)(6436002)(229853002)(68736007)(386003)(66476007)(6506007)(6486002)(64756008)(5660300002)(7416002)(6916009)(316002)(6246003)(66946007)(26005)(66446008)(81156014)(53936002)(446003)(11346002)(2616005)(486006)(305945005)(2906002)(36756003)(66066001)(4326008)(33656002)(86362001)(3846002)(6116002)(186003)(81166006)(8936002)(476003)(14444005)(8676002)(7736002)(256004)(71200400001)(71190400001)(1076003)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4237;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dzS8ZZ6fZOwrQUsECp8r+q73mPl1M0dwjy+6+tD7VKLxxquqgnlGsEc0Rkl+YwiJJ8GmXFl+jC2IWvE3a0gNh0MAVFsCJ276Kw4t7DbRXelzSrgtRNaaRinrU7uZqRxDNc9Qj6uvlS/E1qDKNeRYVjRo6sL14+Bus1GviGLVYFF71Mz39ftLAPdTVm0731Y7o9svofK/tFvcXYpHa0moCH2ivmFo2XAlUqXI2RuybQs2TVOhAzXKb3MkP3Zm1CiuHvaBbPA+YUYrnympxCtpmgkjTzhcnGPnDwgcqaXbTvPgZ2Hs5cWjeNAjPSqFjv+6fH5FWSvSze53BIjVR7hp7vPVx9/0jm5Q5KwwoM0cXAT6O0NESzmWRqBnVOJjQkKsyiyjp1iD98Rw5qlSciiQ2rVfvBls6E3pi0uQoCN1oPE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F5B3D2DC65777B46AAFAA040E6875482@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd27356-63c6-44e9-d77f-08d70079e13c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:19:36.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote:
> On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Add ABI definitions for irdma.
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> >  include/uapi/rdma/irdma-abi.h | 130 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 130 insertions(+)
> >  create mode 100644 include/uapi/rdma/irdma-abi.h
> >
> > diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-ab=
i.h
> > new file mode 100644
> > index 000000000000..bdfbda4c829e
> > +++ b/include/uapi/rdma/irdma-abi.h
> > @@ -0,0 +1,130 @@
> > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserved.
> > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > + */
> > +
> > +#ifndef IRDMA_ABI_H
> > +#define IRDMA_ABI_H
> > +
> > +#include <linux/types.h>
> > +
> > +/* irdma must support legacy GEN_1 i40iw kernel
> > + * and user-space whose last ABI ver is 5
> > + */
> > +#define IRDMA_ABI_VER 6
>=20
> Can you please elaborate about it more?
> There is no irdma code in RDMA yet, so it makes me wonder why new define
> shouldn't start from 1.

It is because they are ABI compatible with the current user space,
which raises the question why we even have this confusing header
file..

I think this needs to be added after you delete the old driver.

Jason
