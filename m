Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B690209A18
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 08:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390058AbgFYGu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 02:50:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389406AbgFYGu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 02:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593067823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=dMrGGsPmPQz/O10isWZueLXcJoi7kOZlheHxHohsvbg=;
        b=Zjas2ATNTXWl+xbtJrwOMjWrYHDN527Mf2rZr2V/oZjjyJcHo4e1X/AdKDLwL7iLsBCaaA
        ivAZNFs83+y2oPioa99plbKBQCgGTrP5Iorm2wiM3ge3ZlRxyqaRp8XjM8Uq2/HP1c3S9Q
        S6XACF4aRzzjYU0iD3CQMxHkbcGqqLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-U1roUC2gN3efwwX44rbtTg-1; Thu, 25 Jun 2020 02:50:19 -0400
X-MC-Unique: U1roUC2gN3efwwX44rbtTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3927A107ACF2;
        Thu, 25 Jun 2020 06:50:17 +0000 (UTC)
Received: from [10.36.113.65] (ovpn-113-65.ams2.redhat.com [10.36.113.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 185981DC;
        Thu, 25 Jun 2020 06:50:10 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] virtio: VIRTIO_F_IOMMU_PLATFORM ->
 VIRTIO_F_ACCESS_PLATFORM
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200624232035.704217-1-mst@redhat.com>
 <20200624232035.704217-2-mst@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <dc85a45d-5507-2cb2-7e6f-2c569844914f@redhat.com>
Date:   Thu, 25 Jun 2020 08:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200624232035.704217-2-mst@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.20 01:21, Michael S. Tsirkin wrote:
> Rename the bit to match latest virtio spec.
> Add a compat macro to avoid breaking existing userspace.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/um/drivers/virtio_uml.c       |  2 +-
>  drivers/vdpa/ifcvf/ifcvf_base.h    |  2 +-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c   |  4 ++--
>  drivers/vhost/net.c                |  4 ++--
>  drivers/vhost/vdpa.c               |  2 +-
>  drivers/virtio/virtio_balloon.c    |  2 +-
>  drivers/virtio/virtio_ring.c       |  2 +-
>  include/linux/virtio_config.h      |  2 +-
>  include/uapi/linux/virtio_config.h | 10 +++++++---
>  tools/virtio/linux/virtio_config.h |  2 +-
>  10 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 351aee52aca6..a6c4bb6c2c01 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -385,7 +385,7 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
>  		}
>  		break;
>  	case VHOST_USER_SLAVE_IOTLB_MSG:
> -		/* not supported - VIRTIO_F_IOMMU_PLATFORM */
> +		/* not supported - VIRTIO_F_ACCESS_PLATFORM */
>  	case VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG:
>  		/* not supported - VHOST_USER_PROTOCOL_F_HOST_NOTIFIER */
>  	default:
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f4554412e607..24af422b5a3e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -29,7 +29,7 @@
>  		 (1ULL << VIRTIO_F_VERSION_1)			| \
>  		 (1ULL << VIRTIO_NET_F_STATUS)			| \
>  		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
> -		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
> +		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
>  		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
>  
>  /* Only one queue pair for now. */
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index c7334cc65bb2..a9bc5e0fb353 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -55,7 +55,7 @@ struct vdpasim_virtqueue {
>  
>  static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
>  			      (1ULL << VIRTIO_F_VERSION_1)  |
> -			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
> +			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
>  
>  /* State of each vdpasim device */
>  struct vdpasim {
> @@ -450,7 +450,7 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
>  	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>  
>  	/* DMA mapping must be done by driver */
> -	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
> +	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
>  		return -EINVAL;
>  
>  	vdpasim->features = features & vdpasim_features;
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index e992decfec53..8e0921d3805d 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -73,7 +73,7 @@ enum {
>  	VHOST_NET_FEATURES = VHOST_FEATURES |
>  			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>  			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
> -			 (1ULL << VIRTIO_F_IOMMU_PLATFORM)
> +			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>  };
>  
>  enum {
> @@ -1653,7 +1653,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
>  	    !vhost_log_access_ok(&n->dev))
>  		goto out_unlock;
>  
> -	if ((features & (1ULL << VIRTIO_F_IOMMU_PLATFORM))) {
> +	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
>  		if (vhost_init_device_iotlb(&n->dev, true))
>  			goto out_unlock;
>  	}
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index a54b60d6623f..18869a35d408 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -31,7 +31,7 @@ enum {
>  		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>  		(1ULL << VIRTIO_F_ANY_LAYOUT) |
>  		(1ULL << VIRTIO_F_VERSION_1) |
> -		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
> +		(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>  		(1ULL << VIRTIO_F_RING_PACKED) |
>  		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
>  		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1f157d2f4952..fc7301406540 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1120,7 +1120,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
>  	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
>  
> -	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
>  	return 0;
>  }
>  
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 58b96baa8d48..a1a5c2a91426 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2225,7 +2225,7 @@ void vring_transport_features(struct virtio_device *vdev)
>  			break;
>  		case VIRTIO_F_VERSION_1:
>  			break;
> -		case VIRTIO_F_IOMMU_PLATFORM:
> +		case VIRTIO_F_ACCESS_PLATFORM:
>  			break;
>  		case VIRTIO_F_RING_PACKED:
>  			break;
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index bb4cc4910750..f2cc2a0df174 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -171,7 +171,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
>  	 * Note the reverse polarity of the quirk feature (compared to most
>  	 * other features), this is for compatibility with legacy systems.
>  	 */
> -	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
>  }
>  
>  static inline
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> index ff8e7dc9d4dd..b5eda06f0d57 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -67,13 +67,17 @@
>  #define VIRTIO_F_VERSION_1		32
>  
>  /*
> - * If clear - device has the IOMMU bypass quirk feature.
> - * If set - use platform tools to detect the IOMMU.
> + * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
> + * If set - use platform DMA tools to access the memory.
>   *
>   * Note the reverse polarity (compared to most other features),
>   * this is for compatibility with legacy systems.
>   */
> -#define VIRTIO_F_IOMMU_PLATFORM		33
> +#define VIRTIO_F_ACCESS_PLATFORM	33
> +#ifndef __KERNEL__
> +/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
> +#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
> +#endif /* __KERNEL__ */
>  
>  /* This feature indicates support for the packed virtqueue layout. */
>  #define VIRTIO_F_RING_PACKED		34
> diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
> index dbf14c1e2188..f99ae42668e0 100644
> --- a/tools/virtio/linux/virtio_config.h
> +++ b/tools/virtio/linux/virtio_config.h
> @@ -51,7 +51,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
>  	 * Note the reverse polarity of the quirk feature (compared to most
>  	 * other features), this is for compatibility with legacy systems.
>  	 */
> -	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
> +	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
>  }
>  
>  static inline bool virtio_is_little_endian(struct virtio_device *vdev)
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

