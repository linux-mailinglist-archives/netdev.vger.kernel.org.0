Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169023A6CED
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhFNRT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbhFNRT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:19:57 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6BCC061574;
        Mon, 14 Jun 2021 10:17:54 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s26so11284850ioe.9;
        Mon, 14 Jun 2021 10:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YxPDELQZv5KQu91nvNkyWlai5VfpWwl2aTEBH7Wb1nc=;
        b=XDOaJdAnxxwX4agHirquiySlTlcaoMZX64px5SotcIJSUajAYiiT1OKggH78t8C210
         t0x9VuqpeLUmPJTZ4yt0aD/uemDAQTxAEGDhbSlGR7squXnzFmDhZUeT6WdyPtZk8n8y
         mz3ewakUYJjsr2KnNUL3d0ioOPo0vI69edcxyyRf8fc654RnC51xN9EGlnvFOwRBu7On
         xl/BuqD3/jVk9j+fEmFmL8Az47Ow/d4RGTGnq10zxYqXcp5g1ldj5qZrC4M2ssyEeUZ8
         F2z5gRrwfLWjYn+TIefrWatNy4q7uSTJLfd4nomU9fmYABT+qet1weDZwnGdFT2BhwYP
         ucBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxPDELQZv5KQu91nvNkyWlai5VfpWwl2aTEBH7Wb1nc=;
        b=Td2mBwsyj8DVw9vGYCR3PdhMT+jg+GvKa/FXZQQhILknmfrN0Jzqa0Sm+J6tPwIAjy
         RMeetoDsGHLXDUzIxH5J7Qy45gNrW2ITpncYqK+mt2MxqgWJ0lwkCui3zgXLiE7e8QKv
         0DDFzOHlFewKvZ3mvShNGlmwpGZvW3Xy70sAFBRT4bCug+EzQ0MIRpk26vGM6HNbP1F0
         989hacwObxL5/dDmfFzdDXZhbP84evf8640t/IInF/ytLxpei43OsZOIW91VHRVLDV+1
         5S1oMEUAeo0F6O7LhjXL/dt2gz4WwApjk6NVTbTH2tu3uJ/orJrlRKULCwEPLerQTWQO
         NMzA==
X-Gm-Message-State: AOAM531d4wQi+fe0QUcUJZOrbcTWUWaJMM9LobBfeCp6wpeXJVtpHt1u
        2HXOSk6/NqSlGvWtsw77JgzOlxf/TXIvndedtOs=
X-Google-Smtp-Source: ABdhPJy+yWiwE0T4hi6fct+9hbPY7t+9S9Yah7kKj7u+SKnI66SWvlSYDkK7wuVr8Vm/Dt3DFDgda6G5xeewQfye+2s=
X-Received: by 2002:a6b:287:: with SMTP id 129mr15514482ioc.182.1623691073584;
 Mon, 14 Jun 2021 10:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210610115058.3779341-1-libaokun1@huawei.com>
In-Reply-To: <20210610115058.3779341-1-libaokun1@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Jun 2021 19:17:47 +0200
Message-ID: <CAOi1vP8rH-Ehq+_4zS7upkqvrdSJjiZw_qCMNomii1vmJ9C=Cw@mail.gmail.com>
Subject: Re: [PATCH -next] libceph: fix doc warnings in cls_lock_client.c
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, yangjihong1@huawei.com,
        yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 1:41 PM Baokun Li <libaokun1@huawei.com> wrote:
>
> Add description to fixes the following W=1 kernel build warning(s):
>
>  net/ceph/cls_lock_client.c:28: warning: Function parameter or
>   member 'osdc' not described in 'ceph_cls_lock'
>  net/ceph/cls_lock_client.c:28: warning: Function parameter or
>   member 'oid' not described in 'ceph_cls_lock'
>  net/ceph/cls_lock_client.c:28: warning: Function parameter or
>   member 'oloc' not described in 'ceph_cls_lock'
>
>  net/ceph/cls_lock_client.c:93: warning: Function parameter or
>   member 'osdc' not described in 'ceph_cls_unlock'
>  net/ceph/cls_lock_client.c:93: warning: Function parameter or
>   member 'oid' not described in 'ceph_cls_unlock'
>  net/ceph/cls_lock_client.c:93: warning: Function parameter or
>   member 'oloc' not described in 'ceph_cls_unlock'
>
>  net/ceph/cls_lock_client.c:143: warning: Function parameter or
>   member 'osdc' not described in 'ceph_cls_break_lock'
>  net/ceph/cls_lock_client.c:143: warning: Function parameter or
>   member 'oid' not described in 'ceph_cls_break_lock'
>  net/ceph/cls_lock_client.c:143: warning: Function parameter or
>   member 'oloc' not described in 'ceph_cls_break_lock'
>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  net/ceph/cls_lock_client.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> index 17447c19d937..82b7f3e3862f 100644
> --- a/net/ceph/cls_lock_client.c
> +++ b/net/ceph/cls_lock_client.c
> @@ -10,7 +10,9 @@
>
>  /**
>   * ceph_cls_lock - grab rados lock for object
> - * @oid, @oloc: object to lock
> + * @osdc: working on this ceph osd client
> + * @oid: object to lock
> + * @oloc: object to lock
>   * @lock_name: the name of the lock
>   * @type: lock type (CEPH_CLS_LOCK_EXCLUSIVE or CEPH_CLS_LOCK_SHARED)
>   * @cookie: user-defined identifier for this instance of the lock
> @@ -82,7 +84,9 @@ EXPORT_SYMBOL(ceph_cls_lock);
>
>  /**
>   * ceph_cls_unlock - release rados lock for object
> - * @oid, @oloc: object to lock
> + * @osdc: working on this ceph osd client
> + * @oid: object to lock
> + * @oloc: object to lock
>   * @lock_name: the name of the lock
>   * @cookie: user-defined identifier for this instance of the lock
>   */
> @@ -130,7 +134,9 @@ EXPORT_SYMBOL(ceph_cls_unlock);
>
>  /**
>   * ceph_cls_break_lock - release rados lock for object for specified client
> - * @oid, @oloc: object to lock
> + * @osdc: working on this ceph osd client
> + * @oid: object to lock
> + * @oloc: object to lock
>   * @lock_name: the name of the lock
>   * @cookie: user-defined identifier for this instance of the lock
>   * @locker: current lock owner

Applied with a minor tweak.

Thanks,

                Ilya
