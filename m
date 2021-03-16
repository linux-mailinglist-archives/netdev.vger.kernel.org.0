Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7309333CDC7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 07:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbhCPGJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 02:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235593AbhCPGJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 02:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615874981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pym55gQ5cNu+m40IVzvuuLtEXKTOXlfin1TVj3jHUAM=;
        b=LMKFoMtUP7noZH4ZL43Wfy+HOOp3k9dlsqZVB96FA87Sf4MYFJVVCwCOrV6ewjINwP0w1B
        c+FD85E0m0VVvkKs0Xc9XKqoNGM3tFJ60Nm2Tkq7RtkGGSb95CnxNJ3PgWBeGQk72M7L5w
        HhMVDbhQ55NYUxTcf+vCIe5wq9jIR90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-oVU6UxoqPiG4oDKOgese7g-1; Tue, 16 Mar 2021 02:09:37 -0400
X-MC-Unique: oVU6UxoqPiG4oDKOgese7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 544FF100C618;
        Tue, 16 Mar 2021 06:09:36 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-216.pek2.redhat.com [10.72.12.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 196C010016DB;
        Tue, 16 Mar 2021 06:09:28 +0000 (UTC)
Subject: Re: [PATCH V4 2/7] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for
 vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
 <20210315074501.15868-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <840ce79d-3fb8-2d61-3b65-2a834d65ba54@redhat.com>
Date:   Tue, 16 Mar 2021 14:09:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315074501.15868-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç3:44, Zhu Lingshan Ð´µÀ:
> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
> for vDPA
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 5 +++++
>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 +++++
>   2 files changed, 10 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 64696d63fe07..75d9a8052039 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -23,6 +23,11 @@
>   #define IFCVF_SUBSYS_VENDOR_ID	0x8086
>   #define IFCVF_SUBSYS_DEVICE_ID	0x001A
>   
> +#define C5000X_PL_VENDOR_ID		0x1AF4
> +#define C5000X_PL_DEVICE_ID		0x1000
> +#define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
> +#define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
> +
>   #define IFCVF_SUPPORTED_FEATURES \
>   		((1ULL << VIRTIO_NET_F_MAC)			| \
>   		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index e501ee07de17..26a2dab7ca66 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -484,6 +484,11 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>   		IFCVF_DEVICE_ID,
>   		IFCVF_SUBSYS_VENDOR_ID,
>   		IFCVF_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
> +			 C5000X_PL_DEVICE_ID,
> +			 C5000X_PL_SUBSYS_VENDOR_ID,
> +			 C5000X_PL_SUBSYS_DEVICE_ID) },
> +
>   	{ 0 },
>   };
>   MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);

