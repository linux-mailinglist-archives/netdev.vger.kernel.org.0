Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965546203F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfGHONr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:13:47 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:10990
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729234AbfGHONq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 10:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zqIOhgnppmG/1NO2D45O7f/uLIORSxawKggoWp2lps=;
 b=QXy1dfwTa1wDKqq2dJHs3NCriKBZ6umNBSIlicaLFtSWXDUb0KKwr/GEvSknj+H2ClFi2YhgNkxYSAZLgT+Ld5xf75d5eKzgkPujDc7fSc8m/fuB+o1+H5tjkqR1JYvMHIl+J8CYi4RpmkFiTNN506T8c7A5E/FWmmB2WKz2BEY=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6143.eurprd05.prod.outlook.com (20.178.205.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 14:13:39 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 14:13:39 +0000
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
Thread-Index: AQHVMg3xm+d1qAoGS06soOrLwK8W6aa6E1uAgABOAoCAAdu/gIAACaUAgAGBJgCAAwKnAA==
Date:   Mon, 8 Jul 2019 14:13:39 +0000
Message-ID: <20190708141336.GF23966@mellanox.com>
References: <20190704021259.15489-1-jeffrey.t.kirsher@intel.com>
 <20190704021259.15489-16-jeffrey.t.kirsher@intel.com>
 <20190704074021.GH4727@mtr-leonro.mtl.com>
 <20190704121933.GD3401@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A684DAAA@fmsmsx124.amr.corp.intel.com>
 <20190705171650.GI31525@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7A68512AA@fmsmsx124.amr.corp.intel.com>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A68512AA@fmsmsx124.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR01CA0022.prod.exchangelabs.com (2603:10b6:208:71::35)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 325a3457-df03-43d6-1cf7-08d703ae7991
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB6143;
x-ms-traffictypediagnostic: VI1PR05MB6143:
x-microsoft-antispam-prvs: <VI1PR05MB61433C6D2F2297986EA8018DCFF60@VI1PR05MB6143.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(189003)(199004)(316002)(14454004)(1076003)(36756003)(6486002)(6512007)(54906003)(86362001)(4326008)(478600001)(6436002)(229853002)(53936002)(7416002)(68736007)(2616005)(476003)(486006)(256004)(305945005)(7736002)(6246003)(446003)(6916009)(11346002)(66066001)(81166006)(81156014)(8936002)(2906002)(33656002)(8676002)(186003)(99286004)(5660300002)(26005)(6506007)(386003)(66476007)(66556008)(64756008)(66946007)(102836004)(73956011)(52116002)(3846002)(6116002)(71190400001)(71200400001)(25786009)(66446008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6143;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HM9BZRVNAQrdIztvzOf8WNCUfWZuL+GQohMeyZzTyvjik8QeiasUcjh3mCZZMn8noCljgCc/hmgZpFyX+srCAa/a9WJGWOzAtCO9rNHJTbdVWfVFAm3MMuSvhEgLtAeLwnczK51HxKUR8ihEpDIT+qdqqpWP89i/9ABqhkJWSOVmJ/bu7sODvTfb4Qo8t8ygkgclytsJybl01aX6kDotw+xX6yYHuTQSvrZmaHYQmkpPl31Oko0mS9fOQX7OaZAmneT6ttKa36A0YtGnl47yb0ch0biAVi4sH+Kvus7uQ6CkZMxucM7EfkvK6HTRNFCtPzkvZ5YFdjYZCWJZLu6bMacv3BGQHxUR83+k4qYVv4A7l1Hz1+EegX274WuWbp2XuRMxCYviIyz8LYDHD+F+Aj+qZlcRKGx+UiDaEhsZzzk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6728CAF4B43EE94C8D3EB22A97279E17@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325a3457-df03-43d6-1cf7-08d703ae7991
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 14:13:39.6739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6143
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 04:15:20PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> >=20
> > On Fri, Jul 05, 2019 at 04:42:19PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [rdma 14/16] RDMA/irdma: Add ABI definitions
> > > >
> > > > On Thu, Jul 04, 2019 at 10:40:21AM +0300, Leon Romanovsky wrote:
> > > > > On Wed, Jul 03, 2019 at 07:12:57PM -0700, Jeff Kirsher wrote:
> > > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > >
> > > > > > Add ABI definitions for irdma.
> > > > > >
> > > > > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > > include/uapi/rdma/irdma-abi.h | 130
> > > > > > ++++++++++++++++++++++++++++++++++
> > > > > >  1 file changed, 130 insertions(+)  create mode 100644
> > > > > > include/uapi/rdma/irdma-abi.h
> > > > > >
> > > > > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > > > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > > > > 000000000000..bdfbda4c829e
> > > > > > +++ b/include/uapi/rdma/irdma-abi.h
> > > > > > @@ -0,0 +1,130 @@
> > > > > > +/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
> > > > > > +/* Copyright (c) 2006 - 2019 Intel Corporation.  All rights re=
served.
> > > > > > + * Copyright (c) 2005 Topspin Communications.  All rights rese=
rved.
> > > > > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > > > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights res=
erved.
> > > > > > + */
> > > > > > +
> > > > > > +#ifndef IRDMA_ABI_H
> > > > > > +#define IRDMA_ABI_H
> > > > > > +
> > > > > > +#include <linux/types.h>
> > > > > > +
> > > > > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > > > > + * and user-space whose last ABI ver is 5  */ #define
> > > > > > +IRDMA_ABI_VER
> > > > > > +6
> > > > >
> > > > > Can you please elaborate about it more?
> > > > > There is no irdma code in RDMA yet, so it makes me wonder why new
> > > > > define shouldn't start from 1.
> > > >
> > > > It is because they are ABI compatible with the current user space,
> > > > which raises the question why we even have this confusing header fi=
le..
> > >
> > > It is because we need to support current providers/i40iw user-space.
> > > Our user-space patch series will introduce a new provider (irdma)
> > > whose ABI ver. is also 6 (capable of supporting X722 and which will
> > > work with i40iw driver on older kernels) and removes providers/i40iw =
from rdma-
> > core.
> >=20
> > Why on earth would we do that?
> >=20
> A unified library providers/irdma to go in hand with the driver irdma and=
 uses the ABI header.
> It can support the new network device e810 and existing x722 iWARP device=
. It obsoletes
> providers/i40iw and extends its ABI. So why keep providers/i40iw around i=
n rdma-core?

Why rewrite a perfectly good userspace that is compatible with the
future and past kernels?

Is there something so wrong with the userspace provider to need this?

Jason
