Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1968C1176F4
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 21:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfLIUDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 15:03:22 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37702 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfLIUDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 15:03:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id m188so14281099qkc.4
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 12:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GDUYUeBUbCRk5D6c/V5R/L+ljtI8qLNEf77mvyj/88c=;
        b=HITeT3Yy7URqczK7aKeGgL2+2uK4OmeOWTuQCmoVEv9f7YGigdozAHsdgsgv/XW54y
         W9bvk4mT1ub8Y3GFzLKmr7Daq/zDRggB98gvWubNe8lWR8JJBTM4g6pFLMrP3+nrm/NF
         X95IsUy8F0mtcCIJRkmMnHkiOll/mO35vcUGl8vWDgceNiNUmdVE63MgkGmz6zEpi8m8
         8VjAojj+l2kv5nMfxFQSc9Ox+RKuzdLXE8KsErS1sYJZdTEELsql0GC8nKc1Nd96WfqE
         +71OisRabQOTOtsb2gxx2DyzuKx2m0i9kMHV0zfHGhQxTKxTwWdXXvleWy/MdjUx21lW
         7WZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GDUYUeBUbCRk5D6c/V5R/L+ljtI8qLNEf77mvyj/88c=;
        b=q65Yd3oqRjyezmElDX+5T2Yzp6krS+eNs75uGqWXKO6M+PCvql7Xo+5MaTkiuPybmO
         ZWy5vjG+Oj5D8c6s5DH3XLZjFmx2i/mg37z3MLbtY8l2Ji/sfz+d8IdStcdsLAqblemA
         s0E6WsKeNB2QfQSWb96bPP2biyux6cTKNGn5F4iCjdBFhgLpIElaOdVwH/Bx/qrciXyb
         R3x3NnZ1PPCRwX3340vsdPBlyK/XtnHbKJvuL8EYILq1o3FJ8pE9yT4T6UbaqYnljJsm
         HxvUxefZxksmQP6GqGAUXt0wpnpeqpaAEmEMQDllN21M43nwlLXohZNHEGZqd2no4bgb
         SXxw==
X-Gm-Message-State: APjAAAWaxKXHjp1YAg9yuWabn8H2402kTEkS6uYWMwF1p3c6thQWqN98
        qOk24wgE6mYQXQ+Yjb3DYCSpIkLqZQ+r8Q==
X-Google-Smtp-Source: APXvYqxUdfacWJJq3CkJ5nuf6con2/1CclwH5aUJ2zuvDPb4Tye09yHCPNqViUdNW+6fRMhQhgOChg==
X-Received: by 2002:a37:6294:: with SMTP id w142mr1594816qkb.284.1575921801371;
        Mon, 09 Dec 2019 12:03:21 -0800 (PST)
Received: from netronome.com (209-213-91-242.bos.ma.meganet.net. [209.213.91.242])
        by smtp.gmail.com with ESMTPSA id z4sm175279qkz.62.2019.12.09.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 12:03:20 -0800 (PST)
Date:   Mon, 9 Dec 2019 15:03:19 -0500
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
Message-ID: <20191209200317.GA10466@netronome.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xin,

On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> To keep consistent with ipgre_policy, it's better to parse
> ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> cls_flower and ip_tunnel_core.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/netfilter/nft_tunnel.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 3d4c2ae..f76cd7d 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
>  }
>  
>  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> +	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U8 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
> -	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
> +	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
>  };
>  
> @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
>  	if (err < 0)
>  		return err;
>  
> -	version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> +	version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);

I have concerns about this change and backwards-compatibility with existing
users of this UAPI. Likewise, with other changes to the encoding of existing
attributes elsewhere in this series.

>  	switch (version) {
>  	case ERSPAN_VERSION:
>  		if (!tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX])
> -- 
> 2.1.0
> 
