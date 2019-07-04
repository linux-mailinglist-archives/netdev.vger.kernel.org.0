Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF135F7C4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfGDMPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:15:08 -0400
Received: from mail-eopbgr40065.outbound.protection.outlook.com ([40.107.4.65]:60643
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727627AbfGDMPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZ9LU80A3VbdChpLqWcRwhdwQ0iuuTQJsGQEGYm2kjg=;
 b=LDa4J1t7r5CqxSFpxg7hAk8xeEflTlPif8m8Dd0azUTSCDeXTWH8vC8+zEbSUHkb7doaqKWvN8zHQeDAbV+1f9adOu8opVKyEbZLfsw6Harxo3gPSZmcf+v/K2nxBdfCFoS0fbVcUYFCkDaZOKvJb/0r5Pt/HJvK9dYSxmB+8dc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5966.eurprd05.prod.outlook.com (20.178.126.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 12:15:04 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:15:04 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>
Subject: Re: [net-next 0/3][pull request] Intel Wired LAN ver Updates
 2019-07-03
Thread-Topic: [net-next 0/3][pull request] Intel Wired LAN ver Updates
 2019-07-03
Thread-Index: AQHVMg3qgzSU8AU2JE++yC4LeoOxy6a6YBaA
Date:   Thu, 4 Jul 2019 12:15:04 +0000
Message-ID: <20190704121459.GA3401@mellanox.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:160::31) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18c429c9-7f48-4c1d-df03-08d700793e9e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5966;
x-ms-traffictypediagnostic: VI1PR05MB5966:
x-microsoft-antispam-prvs: <VI1PR05MB596688E6B66065991CAD3FAFCFFA0@VI1PR05MB5966.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(189003)(199004)(25786009)(36756003)(386003)(6506007)(14454004)(6246003)(86362001)(3846002)(6486002)(6116002)(68736007)(1076003)(186003)(2906002)(7416002)(66066001)(305945005)(7736002)(229853002)(102836004)(71190400001)(2616005)(66556008)(6916009)(446003)(478600001)(486006)(66446008)(64756008)(73956011)(81156014)(66946007)(15650500001)(8676002)(5660300002)(8936002)(6436002)(81166006)(33656002)(54906003)(71200400001)(52116002)(53936002)(316002)(76176011)(99286004)(26005)(476003)(4326008)(11346002)(66476007)(256004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5966;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tVGIyG8eceRxFl+J585VZuhEROpkxQ8HG/APWZHF53vLulYU3ecfwl33Pfbj0RzzswfnxqmXsQ5Yff262uGwXtECVm6sRaGCuiGgr7xhMmWmsnB2FIh4grjSYkqi2yk18glMHgV9Bm8y+E2zRO0Pu3J8QAxMI7zSUhnZIsQJdc+Maa87KFUOPey7xUJQQH97L1JFNa8yyXyROmiXceP4aABniDNy6zwgD4xR31cWesRYX+KbWxsDk5cxTqWTUIsWJbddVKNXV4X1PYMmmq7v9rMYWHfAe/iDwRgJGqlZc70bF3JplMCwpB3EhXIANXP8P9i8F51UBd8TMmRkSbba+jkd4TOZzT/Qs+BQ0iu+VM5h5tjKhl7SgpkMhWBfNcy0gFlAoAJMm7iAapidGQgVb+rK2Kv5Q2Dj041jym9/mKk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E130730340F0C748BE69613E70F4E45A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c429c9-7f48-4c1d-df03-08d700793e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:15:04.1914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5966
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:12:49PM -0700, Jeff Kirsher wrote:
> This series contains updates to i40e an ice drivers only and is required
> for a series of changes being submitted to the RDMA maintainer/tree.
> Vice Versa, the Intel RDMA driver patches could not be applied to
> net-next due to dependencies to the changes currently in the for-next
> branch of the rdma git tree.

RDMA driver code is not to be applied to the net-next tree. We've
learned this causes too many work flow problems.=20

You must co-ordinate your driver with a shared git tree as Mellanox is
doing, or wait for alternating kernel releases.

I'm not sure what to do with this PR, it is far too late in the cycle
to submit a new driver so most likely net should not go ahead with
this prep work until this new driver model scheme is properly
reviewed.

> The following are changes since commit a51df9f8da43e8bf9e508143630849b7d6=
96e053:
>   gve: fix -ENOMEM null check on a page allocation
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100Gb=
E

And if you expect anything to be shared with rdma you need to produce
pull requests that are based on some sensible -rc tag.

Jason
