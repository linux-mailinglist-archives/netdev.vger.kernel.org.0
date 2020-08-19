Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275B824931B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgHSCzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30764 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbgHSCzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 22:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597805744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzuFejnUa6/7SvIdePc4Dxw6u4PQ7TGHV2322mPlU3g=;
        b=CVfo1jb12pGm3N322xw68h2JnJn0JtfG0OOP57oSMsOxgxU0MEKMU+CMGxdRhwkxBsbgA5
        SaYTsqOdGxqqLthUhLAHT1O03FCkbhgIb0TB6UwfbBTNTMP7mdQTFZBOYmukb8IF94LJGB
        xq+LmKy0YwL9QooMI0kldR32TZ63LVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-oPiGWvAuMPyaXe1nKkF9KA-1; Tue, 18 Aug 2020 22:55:40 -0400
X-MC-Unique: oPiGWvAuMPyaXe1nKkF9KA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 817141DDF4;
        Wed, 19 Aug 2020 02:55:39 +0000 (UTC)
Received: from [10.72.13.88] (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22C73BA63;
        Wed, 19 Aug 2020 02:55:33 +0000 (UTC)
Subject: Re: [PATCH -next] vdpa: Remove duplicate include
To:     YueHaibing <yuehaibing@huawei.com>, mst@redhat.com,
        tiwei.bie@intel.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200818114906.58304-1-yuehaibing@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <13e0a08e-abda-9b0d-53b0-03f6948a80f3@redhat.com>
Date:   Wed, 19 Aug 2020 10:55:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818114906.58304-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/8/18 下午7:49, YueHaibing wrote:
> Remove duplicate include file
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/vhost/vdpa.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..95e2b8307a2a 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -22,7 +22,6 @@
>   #include <linux/nospec.h>
>   #include <linux/vhost.h>
>   #include <linux/virtio_net.h>
> -#include <linux/kernel.h>
>   
>   #include "vhost.h"
>   


Acked-by: Jason Wang <jasowang@redhat.com>


