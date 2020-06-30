Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B6020ED97
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgF3FdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:33:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725887AbgF3FdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593495195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEuLRzXmEdahiAKGpnL+nVeF0sdlBPCkwM2Y/fcvgk0=;
        b=Ygtfj/6+dCK2ufcHizC1eU70a4zi1jBsZYbqYHvAt4Tu2PmC7UWIhf4WB0Y2TrG51rsRpH
        isSz2irQgBfNT2gAHmwzUt7ysDGBMGY1eQpGakYBlZYTPnZ1DiNNQw7Rdf+eUOrVFH3riI
        ayxu5IVv+q7tMJ2jMIMm1EGCxrXQfgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-svVRFDr_OByaxAGU_0jUjA-1; Tue, 30 Jun 2020 01:33:10 -0400
X-MC-Unique: svVRFDr_OByaxAGU_0jUjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C5121800D42;
        Tue, 30 Jun 2020 05:33:09 +0000 (UTC)
Received: from [10.72.13.159] (ovpn-13-159.pek2.redhat.com [10.72.13.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFE2F10013C1;
        Tue, 30 Jun 2020 05:33:05 +0000 (UTC)
Subject: Re: [PATCH] vhost: Fix documentation
To:     Eli Cohen <eli@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20200630052925.GA157062@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <dc269512-8f59-4389-4b7f-bec034d66bfa@redhat.com>
Date:   Tue, 30 Jun 2020 13:33:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630052925.GA157062@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/30 下午1:29, Eli Cohen wrote:
> Fix documentation to match actual function prototypes
>
> "end" used instead of "last". Fix that.
>
> Signed-off-by: Eli Cohen <eli@mellanox.com>
> ---


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>   drivers/vhost/iotlb.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 1f0ca6e44410..0d4213a54a88 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_free);
>    * vhost_iotlb_itree_first - return the first overlapped range
>    * @iotlb: the IOTLB
>    * @start: start of IOVA range
> - * @end: end of IOVA range
> + * @last: last byte in IOVA range
>    */
>   struct vhost_iotlb_map *
>   vhost_iotlb_itree_first(struct vhost_iotlb *iotlb, u64 start, u64 last)
> @@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_itree_first);
>    * vhost_iotlb_itree_first - return the next overlapped range
>    * @iotlb: the IOTLB
>    * @start: start of IOVA range
> - * @end: end of IOVA range
> + * @last: last byte IOVA range
>    */
>   struct vhost_iotlb_map *
>   vhost_iotlb_itree_next(struct vhost_iotlb_map *map, u64 start, u64 last)

