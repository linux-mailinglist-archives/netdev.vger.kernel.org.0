Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE0991930F7
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgCYTQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:16:56 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:41741 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgCYTQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:16:55 -0400
Received: by mail-vk1-f194.google.com with SMTP id q8so1006052vka.8
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 12:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hVPS6ck2mwW3cLkOAy6o7QeijQEfZpDs1fTPD3JBZ1E=;
        b=iv52F78zk6Vs7RGp7ez9RlX7p1wE2SGhM4jg/CTDQ+mjK+g7XvA9pKAnkS9TwRLPdQ
         WOxj+TkkfI1b7MoFq36v5/Wpw3cJ4zV/Sj45p6zhRgqY+f0uqU+5jfZfv4BWzi4qxb0O
         tZbziPa8VfqLJOIdF7tMYbgzIBjv8ihQI8rv8lo2RrascUvwGHMR8kjaE6VOQfE3GtHz
         Qc+J9JtDRe8MKKevF7aujzYHcpEZubrkHRQzaZAmEpP17Rlxwe3dy76y3vHl4qsjggOm
         MAJYNoV+Ou17rzxFEx8xxODOlcgSDwd1S2nuxpouG2uEYdYK/Zc/ta/3y1Y45oj1tkuO
         hLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=hVPS6ck2mwW3cLkOAy6o7QeijQEfZpDs1fTPD3JBZ1E=;
        b=AaRAuSW8n99aV+x6+gXSLsoSYvy0BajI8SO1DYQNkXoFI8E2pwZhK6OAMziYUiVr0f
         ltEVTucx1CV6uyUpSM/csPvoRPvp8xEFDtWIyJ8P18MP9D9hrNXgENUHLTf9SyaPtxoC
         qRbOGylMQaaGhfZNdv7mLKXK4nldGNwEoAdY1u5NMRYfimSbFxvD5XIDPYtng+xwOF2n
         d0FAhdbw1k/SlFKOnadErC+aL8pF4S+/E4E7ra3ntNl7llB6ypSLfZLDCQxnOJXZ7qYN
         PG8Rkcb82LlKNl9skqoQXk8/jaa9nG5sBgJeZrzqJZ63xRdnfNoPCYGA8n4cYtr/+jUh
         1ZgQ==
X-Gm-Message-State: ANhLgQ0+sNnmJ7lFYzpzioNaCAVUFZV/2xM/rsBus1nR+p05cc+9/1DM
        Qq1P5jXf0Te6VjnmRKwQJ6UrDmGn4SehV22ijpdvoAbl
X-Google-Smtp-Source: ADFU+vvDzI94z6h5mDZqGcVLDi9Rfw4yyovMqFzyevqLbjHesmI4sHR3ZRzWxYoiiqQZbG+7UEVyPV0j2BKbk8LrPPo=
X-Received: by 2002:ac5:cd83:: with SMTP id i3mr3757164vka.58.1585163813073;
 Wed, 25 Mar 2020 12:16:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Wed, 25 Mar 2020 12:16:52
 -0700 (PDT)
X-Originating-IP: [5.35.40.234]
In-Reply-To: <20200325160211.1b887ca5@carbon>
References: <1585145575-14477-1-git-send-email-kda@linux-powerpc.org> <20200325160211.1b887ca5@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 25 Mar 2020 22:16:52 +0300
Message-ID: <CAOJe8K3fXBH-VBJXhVgm2ne6jFPup_J7xj=9K4v9e4xiw7Ujew@mail.gmail.com>
Subject: Re: [PATCH net-next] net: page pool: allow to pass zero flags to page_pool_init()
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Wed, 25 Mar 2020 17:12:55 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> page pool API can be useful for non-DMA cases like
>> xen-netfront driver so let's allow to pass zero flags to
>> page pool flags.
>>
>> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
>> ---
>>  net/core/page_pool.c | 36 +++++++++++++++++++-----------------
>>  1 file changed, 19 insertions(+), 17 deletions(-)
>
> The pool->p.dma_dir is only used when flag PP_FLAG_DMA_MAP is used, so
> it looks more simple to do:

Yeap, agreed. Thanks!

>
> $ git diff
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 626db912fce4..ef98372facf6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -43,9 +43,11 @@ static int page_pool_init(struct page_pool *pool,
>          * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
>          * which is the XDP_TX use-case.
>          */
> -       if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
> -           (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> -               return -EINVAL;
> +       if (pool->p.flags & PP_FLAG_DMA_MAP) {
> +               if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
> +                   (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> +                       return -EINVAL;
> +       }
>
>
>
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index 10d2b25..eeeb0d9 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -39,27 +39,29 @@ static int page_pool_init(struct page_pool *pool,
>>  	if (ring_qsize > 32768)
>>  		return -E2BIG;
>>
>> -	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
>> -	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
>> -	 * which is the XDP_TX use-case.
>> -	 */
>> -	if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>> -	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>> -		return -EINVAL;
>> -
>> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
>> -		/* In order to request DMA-sync-for-device the page
>> -		 * needs to be mapped
>> +	if (pool->p.flags) {
>> +		/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
>> +		 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
>> +		 * which is the XDP_TX use-case.
>>  		 */
>> -		if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>> +		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>> +		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>>  			return -EINVAL;
>>
>> -		if (!pool->p.max_len)
>> -			return -EINVAL;
>> +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
>> +			/* In order to request DMA-sync-for-device the page
>> +			 * needs to be mapped
>> +			 */
>> +			if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>> +				return -EINVAL;
>>
>> -		/* pool->p.offset has to be set according to the address
>> -		 * offset used by the DMA engine to start copying rx data
>> -		 */
>> +			if (!pool->p.max_len)
>> +				return -EINVAL;
>> +
>> +			/* pool->p.offset has to be set according to the address
>> +			 * offset used by the DMA engine to start copying rx data
>> +			 */
>> +		}
>>  	}
>>
>>  	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>
