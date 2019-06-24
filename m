Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED4450A24
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfFXLvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:51:13 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:54703
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729420AbfFXLvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 07:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7EjxQ/r6Gf2Vi5odnlicPIzOBs9H8jQwPllBzWyYb4=;
 b=sdRcAC3MxaB3KJ0WOe2KB7SO+arFPNuxQ8rWqj11f+XjPLGXZEdBPrV/NfK1EKi08Mzx///Y0brwiCoAyi5zC5Y2J13b0Sj54L0LUGmoFpdX3bfwPPPSKbmB+x3c1AdTOjLqDeDORGu7wrqlbl5974xsSL32zfSzkprzL6EqpTE=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5485.eurprd05.prod.outlook.com (20.177.63.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 11:51:03 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 11:51:03 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
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
Thread-Index: AQHVJfmIbRVZTelD0EOIZCO31FHay6aqujqA
Date:   Mon, 24 Jun 2019 11:51:03 +0000
Message-ID: <20190624115059.GA5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-9-leon@kernel.org>
In-Reply-To: <20190618171540.11729-9-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR08CA0085.namprd08.prod.outlook.com
 (2603:10b6:404:b6::23) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [209.213.91.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ad3475f-7e89-4f60-a3f1-08d6f89a3be5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5485;
x-ms-traffictypediagnostic: VI1PR05MB5485:
x-microsoft-antispam-prvs: <VI1PR05MB54852BD6EBB290DA4DDD6ECFCFE00@VI1PR05MB5485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(346002)(136003)(396003)(199004)(189003)(5660300002)(478600001)(6506007)(53936002)(33656002)(2616005)(6486002)(81156014)(86362001)(3846002)(256004)(8676002)(81166006)(7736002)(229853002)(2906002)(446003)(66446008)(11346002)(68736007)(66476007)(6916009)(486006)(66556008)(36756003)(71190400001)(71200400001)(476003)(73956011)(99286004)(64756008)(66946007)(54906003)(76176011)(102836004)(6512007)(1076003)(52116002)(386003)(25786009)(6116002)(6246003)(6436002)(316002)(66066001)(14454004)(4326008)(8936002)(186003)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5485;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MeUUxXbbw3osjwlN4IkbuMhrdO3XzfzDfBIDJyhb4v0LxwKWEknIpuGWfLu4Bn8fsqNdByPJRPeZDycTcfQ5u8+QxABC/f3Pda+GHGgU9kVlmQsmNn0qwndxMbIQmWduJMhxGiev+WcOfUXezIglY9i//76QpB5mdxYVTh7fc0Ged85NuUivDOJjLSNSaQBAfB8UlKYDl/60qUXcPEwyr/HW/yZsB+2s2dWM7H7xfyQDGozbp8vlifJFsgwaBr551qjcK+eNc3Pew+9mnllZrxYjwSPVYv3buU9/HRM7wUnLq/QW9agPypJN8GcNjg8PpOLRys2E9hi2TtdNaT83UlQRI7/GjJhEl7pcO5sjB+fzTmwhMex75J0KvHh5a5fXJofeWiO3aAKYkoy6lphLTZuz5haOm9/wwh7Qn9SuLJs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <05B2F1E9CF684640A4D5B2CDC86F9823@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad3475f-7e89-4f60-a3f1-08d6f89a3be5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 11:51:03.5599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:36PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
> implementation.
>=20
> This object is from type class FD and will be used to read DEVX
> async events.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c         | 112 ++++++++++++++++++++--
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 ++
>  include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
>  3 files changed, 116 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index 80b42d069328..1815ce0f8daf 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -33,6 +33,24 @@ struct devx_async_data {
>  	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>  };
> =20
> +struct devx_async_event_queue {

It seems to be a mistake to try and re-use the async_event_queue for
both cmd and event, as they use it very differently and don't even
store the same things in the event_list. I think it is bettter to just
inline this into devx_async_event_file (and inline the old struct in
the cmd file

> +	spinlock_t		lock;
> +	wait_queue_head_t	poll_wait;
> +	struct list_head	event_list;
> +	atomic_t		bytes_in_use;
> +	u8			is_destroyed:1;
> +	u32			flags;
> +};

All the flags testing is ugly, why not just add another bitfield?

> +
> +struct devx_async_event_file {
> +	struct ib_uobject		uobj;
> +	struct list_head subscribed_events_list; /* Head of events that are
> +						  * subscribed to this FD
> +						  */
> +	struct devx_async_event_queue	ev_queue;
> +	struct mlx5_ib_dev *dev;
> +};
> +

Crazy indenting

> diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdm=
a/mlx5_user_ioctl_verbs.h
> index a8f34c237458..57beea4589e4 100644
> +++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
> @@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
>  	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
>  };
> =20
> +enum mlx5_ib_uapi_devx_create_event_channel_flags {
> +	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA =3D 1
> << 0,

Maybe this name is too long

Jason
