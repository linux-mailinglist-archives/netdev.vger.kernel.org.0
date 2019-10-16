Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2027D8B9C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbfJPIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726640AbfJPIq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:46:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 36A703C93A;
        Wed, 16 Oct 2019 08:46:27 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A430E60166;
        Wed, 16 Oct 2019 08:45:58 +0000 (UTC)
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2d711b6b-3bdc-afaa-8110-beebd6c5a896@redhat.com>
Date:   Wed, 16 Oct 2019 16:45:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016013050.3918-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 16 Oct 2019 08:46:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/16 上午9:30, Zhu Lingshan wrote:
> + */
> +#define IFCVF_TRANSPORT_F_START 28
> +#define IFCVF_TRANSPORT_F_END   34
> +
> +#define IFC_SUPPORTED_FEATURES \
> +		((1ULL << VIRTIO_NET_F_MAC)			| \
> +		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> +		 (1ULL << VIRTIO_F_VERSION_1)			| \
> +		 (1ULL << VHOST_F_LOG_ALL)			| \


Let's avoid using VHOST_F_LOG_ALL, using the get_mdev_features() instead.


> +		 (1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE)		| \
> +		 (1ULL << VIRTIO_NET_F_CTRL_VQ)			| \
> +		 (1ULL << VIRTIO_NET_F_STATUS)			| \
> +		 (1ULL << VIRTIO_NET_F_MRG_RXBUF)) /* not fully supported */


Why not having VIRTIO_F_IOMMU_PLATFORM and VIRTIO_F_ORDER_PLATFORM?

Thanks

