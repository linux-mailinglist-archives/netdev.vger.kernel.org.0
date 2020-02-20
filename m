Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C0B165616
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 05:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgBTEJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 23:09:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBTEJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 23:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=CsxfWzTNcRqW4gQltRNanmog3EEMxaevUToNMDOBQ8w=; b=RODBwJwvlGrJzqmcQaeZc2Jm6N
        ZEuJ77jFO1YGZDUmQvQ1/r1BkPMfgZYARqUIZgUDKgaNhAr7Thex9GNa2ME8vTF6Z4JnKMYSdxlaC
        V/lecE7apa1yPaYnrCHA+R71OjdQxASztSXQsQM2gd8BjgHyIo8p5FipS996JxP81yGtzBftB7gWE
        9cps4rc3QapE0okZawwtBWhLNXzix7eM8DpXK3dWcgPehNN0wcuUNrIp62n7wwPhV9qlrLVz1Ner0
        UY5Wv9pu+5O5wt30tmtPZ9yEh+PZs3/q7SQ32VjZr22lvVQ8vaTZEq0YpE8bA/PgGDmf4Ml9mEp1w
        BJtl64rg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4d9O-0001lJ-Kb; Thu, 20 Feb 2020 04:09:22 +0000
Subject: Re: [PATCH V3 5/5] vdpasim: vDPA device simulator
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200220035650.7986-1-jasowang@redhat.com>
 <20200220035650.7986-6-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ee917060-da84-e94d-df99-208100345b14@infradead.org>
Date:   Wed, 19 Feb 2020 20:09:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220035650.7986-6-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 7:56 PM, Jason Wang wrote:
> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
> index 7a99170e6c30..e3656b722654 100644
> --- a/drivers/virtio/vdpa/Kconfig
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -7,3 +7,21 @@ config VDPA
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
> +        depends on RUNTIME_TESTING_MENU
> +        default n
> +        help
> +          vDPA networking device simulator which loop TX traffic back
> +          to RX. This device is used for testing, prototyping and
> +          development of vDPA.
> +
> +endif # VDPA_MENU
> +

Use 1 tab for indentation for tristate/select/depends/default/help,
and then 1 tab + 2 spaces for help text.

-- 
~Randy

