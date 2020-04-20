Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DAA1B05FA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 11:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDTJwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 05:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTJwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 05:52:35 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3EBC061A0C;
        Mon, 20 Apr 2020 02:52:35 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s63so9840232qke.4;
        Mon, 20 Apr 2020 02:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oUbgZkV2b2YjQncs6xJl0qIAmIC6z4JNsiWiRG6CyM8=;
        b=OV98tFWvMeT86/iR+qjm0Sw4TshgMfUUksaYgvUGWwwRBDbxQuz5VGhzydSb+sNG1N
         580e5C03VCHyQwVPBMg71FhxSQvtI9+jiKd4mLkQCeRZVSmU25KafO3RR5cQpLuxDkWV
         Zp9eyqcfTP4aZwWMTV2oEmAXfG067JYbAyfZoCUD0arzXo5bdZcTK+RBn972ejRiwfgo
         YrM68QNTqFZI4Dj9wUt9SQO9/h6K1thTe14Rcvh/808E84roorPG6DVYlvbuh5KD7EZV
         YmI8GDPA8w6As4Akcj1IaMr9Op9m1RJji4MfeYJsPaPKAo287M4QAe+v5KNdUBJXHryT
         yuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oUbgZkV2b2YjQncs6xJl0qIAmIC6z4JNsiWiRG6CyM8=;
        b=iTMr3Bt7jAyhuJUffMyhdlBY9lVxrsI2o4alY9NqOvUWN8nE2E259jNcezUItC9RGO
         Ptopfd2YFdVmh588nK+pmUKppH/PVviwir0CigQxzIVnwps8OFJw3siRAtR3o8wtWCSM
         z79XaQQHnDxId46SQxiGqftOQfAagL/NSGNzvbDEEvlfR5GD38r9gZtrRf9/DGtJH5iw
         QIj5xEsl3VbSYPV2jOB+kVNiqYUhkqJo2SEfOBA2wxMYJaMqd6M/eMhUPKaDuTHEpLej
         vBY5oc1Jp+vZ2FyXOowToVSeXuPSeChBKYX52WSzMGtk7PZpBLoI/s2KaxeQ2QloxxmJ
         Tkcw==
X-Gm-Message-State: AGi0PuYEKyH5vY8KyXGhBPfAm3IkPd3R3nMvbz8mvL8TmldfKhu5caOj
        d/EmrocI3wxCciU9jjxcrWXk06J1oSs=
X-Google-Smtp-Source: APiQypLPZkdflHSYJip3Azvk2mTnl1K2arY00W3nh2mvoYewBtd0ybhdFe2JC1m2/7h60jOj49UBcA==
X-Received: by 2002:a37:a649:: with SMTP id p70mr14974153qke.458.1587376354556;
        Mon, 20 Apr 2020 02:52:34 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m7sm246103qke.124.2020.04.20.02.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 02:52:33 -0700 (PDT)
Date:   Mon, 20 Apr 2020 17:52:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/2] xdp: add dev map multicast support
Message-ID: <20200420095227.GJ2159@dhcp-12-139.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200415085437.23028-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415085437.23028-2-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Would you please help review the RFC and give some comments?
Especially for the ifindex parameter of bpf_redirect_map() which
contains both include and exclude map id. Should we keep the current
designing, or find a way to make it flexible, or even add a new syscall
to accept two index parameters?

Thanks
Hangbin

On Wed, Apr 15, 2020 at 04:54:36PM +0800, Hangbin Liu wrote:
> This is a prototype for xdp multicast support. In this implemention we
> use map-in-map to store the multicast groups, because we may have both
> include and exclude groups on one interface.
> 
> The include and exclude groups are seperated by a 32 bits map key.
> the high 16 bits keys are used for include groups and low 16 bits
> keys are for exclude groups.
> 
> The general data path is kept in net/core/filter.c. The native data
> path is in kernel/bpf/devmap.c so we can use direct calls to
> get better performace.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/linux/bpf.h   |  29 +++++++++++
>  include/net/xdp.h     |   1 +
>  kernel/bpf/arraymap.c |   2 +-
>  kernel/bpf/devmap.c   | 118 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/hashtab.c  |   2 +-
>  kernel/bpf/verifier.c |  15 +++++-
>  net/core/filter.c     |  69 +++++++++++++++++++++++-
>  net/core/xdp.c        |  26 ++++++++++
>  8 files changed, 256 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fd2b2322412d..72797667bca8 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1156,11 +1156,17 @@ struct sk_buff;
>  
>  struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key);
>  struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key);
> +void *array_of_map_lookup_elem(struct bpf_map *map, void *key);
> +void *htab_of_map_lookup_elem(struct bpf_map *map, void *key);
>  void __dev_flush(void);
>  int dev_xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
>  int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  		    struct net_device *dev_rx);
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map);
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, u32 index);
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog);
>  
> @@ -1276,6 +1282,16 @@ static inline struct net_device  *__dev_map_hash_lookup_elem(struct bpf_map *map
>  	return NULL;
>  }
>  
> +static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +
> +}
> +
> +static void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +
> +}
> +
>  static inline void __dev_flush(void)
>  {
>  }
> @@ -1297,6 +1313,19 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  	return 0;
>  }
>  
> +static inline
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map)
> +{
> +	return true;
> +}
> +
> +static inline
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, u32 index)
> +{
> +	return 0;
> +}
> +
>  struct sk_buff;
>  
>  static inline int dev_map_generic_redirect(struct bpf_dtab_netdev *dst,
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 40c6d3398458..a214dce8579c 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -92,6 +92,7 @@ static inline void xdp_scrub_frame(struct xdp_frame *frame)
>  }
>  
>  struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp);
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf);
>  
>  /* Convert xdp_buff to xdp_frame */
>  static inline
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 95d77770353c..26ac66a05015 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -1031,7 +1031,7 @@ static void array_of_map_free(struct bpf_map *map)
>  	fd_array_map_free(map);
>  }
>  
> -static void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
> +void *array_of_map_lookup_elem(struct bpf_map *map, void *key)
>  {
>  	struct bpf_map **inner_map = array_map_lookup_elem(map, key);
>  
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 58bdca5d978a..3a60cb209ae1 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -85,6 +85,9 @@ static DEFINE_PER_CPU(struct list_head, dev_flush_list);
>  static DEFINE_SPINLOCK(dev_map_lock);
>  static LIST_HEAD(dev_map_list);
>  
> +static void *dev_map_lookup_elem(struct bpf_map *map, void *key);
> +static void *dev_map_hash_lookup_elem(struct bpf_map *map, void *key);
> +
>  static struct hlist_head *dev_map_create_hash(unsigned int entries)
>  {
>  	int i;
> @@ -456,6 +459,121 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  	return __xdp_enqueue(dev, xdp, dev_rx);
>  }
>  
> +/* Use direct call in fast path instead of  map->ops->map_get_next_key() */
> +static int devmap_get_next_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +
> +	switch (map->map_type) {
> +	case BPF_MAP_TYPE_DEVMAP:
> +		return dev_map_get_next_key(map, key, next_key);
> +	case BPF_MAP_TYPE_DEVMAP_HASH:
> +		return dev_map_hash_get_next_key(map, key, next_key);
> +	default:
> +		break;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +bool dev_in_exclude_map(struct bpf_dtab_netdev *obj, struct bpf_map *map)
> +{
> +	struct bpf_dtab_netdev *in_obj = NULL;
> +	u32 key, next_key;
> +	int err;
> +
> +	devmap_get_next_key(map, NULL, &key);
> +
> +	for (;;) {
> +		switch (map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			in_obj = __dev_map_lookup_elem(map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			in_obj = __dev_map_hash_lookup_elem(map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		if (in_obj && in_obj->dev->ifindex == obj->dev->ifindex)
> +			return true;
> +
> +		err = devmap_get_next_key(map, &key, &next_key);
> +
> +		if (err)
> +			break;
> +
> +		key = next_key;
> +	}
> +
> +	return false;
> +}
> +
> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, u32 index)
> +{
> +	struct bpf_dtab_netdev *obj = NULL;
> +	struct bpf_map *in_map, *ex_map;
> +	struct xdp_frame *xdpf, *nxdpf;
> +	struct net_device *dev;
> +	u32 in_index, ex_index;
> +	u32 key, next_key;
> +	int err;
> +
> +	in_index = index >> 16;
> +	in_index = in_index << 16;
> +	ex_index = in_index ^ index;
> +
> +	in_map = map->ops->map_lookup_elem(map, &in_index);
> +	/* ex_map could be NULL */
> +	ex_map = map->ops->map_lookup_elem(map, &ex_index);
> +
> +	devmap_get_next_key(in_map, NULL, &key);
> +
> +	xdpf = convert_to_xdp_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	for (;;) {
> +		switch (in_map->map_type) {
> +		case BPF_MAP_TYPE_DEVMAP:
> +			obj = __dev_map_lookup_elem(in_map, key);
> +			break;
> +		case BPF_MAP_TYPE_DEVMAP_HASH:
> +			obj = __dev_map_hash_lookup_elem(in_map, key);
> +			break;
> +		default:
> +			break;
> +		}
> +		if (!obj)
> +			goto find_next;
> +
> +		if (ex_map && !dev_in_exclude_map(obj, ex_map)) {
> +			dev = obj->dev;
> +
> +			if (!dev->netdev_ops->ndo_xdp_xmit)
> +				return -EOPNOTSUPP;
> +
> +			err = xdp_ok_fwd_dev(dev, xdp->data_end - xdp->data);
> +			if (unlikely(err))
> +				return err;
> +
> +			nxdpf = xdpf_clone(xdpf);
> +			if (unlikely(!nxdpf))
> +				return -ENOMEM;
> +
> +			bq_enqueue(dev, nxdpf, dev_rx);
> +		}
> +find_next:
> +		err = devmap_get_next_key(in_map, &key, &next_key);
> +		if (err)
> +			break;
> +		key = next_key;
> +	}
> +
> +	return 0;
> +}
> +
>  int dev_map_generic_redirect(struct bpf_dtab_netdev *dst, struct sk_buff *skb,
>  			     struct bpf_prog *xdp_prog)
>  {
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index d541c8486c95..4e0a2eebd38d 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1853,7 +1853,7 @@ static struct bpf_map *htab_of_map_alloc(union bpf_attr *attr)
>  	return map;
>  }
>  
> -static void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
> +void *htab_of_map_lookup_elem(struct bpf_map *map, void *key)
>  {
>  	struct bpf_map **inner_map  = htab_map_lookup_elem(map, key);
>  
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 04c6630cc18f..84d23418823a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3898,7 +3898,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		break;
>  	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
>  	case BPF_MAP_TYPE_HASH_OF_MAPS:
> -		if (func_id != BPF_FUNC_map_lookup_elem)
> +		/* Used by multicast redirect */
> +		if (func_id != BPF_FUNC_redirect_map &&
> +		    func_id != BPF_FUNC_map_lookup_elem)
>  			goto error;
>  		break;
>  	case BPF_MAP_TYPE_SOCKMAP:
> @@ -3968,8 +3970,17 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
>  		if (map->map_type != BPF_MAP_TYPE_DEVMAP &&
>  		    map->map_type != BPF_MAP_TYPE_DEVMAP_HASH &&
>  		    map->map_type != BPF_MAP_TYPE_CPUMAP &&
> -		    map->map_type != BPF_MAP_TYPE_XSKMAP)
> +		    map->map_type != BPF_MAP_TYPE_XSKMAP &&
> +		    map->map_type != BPF_MAP_TYPE_ARRAY_OF_MAPS &&
> +		    map->map_type != BPF_MAP_TYPE_HASH_OF_MAPS)
>  			goto error;
> +		if (map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
> +		    map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
> +			/* FIXME: Maybe we should also strict the key size here ?? */
> +			if (map->inner_map_meta->map_type != BPF_MAP_TYPE_DEVMAP &&
> +			    map->inner_map_meta->map_type != BPF_MAP_TYPE_DEVMAP_HASH)
> +				goto error;
> +		}
>  		break;
>  	case BPF_FUNC_sk_redirect_map:
>  	case BPF_FUNC_msg_redirect_map:
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7628b947dbc3..7d2076f5b0a4 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3473,12 +3473,17 @@ static const struct bpf_func_proto bpf_xdp_adjust_meta_proto = {
>  };
>  
>  static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
> -			    struct bpf_map *map, struct xdp_buff *xdp)
> +			    struct bpf_map *map, struct xdp_buff *xdp,
> +			    u32 index)
>  {
>  	switch (map->map_type) {
>  	case BPF_MAP_TYPE_DEVMAP:
> +		/* fall through */
>  	case BPF_MAP_TYPE_DEVMAP_HASH:
>  		return dev_map_enqueue(fwd, xdp, dev_rx);
> +	case BPF_MAP_TYPE_HASH_OF_MAPS:
> +	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> +		return dev_map_enqueue_multi(xdp, dev_rx, map, index);
>  	case BPF_MAP_TYPE_CPUMAP:
>  		return cpu_map_enqueue(fwd, xdp, dev_rx);
>  	case BPF_MAP_TYPE_XSKMAP:
> @@ -3508,6 +3513,10 @@ static inline void *__xdp_map_lookup_elem(struct bpf_map *map, u32 index)
>  		return __cpu_map_lookup_elem(map, index);
>  	case BPF_MAP_TYPE_XSKMAP:
>  		return __xsk_map_lookup_elem(map, index);
> +	case BPF_MAP_TYPE_ARRAY_OF_MAPS:
> +		return array_of_map_lookup_elem(map, (index >> 16) << 16);
> +	case BPF_MAP_TYPE_HASH_OF_MAPS:
> +		return htab_of_map_lookup_elem(map, (index >> 16) << 16);
>  	default:
>  		return NULL;
>  	}
> @@ -3552,7 +3561,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  
>  		err = dev_xdp_enqueue(fwd, xdp, dev);
>  	} else {
> -		err = __bpf_tx_xdp_map(dev, fwd, map, xdp);
> +		err = __bpf_tx_xdp_map(dev, fwd, map, xdp, index);
>  	}
>  
>  	if (unlikely(err))
> @@ -3566,6 +3575,55 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>  }
>  EXPORT_SYMBOL_GPL(xdp_do_redirect);
>  
> +static int dev_map_redirect_multi(struct sk_buff *skb, struct bpf_prog *xdp_prog,
> +				  struct bpf_map *map, u32 index)
> +
> +{
> +	struct bpf_map *in_map, *ex_map;
> +	struct bpf_dtab_netdev *dst;
> +	u32 in_index, ex_index;
> +	struct sk_buff *nskb;
> +	u32 key, next_key;
> +	int err;
> +	void *fwd;
> +
> +	in_index = index >> 16;
> +	in_index = in_index << 16;
> +	ex_index = in_index ^ index;
> +
> +	in_map = map->ops->map_lookup_elem(map, &in_index);
> +	/* ex_map could be NULL */
> +	ex_map = map->ops->map_lookup_elem(map, &ex_index);
> +
> +	in_map->ops->map_get_next_key(in_map, NULL, &key);
> +
> +	for (;;) {
> +		fwd = __xdp_map_lookup_elem(in_map, key);
> +		if (fwd) {
> +			dst = (struct bpf_dtab_netdev *)fwd;
> +			if (ex_map && dev_in_exclude_map(dst, ex_map))
> +				goto find_next;
> +
> +			nskb = skb_clone(skb, GFP_ATOMIC);
> +			if (!nskb)
> +				return -EOVERFLOW;
> +
> +			err = dev_map_generic_redirect(dst, nskb, xdp_prog);
> +			if (unlikely(err))
> +				return err;
> +		}
> +
> +find_next:
> +		err = in_map->ops->map_get_next_key(in_map, &key, &next_key);
> +		if (err)
> +			break;
> +
> +		key = next_key;
> +	}
> +
> +	return 0;
> +}
> +
>  static int xdp_do_generic_redirect_map(struct net_device *dev,
>  				       struct sk_buff *skb,
>  				       struct xdp_buff *xdp,
> @@ -3588,6 +3646,13 @@ static int xdp_do_generic_redirect_map(struct net_device *dev,
>  		err = dev_map_generic_redirect(dst, skb, xdp_prog);
>  		if (unlikely(err))
>  			goto err;
> +	} else if (map->map_type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
> +		   map->map_type == BPF_MAP_TYPE_HASH_OF_MAPS) {
> +		/* Do multicast redirecting */
> +		err = dev_map_redirect_multi(skb, xdp_prog, map, index);
> +		if (unlikely(err))
> +			goto err;
> +		consume_skb(skb);
>  	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
>  		struct xdp_sock *xs = fwd;
>  
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 4c7ea85486af..70dfb4910f84 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -496,3 +496,29 @@ struct xdp_frame *xdp_convert_zc_to_xdp_frame(struct xdp_buff *xdp)
>  	return xdpf;
>  }
>  EXPORT_SYMBOL_GPL(xdp_convert_zc_to_xdp_frame);
> +
> +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> +{
> +	unsigned int headroom, totalsize;
> +	struct xdp_frame *nxdpf;
> +	struct page *page;
> +	void *addr;
> +
> +	headroom = xdpf->headroom + sizeof(*xdpf);
> +	totalsize = headroom + xdpf->len;
> +
> +	if (unlikely(totalsize > PAGE_SIZE))
> +		return NULL;
> +	page = dev_alloc_page();
> +	if (!page)
> +		return NULL;
> +	addr = page_to_virt(page);
> +
> +	memcpy(addr, xdpf, totalsize);
> +
> +	nxdpf = addr;
> +	nxdpf->data = addr + headroom;
> +
> +	return nxdpf;
> +}
> +EXPORT_SYMBOL_GPL(xdpf_clone);
> -- 
> 2.19.2
> 
