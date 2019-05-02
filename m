Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F64E118A7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 14:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfEBMKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 08:10:48 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60260 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbfEBMKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 08:10:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42C5wRJ013955;
        Thu, 2 May 2019 05:10:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=bGCgWFfJj4r6cnnfPfA8LXucBdiV+UzMjGskRfojSyU=;
 b=l2CvD9WVzbPGWT3txnzegwXD9whdi/wb4DDVC/bbzyERUzqSwwNcL8DJ1b6rxNw0FymQ
 ejKDY4u1zbcgwqXzVc2PQVZuEq9CX5r1O435nWoyleuGX7J6TWd3bdgHj9hanH+pcAuY
 jii3J1N3yQEUwgXB8m3+lChR9qonqlQXgdNKSIlkCc4DUTtWpl6pH21TFif4eEgtWMx3
 h4BxBQxnia0UBckw6+JW4VDvdTUbnQn+JmD1BpcUUdqZ6ryMMZCzQ2odtY5M5dBc2afA
 kaIWBLCP8cIKmTJInb4qTtym3EEFx4PCigU+Cj01WELhB3GiV7lfClXYQZjURxQbnSo8 /A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2s7ycr05xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 May 2019 05:10:42 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 2 May
 2019 05:10:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 2 May 2019 05:10:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGCgWFfJj4r6cnnfPfA8LXucBdiV+UzMjGskRfojSyU=;
 b=YBWiJYzhbSDsA1Kd0HcQLxjpBjqwE8PAWihzPa1pcXQXnisGfd8MwAoL6SgV1B4Po934l/W9wwiresKfhn90TiYZ1qZ6UxrsqRIY7xLr+7eu9wxCVRD33SIiPrwdHWfkYoXOOfDhN3GOx+UohTjuNCvxBMvEgdCIsSZcBqvSImA=
Received: from BLUPR18MB0130.namprd18.prod.outlook.com (10.160.188.26) by
 BLUPR18MB0004.namprd18.prod.outlook.com (10.160.188.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.18; Thu, 2 May 2019 12:10:39 +0000
Received: from BLUPR18MB0130.namprd18.prod.outlook.com
 ([fe80::d998:a162:bdee:3ed3]) by BLUPR18MB0130.namprd18.prod.outlook.com
 ([fe80::d998:a162:bdee:3ed3%7]) with mapi id 15.20.1835.018; Thu, 2 May 2019
 12:10:39 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     Ariel Elior <aelior@marvell.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Thread-Topic: [EXT] Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
Thread-Index: AQHVAASJgb30DtcUnkKd3+vJ8gvix6ZW/dEAgABNqQCAAHNAoA==
Date:   Thu, 2 May 2019 12:10:39 +0000
Message-ID: <BLUPR18MB0130AF99D6AB674A85E075D9A1340@BLUPR18MB0130.namprd18.prod.outlook.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
 <20190501095722.6902-8-michal.kalderon@marvell.com>
 <20190501.203522.1577716429222042609.davem@davemloft.net>
 <20190502051320.GF7676@mtr-leonro.mtl.com>
In-Reply-To: <20190502051320.GF7676@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e9bf966-4ca9-4384-30d8-08d6cef730f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BLUPR18MB0004;
x-ms-traffictypediagnostic: BLUPR18MB0004:
x-microsoft-antispam-prvs: <BLUPR18MB0004A6E2C1E3EFBB4DEF3721A1340@BLUPR18MB0004.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39860400002)(376002)(396003)(346002)(199004)(189003)(25786009)(6116002)(9686003)(316002)(305945005)(76176011)(6246003)(68736007)(99286004)(110136005)(5660300002)(74316002)(4326008)(54906003)(102836004)(7696005)(33656002)(14454004)(71190400001)(71200400001)(478600001)(2906002)(476003)(186003)(6436002)(6506007)(446003)(53936002)(7736002)(11346002)(26005)(86362001)(52536014)(81156014)(81166006)(55016002)(229853002)(3846002)(8936002)(66556008)(66476007)(73956011)(64756008)(76116006)(256004)(66446008)(486006)(66066001)(14444005)(8676002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR18MB0004;H:BLUPR18MB0130.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uQkKyUMmYZeQplIiSTfGkr/9sg7Vg9lw4fLJJJhdM73ZZVC4cOnL7X+YSOdW+lmIU2bcARERs0GPfTbljwV7TpedUUC4eQ1Q9P6v1PnoQJxoPDPIUjzHu/qXH2AENs4x0/IUiSjVgwouyKaWFPNh98WNEf2WozbwcDKlLsmCopGEuhmCrkqQvr3c85Dk8Spcmgz8TxVM5ACWtHFmrUy2xguXuZcTcqDbOUH3dSJPBCG0u6d6Pz3e9sCHN82rBqg9FQKL0eOIT2P0GGbNp5u4eBwvxuEk5T+7pcWMVxTqFSQ6IXVoknGGXPzE/XH+KaRK1pYHC6NdhmPFBiaaGqG6WQjvPV5jXjXGKREdENJUsa4BQxEfTK/L/jnds8+bKNpI2FKKgCHGkTeUV8DZfbsmQHlrqNFkHNvh3z+n5vEK7wI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e9bf966-4ca9-4384-30d8-08d6cef730f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 12:10:39.1722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR18MB0004
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_06:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, May 2, 2019 8:13 AM
> On Wed, May 01, 2019 at 08:35:22PM -0400, David Miller wrote:
> > From: Michal Kalderon <michal.kalderon@marvell.com>
> > Date: Wed, 1 May 2019 12:57:19 +0300
> >
> > > diff --git a/drivers/infiniband/hw/qedr/main.c
> > > b/drivers/infiniband/hw/qedr/main.c
> > > index d93c8a893a89..8bc6775abb79 100644
> > > --- a/drivers/infiniband/hw/qedr/main.c
> > > +++ b/drivers/infiniband/hw/qedr/main.c
> > > @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE
> > > Driver");  MODULE_AUTHOR("QLogic Corporation");
> > > MODULE_LICENSE("Dual BSD/GPL");
> > >
> > > +static uint iwarp_cmt;
> > > +module_param(iwarp_cmt, uint, 0444);
> MODULE_PARM_DESC(iwarp_cmt, "
> > > +iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default:
> > > +Disabled");
> > > +
> >
> > Sorry no, this is totally beneath us.
>=20
> It is not acceptable for RDMA too.

Dave and Leon,=20

This is a bit of a special case related specifically to our hardware.
Enabling iWARP on this kind of configuration impacts L2 performance.
We don't want this to happen implicitly once the rdma driver is loaded sinc=
e
that can happen automatically and could lead to unexpected behavior from us=
er perspective.
Therefore we need a way of giving the user control to decide whether they w=
ant iWARP at the cost
of L2 performance degradation.
We also need this information as soon as the iWARP device registers, so usi=
ng the rdma-tool would be too late.

If module parameter is not an option, could you please advise what would be=
 ok ?=20
ethtool private flags ?=20
devlink ?=20

thanks,
Michal

>=20
> Also please don't use comments inside function calls, it complicates vari=
ous
> checkers without real need.
> dev->ops->iwarp_set_engine_affin(dev->cdev, true /* reset */);
>                                                 ^^^^^^^^^^^^^^ Thanks
