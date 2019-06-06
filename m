Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713ED374D1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfFFNHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:07:23 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:44610
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfFFNHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 09:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUOUOOVog7Ui4Oem5h4vQ6omdPiXnglg2OMNUs6TIjs=;
 b=skBse3+AVFPy2lgy5EsxFR8Mz7TAbNbzaeJUpYWeot96vJj69IdjHm0Buh/HnXen3C5NduLlpmiPWa0bRZY6ZkiFD2AqwYwf4Olai/ghwVsipUQJ24P+7+PPW4C+J/DdhSmwnqxa9reYqhwtLRTj9zGgf+pAcqrYr+abf9T1DRE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5087.eurprd05.prod.outlook.com (20.177.52.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 13:07:18 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::c16d:129:4a40:9ba1%6]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 13:07:18 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Max Gurtovoy <maxg@mellanox.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Tal Gilboa <talgi@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Thread-Topic: [pull request][for-next 0/9] Generic DIM lib for netdev and RDMA
Thread-Index: AQHVG/XTn2LcR9xgMkG6p2oMks5Qt6aONwiAgAABdoCAAGEZgA==
Date:   Thu, 6 Jun 2019 13:07:18 +0000
Message-ID: <20190606130713.GC17392@mellanox.com>
References: <20190605232348.6452-1-saeedm@mellanox.com>
 <20190606071427.GU5261@mtr-leonro.mtl.com>
 <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
In-Reply-To: <898e0df0-b73c-c6d7-9cbe-084163643236@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:c0::17) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0089310b-eff5-4572-e2ef-08d6ea7fe735
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5087;
x-ms-traffictypediagnostic: VI1PR05MB5087:
x-microsoft-antispam-prvs: <VI1PR05MB5087163F8363BB2B8FC5CC06CF170@VI1PR05MB5087.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(39860400002)(136003)(199004)(189003)(2906002)(66066001)(6486002)(26005)(229853002)(25786009)(68736007)(6116002)(3846002)(6436002)(316002)(476003)(36756003)(102836004)(2616005)(186003)(86362001)(486006)(6512007)(6506007)(386003)(14444005)(256004)(11346002)(446003)(73956011)(99286004)(6636002)(71190400001)(66476007)(66446008)(64756008)(66556008)(14454004)(66946007)(4326008)(76176011)(478600001)(8936002)(52116002)(71200400001)(81156014)(8676002)(81166006)(7736002)(305945005)(54906003)(6246003)(37006003)(6862004)(5660300002)(1076003)(33656002)(53936002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5087;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KJ7QJMzgCIpyY/k+DaNDO+IOzxKEw4a9XsYja77GCaVOK0cB76AKJF+QBwSAKOOagoD+5oKdCtUUT7LqKHRCxo7aggal98ERGmsgi0xqfoxkDCDRCZoT4LAgeTCJvZh3qa7111NXHaN6K9zpcuFclDBpcG4qQOBbMdJeVkOoWwqLRhaq/U/0HMf2/V56clleEUCuybShr6Cm797dj8U5DZtzZLJ3cXf8TTUBNevLeMSt6mzFkjbSzwFXreyv1qAkiX9jzcm3CuhBZ5JOPhuCoX4uiNvTQ3kJalAMBgnoK2d4/9aQCBUa4l1x9gzaJIkW/A1T4fqYEpkmkyQEvv5tOxyMlPZeZfwi3qcOq/MmFlMsoKBoT2QZ6M2ADewWcF8pB8C5NdXXXMJybmeJ++dT0ceU1KXYS0VoEZ2DA5RI4cg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3133F2B66F95664CBC0D308614FA41E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0089310b-eff5-4572-e2ef-08d6ea7fe735
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 13:07:18.3966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5087
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 10:19:41AM +0300, Max Gurtovoy wrote:
> > > Solution:
> > > - Common logic is declared in include/linux/dim.h and implemented in
> > >    lib/dim/dim.c
> > > - Net DIM (existing) logic is declared in include/linux/net_dim.h and
> > >    implemented in lib/dim/net_dim.c, which uses the common logic from=
 dim.h
> > > - Any new DIM logic will be declared in "/include/linux/new_dim.h" an=
d
> > >     implemented in "lib/dim/new_dim.c".
> > > - This new implementation will expose modified versions of profiles,
> > >    dim_step() and dim_decision().
> > >=20
> > > Pros for this solution are:
> > > - Zero impact on existing net_dim implementation and usage
> > > - Relatively more code reuse (compared to two separate solutions)
> > > - Increased extensibility
> > >=20
> > > Tal Gilboa (6):
> > >        linux/dim: Move logic to dim.h
> > >        linux/dim: Remove "net" prefix from internal DIM members
> > >        linux/dim: Rename externally exposed macros
> > >        linux/dim: Rename net_dim_sample() to net_dim_update_sample()
> > >        linux/dim: Rename externally used net_dim members
> > >        linux/dim: Move implementation to .c files
> > >=20
> > > Yamin Friedman (3):
> > >        linux/dim: Add completions count to dim_sample
> > >        linux/dim: Implement rdma_dim
> > >        RDMA/core: Provide RDMA DIM support for ULPs
> > Saeed,
> >=20
> > No, for the RDMA patches.
> > We need to see usage of those APIs before merging.
>=20
> I've asked Yamin to prepare patches for NVMeoF initiator and target for
> review, so I guess he has it on his plate (this is how he tested it..).
>=20
> It might cause conflict with NVMe/blk branch maintained by Sagi, Christop=
h
> and Jens.

It looks like nvme could pull this series + the RDMA patches into the
nvme tree via PR? I'm not familiar with how that tree works.

But we need to get the patches posted right away..

Jason
