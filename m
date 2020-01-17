Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9391402E8
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 05:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgAQEQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 23:16:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgAQEQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 23:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7VKPSEClUB+tWGnzrvYaTHzOiMMd/kHZruURBfe+vnQ=; b=jN2CClEPnQYyeT9d4eZTEly4Q
        PmwTMa1GHHZMQDhhZRvpnenpCM+rSaUkDkHg9autZMAAJpClo7O5UAqHwrHQKv/LSHvOW4UneLkhU
        wraVQkBqdWv1Dqpqj3dCFu/beIIEmY9sihhuvTCdUBqWPiRQGDci7Tb7nA9aDHA9aypkuViytEkRH
        R8pUNv8riHnvy75XurQR54VLLrlZMdUyVdBRlk7bqrSAAoaNmWCmNlsa0akoYdVs0zOeNBcwRauAH
        zaC2oppm1GNAs7Rr9GTaLjn1OsNufPITzOKDd+jhVoUdR0Kp98KiUxM9rFuW/cdsMOvXqdj/rnWl1
        D0kYByIPw==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1isJ3i-0008MQ-Gv; Fri, 17 Jan 2020 04:16:34 +0000
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
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
 <20200116124231.20253-4-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3d0951af-a854-3b4a-99e4-d501a7fa7a9c@infradead.org>
Date:   Thu, 16 Jan 2020 20:16:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200116124231.20253-4-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 4:42 AM, Jason Wang wrote:
> diff --git a/drivers/virtio/vdpa/Kconfig b/drivers/virtio/vdpa/Kconfig
> new file mode 100644
> index 000000000000..3032727b4d98
> --- /dev/null
> +++ b/drivers/virtio/vdpa/Kconfig
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config VDPA
> +	tristate
> +        default n
> +        help
> +          Enable this module to support vDPA device that uses a

	                                        devices

> +          datapath which complies with virtio specifications with
> +          vendor specific control path.
> +

Use tab + 2 spaces for Kconfig indentation.

-- 
~Randy

