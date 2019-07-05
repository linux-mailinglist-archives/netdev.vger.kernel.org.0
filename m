Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14760ADB
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfGERQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 13:16:59 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:45952
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727217AbfGERQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 13:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vdTYFM7fTKEa5ZbKPb0mo5GcETTV5PyBMdGtOwmbIY=;
 b=GmeK4/6kAnN5PiHIRCPaWd8xa0TKZeJ3R+fIy2ZZ4+InLgB7YygiMPzW8Srg166LUu3N5GydgK418DWP9zk3rLqpd+EQo7SrL2UGjsIqpDkn04C22fMJ/QfcpSUA17ayjGGJFa+rj6kzzHnrZXx0Jt8dhB/Fu3OSn5doI4GD3uw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB3165.eurprd05.prod.outlook.com (10.170.237.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Fri, 5 Jul 2019 17:16:53 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 17:16:53 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "Ertman, David M" <david.m.ertman@intel.com>
Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Topic: [rdma 14/16] RDMA/irdma: Add ABI definitions
Thread-Index: AQHVMg3xm+d1qAoGS06soOrLwK8W6aa6E1uAgABOAoCAAdu/gIAACaUA
Date:   Fri, 5 Jul 2019 17:16:53 +0000
Message-ID: <20190705171650.GI31525@mellanox.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
 <20190704121933.GD3401@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:207:3d::29) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e928e3fc-c01d-4f93-a71a-08d7016c9361
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB3165;
x-ms-traffictypediagnostic: VI1PR05MB3165:
x-microsoft-antispam-prvs: <VI1PR05MB316530952730C868C69E255ECFF50@VI1PR05MB3165.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(189003)(199004)(5660300002)(71190400001)(71200400001)(102836004)(26005)(7416002)(53936002)(68736007)(6916009)(256004)(186003)(386003)(4326008)(25786009)(14454004)(478600001)(66476007)(66556008)(66066001)(1076003)(64756008)(73956011)(66946007)(66446008)(6506007)(6486002)(229853002)(6512007)(2906002)(6436002)(36756003)(305945005)(7736002)(316002)(446003)(54906003)(6246003)(33656002)(81156014)(3846002)(86362001)(99286004)(8936002)(8676002)(6116002)(81166006)(476003)(52116002)(76176011)(11346002)(486006)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3165;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rVX9KQCazvT5Nk7diChJ4QJx5fY4bM5Oet970sz1Az0WZeT/dHQTgVYwHLfjROVOzR6Supa1fw+TBk6EX0cvK5DwUR90HQE41IeuXrTChc61zxrdj/sg+NNrUXbtCqesTLyWA0ZWmkhZAEFR04/myddF6ZhjkQ6iigbJvOjiiopUcolNK18bDb0BFZLyY9xxANuSIYjyKc/jQhGFbiICebp+S+2dRX415d0ts6Yn7m17hZWiHxsxVKRXl9acmnlm5M/HHcGhg1mZZ5KT1Gtv4pvOrp6kIu+bXLNyuZnqQP/WI3w4T2EfsxF/0GU29TjjSU+x7J8Bl1zGn/aWmkZWYCMYqfHzsO+wihmAoOJ/m6gSBBxTJM4nRgXC3efzAs2lVSSf8esB0Vp20tJ3wWu0MEJY4SQ+Fh2aw8ShBMVH7m8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3E892F273206F40ABB90742C0349AC2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e928e3fc-c01d-4f93-a71a-08d7016c9361
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 17:16:53.8509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3165
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 04:42:19PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> >=20
> > On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote:
> > > On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > >
> > > > Add ABI definitions for irdma.
> > > >
> > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > include/uapi/rdma/irdma-abi.h | 130
> > > > ++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 130 insertions(+)
> > > >  create mode 100644 include/uapi/rdma/irdma-abi.h
> > > >
> > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > 000000000000..bdfbda4c829e
> > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > @@ -0,0 +1,130 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > > > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights reserv=
ed.
> > > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved=
.
> > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserve=
d.
> > > > + */
> > > > +
> > > > +#ifndef IRDMA_ABI_H
> > > > +#define IRDMA_ABI_H
> > > > +
> > > > +#include <linux/types.h>
> > > > +
> > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > + * and user-space whose last ABI ver is 5  */ #define IRDMA_ABI_VE=
R
> > > > +6
> > >
> > > Can you please elaborate about it more?
> > > There is no irdma code in RDMA yet, so it makes me wonder why new
> > > define shouldn't start from 1.
> >=20
> > It is because they are ABI compatible with the current user space, whic=
h raises the
> > question why we even have this confusing header file..
>=20
> It is because we need to support current providers/i40iw user-space.
> Our user-space patch series will introduce a new provider (irdma) whose A=
BI
> ver. is also 6 (capable of supporting X722 and which will work with i40iw=
 driver
> on older kernels) and removes providers/i40iw from rdma-core.

Why on earth would we do that?

Jason=20
