Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4398B3A9834
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhFPK6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:58:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231698AbhFPK6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623840964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ljxixY8CnS7LYT8j9VkYB8Ywtpo5H0tVhPE5QC8Gac=;
        b=dXfDEnGxuHpmyHmFeKOhkDngcXLT0JITfVuOMhZypltssIIOSAXXUbJ14mehIJwuBmeiET
        7TUspETSJ6PAjX3Hgk8IU5HuvMLOC8k7GokBWZJhJ8Vzapdb7zMZ59PVQlMVht6nij3tVz
        Kl3PmhHydthOiDq3Dt9AcB6VdK3SPI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-a1JLw-PHO7aTE2082gTNBQ-1; Wed, 16 Jun 2021 06:56:00 -0400
X-MC-Unique: a1JLw-PHO7aTE2082gTNBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A8E8107ACF6;
        Wed, 16 Jun 2021 10:55:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9357F60BF1;
        Wed, 16 Jun 2021 10:55:52 +0000 (UTC)
Date:   Wed, 16 Jun 2021 12:55:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     brouer@redhat.com, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] samples/bpf: Add missing option to
 xdp_sample_pkts usage
Message-ID: <20210616125550.2f0e2544@carbon>
In-Reply-To: <20210615135724.29528-1-wanghai38@huawei.com>
References: <20210615135724.29528-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 21:57:24 +0800
Wang Hai <wanghai38@huawei.com> wrote:

> xdp_sample_pkts usage() is missing the introduction of the
> "-S" option, this patch adds it.
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  samples/bpf/xdp_sample_pkts_user.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Fixes: d50ecc46d18f ("samples/bpf: Attach XDP programs in driver mode by default")

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
 
> diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
> index 706475e004cb..495e09897bd3 100644
> --- a/samples/bpf/xdp_sample_pkts_user.c
> +++ b/samples/bpf/xdp_sample_pkts_user.c
> @@ -103,7 +103,8 @@ static void usage(const char *prog)
>  	fprintf(stderr,
>  		"%s: %s [OPTS] <ifname|ifindex>\n\n"
>  		"OPTS:\n"
> -		"    -F    force loading prog\n",
> +		"    -F    force loading prog\n"
> +		"    -S    use skb-mode\n",
>  		__func__, prog);
>  }
>  

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

