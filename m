Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F93DE793
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhHCHvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:51:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234292AbhHCHvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 03:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627977061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYcam7agTFSd/2Q6NOTWlhklTs5e2KArUsWMeCcGGAM=;
        b=VdofTyAdJZV9hm305JyIHmXL7Mqfti9dV37IcC4KcHiCQeEW7g19W+inxDJkvw8DS8xOqL
        s0Hy3pYjBqRgLJws0uQWJQ7AIBPD1OjIlifA2nupTd+M465E2GIwkYnhlDL+oUFugi1Yyu
        +el3gQxdr3u/qAq65yx+8xs5E78SpcM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-37sn2L-uO-Gb9P1uozrqiw-1; Tue, 03 Aug 2021 03:51:00 -0400
X-MC-Unique: 37sn2L-uO-Gb9P1uozrqiw-1
Received: by mail-pj1-f69.google.com with SMTP id f62-20020a17090a28c4b02901733dbfa29cso2244999pjd.0
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 00:51:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oYcam7agTFSd/2Q6NOTWlhklTs5e2KArUsWMeCcGGAM=;
        b=AC1JNga1sQGALxB8vdvMwS4BUcxPzQvxjhyO2cmFX/+Ct9heUvNCvJFY7kanwd4hEA
         Hd6pOWGQYCSAslh7T8tzp0V/lUw6xqwr8eT21J7+V6vI/Xwesq5aw7KqVtv+47e9hJi4
         w/xRVKk4zq8aLrPkCp4BK7EzjSe6ePR4ypCJhIIj6wkrpzfSVOfzovkFhVOFnUoDBXmp
         yvdT8Oj73XLOFSedqYbkmGUIOInjJGxDb+dkuIX0Ym418bx59bh+d29HOeIXeSKiAaFN
         0K6vj/XTz2NWxj2Ojf+2XGSlslJ8oDrYvPMl5IemOVqy1y0cs9Di89vtXiJqm7Jp8AnH
         lypg==
X-Gm-Message-State: AOAM533Vkt0DmNZ2DengHwZmnoiQgoDfjNusWEY5r1/2IN2aHLpjhHtu
        GvR4VRR8Fwv/3EIcsUeiMHP7jlj5e4iyFGcB0TYzZXPvqXgAOu8q8muk6jsZwEUhI5DAhSa74ZU
        kuB8t4YumAAEoIuqi
X-Received: by 2002:a05:6a00:a8a:b029:356:be61:7f18 with SMTP id b10-20020a056a000a8ab0290356be617f18mr20640884pfl.29.1627977059222;
        Tue, 03 Aug 2021 00:50:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLduE7LXN7Wln37TgSE39sEWlhyZA9xOCP4JLoPOJrBqHBCOe6D/dpJAaC4v4en3vOIVKYWw==
X-Received: by 2002:a05:6a00:a8a:b029:356:be61:7f18 with SMTP id b10-20020a056a000a8ab0290356be617f18mr20640860pfl.29.1627977058989;
        Tue, 03 Aug 2021 00:50:58 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 98sm13139744pjo.26.2021.08.03.00.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:50:58 -0700 (PDT)
Subject: Re: [PATCH v10 03/17] vdpa: Fix code indentation
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <aaf82d3f-05e3-13d5-3a63-52cd8045b4c6@redhat.com>
Date:   Tue, 3 Aug 2021 15:50:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:34, Xie Yongji Ð´µÀ:
> Use tabs to indent the code instead of spaces.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   include/linux/vdpa.h | 29 ++++++++++++++---------------
>   1 file changed, 14 insertions(+), 15 deletions(-)


It looks to me not all the warnings are addressed.

Or did you silent checkpatch.pl -f?

Thanks


>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 7c49bc5a2b71..406d53a606ac 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -43,17 +43,17 @@ struct vdpa_vq_state_split {
>    * @last_used_idx: used index
>    */
>   struct vdpa_vq_state_packed {
> -        u16	last_avail_counter:1;
> -        u16	last_avail_idx:15;
> -        u16	last_used_counter:1;
> -        u16	last_used_idx:15;
> +	u16	last_avail_counter:1;
> +	u16	last_avail_idx:15;
> +	u16	last_used_counter:1;
> +	u16	last_used_idx:15;
>   };
>   
>   struct vdpa_vq_state {
> -     union {
> -          struct vdpa_vq_state_split split;
> -          struct vdpa_vq_state_packed packed;
> -     };
> +	union {
> +		struct vdpa_vq_state_split split;
> +		struct vdpa_vq_state_packed packed;
> +	};
>   };
>   
>   struct vdpa_mgmt_dev;
> @@ -131,7 +131,7 @@ struct vdpa_iova_range {
>    *				@vdev: vdpa device
>    *				@idx: virtqueue index
>    *				@state: pointer to returned state (last_avail_idx)
> - * @get_vq_notification: 	Get the notification area for a virtqueue
> + * @get_vq_notification:	Get the notification area for a virtqueue
>    *				@vdev: vdpa device
>    *				@idx: virtqueue index
>    *				Returns the notifcation area
> @@ -342,25 +342,24 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
>   
>   static inline void vdpa_reset(struct vdpa_device *vdev)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	vdev->features_valid = false;
> -        ops->set_status(vdev, 0);
> +	ops->set_status(vdev, 0);
>   }
>   
>   static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	vdev->features_valid = true;
> -        return ops->set_features(vdev, features);
> +	return ops->set_features(vdev, features);
>   }
>   
> -
>   static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>   				   void *buf, unsigned int len)
>   {
> -        const struct vdpa_config_ops *ops = vdev->config;
> +	const struct vdpa_config_ops *ops = vdev->config;
>   
>   	/*
>   	 * Config accesses aren't supposed to trigger before features are set.

