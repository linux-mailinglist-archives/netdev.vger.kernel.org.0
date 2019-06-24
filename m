Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9E3F50A46
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfFXL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:57:36 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:61713
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfFXL5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 07:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVzoeg0jOo686WM1nVS4BzpjlTu2pFUFyO7tTWvmzx4=;
 b=iB3qjmnLb96gMi4hdp/gtDvgGPao2fcSxc3Ge3170OeByADIeAU+txgZfV266lJOhQB4q1jds6pdsDxLnlPkiMJKkNOlMy9eScq+b0p+Lr4qf9gwBwwP9wcgpPRLX01jTQSnJ1L5oP4CaD97FXkULsozh3J2dEgubTNreyYn26k=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5485.eurprd05.prod.outlook.com (20.177.63.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 11:57:31 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 11:57:31 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
Thread-Topic: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
Thread-Index: AQHVJfmLnHTD8lu5y0Ka9qPSVWhC9qaqvAcA
Date:   Mon, 24 Jun 2019 11:57:30 +0000
Message-ID: <20190624115726.GC5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-11-leon@kernel.org>
In-Reply-To: <20190618171540.11729-11-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN8PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:408:d4::16) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [209.213.91.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e11249c-070b-46b6-c7fc-08d6f89b22ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5485;
x-ms-traffictypediagnostic: VI1PR05MB5485:
x-microsoft-antispam-prvs: <VI1PR05MB5485547DF7B944BB4E0A7C3BCFE00@VI1PR05MB5485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(376002)(346002)(136003)(396003)(199004)(189003)(5660300002)(478600001)(6506007)(53936002)(33656002)(2616005)(6486002)(81156014)(86362001)(14444005)(3846002)(256004)(8676002)(81166006)(7736002)(229853002)(2906002)(446003)(66446008)(11346002)(68736007)(66476007)(6916009)(486006)(66556008)(36756003)(71190400001)(71200400001)(476003)(73956011)(99286004)(64756008)(66946007)(54906003)(76176011)(102836004)(6512007)(1076003)(52116002)(386003)(25786009)(6116002)(6246003)(6436002)(316002)(66066001)(14454004)(4326008)(8936002)(186003)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5485;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IOtLMmFr/7U444KakDMPxogyeBQTxfIx4kV6CWyYYMweLT4nf9WeC1HlDzAUwqaUkk9BZp6dfUBPfFL22Gqfrmy9F7t9bBc8gnRbEqIvXYXm/dbuHBge4/js5heuU7lZSLODXQfuoNUNmhSVJMzATmjuOFZkgFI5PJ+iBSHC/m+FhktGvKdVx0y1+aWBVRm0o4yvYXfP/EN1+IVcP+DjAt/xKqYfUJDLBcWgvEfgU+0/adCRdb0I/XPfXXh4AjtHGDBxFz23Aw+858RVJnBraN9ThZn2nPHO19lBd1Ar3L8wbEoLzRNl6uGNcdpTESjrC4G3smtmvIbNdIr5pQjR/G3oW7r5rXU15nfiP3Z0UON1WVmGwibPL1/lRDvIm+86/aSyucDRmUOC5f6p6hI9zz37vVHM6YX9blq9nC7Lvb4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F5EC55C88074348AAFD397569645995@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e11249c-070b-46b6-c7fc-08d6f89b22ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 11:57:30.8985
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

On Tue, Jun 18, 2019 at 08:15:38PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Enable subscription for device events over DEVX.
>=20
> Each subscription is added to the two level XA data structure according
> to its event number and the DEVX object information in case was given
> with the given target fd.
>=20
> Those events will be reported over the given fd once will occur.
> Downstream patches will mange the dispatching to any subscription.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c        | 564 ++++++++++++++++++++++-
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h |   9 +
>  2 files changed, 566 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index e9b9ba5a3e9a..304b13e7a265 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -14,6 +14,7 @@
>  #include <linux/mlx5/driver.h>
>  #include <linux/mlx5/fs.h>
>  #include "mlx5_ib.h"
> +#include <linux/xarray.h>
> =20
>  #define UVERBS_MODULE_NAME mlx5_ib
>  #include <rdma/uverbs_named_ioctl.h>
> @@ -33,6 +34,37 @@ struct devx_async_data {
>  	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>  };
> =20
> +/* first level XA value data structure */
> +struct devx_event {
> +	struct xarray object_ids; /* second XA level, Key =3D object id */
> +	struct list_head unaffiliated_list;
> +};
> +
> +/* second level XA value data structure */
> +struct devx_obj_event {
> +	struct rcu_head rcu;
> +	struct list_head obj_sub_list;
> +};
> +
> +struct devx_event_subscription {
> +	struct list_head file_list; /* headed in private_data->
> +				     * subscribed_events_list
> +				     */
> +	struct list_head xa_list; /* headed in devx_event->unaffiliated_list or
> +				   * devx_obj_event->obj_sub_list
> +				   */
> +	struct list_head obj_list; /* headed in devx_object */
> +
> +	u32 xa_key_level1;
> +	u32 xa_key_level2;
> +	struct rcu_head	rcu;
> +	u64 cookie;
> +	bool is_obj_related;
> +	struct ib_uobject *fd_uobj;
> +	void *object;	/* May need direct access upon hot unplug */

This should be a 'struct file *' and have a better name.

And I'm unclear why we need to store both the ib_uobject and the
struct file for the same thing? And why are we storing the uobj here
instead of the struct devx_async_event_file *?

Since uobj->object =3D=3D flip && filp->private_data =3D=3D uobj, I have a
hard time to understand why we need both things, it seems to me that
if we get the fget on the filp then we can rely on the
filp->private_data to get back to the devx_async_event_file.

> +	struct eventfd_ctx *eventfd;
> +};
> +

>  /*
>   * As the obj_id in the firmware is not globally unique the object type
>   * must be considered upon checking for a valid object id.
> @@ -1143,14 +1275,53 @@ static void devx_cleanup_mkey(struct devx_obj *ob=
j)
>  	write_unlock_irqrestore(&table->lock, flags);
>  }
> =20
> +static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
> +				      struct devx_event_subscription *sub)
> +{
> +	list_del_rcu(&sub->file_list);
> +	list_del_rcu(&sub->xa_list);
> +
> +	if (sub->is_obj_related) {

is_obj_related looks like it is just list_empty(obj_list)??

Success oriented flow

> @@ -1523,6 +1700,350 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ=
_ASYNC_QUERY)(
>  	return err;
>  }
> =20
> +static void
> +subscribe_event_xa_dealloc(struct mlx5_devx_event_table *devx_event_tabl=
e,
> +			   u32 key_level1,
> +			   u32 key_level2,
> +			   struct devx_obj_event *alloc_obj_event)
> +{
> +	struct devx_event *event;
> +
> +	/* Level 1 is valid for future use - no need to free */
> +	if (!alloc_obj_event)
> +		return;
> +
> +	event =3D xa_load(&devx_event_table->event_xa, key_level1);
> +	WARN_ON(!event);
> +
> +	xa_erase(&event->object_ids, key_level2);

Shoulnd't this only erase if the value stored is NULL?

> +	kfree(alloc_obj_event);
> +}
> +
> +static int
> +subscribe_event_xa_alloc(struct mlx5_devx_event_table *devx_event_table,
> +			 u32 key_level1,
> +			 bool is_level2,
> +			 u32 key_level2,
> +			 struct devx_obj_event **alloc_obj_event)
> +{
> +	struct devx_obj_event *obj_event;
> +	struct devx_event *event;
> +	bool new_entry_level1 =3D false;
> +	int err;
> +
> +	event =3D xa_load(&devx_event_table->event_xa, key_level1);
> +	if (!event) {
> +		event =3D kzalloc(sizeof(*event), GFP_KERNEL);
> +		if (!event)
> +			return -ENOMEM;
> +
> +		new_entry_level1 =3D true;
> +		INIT_LIST_HEAD(&event->unaffiliated_list);
> +		xa_init(&event->object_ids);
> +
> +		err =3D xa_insert(&devx_event_table->event_xa,
> +				key_level1,
> +				event,
> +				GFP_KERNEL);
> +		if (err)
> +			goto end;
> +	}
> +
> +	if (!is_level2)
> +		return 0;
> +
> +	obj_event =3D xa_load(&event->object_ids, key_level2);
> +	if (!obj_event) {
> +		err =3D xa_reserve(&event->object_ids, key_level2, GFP_KERNEL);
> +		if (err)
> +			goto err_level1;
> +
> +		obj_event =3D kzalloc(sizeof(*obj_event), GFP_KERNEL);
> +		if (!obj_event) {
> +			err =3D -ENOMEM;
> +			goto err_level2;
> +		}
> +
> +		INIT_LIST_HEAD(&obj_event->obj_sub_list);
> +		*alloc_obj_event =3D obj_event;

This is goofy, just store the empty obj_event in the xa instead of
using xa_reserve, and when you go to do the error unwind just delete
any level2' devx_obj_event' that has a list_empty(obj_sub_list), get
rid of the wonky alloc_obj_event stuff.

The best configuration would be to use devx_cleanup_subscription to
undo the partially ready subscription.

> +	}
> +
> +	return 0;
> +
> +err_level2:
> +	xa_erase(&event->object_ids, key_level2);
> +
> +err_level1:
> +	if (new_entry_level1)
> +		xa_erase(&devx_event_table->event_xa, key_level1);
> +end:
> +	if (new_entry_level1)
> +		kfree(event);

Can't do this, once the level1 is put in the tree it could be referenced by
the irqs. At least it needs a kfree_rcu, most likely it is simpler to
just leave it.

> +#define MAX_NUM_EVENTS 16
> +static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
> +	struct uverbs_attr_bundle *attrs)
> +{
> +	struct ib_uobject *devx_uobj =3D uverbs_attr_get_uobject(
> +				attrs,
> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_OBJ_HANDLE);
> +	struct mlx5_ib_ucontext *c =3D rdma_udata_to_drv_context(
> +		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
> +	struct mlx5_ib_dev *dev =3D to_mdev(c->ibucontext.device);
> +	struct ib_uobject *fd_uobj;
> +	struct devx_obj *obj =3D NULL;
> +	struct devx_async_event_file *ev_file;
> +	struct mlx5_devx_event_table *devx_event_table =3D &dev->devx_event_tab=
le;
> +	u16 *event_type_num_list;
> +	struct devx_event_subscription **event_sub_arr;
> +	struct devx_obj_event  **event_obj_array_alloc;
> +	int redirect_fd;
> +	bool use_eventfd =3D false;
> +	int num_events;
> +	int num_alloc_xa_entries =3D 0;
> +	u16 obj_type =3D 0;
> +	u64 cookie =3D 0;
> +	u32 obj_id =3D 0;
> +	int err;
> +	int i;
> +
> +	if (!c->devx_uid)
> +		return -EINVAL;
> +
> +	if (!IS_ERR(devx_uobj)) {
> +		obj =3D (struct devx_obj *)devx_uobj->object;
> +		if (obj)
> +			obj_id =3D get_dec_obj_id(obj->obj_id);
> +	}
> +
> +	fd_uobj =3D uverbs_attr_get_uobject(attrs,
> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_HANDLE);
> +	if (IS_ERR(fd_uobj))
> +		return PTR_ERR(fd_uobj);
> +
> +	ev_file =3D container_of(fd_uobj, struct devx_async_event_file,
> +			       uobj);
> +
> +	if (uverbs_attr_is_valid(attrs,
> +				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM)) {
> +		err =3D uverbs_copy_from(&redirect_fd, attrs,
> +			       MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_FD_NUM);
> +		if (err)
> +			return err;
> +
> +		use_eventfd =3D true;
> +	}
> +
> +	if (uverbs_attr_is_valid(attrs,
> +				 MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE)) {
> +		if (use_eventfd)
> +			return -EINVAL;
> +
> +		err =3D uverbs_copy_from(&cookie, attrs,
> +				MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_COOKIE);
> +		if (err)
> +			return err;
> +	}
> +
> +	num_events =3D uverbs_attr_ptr_get_array_size(
> +		attrs, MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST,
> +		sizeof(u16));
> +
> +	if (num_events < 0)
> +		return num_events;
> +
> +	if (num_events > MAX_NUM_EVENTS)
> +		return -EINVAL;
> +
> +	event_type_num_list =3D uverbs_attr_get_alloced_ptr(attrs,
> +			MLX5_IB_ATTR_DEVX_SUBSCRIBE_EVENT_TYPE_NUM_LIST);
> +
> +	if (!is_valid_events(dev->mdev, num_events, event_type_num_list, obj))
> +		return -EINVAL;
> +
> +	event_sub_arr =3D uverbs_zalloc(attrs,
> +		MAX_NUM_EVENTS * sizeof(struct devx_event_subscription *));
> +	event_obj_array_alloc =3D uverbs_zalloc(attrs,
> +		MAX_NUM_EVENTS * sizeof(struct devx_obj_event *));

There are so many list_heads in the devx_event_subscription, why not
use just one of them to store the allocated events instead of this
temp array? ie event_list looks good for this purpose.

> +
> +	if (!event_sub_arr || !event_obj_array_alloc)
> +		return -ENOMEM;
> +
> +	/* Protect from concurrent subscriptions to same XA entries to allow
> +	 * both to succeed
> +	 */
> +	mutex_lock(&devx_event_table->event_xa_lock);
> +	for (i =3D 0; i < num_events; i++) {
> +		u32 key_level1;
> +
> +		if (obj)
> +			obj_type =3D get_dec_obj_type(obj,
> +						    event_type_num_list[i]);
> +		key_level1 =3D event_type_num_list[i] | obj_type << 16;
> +
> +		err =3D subscribe_event_xa_alloc(devx_event_table,
> +					       key_level1,
> +					       obj ? true : false,
> +					       obj_id,
> +					       &event_obj_array_alloc[i]);

Usless ?:

> +		if (err)
> +			goto err;
> +
> +		num_alloc_xa_entries++;
> +		event_sub_arr[i] =3D kzalloc(sizeof(*event_sub_arr[i]),
> +					   GFP_KERNEL);
> +		if (!event_sub_arr[i])
> +			goto err;
> +
> +		if (use_eventfd) {
> +			event_sub_arr[i]->eventfd =3D
> +				eventfd_ctx_fdget(redirect_fd);
> +
> +			if (IS_ERR(event_sub_arr[i]->eventfd)) {
> +				err =3D PTR_ERR(event_sub_arr[i]->eventfd);
> +				event_sub_arr[i]->eventfd =3D NULL;
> +				goto err;
> +			}
> +		}
> +
> +		event_sub_arr[i]->cookie =3D cookie;
> +		event_sub_arr[i]->fd_uobj =3D fd_uobj;
> +		event_sub_arr[i]->object =3D fd_uobj->object;
> +		/* May be needed upon cleanup the devx object/subscription */
> +		event_sub_arr[i]->xa_key_level1 =3D key_level1;
> +		event_sub_arr[i]->xa_key_level2 =3D obj_id;
> +		event_sub_arr[i]->is_obj_related =3D obj ? true : false;

Unneeded ?:


Jason
