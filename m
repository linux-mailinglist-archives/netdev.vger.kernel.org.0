Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68363336AAA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCKD00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:26:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56838 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhCKD0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615433168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFqvqdxhcEJJpTkmLszHn4IZfhxa3EbZT89ftgo2+BY=;
        b=FXSoE1583X3yS43pcB6l/YyZnPK01xgoaaw0zSF+/iU6e1Whsyk74CbmNX6AOi5VlP+xEM
        oV7OoqoKLKvb9vc7nPYQYglTbGHPn8+LeTFgv62AMu9XvcM2uutDk5NljhWikbxGOzuRXz
        +FZ2LjGWWfGpVvjikrfsoD1ZRMpijmE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-YZ3Xp-TGOkGLGBFEgckrVg-1; Wed, 10 Mar 2021 22:26:05 -0500
X-MC-Unique: YZ3Xp-TGOkGLGBFEgckrVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 014A41009E2D;
        Thu, 11 Mar 2021 03:26:04 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2129F5D6D7;
        Thu, 11 Mar 2021 03:25:57 +0000 (UTC)
Subject: Re: [PATCH V3 3/6] vDPA/ifcvf: rename original IFCVF dev ids to N3000
 ids
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5e2b22cc-7faa-2987-a30a-ce32f10099b6@redhat.com>
Date:   Thu, 11 Mar 2021 11:25:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310090052.4762-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
> IFCVF driver probes multiple types of devices now,
> to distinguish the original device driven by IFCVF
> from others, it is renamed as "N3000".
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
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


I am not sure the plan for Intel but I wonder if we can simply use 
PCI_ANY_ID for device id here. Otherewise you need to maintain a very 
long list of ids here.

Thanks


> +			 N3000_SUBSYS_VENDOR_ID,
> +			 N3000_SUBSYS_DEVICE_ID) },
>   	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>   			 C5000X_PL_DEVICE_ID,
>   			 C5000X_PL_SUBSYS_VENDOR_ID,

