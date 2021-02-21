Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0995B32080A
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 02:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhBUByx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 20:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhBUByv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 20:54:51 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F0AC061574;
        Sat, 20 Feb 2021 17:54:11 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id o3so673381oic.8;
        Sat, 20 Feb 2021 17:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2YeG2HTU6ffO0nhsXtBfvb2LSJCOeXJuMNGMXF/3az4=;
        b=LyqUox4giymneLKtYSf9GSOLBlfSZAqrA47Y54NRxAJDnqQKWi+TEZlKclVIaodEsC
         +i1OierxMLQDRH4YfySHAz4FCz2dQksO/uEsgk8kq7n/Ot5+63l2rHUWkXTmMIKa51rm
         3v2f4QIKJScvULohfCGv36QmGsIO9BidKPmXyZDOQgFN9BZiUu1ywDR1J/zZm2ZggRHF
         pwGW5mjE4+wmV7ZQgy4x6oglMG2MG3Oa+/T5nGRyv6FjuQ231wUPzpxMlx9OkN6GbgcH
         THFs/low3d0mK+1iWXLkqkKbbHyYYUDZpqBLvHwkLD4bee+R5o5nVGr28gaUeNKl9Ewr
         apvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2YeG2HTU6ffO0nhsXtBfvb2LSJCOeXJuMNGMXF/3az4=;
        b=N8oMo/vzEZdHTlMhW6uBp8o20xhLMqc+XEj7iZlw4FawWhxNSDafX+Apk0Rl9QdmTg
         R5gsJLNW19WakJ2wCQNsWcYzM9T5HNCFgDAfHf2htPcjRGB97kOdBC4E5otCqLjsLi4N
         YCMnH4UH7hLr0QVQzU1wiXGRH8qiQJr/fWGao50lWJW99X4ApCzU0uc/u4pu7heNBWqS
         RKLLPxrp1bUioz70OkfomtfNZNIEvpxzsYlMVlv3DLJbkf/5WWw+1DxUNOkDMjUumRJE
         EUqjWacupionuGLMYqdDt0ZtimKLDksXO7Wgn+Prfp3ocRjgx5ks2LgryuHpAjUoFJHf
         wkpA==
X-Gm-Message-State: AOAM531O0rkYhDMR1VhnUKI37emynjtYZJDtrqvqKwmDlKDnpnLc3HRo
        6hp/A4Z0z+dgnsOanfVEh8nFMT6fp8k=
X-Google-Smtp-Source: ABdhPJwSZ27T8bbKpU/QWqVD1FJUkG4mOApvpKQtffWBuj4z5BRnc6InlACNoR4nieRmVJaphWgegw==
X-Received: by 2002:aca:f5d4:: with SMTP id t203mr150123oih.132.1613872450283;
        Sat, 20 Feb 2021 17:54:10 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id g6sm2656423ooh.29.2021.02.20.17.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 17:54:09 -0800 (PST)
Subject: Re: [PATCH] arp: Remove the arp_hh_ops structure
To:     Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210220043203.11754-1-yejune.deng@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3b69191b-9bd5-9050-9126-17b4905a67e9@gmail.com>
Date:   Sat, 20 Feb 2021 18:54:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210220043203.11754-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/21 9:32 PM, Yejune Deng wrote:
>  static const struct neigh_ops arp_direct_ops = {
>  	.family =		AF_INET,
>  	.output =		neigh_direct_output,
> @@ -277,15 +269,10 @@ static int arp_constructor(struct neighbour *neigh)
>  			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
>  		}
>  
> -		if (dev->header_ops->cache)
> -			neigh->ops = &arp_hh_ops;
> -		else
> -			neigh->ops = &arp_generic_ops;

How did you test this?

you took out the neigh->ops assignment, so all of the neigh->ops in
net/core/neighbour.c are going to cause a NULL dereference.


> -
> -		if (neigh->nud_state & NUD_VALID)
> -			neigh->output = neigh->ops->connected_output;
> +		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
> +			neigh->output = arp_generic_ops.connected_output;
>  		else
> -			neigh->output = neigh->ops->output;
> +			neigh->output = arp_generic_ops.output;
>  	}
>  	return 0;
>  }
> 

