Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4586446095D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 20:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhK1T2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 14:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhK1T0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 14:26:13 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911FBC0613ED
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:21:44 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id 7so30194127oip.12
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 11:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OTYh65uWyRqZeEN7VzbN4i2uirn/K/cINQsjlKBmPP0=;
        b=AQwIfUInK21lFZTRDjy+QCa3TFMgQhxLk3TwGqpfI5qjv1LeUgIMUbzpTTCIYRGehD
         YFMObCWGByymQw9DZKA0xXR4C3Uc7DgnbH+uW3KYElmwxA3kY/++MSkgUc/DjduZ59wW
         PK+VnUbEcFZdlmKkJLh0TopLeU3OrMPbGI7YIP9pIdGqaR9gwj+53wFO8W+xrLTSCMFn
         cHMwx9GFj9oEde1aghqIKZY+udW/dPSg0dWKmVosZjYqanftp1AgCYHiIeHbXKINxEuy
         Cho2WjkI2K+8zp1XMsskmFFAQ4f1ieiXyAV54vlM2kSyu88Zt/JGUW9KHWZj9oRXqI6T
         UO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OTYh65uWyRqZeEN7VzbN4i2uirn/K/cINQsjlKBmPP0=;
        b=3L6LFnbnCD2Un2JKszmyPxeq0t1mKzxl+j9fP35DkYrFuIr/0kGHTe6MLAY9tbi43/
         NNV6zU8gg3BWH5H0+l2M38TtSex+mqpg6T07V6RQGe7hBmNpNYrQeTGaZAicyvTntxGV
         cnIqC3fP7E+QzX9YEpnuGSLZYrxgEvtdxwRa2c1jFU5fS7KvrsHg6ppwxOezk5L/pQL+
         n1JNLso64932U3/v0zYC7wfBix4nrLUXvvs6yxw4XdPuqMZenq46VLtea8iGtPq8XNxe
         P4Q+0igowIjqXn7EFr9qqAz47eM3F8KH4c7H/U3KhGoHowAR834n/J5gEdDOFlSASUDG
         hGng==
X-Gm-Message-State: AOAM531LmQkH/blXj+d5i/CCv2h7SNC/n+cVXA3pktVrdAGMdCe9PNNh
        zCiFHwlODTMSxF8tb7YEOOk=
X-Google-Smtp-Source: ABdhPJx2YZMntXCgO/vvk1GQ5dBpbsNQ3FpJEPN9a+qwdNcWtOsOymL51Ls8gypOZuIGgcJQYJOhTA==
X-Received: by 2002:aca:2408:: with SMTP id n8mr36053962oic.124.1638127303996;
        Sun, 28 Nov 2021 11:21:43 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bj8sm2607791oib.51.2021.11.28.11.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 11:21:43 -0800 (PST)
Message-ID: <28dd7421-15f3-db72-4e1e-3d86fa2129d7@gmail.com>
Date:   Sun, 28 Nov 2021 12:21:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net v2 1/3] net: ipv6: add fib6_nh_release_dsts stub
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     idosch@idosch.org, davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20211122151514.2813935-1-razor@blackwall.org>
 <20211122151514.2813935-2-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211122151514.2813935-2-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/21 8:15 AM, Nikolay Aleksandrov wrote:
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 3ae25b8ffbd6..42d60c76d30a 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3680,6 +3680,25 @@ void fib6_nh_release(struct fib6_nh *fib6_nh)
>  	fib_nh_common_release(&fib6_nh->nh_common);
>  }
>  
> +void fib6_nh_release_dsts(struct fib6_nh *fib6_nh)
> +{
> +	int cpu;
> +
> +	if (!fib6_nh->rt6i_pcpu)
> +		return;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct rt6_info *pcpu_rt, **ppcpu_rt;
> +
> +		ppcpu_rt = per_cpu_ptr(fib6_nh->rt6i_pcpu, cpu);
> +		pcpu_rt = xchg(ppcpu_rt, NULL);
> +		if (pcpu_rt) {
> +			dst_dev_put(&pcpu_rt->dst);
> +			dst_release(&pcpu_rt->dst);
> +		}
> +	}
> +}
> +

this duplicates fib6_nh_release. Can you send a follow on to have it use
this new function?

