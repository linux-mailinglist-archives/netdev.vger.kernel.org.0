Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E733CDD4
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 07:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhCPGLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 02:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235738AbhCPGLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 02:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615875073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PUbH8K+dxP06KIGzIKvVc1Q5rD/dHm6SKImpw8nnM+U=;
        b=cx19epPURVbix78a5wZUIzLQS6hig49yOhDEG0rhkgUpUZZrkVz1r+I9jNhwS1x/9ctz0G
        6Td1F41j7sPo8vhpKK5YbPr0sxaGV2JGFLMaqx1Q/UNR/VucRcYRRNa1gnc0U2pB37cc65
        g+OVLEbDX2weJMrDrM8hMIdIwlj163o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-tUY7HdLWNHebOFDKeVnLUw-1; Tue, 16 Mar 2021 02:11:09 -0400
X-MC-Unique: tUY7HdLWNHebOFDKeVnLUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16E12760C4;
        Tue, 16 Mar 2021 06:11:08 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-216.pek2.redhat.com [10.72.12.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1BC66F130;
        Tue, 16 Mar 2021 06:11:00 +0000 (UTC)
Subject: Re: [PATCH V4 3/7] vDPA/ifcvf: rename original IFCVF dev ids to N3000
 ids
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <09a56b2e-f184-d003-a789-007d4a854975@redhat.com>
Date:   Tue, 16 Mar 2021 14:10:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç3:44, Zhu Lingshan Ð´µÀ:
> IFCVF driver probes multiple types of devices now,
> to distinguish the original device driven by IFCVF
> from others, it is renamed as "N3000".
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>

If you want to have a general driver, you probaby need to rename the driver.

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

