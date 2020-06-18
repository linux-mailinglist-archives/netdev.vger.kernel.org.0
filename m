Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42111FEFFC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgFRKvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 06:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFRKvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:51:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DD1C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:51:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p5so5523091wrw.9
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 03:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+hwWCXAGYao3JhWCAsQgmOKkdUf+oyUVOgHmaZBeau4=;
        b=gIiatOaOnL7zbNUrZ4sdA6IpcDEMW89+xkMzGLBVlIdnsfrJ+eAmTdLTLUUCYeRkr3
         NcaOFOpuHpDy8NznXrIqD7T7lcTD5cdJF9rJ7gR9pzfTx1/0lbVAh4jzRk2BsSNFCGnN
         gpafrv05qjCG+M6dRqHo5Q081WaIO+0hZjt/2jZmuqMiEIvlDpKnUM91BIbOOpqnyXjl
         ptKyzyczG4DZSEYmLZLXclJLSFtLhBpv1Ee7olDH3H4T9hh5POngATjQ4CrfS32+Rfpi
         bVaxqQOPTBgicQ1caEvjjbg3XxIi70vdazq+Q8yejL5CrFqthA7O9iN9OpbFK/S6wdVc
         BwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+hwWCXAGYao3JhWCAsQgmOKkdUf+oyUVOgHmaZBeau4=;
        b=Xy1bueFM4cAF0Dlel1YrkV4xkIWQobYR5mWlz6VqxFfzNVAmY/+ejaSl5zStlFZMYO
         4x2vWw6xHNExysXGa5kja6u5kIBoDUHi9Zg9IJW1qzgU9X4wON7CQEJn6bRsJOuwP7/z
         RFjWIlwNVZ0rXEuBD+71xskDEeIkv5LjNMFMfKs2zHwth/JsTkyvjVv2217+/Xtpeivx
         atqUmojf78T3cXXAmeKOG/61Rhw8n7+5e6tO8928RWY/4OxPr3gLabljWA85vBWecniO
         rBUzo1gZadGnCsX90iY3zJm97pBcIETv/m1yLk9HG84lGZfsBmsAyQIiQY3Lyw1FuTZw
         4Dgg==
X-Gm-Message-State: AOAM5331VL85BjtmTAdr4rb0fbl4eISHljuAcHWipAmAl7Pugf4JcTdf
        ns5mMZ3471lPFLnjlsw9U00sMw==
X-Google-Smtp-Source: ABdhPJyWNRjcGtTeysR5P3uX30mb29onkz+anlPX0ivtwGfWcL/NgR568hDzYDQzDSBeqxDom3Y5tg==
X-Received: by 2002:a5d:50c9:: with SMTP id f9mr4115268wrt.9.1592477469855;
        Thu, 18 Jun 2020 03:51:09 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id r7sm2860957wmh.46.2020.06.18.03.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 03:51:09 -0700 (PDT)
Date:   Thu, 18 Jun 2020 12:51:08 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        lucien.xin@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
Message-ID: <20200618105107.GB27897@netronome.com>
References: <20200618104420.499155-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618104420.499155-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 06:44:20PM +0800, Hangbin Liu wrote:
> Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
> to "geneve_opts", which may break the program compatibility. Reset
> it back to geneve_opt.
> 
> Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Thanks Hangbin.

I agree that the patch in question did change the name of the option
as you describe, perhaps inadvertently. But I wonder if perhaps this fix
is too simple as the patch mentioned also:

1. Documents the option as geneve_opts
2. Adds vxlan_opts

So this patch invalidates the documentation and creates asymmetry between
the VXLAN and Geneve variants of this feature.

Another problem is that any user of geneve_opts will break.

Perhaps a way out of this mess is to:
1. make geneve_opt an alias for geneve_opts (i.e. two names for the same
   thing)
2. Document geneve_opt, possibly marking it as deprecated.

> ---
>  tc/m_tunnel_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
> index bfec9072..0074f744 100644
> --- a/tc/m_tunnel_key.c
> +++ b/tc/m_tunnel_key.c
> @@ -534,7 +534,7 @@ static void tunnel_key_print_geneve_options(struct rtattr *attr)
>  	struct rtattr *i = RTA_DATA(attr);
>  	int ii, data_len = 0, offset = 0;
>  	int rem = RTA_PAYLOAD(attr);
> -	char *name = "geneve_opts";
> +	char *name = "geneve_opt";
>  	char strbuf[rem * 2 + 1];
>  	char data[rem * 2 + 1];
>  	uint8_t data_r[rem];
> -- 
> 2.25.4
> 
