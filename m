Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49146F95C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhLJCyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:54:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60428 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhLJCyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:54:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AADF6B82644;
        Fri, 10 Dec 2021 02:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09196C004DD;
        Fri, 10 Dec 2021 02:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639104624;
        bh=83/ICU56MD7Q8EfnNZUQUHhZK9GX4pO3U1W/FVKNJ/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p4KM0xR4/OM+lEwQaj6VJPQy6dEVOjChiFKKQj/gdbC3euShHllnIU1mCL+JXG4vB
         tfgzRrVsgg3bFtUaskXZrvji9w6ITkhvNMo6UF2Chgpeb0arXWhzOI5fmViIO1VDOA
         I61PMJdHaFUPu0o0LbBXv/HZ5iczzq8sRplAOsDqHTEO/MAXRUazb9q13zsHR0Rp9o
         XBKYYE96Qjlb2HDBhAtHXhW41hMzEjONVu8d9dMd0kNUu9zaQQ8LV7kNe98ZFHggV2
         F54pmcm/SnOeekEGehQbHqbFvnMo2Jjh0LsG5eGLMoLADrfX7X7A06IXcjJPACVCmd
         xRe7aEhSjH/dA==
Date:   Thu, 9 Dec 2021 18:50:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, pablo@netfilter.org, contact@proelbtn.com,
        justin.iurman@uliege.be, chi.minghao@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cm>
Subject: Re: [PATCH core-next] net/core: remove unneeded variable
Message-ID: <20211209185023.2660b7b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210022012.423994-1-chi.minghao@zte.com.cn>
References: <20211210022012.423994-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 02:20:12 +0000 cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return status directly from function called.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---
>  net/core/lwtunnel.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> index 2820aca2173a..c34248e358ac 100644
> --- a/net/core/lwtunnel.c
> +++ b/net/core/lwtunnel.c
> @@ -63,11 +63,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
>  
>  struct lwtunnel_state *lwtunnel_state_alloc(int encap_len)
>  {
> -	struct lwtunnel_state *lws;
> -
> -	lws = kzalloc(sizeof(*lws) + encap_len, GFP_ATOMIC);
> -
> -	return lws;
> +	return kzalloc(sizeof(*lws) + encap_len, GFP_ATOMIC);
>  }
>  EXPORT_SYMBOL_GPL(lwtunnel_state_alloc);

I don't think any of your "remove unneeded variable" patches are worth
applying, sorry.

This one doesn't even build.
