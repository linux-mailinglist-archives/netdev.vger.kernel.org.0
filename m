Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA30514E7BA
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 04:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgAaD44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 22:56:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36472 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgAaD44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 22:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5AiRNNR3E4corHChDgT2p0fKB/v898YA69onJ2mDDvw=; b=ZT77gvY6Brb8nwO28+W+PgGME
        1oHALqs7edfA5cAXt2DkOj2ED02hIyZk7cqJZUEQ6g9u6JxtsI2no2cLY87s/Gw8YqdFaGe7neSG3
        TnzE4fI058xHpmkMFgn4T9ST8cE/wBnMz1TXttpMowzC/81zyT7NbUQTDs6rp5VjWDP34tBDwvi0d
        4SaOhBuvujCcPwav2o9u7mZZb9KWuycxO2j08+HV/qBzJPjTSlJgoSlyF8xoM+eO3fEq2SeyS3Wfz
        FvLanvkTO7oNyZKJHaSODqEIHL/RVYgxErYSycYFySL+vareq71eeVKPboLj6qLAvpnhaSsRKFbhj
        Jp6aKukPQ==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixNQD-0003II-6X; Fri, 31 Jan 2020 03:56:45 +0000
Subject: Re: [PATCH] vhost: introduce vDPA based backend
To:     Tiwei Bie <tiwei.bie@intel.com>, mst@redhat.com,
        jasowang@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        shahafs@mellanox.com, jgg@mellanox.com, rob.miller@broadcom.com,
        haotian.wang@sifive.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
References: <20200131033651.103534-1-tiwei.bie@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <43aeecb4-4c08-df3d-1c1d-699ec4c494bd@infradead.org>
Date:   Thu, 30 Jan 2020 19:56:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131033651.103534-1-tiwei.bie@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/30/20 7:36 PM, Tiwei Bie wrote:
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index f21c45aa5e07..13e6a94d0243 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -34,6 +34,18 @@ config VHOST_VSOCK
>  	To compile this driver as a module, choose M here: the module will be called
>  	vhost_vsock.
>  
> +config VHOST_VDPA
> +	tristate "Vhost driver for vDPA based backend"
> +	depends on EVENTFD && VDPA
> +	select VHOST
> +	default n
> +	---help---
> +	This kernel module can be loaded in host kernel to accelerate
> +	guest virtio devices with the vDPA based backends.

	                              vDPA-based

> +
> +	To compile this driver as a module, choose M here: the module
> +	will be called vhost_vdpa.
> +

The preferred Kconfig style nowadays is
(a) use "help" instead of "---help---"
(b) indent the help text with one tab + 2 spaces

and don't use "default n" since that is already the default.

>  config VHOST
>  	tristate
>          depends on VHOST_IOTLB

thanks.
-- 
~Randy

