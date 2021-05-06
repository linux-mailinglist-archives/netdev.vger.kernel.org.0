Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900C8374DDF
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 05:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbhEFDSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 23:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhEFDSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 23:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620271058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mHcgWqiBds5lBtditwajbBOEjZ3IZCTkxDstlE/eLZI=;
        b=AF/jtVFXxAfeuNk7RSln6Ub7VTH5fBYAj/Bd5z18bmSPjs2yxI0EEASW6R4nPi93AwQ1D3
        LhUs2t64mejMzX7wCYuhrnPT8KCA/iHIKbuGybH5ufTi4ruFf1aXr/5KajPBGZ+VTZy/gc
        hk1RpHuLK17m2U+KbfFmGXyLyXZOPgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-hfWxXVjoNJ6ug_c-ehhd0g-1; Wed, 05 May 2021 23:17:35 -0400
X-MC-Unique: hfWxXVjoNJ6ug_c-ehhd0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E2E71006C80;
        Thu,  6 May 2021 03:17:34 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD130BA6F;
        Thu,  6 May 2021 03:17:28 +0000 (UTC)
Subject: Re: [PATCH] vhost-iotlb: fix vhost_iotlb_del_range() documentation
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210504135444.158716-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <93e4cb04-105e-e853-e2b6-d95435ca55f2@redhat.com>
Date:   Thu, 6 May 2021 11:17:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210504135444.158716-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/4 ÏÂÎç9:54, Stefano Garzarella Ð´µÀ:
> Trivial change for the vhost_iotlb_del_range() documentation,
> fixing the function name in the comment block.
>
> Discovered with `make C=2 M=drivers/vhost`:
> ../drivers/vhost/iotlb.c:92: warning: expecting prototype for vring_iotlb_del_range(). Prototype was for vhost_iotlb_del_range() instead
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---


Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/vhost/iotlb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 0fd3f87e913c..0582079e4bcc 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -83,7 +83,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
>   EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
>   
>   /**
> - * vring_iotlb_del_range - delete overlapped ranges from vhost IOTLB
> + * vhost_iotlb_del_range - delete overlapped ranges from vhost IOTLB
>    * @iotlb: the IOTLB
>    * @start: start of the IOVA range
>    * @last: last of IOVA range

