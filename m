Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F70726A01D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIOHrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 03:47:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726245AbgIOHrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 03:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600156047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTp+0adIMlkbx1qsm74sDSR5UPl/diwwLvQ0udN7+Fk=;
        b=af4xiQMw5E9QQouDc7hzi0+ttmztTPTpUiSWOViXgAz6g6mCl26ziyPoZRjuIUjBDkzSdi
        mltPDIxjuVLojtKtZ9XcTcrTK7DJIyHrHpJSiBx22VmfJnliogdl6uSceo9VAtKbE1LwfE
        aySbLk38SnsRoprd68uDaxNGsGIB0Y4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-bFYMHfc7Pzm1PAvS72QZsQ-1; Tue, 15 Sep 2020 03:47:25 -0400
X-MC-Unique: bFYMHfc7Pzm1PAvS72QZsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CD638030C7;
        Tue, 15 Sep 2020 07:47:24 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3093B27BC0;
        Tue, 15 Sep 2020 07:47:17 +0000 (UTC)
Subject: Re: [PATCH] vhost_vdpa: Fix duplicate included kernel.h
To:     Tian Tao <tiantao6@hisilicon.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Cc:     linuxarm@huawei.com
References: <1600131102-24672-1-git-send-email-tiantao6@hisilicon.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d351bfb1-bc39-c63b-2124-29dcafe017ee@redhat.com>
Date:   Tue, 15 Sep 2020 15:47:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600131102-24672-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/15 上午8:51, Tian Tao wrote:
> linux/kernel.h is included more than once, Remove the one that isn't
> necessary.
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>   drivers/vhost/vdpa.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f..95e2b83 100644
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


