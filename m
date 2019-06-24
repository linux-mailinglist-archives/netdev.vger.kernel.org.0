Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1A450E0B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFXOa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:30:27 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:63591
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbfFXOa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 10:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCmyGIYHMIPe32FIAvv283iZUKVBPbIp4xb/mOs+UEE=;
 b=hTWQmoIPM3nVxvwjiYV+w60VvzuPA6quC5p1U9i44TwKRnx5lTDFaZ/tO1FzmCQNwN7id9TvF9b0vc17/5/8WA0tv3oWRuvm7XqnTnO+9jLo7Mh2zIfWL0MkDo1O8qYbZE4tan/MY1WPmctVIY5R9EhTfLI4pmcRVAwYYP8OjIc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5375.eurprd05.prod.outlook.com (20.178.8.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 14:30:20 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 14:30:20 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 08/12] IB/mlx5: Introduce
 MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
Thread-Topic: [PATCH rdma-next v1 08/12] IB/mlx5: Introduce
 MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
Thread-Index: AQHVJfmIbRVZTelD0EOIZCO31FHay6aqujqAgAAacYCAABIQAA==
Date:   Mon, 24 Jun 2019 14:30:19 +0000
Message-ID: <20190624143016.GC7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-9-leon@kernel.org> <20190624115059.GA5479@mellanox.com>
 <baae74b9-94ff-9f5a-0992-c1eec5049306@dev.mellanox.co.il>
In-Reply-To: <baae74b9-94ff-9f5a-0992-c1eec5049306@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0002.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::15) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 070ce8c0-7cf4-4716-c546-08d6f8b07be7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5375;
x-ms-traffictypediagnostic: VI1PR05MB5375:
x-microsoft-antispam-prvs: <VI1PR05MB5375E58ACCCE5791A0A1D260CFE00@VI1PR05MB5375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(189003)(199004)(7736002)(33656002)(86362001)(53936002)(446003)(99286004)(6246003)(6512007)(316002)(76176011)(486006)(53546011)(386003)(6506007)(6436002)(66066001)(26005)(6486002)(25786009)(229853002)(8676002)(2616005)(476003)(4326008)(102836004)(8936002)(6862004)(81156014)(68736007)(81166006)(2906002)(186003)(54906003)(52116002)(5660300002)(11346002)(3846002)(14454004)(478600001)(36756003)(71190400001)(256004)(6116002)(66446008)(1076003)(73956011)(66476007)(66946007)(66556008)(64756008)(71200400001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5375;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AB2DheajiG01OD3srnRS+EDl5Bdgd3NMoGdSOsfOb43yTu2wxx4wkq7OyBWt7AWnOf226C5zldWKHpB2iFZt2BH9uRtLlbret88b0jyTO4wj/RWMqGdJ2niZpw+JYvUomgwn4rLbJWzZsW0aZuwMpIAent97BiyplnBue7pkWa/+svRfrbzYY4HLkJHnejkfF5D0VumLsengKnU6y9PJ0vFAi0xZnQNeXF+PWi9REpQuZGsqWIjM85qlDSi/rKGh8BejrMazVIj4GGic3o/CIuIlE7V/Z2IiGqtcRZmJgvQpX2itHXHGBXDfL2uOv3pZZrU9ZhYmrAorYJG31aQX4zXK7dcpFxzOoAVAzHw4YYwsY8bgSgIYiLmaBfa/e/f95VmtjZfIn7PCk4srfyQa+QAMHo7YeHBI+Jykj63g2zE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5E69717CEF56D4CA091E76CCD5397A4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 070ce8c0-7cf4-4716-c546-08d6f8b07be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 14:30:20.0171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 04:25:37PM +0300, Yishai Hadas wrote:
> On 6/24/2019 2:51 PM, Jason Gunthorpe wrote:
> > On Tue, Jun 18, 2019 at 08:15:36PM +0300, Leon Romanovsky wrote:
> > > From: Yishai Hadas <yishaih@mellanox.com>
> > >=20
> > > Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
> > > implementation.
> > >=20
> > > This object is from type class FD and will be used to read DEVX
> > > async events.
> > >=20
> > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >   drivers/infiniband/hw/mlx5/devx.c         | 112 +++++++++++++++++++=
+--
> > >   include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 ++
> > >   include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
> > >   3 files changed, 116 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/h=
w/mlx5/devx.c
> > > index 80b42d069328..1815ce0f8daf 100644
> > > +++ b/drivers/infiniband/hw/mlx5/devx.c
> > > @@ -33,6 +33,24 @@ struct devx_async_data {
> > >   	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
> > >   };
> > > +struct devx_async_event_queue {
> >=20
> > It seems to be a mistake to try and re-use the async_event_queue for
> > both cmd and event, as they use it very differently and don't even
> > store the same things in the event_list. I think it is bettter to just
> > inline this into devx_async_event_file (and inline the old struct in
> > the cmd file
> >=20
>=20
> How about having another struct with all the event's queue fields togethe=
r ?
> this has the benefit of having all those related fields in one place and
> leave the cmd as is.
>=20
> Alternatively,
> We can inline the event stuff under devx_async_event_file and leave the c=
md
> for now under a struct as it's not directly related to this series.

I would probbaly do this

> > > +	spinlock_t		lock;
> > > +	wait_queue_head_t	poll_wait;
> > > +	struct list_head	event_list;
> > > +	atomic_t		bytes_in_use;
> > > +	u8			is_destroyed:1;
> > > +	u32			flags;
> > > +};
> >=20
> > All the flags testing is ugly, why not just add another bitfield?
>=20
> The flags are coming from user space and have their different name space,=
 I
> prefer to not mix with kernel ones. (i.e. is_destroyed).
> Makes sense ?

No, better to add a bitfield than store the raw flags and another
bitfield.

> > > diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi=
/rdma/mlx5_user_ioctl_verbs.h
> > > index a8f34c237458..57beea4589e4 100644
> > > +++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
> > > @@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
> > >   	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
> > >   };
> > > +enum mlx5_ib_uapi_devx_create_event_channel_flags {
> > > +	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA =3D 1
> > > << 0,
> >=20
> > Maybe this name is too long
>=20
> Quite long but follows the name scheme having the UAPI prefix.
> Any shorter suggestion ?
>=20

I think you should shorten it

Jason
