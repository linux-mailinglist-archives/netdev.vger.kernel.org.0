Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3B23A9828
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhFPKzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231698AbhFPKzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623840779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c9F48oU5+bFnmZpTSygnLXDKFJhTTaB0FdhvJwlUGVo=;
        b=AbBK2i9Rr3sZouFhn+IuaBSBD1IFjl+yQeGWO5j9e8vIWPkECr4gzKCFgCv7gBiT0KpIKW
        90qH8b8DtMxIOXADN7DcX5iNao/NjUXd+vi7dPoOUMS/YlcP4RIErjkGCqSbUZU0hoHiOJ
        QTdHXn8Cefhp8PEh1c21UAoGfj9Q8JM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-w5p6DPP5MjemYnMUCAnBnA-1; Wed, 16 Jun 2021 06:52:56 -0400
X-MC-Unique: w5p6DPP5MjemYnMUCAnBnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91BB6107ACF6;
        Wed, 16 Jun 2021 10:52:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4F25D703;
        Wed, 16 Jun 2021 10:52:47 +0000 (UTC)
Date:   Wed, 16 Jun 2021 12:52:46 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     brouer@redhat.com, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] samples/bpf: Add missing option to xdp_fwd
 usage
Message-ID: <20210616125246.2a74c069@carbon>
In-Reply-To: <20210615135554.29158-1-wanghai38@huawei.com>
References: <20210615135554.29158-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 21:55:54 +0800
Wang Hai <wanghai38@huawei.com> wrote:

> xdp_fwd usage() is missing the introduction of the "-S"
> and "-F" options, this patch adds it.
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  samples/bpf/xdp_fwd_user.c | 2 ++
>  1 file changed, 2 insertions(+)


Fixes: d50ecc46d18f ("samples/bpf: Attach XDP programs in driver mode by default")

LGTM but please add "Fixes:" tag next time, I think patchwork will pick
this up via this reply.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index 74a4583d0d86..00061261a8da 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -67,6 +67,8 @@ static void usage(const char *prog)
>  		"usage: %s [OPTS] interface-list\n"
>  		"\nOPTS:\n"
>  		"    -d    detach program\n"
> +		"    -S    use skb-mode\n"
> +		"    -F    force loading prog\n"
>  		"    -D    direct table lookups (skip fib rules)\n",
>  		prog);
>  }
    -


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

