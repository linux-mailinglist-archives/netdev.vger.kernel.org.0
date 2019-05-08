Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D9417CAD
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEHO6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:58:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35555 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfEHO6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:58:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id t87so10060203pfa.2;
        Wed, 08 May 2019 07:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yEQ3QDmG4J4aCqR8TE4zPyewDF8Wu8jUX8cEw4gcVRM=;
        b=rDQOPtuMVcCa51KDjmVzZagDYZSJ7KpqkKLxG2aJAO67+Y2O0k/47H5A71Q4eOMDOj
         /cpoNEZB5y+nLbzQ07zHdoyiBOAkA0U5Ku6iUXF+Sb5JCO0w984LdjQ9M8Ll42tq04jO
         V2TBLFo54V07e8iPelizoBjbldJxs81qzR+m+bhy+VzckVkvLaWWqMjqBtBFRP5nPfCr
         LZk90P0U2vNIInaVJ2nLlrUB+QRgarTVeisfP2uvlnmohAdiLzuM2sennX9t9qoHCOAn
         268/ABq1HO20belSNgZGHvJE8WMCbzTtmBv/1bMzHZYDLal/IdAQjJx1N1GUcrt5uCqP
         ck6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yEQ3QDmG4J4aCqR8TE4zPyewDF8Wu8jUX8cEw4gcVRM=;
        b=sWtzw0cg/rsbzoKgxmbl6DpzAJAIRiSIh5R0HDFkE7B1Pspih4xF2DSJcZkO0qPqFR
         zZ3dCFZVKzQlp1WywTjYFEs12glq64eXtIwq4IytSW6KoxZFPPtS2Bad11/0IgY3TkGN
         +qREnmen+8gw2ZAubsCfWogTIYhPMJcwPgz6mhjueuSvuLhirZe3dlUxqcrviTICGaU+
         24TtQto1zNcSaYQUB4r28ALw2oLCZDolNj+xW8CH31dGA3nrzCxkeJ5PdpwtWb13OzgZ
         de2tUwYNIomwXnXyHjxxGqdesTIOKw9NeY+7OA7JDnSBUt7b/NL4AfwdHiFSrjQglcs/
         uk2Q==
X-Gm-Message-State: APjAAAWtnfxNxPKAqDhe47Nuxkj7ZAv1LT/tofLZ5XbK98m/nRjoM4HV
        GspPHw2oFUW4nwpPZuGJFhc=
X-Google-Smtp-Source: APXvYqzX9tfEM2lwPbl+tJ2jnH/8uKb0388ddWRDbaD3EtJA24j7l+BR6W/1NtQSeMBgWSe/SSUWEw==
X-Received: by 2002:a63:2b0d:: with SMTP id r13mr47971764pgr.400.1557327510091;
        Wed, 08 May 2019 07:58:30 -0700 (PDT)
Received: from [192.168.84.92] (207.sub-166-167-102.myvzw.com. [166.167.102.207])
        by smtp.gmail.com with ESMTPSA id h6sm11452931pfk.188.2019.05.08.07.58.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 07:58:29 -0700 (PDT)
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
 <20190508141211.4191-1-l.pawelczyk@samsung.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
Date:   Wed, 8 May 2019 07:58:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508141211.4191-1-l.pawelczyk@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
> The XT_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID to
> be also checked in the supplementary groups of a process.
> 
> Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
> ---
>  include/uapi/linux/netfilter/xt_owner.h |  1 +
>  net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
> index fa3ad84957d5..d646f0dc3466 100644
> --- a/include/uapi/linux/netfilter/xt_owner.h
> +++ b/include/uapi/linux/netfilter/xt_owner.h
> @@ -8,6 +8,7 @@ enum {
>  	XT_OWNER_UID    = 1 << 0,
>  	XT_OWNER_GID    = 1 << 1,
>  	XT_OWNER_SOCKET = 1 << 2,
> +	XT_SUPPL_GROUPS = 1 << 3,
>  };
>  
>  struct xt_owner_match_info {
> diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
> index 46686fb73784..283a1fb5cc52 100644
> --- a/net/netfilter/xt_owner.c
> +++ b/net/netfilter/xt_owner.c
> @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	}
>  
>  	if (info->match & XT_OWNER_GID) {
> +		unsigned int i, match = false;
>  		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
>  		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
> -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
> -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
> -		    !(info->invert & XT_OWNER_GID))
> +		struct group_info *gi = filp->f_cred->group_info;
> +
> +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
> +		    gid_lte(filp->f_cred->fsgid, gid_max))
> +			match = true;
> +
> +		if (!match && (info->match & XT_SUPPL_GROUPS) && gi) {
> +			for (i = 0; i < gi->ngroups; ++i) {
> +				kgid_t group = gi->gid[i];
> +
> +				if (gid_gte(group, gid_min) &&
> +				    gid_lte(group, gid_max)) {
> +					match = true;
> +					break;
> +				}
> +			}
> +		}
> +
> +		if (match ^ !(info->invert & XT_OWNER_GID))
>  			return false;
>  	}
>  
> 

How can this be safe on SMP ?


