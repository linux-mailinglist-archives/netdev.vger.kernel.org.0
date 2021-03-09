Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A5E331CF3
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhCICZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:25:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230391AbhCICYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615256686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QMGDh/tM/ZzBGLY6JnLbTtw7r7X8XSbA7HZppr+O/eA=;
        b=QqPNOYYn0sUu2wwgvAZA6dYcAtV9ANUY1d630Xt7fTzgS0KWP4f6tqx+R6oG47EObEKQRk
        rhqgn6cYMkVYz3NXYjCVt/Xd242Mbs1S5BOhzc0tFSbiVLPNq+l6bvoe9aIkM+QhApqIky
        Bz6dgtg8N+OcV8lJUIA1WaLcEsjd9JE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-80li3uNSOpSACzg98jN-JQ-1; Mon, 08 Mar 2021 21:24:43 -0500
X-MC-Unique: 80li3uNSOpSACzg98jN-JQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03B778042C3;
        Tue,  9 Mar 2021 02:24:42 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-202.pek2.redhat.com [10.72.13.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8159E5D9CD;
        Tue,  9 Mar 2021 02:24:36 +0000 (UTC)
Subject: Re: [PATCH V2 3/4] vDPA/ifcvf: rename original IFCVF dev ids to N3000
 ids
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210308083525.382514-1-lingshan.zhu@intel.com>
 <20210308083525.382514-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <75863302-b395-7551-6cb6-6ae327c6ce71@redhat.com>
Date:   Tue, 9 Mar 2021 10:24:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308083525.382514-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/8 4:35 下午, Zhu Lingshan wrote:
> IFCVF driver probes multiple types of devices now,
> to distinguish the original device driven by IFCVF
> from others, it is renamed as "N3000".
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>

You probably need to rename the driver.

Thanks


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 8 ++++----
>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
>   2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 75d9a8052039..794d1505d857 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -18,10 +18,10 @@
>   #include <uapi/linux/virtio_config.h>
>   #include <uapi/linux/virtio_pci.h>
>   
> -#define IFCVF_VENDOR_ID		0x1AF4
> -#define IFCVF_DEVICE_ID		0x1041
> -#define IFCVF_SUBSYS_VENDOR_ID	0x8086
> -#define IFCVF_SUBSYS_DEVICE_ID	0x001A
> +#define N3000_VENDOR_ID		0x1AF4
> +#define N3000_DEVICE_ID		0x1041
> +#define N3000_SUBSYS_VENDOR_ID	0x8086
> +#define N3000_SUBSYS_DEVICE_ID	0x001A
>   
>   #define C5000X_PL_VENDOR_ID		0x1AF4
>   #define C5000X_PL_DEVICE_ID		0x1000
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 26a2dab7ca66..fd5befc5cbcc 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -480,10 +480,10 @@ static void ifcvf_remove(struct pci_dev *pdev)
>   }
>   
>   static struct pci_device_id ifcvf_pci_ids[] = {
> -	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
> -		IFCVF_DEVICE_ID,
> -		IFCVF_SUBSYS_VENDOR_ID,
> -		IFCVF_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(N3000_VENDOR_ID,
> +			 N3000_DEVICE_ID,
> +			 N3000_SUBSYS_VENDOR_ID,
> +			 N3000_SUBSYS_DEVICE_ID) },
>   	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>   			 C5000X_PL_DEVICE_ID,
>   			 C5000X_PL_SUBSYS_VENDOR_ID,

