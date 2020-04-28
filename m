Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9A1BBB98
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgD1Kv5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Apr 2020 06:51:57 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2495 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726312AbgD1Kv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 06:51:57 -0400
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 220E78CC23D9F9AAD746;
        Tue, 28 Apr 2020 18:51:55 +0800 (CST)
Received: from DGGEML522-MBX.china.huawei.com ([169.254.7.242]) by
 DGGEML403-HUB.china.huawei.com ([fe80::74d9:c659:fbec:21fa%31]) with mapi id
 14.03.0487.000; Tue, 28 Apr 2020 18:51:49 +0800
From:   liweihang <liweihang@huawei.com>
To:     Maor Gottlieb <maorg@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     "leonro@mellanox.com" <leonro@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexr@mellanox.com" <alexr@mellanox.com>
Subject: Re: [PATCH V6 mlx5-next 10/16] RDMA: Group create AH arguments in
 struct
Thread-Topic: [PATCH V6 mlx5-next 10/16] RDMA: Group create AH arguments in
 struct
Thread-Index: AQHWG5rRRKUqmf6UlE2jdAl/Mf/zJg==
Date:   Tue, 28 Apr 2020 10:51:49 +0000
Message-ID: <B82435381E3B2943AA4D2826ADEF0B3A0232A2C8@DGGEML522-MBX.china.huawei.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-11-maorg@mellanox.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.40.168.149]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/26 15:18, Maor Gottlieb wrote:
> Following patch adds additional argument to the create AH function,
> so it make sense to group ah_attr and flags arguments in struct.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> ---
>  drivers/infiniband/core/verbs.c                 |  5 ++++-
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c        |  8 +++++---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.h        |  2 +-
>  drivers/infiniband/hw/efa/efa.h                 |  3 +--
>  drivers/infiniband/hw/efa/efa_verbs.c           |  6 +++---
>  drivers/infiniband/hw/hns/hns_roce_ah.c         |  5 +++--
>  drivers/infiniband/hw/hns/hns_roce_device.h     |  4 ++--
>  drivers/infiniband/hw/mlx4/ah.c                 | 11 +++++++----
>  drivers/infiniband/hw/mlx4/mlx4_ib.h            |  2 +-
>  drivers/infiniband/hw/mlx5/ah.c                 |  5 +++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h            |  2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c    |  9 +++++----
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  3 ++-
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h        |  2 +-
>  drivers/infiniband/hw/qedr/verbs.c              |  4 ++--
>  drivers/infiniband/hw/qedr/verbs.h              |  2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  5 +++--
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h |  2 +-
>  drivers/infiniband/sw/rdmavt/ah.c               | 11 ++++++-----
>  drivers/infiniband/sw/rdmavt/ah.h               |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_verbs.c           |  9 +++++----
>  include/rdma/ib_verbs.h                         |  9 +++++++--
>  22 files changed, 66 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 3bfadd8effcc..86be8a54a2d6 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -502,6 +502,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  				     u32 flags,
>  				     struct ib_udata *udata)
>  {
> +	struct rdma_ah_init_attr init_attr = {};
>  	struct ib_device *device = pd->device;
>  	struct ib_ah *ah;
>  	int ret;
> @@ -521,8 +522,10 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  	ah->pd = pd;
>  	ah->type = ah_attr->type;
>  	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
> +	init_attr.ah_attr = ah_attr;
> +	init_attr.flags = flags;
>  
> -	ret = device->ops.create_ah(ah, ah_attr, flags, udata);
> +	ret = device->ops.create_ah(ah, &init_attr, udata);
>  	if (ret) {
>  		kfree(ah);
>  		return ERR_PTR(ret);
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> index d98348e82422..5a7c090204c5 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -631,11 +631,12 @@ static u8 bnxt_re_stack_to_dev_nw_type(enum rdma_network_type ntype)
>  	return nw_type;
>  }
>  
> -int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
> -		      u32 flags, struct ib_udata *udata)
> +int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_init_attr *init_attr,
> +		      struct ib_udata *udata)
>  {
>  	struct ib_pd *ib_pd = ib_ah->pd;
>  	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
>  	struct bnxt_re_dev *rdev = pd->rdev;
>  	const struct ib_gid_attr *sgid_attr;
> @@ -673,7 +674,8 @@ int bnxt_re_create_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr,
>  
>  	memcpy(ah->qplib_ah.dmac, ah_attr->roce.dmac, ETH_ALEN);
>  	rc = bnxt_qplib_create_ah(&rdev->qplib_res, &ah->qplib_ah,
> -				  !(flags & RDMA_CREATE_AH_SLEEPABLE));
> +				  !(init_attr->flags &
> +				    RDMA_CREATE_AH_SLEEPABLE));
>  	if (rc) {
>  		ibdev_err(&rdev->ibdev, "Failed to allocate HW AH");
>  		return rc;
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> index 18dd46f46cf4..204c0849ba28 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
> @@ -170,7 +170,7 @@ enum rdma_link_layer bnxt_re_get_link_layer(struct ib_device *ibdev,
>  					    u8 port_num);
>  int bnxt_re_alloc_pd(struct ib_pd *pd, struct ib_udata *udata);
>  void bnxt_re_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata);
> -int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr, u32 flags,
> +int bnxt_re_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
>  		      struct ib_udata *udata);
>  int bnxt_re_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
>  int bnxt_re_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
> diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
> index aa7396a1588a..45d519edb4c3 100644
> --- a/drivers/infiniband/hw/efa/efa.h
> +++ b/drivers/infiniband/hw/efa/efa.h
> @@ -153,8 +153,7 @@ int efa_mmap(struct ib_ucontext *ibucontext,
>  	     struct vm_area_struct *vma);
>  void efa_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
>  int efa_create_ah(struct ib_ah *ibah,
> -		  struct rdma_ah_attr *ah_attr,
> -		  u32 flags,
> +		  struct rdma_ah_init_attr *init_attr,
>  		  struct ib_udata *udata);
>  void efa_destroy_ah(struct ib_ah *ibah, u32 flags);
>  int efa_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
> index 5c57098a4aee..454b01b21e6a 100644
> --- a/drivers/infiniband/hw/efa/efa_verbs.c
> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
> @@ -1639,10 +1639,10 @@ static int efa_ah_destroy(struct efa_dev *dev, struct efa_ah *ah)
>  }
>  
>  int efa_create_ah(struct ib_ah *ibah,
> -		  struct rdma_ah_attr *ah_attr,
> -		  u32 flags,
> +		  struct rdma_ah_init_attr *init_attr,
>  		  struct ib_udata *udata)
>  {
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	struct efa_dev *dev = to_edev(ibah->device);
>  	struct efa_com_create_ah_params params = {};
>  	struct efa_ibv_create_ah_resp resp = {};
> @@ -1650,7 +1650,7 @@ int efa_create_ah(struct ib_ah *ibah,
>  	struct efa_ah *ah = to_eah(ibah);
>  	int err;
>  
> -	if (!(flags & RDMA_CREATE_AH_SLEEPABLE)) {
> +	if (!(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE)) {
>  		ibdev_dbg(&dev->ibdev,
>  			  "Create address handle is not supported in atomic context\n");
>  		err = -EOPNOTSUPP;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
> index 8a522e14ef62..5b2f9314edd3 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_ah.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
> @@ -39,13 +39,14 @@
>  #define HNS_ROCE_VLAN_SL_BIT_MASK	7
>  #define HNS_ROCE_VLAN_SL_SHIFT		13
>  
> -int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr,
> -		       u32 flags, struct ib_udata *udata)
> +int hns_roce_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
> +		       struct ib_udata *udata)
>  {
>  	struct hns_roce_dev *hr_dev = to_hr_dev(ibah->device);
>  	const struct ib_gid_attr *gid_attr;
>  	struct device *dev = hr_dev->dev;
>  	struct hns_roce_ah *ah = to_hr_ah(ibah);
> +	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
>  	const struct ib_global_route *grh = rdma_ah_read_grh(ah_attr);
>  	u16 vlan_id = 0xffff;
>  	bool vlan_en = false;
> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> index f6b3cf6b95d6..74ef3f0b8b5a 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -1171,8 +1171,8 @@ void hns_roce_bitmap_free_range(struct hns_roce_bitmap *bitmap,
>  				unsigned long obj, int cnt,
>  				int rr);
>  
> -int hns_roce_create_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr,
> -		       u32 flags, struct ib_udata *udata);
> +int hns_roce_create_ah(struct ib_ah *ah, struct rdma_ah_init_attr *init_attr,
> +		       struct ib_udata *udata);
>  int hns_roce_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
>  void hns_roce_destroy_ah(struct ib_ah *ah, u32 flags);
> 
It's ok for the hns part, thank you.

Acked-by: Weihang Li <liweihang@huawei.com>
