Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1075090A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfFXKg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:36:57 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfFXKg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:36:57 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OAV1Hr029003;
        Mon, 24 Jun 2019 03:36:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=n8xvpJhSHEpJhSQUwHzBWcLEFLx7jkmRurAyQTccSRc=;
 b=QB6sEOeJl48S6JPlzH+awhGqUXkhvNCugwbjPHJC+zkX6+aUPuZNB5lyzBKhL3p+9DKr
 SfX484eudjjuAovScjdpX6ekgYiUW2pGtZnmNkYnMC4ARAMkTSx7INhgJa7TmE/2ERzX
 ug24v1MXND0BQ2050Cy8WSHg9bC07L6bom440ENTwtn9jfFWF0YzFYUFTJ9V5oWZMWJX
 HxPgvI9j1x1BP+7X5GPgU+vib2ik57JGFwxgFLbW0v7Ss/VGt0lJfP0/quXUZGmbnQWB
 ISjB6EXaqGvbp2f/NLozh6dypP4Rw9U0vUlPmd4ohJTzdg2nZLFoRnSgdpLizyp+UXdm cw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t9kujeag4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:36:37 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 24 Jun
 2019 03:36:35 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 24 Jun 2019 03:36:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8xvpJhSHEpJhSQUwHzBWcLEFLx7jkmRurAyQTccSRc=;
 b=OMvTmj45TcvBXn5OHZXJ/5uQBs+R7LQ6GiofCTi/onMq57u+VeokSmQYXbx68ZYwRM4TqzMIhp6JM9KP0DsuHSOheRTG0qZlOr6NfdiuGTRq7luplU5sh5sVhKKg4MYG90anx0RiAdAK5e78kw2BmxbZqI5sdFrDnMV9vJL36Tw=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3230.namprd18.prod.outlook.com (10.255.237.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 10:36:30 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413%3]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 10:36:30 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     Ariel Elior <aelior@marvell.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell
 overflow recovery mechanism for RDMA
Thread-Topic: [EXT] Re: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell
 overflow recovery mechanism for RDMA
Thread-Index: AQHVIcOPS8dQZZiCAk+T2CNQdiy87KamTmsAgABA6RCAAAR7AIAEGdzA
Date:   Mon, 24 Jun 2019 10:36:29 +0000
Message-ID: <MN2PR18MB3182104653BC4373602BE7B9A1E00@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190613083819.6998-1-michal.kalderon@marvell.com>
 <bda0321cb362bc93f5428b1df7daf69fed083656.camel@redhat.com>
 <MN2PR18MB3182498CA8C9C7EB3259F62FA1E70@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190621195818.GY19891@ziepe.ca>
In-Reply-To: <20190621195818.GY19891@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fe59707-26a9-4cc5-d029-08d6f88fd1e1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3230;
x-ms-traffictypediagnostic: MN2PR18MB3230:
x-microsoft-antispam-prvs: <MN2PR18MB32306EEFCF30074B98B6CA67A1E00@MN2PR18MB3230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(39850400004)(366004)(136003)(189003)(51914003)(199004)(486006)(7736002)(74316002)(14454004)(53936002)(478600001)(66946007)(110136005)(11346002)(305945005)(66446008)(26005)(66476007)(25786009)(476003)(229853002)(99286004)(73956011)(6436002)(4326008)(33656002)(446003)(8676002)(55016002)(5660300002)(6506007)(316002)(81156014)(81166006)(54906003)(6246003)(9686003)(2906002)(86362001)(71200400001)(71190400001)(8936002)(76116006)(68736007)(52536014)(256004)(186003)(7696005)(6116002)(14444005)(3846002)(76176011)(66066001)(64756008)(66556008)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3230;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ddOmOGDtGjMG/zP1/7idYfwjaCHesg+qrSnj+49/Wh9Yk1bScK8IK1wfARKybTWWFFd1CrfFOlOp8n2Q9goxzcFTrvwBMNszhaZeMLUMd07ZsGCVz2mhSGXCo9SUyg74Xj6JangTgBK+jmGXKUXXoK78ENwjRs3J59stza1OSaPHQKB95DaY5+y9P+GyJB1vpDH4fnkfbJOXpc8zsgtM3ZqScqP4/WDtyGMSr6bvae8enB78I7UsdlViheIiIhsyoN8IxGH/4mxUJLHLF+bILWmcq98jEBwBqrwSMQqmdV/mLl0wTZLl5WktcGAHD40bfE525ZkpvKRx/LSMMKylmHt4n0q/8Sct3DuFSpA4/J6LcCP9tJVIEOOzUkzuQA/mBwNVtsq9UKD0hguQ3gvA1m2Kni53e53fsqq3cfN0sA0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe59707-26a9-4cc5-d029-08d6f88fd1e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 10:36:30.2353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3230
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, June 21, 2019 10:58 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Fri, Jun 21, 2019 at 07:49:39PM +0000, Michal Kalderon wrote:
> > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > owner@vger.kernel.org> On Behalf Of Doug Ledford
> > >
> > > On Thu, 2019-06-13 at 11:38 +0300, Michal Kalderon wrote:
> > > > This patch series used the doorbell overflow recovery mechanism
> > > > introduced in commit 36907cd5cd72 ("qed: Add doorbell overflow
> > > > recovery mechanism") for rdma ( RoCE and iWARP )
> > > >
> > > > rdma-core pull request #493
> > > >
> > > > Changes from V2:
> > > > - Don't use long-lived kmap. Instead use user-trigger mmap for the
> > > >   doorbell recovery entries.
> > > > - Modify dpi_addr to be denoted with __iomem and avoid redundant
> > > >   casts
> > > >
> > > > Changes from V1:
> > > > - call kmap to map virtual address into kernel space
> > > > - modify db_rec_delete to be void
> > > > - remove some cpu_to_le16 that were added to previous patch which
> are
> > > >   correct but not related to the overflow recovery mechanism. Will =
be
> > > >   submitted as part of a different patch
> > > >
> > > >
> > > > Michal Kalderon (3):
> > > >   qed*: Change dpi_addr to be denoted with __iomem
> > > >   RDMA/qedr: Add doorbell overflow recovery support
> > > >   RDMA/qedr: Add iWARP doorbell recovery support
> > > >
> > > >  drivers/infiniband/hw/qedr/main.c          |   2 +-
> > > >  drivers/infiniband/hw/qedr/qedr.h          |  27 +-
> > > >  drivers/infiniband/hw/qedr/verbs.c         | 387
> > > > ++++++++++++++++++++++++-----
> > > >  drivers/net/ethernet/qlogic/qed/qed_rdma.c |   6 +-
> > > >  include/linux/qed/qed_rdma_if.h            |   2 +-
> > > >  include/uapi/rdma/qedr-abi.h               |  25 ++
> > > >  6 files changed, 378 insertions(+), 71 deletions(-)
> > > >
> > >
> > > Hi Michal,
> > >
> > > In patch 2 and 3 both, you still have quite a few casts to (u8 __iome=
m *).
> > > Why not just define the struct elements as u8 __iomem * instead of
> > > void __iomem * and avoid all the casts?
> > >
> > Hi Doug,
> >
> > Thanks for the review. The remaining casts are due to pointer
> > arithmetic and not variable assignments as before. Removing the cast
> > entirely will require quite a lot of changes in qed and in rdma-core wh=
ich I
> would be happy to avoid at this time.
>=20
> In linux pointer math on a void * acts the same as a u8 so you should nev=
er
> need to cast a void * to a u8 just to do math?
>=20
Ok, thanks. Sent v4.
Michal

> Jason

