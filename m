Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6FD322A7E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 13:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhBWM2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 07:28:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232387AbhBWM2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 07:28:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614083194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dlRBImIxcwNi4rHuXYdMygYUREHsouYdgn7QLrLfVHk=;
        b=Cm7JP0N6Y4V+fPR2CAzm1X8u0BXkQzkxF11gHD6NxQFTiND4oFH3ezFalWAhasPnjnk2ew
        UedT9/DZncHRxoMJeLUFsVym6MecefjjFKyl1qKxF0JC2nf+v9BPbQ9ZJ6hrxhT4WKd5mi
        Mat82PjKEPI5pDo/o3tSDC8UtO35jkc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-NAsRuezNMhO3VPfRyCzlLw-1; Tue, 23 Feb 2021 07:26:33 -0500
X-MC-Unique: NAsRuezNMhO3VPfRyCzlLw-1
Received: by mail-wr1-f72.google.com with SMTP id k5so2230178wrw.14
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 04:26:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dlRBImIxcwNi4rHuXYdMygYUREHsouYdgn7QLrLfVHk=;
        b=rA0XRbkm66YHZQz7luNLF6XoQP2BtNpMd70pY9oN7hDDk/cs2i4JpxPiN4ZdLHzJR2
         2Mq5ce99CCNjGoHKq2wCO/0zdBNHhF7xFihovTUBCOZSlVceycq1ZfPwFp79aFJTE9DI
         OuvCUen9yIGUyK2LtQ09TqznorJ9JucmHk1UU3lTdFmRQPCy1twFGxkuN0PqK+OM3yPY
         VJVmd3dV/Hkz1pJkY0a5S5FYYcXouTXsAfhgA3rvTP57BUZkcb7E0mmTqAFtc4fc+ccK
         Ha9oi0BzOJ50OZB8exoOqnMQOBtJ3OqWzD300O8CLX5dSnM3WYYRgKYDOW8k+05fqav2
         eeuA==
X-Gm-Message-State: AOAM531+iJR8txkJklgxzLCU0dJHQ3sPiJ3sSUpvyt0bAZTWnI0kvQDz
        BFKcw6zpV8Z2bP6yaaABp5zn/9sVKsyMOx/xDUpHXO3bT6/5SE1KwJLIPl2DKE1FnteajIOKUsv
        n4DqiYcZ+b8E6axxi
X-Received: by 2002:a5d:5109:: with SMTP id s9mr25259278wrt.325.1614083192188;
        Tue, 23 Feb 2021 04:26:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxocWMZ+yxHbiie9t5x9KGG8c7GcIkLf9fWyaLKqgKNZ40RLp7+9DospqS4cosjlYPsyzL2NQ==
X-Received: by 2002:a5d:5109:: with SMTP id s9mr25259260wrt.325.1614083191996;
        Tue, 23 Feb 2021 04:26:31 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id e17sm9660537wro.36.2021.02.23.04.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:26:31 -0800 (PST)
Date:   Tue, 23 Feb 2021 07:26:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     jasowang@redhat.com, elic@nvidia.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
Message-ID: <20210223072047-mutt-send-email-mst@kernel.org>
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 06:54:58AM -0500, Si-Wei Liu wrote:
> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
> for legacy") made an exception for legacy guests to reset
> features to 0, when config space is accessed before features
> are set. We should relieve the verify_min_features() check
> and allow features reset to 0 for this case.
> 
> It's worth noting that not just legacy guests could access
> config space before features are set. For instance, when
> feature VIRTIO_NET_F_MTU is advertised some modern driver
> will try to access and validate the MTU present in the config
> space before virtio features are set. Rejecting reset to 0
> prematurely causes correct MTU and link status unable to load
> for the very first config space access, rendering issues like
> guest showing inaccurate MTU value, or failure to reject
> out-of-range MTU.
> 
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")

isn't this more

    vdpa: make sure set_features is invoked for legacy


> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>

I think we at least need to correct the comment in
include/linux/vdpa.h then

Instead of "we assume a legacy guest" we'd say something like
"call set features in case it's a legacy guest".

Generally it's unfortunate. Need to think about what to do here.
Any idea how else we can cleanly detect a legacy guest?

> ---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 7c1f789..540dd67 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>  	return mvdev->mlx_features;
>  }
>  
> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
> -{
> -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
> -		return -EOPNOTSUPP;
> -
> -	return 0;
> -}
> -
>  static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>  {
>  	int err;

Let's just set VIRTIO_F_ACCESS_PLATFORM in core?
Then we don't need to hack mlx5 ...


> @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>  {
>  	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>  	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
> -	int err;
>  
>  	print_features(mvdev, features, true);
>  
> -	err = verify_min_features(mvdev, features);
> -	if (err)
> -		return err;
> -
>  	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>  	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>  	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
> -	return err;
> +	return 0;
>  }
>  
>  static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
> -- 
> 1.8.3.1

