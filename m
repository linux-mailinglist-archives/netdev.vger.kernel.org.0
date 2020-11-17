Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2142B56BC
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgKQCaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:30:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726512AbgKQCaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605580205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CmZ1mGxlAVYrel/KK7OgqUxp4N3oZUIGmB1egO/JG/0=;
        b=W1bcZiRuFYzkNidavFq+0znMaIfQfhmnH5Y3OeCS9iLhrqI8vZzh7XbeULemi9hIdHS/dv
        is432aE2lxmPW1rZtJXkGnlrcn9wiwHGrVhfX2btWxFyBraP9O9UHAgjUrHJvGRAkmRCqL
        w1BN8RiIqEGWWx5IPWiT5oRIEA2605E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-M2lvSCNmNwiLwy4MuK1gcQ-1; Mon, 16 Nov 2020 21:30:03 -0500
X-MC-Unique: M2lvSCNmNwiLwy4MuK1gcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91968107ACF5;
        Tue, 17 Nov 2020 02:30:02 +0000 (UTC)
Received: from [10.72.13.201] (ovpn-13-201.pek2.redhat.com [10.72.13.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B214760C04;
        Tue, 17 Nov 2020 02:29:57 +0000 (UTC)
Subject: Re: [PATCH] vringh: fix vringh_iov_push_*() documentation
To:     Stefano Garzarella <sgarzare@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201116161653.102904-1-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3aa02874-1c7f-d516-b80b-c79b33c0b1fd@redhat.com>
Date:   Tue, 17 Nov 2020 10:29:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116161653.102904-1-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/17 上午12:16, Stefano Garzarella wrote:
> vringh_iov_push_*() functions don't have 'dst' parameter, but have
> the 'src' parameter.
>
> Replace 'dst' description with 'src' description.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vringh.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 8bd8b403f087..b7403ba8e7f7 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -730,7 +730,7 @@ EXPORT_SYMBOL(vringh_iov_pull_user);
>   /**
>    * vringh_iov_push_user - copy bytes into vring_iov.
>    * @wiov: the wiov as passed to vringh_getdesc_user() (updated as we consume)
> - * @dst: the place to copy.
> + * @src: the place to copy from.
>    * @len: the maximum length to copy.
>    *
>    * Returns the bytes copied <= len or a negative errno.
> @@ -976,7 +976,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
>   /**
>    * vringh_iov_push_kern - copy bytes into vring_iov.
>    * @wiov: the wiov as passed to vringh_getdesc_kern() (updated as we consume)
> - * @dst: the place to copy.
> + * @src: the place to copy from.
>    * @len: the maximum length to copy.
>    *
>    * Returns the bytes copied <= len or a negative errno.
> @@ -1333,7 +1333,7 @@ EXPORT_SYMBOL(vringh_iov_pull_iotlb);
>    * vringh_iov_push_iotlb - copy bytes into vring_iov.
>    * @vrh: the vring.
>    * @wiov: the wiov as passed to vringh_getdesc_iotlb() (updated as we consume)
> - * @dst: the place to copy.
> + * @src: the place to copy from.
>    * @len: the maximum length to copy.
>    *
>    * Returns the bytes copied <= len or a negative errno.

