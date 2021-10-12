Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C028A42A67D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236853AbhJLN53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJLN52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:57:28 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76F6C061570;
        Tue, 12 Oct 2021 06:55:26 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id w11so18501634ilv.6;
        Tue, 12 Oct 2021 06:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tHfaoDZl2aKS3pIJDtjv61N4CXjaQvKyjIgaX+6126o=;
        b=WDtYAi+8vqWZQuqZUnRJaDElSisB9WHcH15ldknaudyKbnIH28LsYU6yKm+CE9ahle
         rbKAuXNZ1CJNrcuSBtbfDWrgYa6fdbDPZay+O1gVYilERaB/QWBw6pMCMKBiWiqY70ZM
         +E32u2XcmNv5Jvex5TX8R2EP9tpxU7AxBpZfEYJQq8BIlGosR1692D6ry7/m/phB/fTj
         luRzdF1hD5gMRivh/pEH+g8igBox3UWWu4UnxiSPqzQiU8Vz07YUyff3mNsIONMarz2B
         u+4uZyReBAW2QMiDlzKpJwxx9/BjCO8S0d+V1XKnjAZYsMapfTWQXwJD82KZCRSSIdKu
         FjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tHfaoDZl2aKS3pIJDtjv61N4CXjaQvKyjIgaX+6126o=;
        b=g5R/Udge1WloWxhsDjDnk4FdCK/X0FmyP0HPjK8QBVwuI94rnAywr6RBG7RRYSV130
         xCO0hLXsaorYKSiTS8OkQZSv+QrSbVhnSR2Kj3BLeg6T8m18NxVuXloIQ3ha6waUNb0+
         APBP9CdZgJsmJKgLwBxrAKJ2vmO4Y+0CayC9LfXNfsBAjg2nA2IqLyXLmikbuEKESaE8
         kpErvQGr3E79cOX98xbW1CKwG2cvrfAt9H64FkwC8CZhhk6YpQULZiKrOJNjz6jgua4L
         sZubdz6OqU9oDPXhdjMHfllvhoT6kIJ2Ao+3q1uBHDKw3fB+Il15X6X4tSCi+rfu+E2M
         gkMQ==
X-Gm-Message-State: AOAM532fXxtw2fvSq3COUkcGTuGauyf+aVSZM/bmXa6Z7i6b8Vz+xbRM
        glUWsb5+8tQit0qeThE8eHCoCpdVe0zhiw==
X-Google-Smtp-Source: ABdhPJya7Rzl4jISSA8QShEp7dZnOVuWi1cgPowSWRS001XFnLMZ1722TKDbHUC1HDK9Jnr4lrHuBA==
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr5346570ili.240.1634046926149;
        Tue, 12 Oct 2021 06:55:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id s18sm3384357ilo.14.2021.10.12.06.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 06:55:25 -0700 (PDT)
Subject: Re: [PATCH] ipv4: only allow increasing fib_info_hash_size
To:     zhang kai <zhangkaiheb@126.com>, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211012110658.10166-1-zhangkaiheb@126.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <23911752-3971-0230-cfd2-f8e30e8805db@gmail.com>
Date:   Tue, 12 Oct 2021 07:55:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012110658.10166-1-zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 5:06 AM, zhang kai wrote:
> and when failed to allocate memory, check fib_info_hash_size.


what problem are you trying to solve?



> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv4/fib_semantics.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index a632b66bc..7547708a9 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -1403,17 +1403,20 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>  
>  		if (!new_size)
>  			new_size = 16;
> -		bytes = new_size * sizeof(struct hlist_head *);
> -		new_info_hash = fib_info_hash_alloc(bytes);
> -		new_laddrhash = fib_info_hash_alloc(bytes);
> -		if (!new_info_hash || !new_laddrhash) {
> -			fib_info_hash_free(new_info_hash, bytes);
> -			fib_info_hash_free(new_laddrhash, bytes);
> -		} else
> -			fib_info_hash_move(new_info_hash, new_laddrhash, new_size);
> -
> -		if (!fib_info_hash_size)
> -			goto failure;
> +
> +		if (new_size > fib_info_hash_size) {
> +			bytes = new_size * sizeof(struct hlist_head *);
> +			new_info_hash = fib_info_hash_alloc(bytes);
> +			new_laddrhash = fib_info_hash_alloc(bytes);
> +			if (!new_info_hash || !new_laddrhash) {
> +				fib_info_hash_free(new_info_hash, bytes);
> +				fib_info_hash_free(new_laddrhash, bytes);
> +
> +				if (!fib_info_hash_size)
> +					goto failure;
> +			} else
> +				fib_info_hash_move(new_info_hash, new_laddrhash, new_size);
> +		}
>  	}
>  
>  	fi = kzalloc(struct_size(fi, fib_nh, nhs), GFP_KERNEL);
> 

