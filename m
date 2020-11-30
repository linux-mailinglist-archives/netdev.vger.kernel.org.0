Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B782C80EC
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 10:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgK3JYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 04:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgK3JYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 04:24:47 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD21C0613CF;
        Mon, 30 Nov 2020 01:24:07 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p8so15102674wrx.5;
        Mon, 30 Nov 2020 01:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gU8lO5LAldiFlnsZIdzpiU5H+CGrL6JqiRo0rf1tkEw=;
        b=Xhq86EeD2GXNUQWMZxvdyxtQj4PSxR6QH1H0v8AowvRErg/TJo/h4gmRJvgwDZJCvX
         k6fKXEOXzzXvxcliXBi3q2ejqom8ii03xtQN0EGZ5rf3kR3/n2Q6+AAbkOdoLbQt9SuL
         3MwWE4Rqu3+aATNQmHS8z8lIQfiieypfCFK8MS0Q3oFEfj4ValuoqZowjgtbJv9jF9HN
         ddskes1/Ke9HoiW3sFEC5PBkiZrsXhpkhXcAS/yyV43FPiLsJ1wJuvuqCLKMrr4Mig+p
         q7P9EtOUCeyUIwRo/5tsqzXjas4k7TDF/ll6qDQ2feenH6cOazuTIg0D+ZWmqU4chYIW
         K0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gU8lO5LAldiFlnsZIdzpiU5H+CGrL6JqiRo0rf1tkEw=;
        b=XTD+LaIzGWVCV2hFolwX1//EfYjsgj1JLCS6uqeLSaNng8zjnVtciwjXS4Rp3GKQSF
         KZU6dx8ri7QnQp4sPfD6V0YDzbq4j55LmYDUVCAZ6gCOBkJ588QxZLd2rVceGMpIEnjw
         UaCEN89QsDlXdCZCgiS5kpNBv2xMUiRVPv8tstwNQfhU293la+gU6Cp/pm3jwMQ+IY6L
         GnAjB2IRgLrsvbzYvEdKaG7PGcSO/s9SJPsoYiLoMvNZI91IuIKhmTjWJ8tmKullg8KX
         5le8Q7/+36MsWoZ8m3X/jrpchJsvRKh8GNcwb31w1WfpQW7W4dWqGfmOXJqSBtgUktTl
         7EgA==
X-Gm-Message-State: AOAM532G5F4Cfy0svtPMzgz6aWw27oXuhw3S59RVne0kaCiIof4T4bek
        kNLWFY7bS5zLXxfseyNNkAVKjWTSrz4kV995
X-Google-Smtp-Source: ABdhPJxO9bMA3cC05ceNaFl7oIxZ8m4GUA7h3yxz7UOuR8ovczMLjbg44ZkMv8v1OYALr0u3NGivzQ==
X-Received: by 2002:a5d:6191:: with SMTP id j17mr26865704wru.299.1606728245767;
        Mon, 30 Nov 2020 01:24:05 -0800 (PST)
Received: from [192.168.1.122] (cpc92720-cmbg20-2-0-cust364.5-4.cable.virginm.net. [82.21.83.109])
        by smtp.gmail.com with ESMTPSA id e1sm4842895wma.17.2020.11.30.01.24.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 01:24:05 -0800 (PST)
Subject: Re: [PATCH] net: flow_offload: remove trailing semicolon in macro
 definition
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        wenxu@ucloud.cn, pablo@netfilter.org, jiri@mellanox.com,
        herbert@gondor.apana.org.au, paulb@mellanox.com,
        john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201127193727.2875003-1-trix@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <9d9536d9-b2ba-d3f9-5cf7-56c8dd67bb3e@gmail.com>
Date:   Mon, 30 Nov 2020 09:24:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201127193727.2875003-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/11/2020 19:37, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> The macro use will already have a semicolon.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/core/flow_offload.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index d4474c812b64..59ddfd3f3876 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -32,7 +32,7 @@ EXPORT_SYMBOL(flow_rule_alloc);
>  	struct flow_dissector *__d = (__m)->dissector;				\
>  										\
>  	(__out)->key = skb_flow_dissector_target(__d, __type, (__m)->key);	\
> -	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask);	\
> +	(__out)->mask = skb_flow_dissector_target(__d, __type, (__m)->mask)	\
>  Strictly speaking shouldn't this macro have a do {} while (0)
 around it anyway?

-ed
