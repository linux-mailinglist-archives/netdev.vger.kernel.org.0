Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACDF258600
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 05:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIADHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 23:07:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726044AbgIADHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 23:07:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598929626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NiMSZ2Bp0rwp10xCJBRx9TIWLthoqJ/GxVfGBmzS4Dk=;
        b=FFRfv6dirw3flLTjWX2gtKolwSSfxl85VRGWxQQ9PTmQwpRDI3nivSpHJf8FxSO77UQ4ja
        ycSTy7ZGfgUEDR5wai/eIXDD1LtJplbo0zywQw99Ya5nWypUgJ7gAncQQH6Tx/bmHtm/pL
        YZ43wEGJE2mYCBwhq29Gj7alTlF+l24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-G9NcSATZMni7qWSgOVtv-A-1; Mon, 31 Aug 2020 23:07:04 -0400
X-MC-Unique: G9NcSATZMni7qWSgOVtv-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE84C1888A1E;
        Tue,  1 Sep 2020 03:07:02 +0000 (UTC)
Received: from [10.72.13.164] (ovpn-13-164.pek2.redhat.com [10.72.13.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B891A7EB8A;
        Tue,  1 Sep 2020 03:06:57 +0000 (UTC)
Subject: Re: [PATCH net-next] vhost: fix typo in error message
To:     Yunsheng Lin <linyunsheng@huawei.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <26f844a5-c7de-cb0b-35eb-e6e30425ed35@redhat.com>
Date:   Tue, 1 Sep 2020 11:06:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1598927949-201997-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/1 上午10:39, Yunsheng Lin wrote:
> "enable" should be "disable" when the function name is
> vhost_disable_notify(), which does the disabling work.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   drivers/vhost/vhost.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5857d4e..b45519c 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2537,7 +2537,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
>   	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
>   		r = vhost_update_used_flags(vq);
>   		if (r)
> -			vq_err(vq, "Failed to enable notification at %p: %d\n",
> +			vq_err(vq, "Failed to disable notification at %p: %d\n",
>   			       &vq->used->flags, r);
>   	}
>   }


Acked-by: Jason Wang <jasowang@redhat.com>



