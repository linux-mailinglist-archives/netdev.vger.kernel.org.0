Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35D72A3D37
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 08:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgKCHLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 02:11:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19738 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgKCHK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 02:10:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa102830000>; Mon, 02 Nov 2020 23:10:59 -0800
Received: from [172.27.13.204] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 07:10:51 +0000
Subject: Re: [PATCH mlx5-next v1 11/11] RDMA/mlx5: Remove IB representors dead
 code
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <broonie@kernel.org>, "David S . Miller" <davem@davemloft.net>,
        <ranjani.sridharan@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>, <fred.oh@linux.intel.com>,
        <shiraz.saleem@intel.com>, <dan.j.williams@intel.com>,
        <kiran.patil@intel.com>, <linux-kernel@vger.kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-12-leon@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <845b26c8-4dfa-5ef2-67a8-1ae6f556fd71@nvidia.com>
Date:   Tue, 3 Nov 2020 09:10:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101201542.2027568-12-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604387459; bh=4WUhWdFgickYDSVFf73IeSlsegDSnCyqJHXLcImggck=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=Dah3vnxqaguW+nzDWpLeyjsmEMHzddxz/bOE8aJ2quo8SYWhPfZW9duce4clcU2ej
         GDvO7zRgP2eEzc57IkWZzFs0B8FdA4oKAREzx4GKnuosH6K8N+gYKCzkRksHIwl+BY
         J/lDEDeZ/jEIpOjtHSLOLEuTrWFl7yRZOjGW0s9jh0zRZFgVXmWM6aWYdZpEf4+sBU
         py9TwqCM+HnDehlKgL3fsLF3JZPH3K0pmL260bnNDmwfiW9C6vnS4YaXSX/rdNX2uZ
         ih2ncLS8xu/ZN9QxF8Ygw1/FKacbdTF/cGpwDzDrqYWjFzaJI/phkRuYPZhzRozU3o
         Z1jQ9+kZh73JA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-11-01 10:15 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Delete dead code.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/infiniband/hw/mlx5/ib_rep.c | 31 +++++++----------------------
>   drivers/infiniband/hw/mlx5/ib_rep.h | 31 -----------------------------
>   2 files changed, 7 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
> index 9810bdd7f3bc..a1a9450ed92c 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.c
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.c
> @@ -13,7 +13,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
>   	struct mlx5_ib_dev *ibdev;
>   	int vport_index;
> 
> -	ibdev = mlx5_ib_get_uplink_ibdev(dev->priv.eswitch);
> +	ibdev = mlx5_eswitch_uplink_get_proto_dev(dev->priv.eswitch, REP_IB);
>   	vport_index = rep->vport_index;
> 
>   	ibdev->port[vport_index].rep = rep;
> @@ -74,6 +74,11 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
>   	return ret;
>   }
> 
> +static void *mlx5_ib_rep_to_dev(struct mlx5_eswitch_rep *rep)
> +{
> +	return rep->rep_data[REP_IB].priv;
> +}
> +
>   static void
>   mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
>   {
> @@ -91,40 +96,18 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
>   		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
>   }
> 
> -static void *mlx5_ib_vport_get_proto_dev(struct mlx5_eswitch_rep *rep)
> -{
> -	return mlx5_ib_rep_to_dev(rep);
> -}
> -
>   static const struct mlx5_eswitch_rep_ops rep_ops = {
>   	.load = mlx5_ib_vport_rep_load,
>   	.unload = mlx5_ib_vport_rep_unload,
> -	.get_proto_dev = mlx5_ib_vport_get_proto_dev,
> +	.get_proto_dev = mlx5_ib_rep_to_dev,
>   };
> 
> -struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
> -					  u16 vport_num)
> -{
> -	return mlx5_eswitch_get_proto_dev(esw, vport_num, REP_IB);
> -}
> -
>   struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
>   					  u16 vport_num)
>   {
>   	return mlx5_eswitch_get_proto_dev(esw, vport_num, REP_ETH);
>   }
> 
> -struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw)
> -{
> -	return mlx5_eswitch_uplink_get_proto_dev(esw, REP_IB);
> -}
> -
> -struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
> -					   u16 vport_num)
> -{
> -	return mlx5_eswitch_vport_rep(esw, vport_num);
> -}
> -
>   struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
>   						   struct mlx5_ib_sq *sq,
>   						   u16 port)
> diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
> index 93f562735e89..ce1dcb105dbd 100644
> --- a/drivers/infiniband/hw/mlx5/ib_rep.h
> +++ b/drivers/infiniband/hw/mlx5/ib_rep.h
> @@ -12,11 +12,6 @@
>   extern const struct mlx5_ib_profile raw_eth_profile;
> 
>   #ifdef CONFIG_MLX5_ESWITCH
> -struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
> -					  u16 vport_num);
> -struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw);
> -struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
> -					   u16 vport_num);
>   int mlx5r_rep_init(void);
>   void mlx5r_rep_cleanup(void);
>   struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
> @@ -25,26 +20,6 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
>   struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
>   					  u16 vport_num);
>   #else /* CONFIG_MLX5_ESWITCH */
> -static inline
> -struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
> -					  u16 vport_num)
> -{
> -	return NULL;
> -}
> -
> -static inline
> -struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw)
> -{
> -	return NULL;
> -}
> -
> -static inline
> -struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
> -					   u16 vport_num)
> -{
> -	return NULL;
> -}
> -
>   static inline int mlx5r_rep_init(void) { return 0; }
>   static inline void mlx5r_rep_cleanup(void) {}
>   static inline
> @@ -62,10 +37,4 @@ struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
>   	return NULL;
>   }
>   #endif
> -
> -static inline
> -struct mlx5_ib_dev *mlx5_ib_rep_to_dev(struct mlx5_eswitch_rep *rep)
> -{
> -	return rep->rep_data[REP_IB].priv;
> -}
>   #endif /* __MLX5_IB_REP_H__ */
> --
> 2.28.0
> 

Reviewed-by: Roi Dayan <roid@nvidia.com>
