Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A1E1402CF
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAQEMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:12:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39308 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgAQEMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:12:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hwLIua86PNTC41LUY82iqhVgk61ShX0Wj3SYZmEoFz0=; b=c0TN64CssfTFt/FopsUOaMpIU
        BGibgXd6TlDMasJwluNoaXq+aMXgm9gfTYQgaoFljMTukFaIF02DnZrQIAWzDqkZTlTGwUBo4oMU/
        vrhIsE9tPfq74231UwcDfdUq02y0JXq3IZImp+Abl4Jps59XFD5MXFm77PlyIPMlyQij2FZzgWR5X
        4NYuhtlEOs/oZ+rugGvI7N6Y/KPeCuKJYga2e2FrS+UnUCu4QvJF2kCEeLCYCu0H2hXi30+2OkPar
        bmcQq675YS8muXsCQnBIrZIT6412nxUkYQ3a1SWU3o7iDR3mn0CCn3toov16CiYpCX6iFTAgCNazx
        Pj5QYZHwQ==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isIzW-0006pj-To; Fri, 17 Jan 2020 04:12:14 +0000
Subject: Re: [PATCH 5/5] vdpasim: vDPA device simulator
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
 <20200116124231.20253-6-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <55d84df0-803a-a81f-b49f-2d6fe8f78b96@infradead.org>
Date:   Thu, 16 Jan 2020 20:12:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116124231.20253-6-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 4:42 AM, Jason Wang wrote:
> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
> index 3032727b4d98..12ec25d48423 100644
> --- a/drivers/virtio/vdpa/Kconfig
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -7,3 +7,20 @@ config VDPA
>            datapath which complies with virtio specifications with
>            vendor specific control path.
>  
> +menuconfig VDPA_MENU
> +	bool "VDPA drivers"
> +	default n
> +
> +if VDPA_MENU
> +
> +config VDPA_SIM
> +	tristate "vDPA device simulator"
> +        select VDPA
> +        default n
> +        help
> +          vDPA networking device simulator which loop TX traffic back

	                                            loops

> +          to RX. This device is used for testing, prototyping and
> +          development of vDPA.
> +
> +endif # VDPA_MENU

Most lines above use spaces for indentation, while they should use
tab + 2 spaces.

-- 
~Randy

