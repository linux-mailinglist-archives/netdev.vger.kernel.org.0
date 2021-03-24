Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED073347E59
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbhCXQ6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbhCXQ6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:58:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA19C061763;
        Wed, 24 Mar 2021 09:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=jafv0gazuyTSC4IKqAojqIlpdwE8g/2OqzXZ6qaK9qM=; b=Iw3KkCGuCbVP7EeFoTNUp8tgY7
        44scb4S8dhiLzP9qYq6wPSjp5gBcwJlndeZBulKYY1x9TTr5nF/SPQw02CoePrDI2wkXjuwB8r9NW
        Y7itHo0FqQdWQobekQwSvXKWpqmG3zSmgKUMXOD9TlXsGw6+bkag3GJcv6dYBDr6o+85YAlw9dj9l
        XI7JxQwILss9feYUyN+i6Q1jM5fOhSx80j0dOKCX5tXf7B86wuw3ZWhH8j7UJTwTpr3BNApONG001
        dQDf3Kv6qkukZwMmQVmfitp0X1Em+6hlF4qP+7ixiYT6UHgkqJYenm4FKMeigghZeKTcKxbBPPyhM
        m+kgdMcg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP6pN-00Bbg8-E0; Wed, 24 Mar 2021 16:58:02 +0000
Subject: Re: [PATCH net-next] 6lowpan: Fix some typos in nhc_udp.c
To:     Wang Hai <wanghai38@huawei.com>, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324062224.13032-1-wanghai38@huawei.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8b3f510f-3999-5775-e3b9-4720df77ad7a@infradead.org>
Date:   Wed, 24 Mar 2021 09:57:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324062224.13032-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 11:22 PM, Wang Hai wrote:
> s/Orignal/Original/
> s/infered/inferred/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/6lowpan/nhc_udp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/6lowpan/nhc_udp.c b/net/6lowpan/nhc_udp.c
> index 8a3507524f7b..33f17bd8cda7 100644
> --- a/net/6lowpan/nhc_udp.c
> +++ b/net/6lowpan/nhc_udp.c
> @@ -5,7 +5,7 @@
>   *	Authors:
>   *	Alexander Aring	<aar@pengutronix.de>
>   *
> - *	Orignal written by:
> + *	Original written by:
>   *	Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
>   *	Jon Smirl <jonsmirl@gmail.com>
>   */
> @@ -82,7 +82,7 @@ static int udp_uncompress(struct sk_buff *skb, size_t needed)
>  	if (fail)
>  		return -EINVAL;
>  
> -	/* UDP length needs to be infered from the lower layers
> +	/* UDP length needs to be inferred from the lower layers
>  	 * here, we obtain the hint from the remaining size of the
>  	 * frame
>  	 */
> 


-- 
~Randy

