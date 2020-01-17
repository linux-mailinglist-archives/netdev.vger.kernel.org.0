Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E18E1402CA
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbgAQEKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:10:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbgAQEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KM4jBWrreX7YdYs9/PMtNlfIXwcq6JEXQmTdCdMcdKE=; b=NfiCKMOXXLzXSiHqQtYL6XeHm
        6mo8pYpAJf3rdBor+acqnZjJX7Zr9BNldK4zJA0RqojzhLXBmPGZ0wGxSrNYlKFsPXJ0wKpTlYhIY
        xr1rbvYE9DhOL46mm+cT+8PF1z/3yRVwZ8v2MYM5QSMg0Y8eJzoYuJ36bvARy6O7cKMjTA6KjBGj5
        F/I8Vgc7UDGE7ltMtAPPHSc30BBOPZEyuoj7msXd5G2vOEjIKAhHLzmBTjkmaz1Stt22kRPRbrboD
        6N3hppDqwXRgqrX4ivw5L1bYyambOTJN1BIrtb52/j/bvAuVka7nV/b6dFwDdIxJ5R4gmY2TYr+CO
        WWVt7vZOg==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isIxW-0005LR-JB; Fri, 17 Jan 2020 04:10:10 +0000
Subject: Re: [PATCH 4/5] virtio: introduce a vDPA based transport
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jakub.kicinski@netronome.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-5-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e71bdbfe-559c-e881-26d4-03080cee42ed@infradead.org>
Date:   Thu, 16 Jan 2020 20:10:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116124231.20253-5-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/16/20 4:42 AM, Jason Wang wrote:
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 9c4fdb64d9ac..b4276999d17d 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -43,6 +43,19 @@ config VIRTIO_PCI_LEGACY
>  
>  	  If unsure, say Y.
>  
> +config VIRTIO_VDPA
> +	tristate "vDPA driver for virtio devices"
> +	depends on VDPA && VIRTIO
> +	default n
> +	help
> +	  This driver provides support for virtio based paravirtual

	                                   virtio-based

> +	  device driver over vDPA bus. For this to be useful, you need
> +	  an appropriate vDPA device implementation that operates on a
> +          physical device to allow the datapath of virtio to be

use tab + 2 spaces above for indentation, not lots of spaces.

> +	  offloaded to hardware.
> +
> +	  If unsure, say M.
> +
>  config VIRTIO_PMEM
>  	tristate "Support for virtio pmem driver"
>  	depends on VIRTIO


-- 
~Randy

