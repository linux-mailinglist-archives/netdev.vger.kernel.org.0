Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285CD32121F
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhBVIik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhBVIid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 03:38:33 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD775C061574;
        Mon, 22 Feb 2021 00:37:51 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id p3so2524380wmc.2;
        Mon, 22 Feb 2021 00:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CeWBZt+hcCxVqYJNaniFHpV0E/tU4rgmknD4HdcGoA8=;
        b=B7RaBO+aD3Tzj0ptbjRBs/L0Tl8BhA1vYGHLzgZGwDCq0Wf9LNAP4q91TXQIXqcrJD
         6UwWdNJgd+CIoAEOII3zYFqGA7VH3HaVaqbWbFV+T/L653qvNuDr7h1HY5w5AUzZXi5Z
         dSv37h529bzRmG4aNSY0+KyY59cdMaQo1HmBoR7qeOEYSs6j9VMwk0e/KuJg3uY+6qXI
         k8fIqAKGWTG4XTYVQ+5M9HqYqlQPIgyW+J0ZQOtpVwDdNeMUILMudW5+mXgUjhI+Oga7
         fJCb8tlsYSLuqxYyGcflHCx+aEo3pPgZyFENysWtucVVbp8fNuzdZPdHes8gM13k3o3Y
         OLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CeWBZt+hcCxVqYJNaniFHpV0E/tU4rgmknD4HdcGoA8=;
        b=gvh4Z8TnoVEZWifQREkLgpkj7L1JD+xmvUWzC/nnNfjbgMU1OG708U/Q4XW7mbFQqZ
         am9enpuK80svXkXDFbe6gd2xvPD0c89pEnUUCKXDHmTe+6LTj3TdIjJjFdlYk69I8ASM
         quFqbBDWg/jgiSk/6lSo1AKeOAUqXOh1U5MahzmVj1VH+976OrzYNS4qJw23LrCUhNOx
         HP+4rlgbTs5u/UMMJJVrFOq+CoX3haUbWvaHIM3j3igew/Q6nh0+390Vs1ig81asdgKY
         SWvdXGatMGfu6aEkoIube89udWX4vP9ecaEKHjWBlUFhQUFEOaZdjDG+d0f/lRnssBDY
         /QkA==
X-Gm-Message-State: AOAM531NM6LHZSs/L+PH2gSjWFPoQXcR+JcJwNPVNSP0LQlvab8L4eMm
        8vjFVo6dFduwF4cvnaY5y2Hi2uc3QB8=
X-Google-Smtp-Source: ABdhPJymMOf4TNIDxX2pW6azZ2nmgM8INoCSdxZy+6QriYxawL7PnXosUCFFkkYekcAEUTqztF3u0A==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr19430978wmq.154.1613983070546;
        Mon, 22 Feb 2021 00:37:50 -0800 (PST)
Received: from [192.168.1.101] ([37.171.239.209])
        by smtp.gmail.com with ESMTPSA id f7sm28234732wrm.92.2021.02.22.00.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 00:37:49 -0800 (PST)
Subject: Re: [PATCH] arp: Remove the arp_hh_ops structure
To:     Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
References: <20210222031526.3834-1-yejune.deng@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0143f961-7530-3ae9-27f2-f076ea951975@gmail.com>
Date:   Mon, 22 Feb 2021 09:37:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222031526.3834-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/21 4:15 AM, Yejune Deng wrote:
> The arp_hh_ops structure is similar to the arp_generic_ops structure.
> but the latter is more general,so remove the arp_hh_ops structure.
> 
> Fix when took out the neigh->ops assignment:
> 8.973653] #PF: supervisor read access in kernel mode
> [    8.975027] #PF: error_code(0x0000) - not-present page
> [    8.976310] PGD 0 P4D 0
> [    8.977036] Oops: 0000 [#1] SMP PTI
> [    8.977973] CPU: 1 PID: 210 Comm: sd-resolve Not tainted 5.11.0-rc7-02046-g4591591ab715 #1
> [    8.979998] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [    8.981996] RIP: 0010:neigh_probe (kbuild/src/consumer/net/core/neighbour.c:1009)
> 

I have a hard time understanding this patch submission.

This seems a mix of a net-next and net material ?



> Reported-by: kernel test robot <oliver.sang@intel.com>

If this is a bug fix, we want a Fixes: tag

This will really help us. Please don't let us guess what is going on.


Also, if this is not a bug fix, this should target net-next tree,
please take a look at Documentation/networking/netdev-FAQ.rst

In short, the stack trace in this changelog seems to be not
related to this patch, maybe a prior version ? We do not want
to keep artifacts of some buggy version that was never merged
into official tree.

Thanks.

> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/arp.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 922dd73e5740..9ee59c2e419a 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -135,14 +135,6 @@ static const struct neigh_ops arp_generic_ops = {
>  	.connected_output =	neigh_connected_output,
>  };
>  
> -static const struct neigh_ops arp_hh_ops = {
> -	.family =		AF_INET,
> -	.solicit =		arp_solicit,
> -	.error_report =		arp_error_report,
> -	.output =		neigh_resolve_output,
> -	.connected_output =	neigh_resolve_output,
> -};
> -
>  static const struct neigh_ops arp_direct_ops = {
>  	.family =		AF_INET,
>  	.output =		neigh_direct_output,
> @@ -277,12 +269,9 @@ static int arp_constructor(struct neighbour *neigh)
>  			memcpy(neigh->ha, dev->broadcast, dev->addr_len);
>  		}
>  
> -		if (dev->header_ops->cache)
> -			neigh->ops = &arp_hh_ops;
> -		else
> -			neigh->ops = &arp_generic_ops;
> +		neigh->ops = &arp_generic_ops;
>  
> -		if (neigh->nud_state & NUD_VALID)
> +		if (!dev->header_ops->cache && (neigh->nud_state & NUD_VALID))
>  			neigh->output = neigh->ops->connected_output;
>  		else
>  			neigh->output = neigh->ops->output;
> 
