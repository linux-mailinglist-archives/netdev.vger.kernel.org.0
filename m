Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBECF3461C6
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhCWOqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbhCWOp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:45:57 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED7BC061574;
        Tue, 23 Mar 2021 07:45:57 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id l79so17249108oib.1;
        Tue, 23 Mar 2021 07:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m+gdomP34bExz5vswR3uMTpg5ypgbG8IaKGTNQlEkJs=;
        b=lL2lPLq+og1BnTbIOjd2GaCNeyEUnPgGAMHWZCPMfUQgb6/sIAu89eNRW5oW1FAf+Z
         OFE0jSCUN6Oo2m+Fi7CnoD1wcsyxdOXX8ukMjBP2LIz1NOXwyCJDQoY2MxLhvWTMDvau
         hWQbJdAmq0R4fquG4coKSrx5XQtgBbCG1V9UEOCT9Dt8T29pNRvSUTVeXu4a6v6ZSXGp
         cwUwWR0ywV5wCKyEqmOsx+ddasQEIlkTVTCU6AmfryLmSx+9YtIs8jJPpmL16ymDUTX0
         MJABilo7/WFBV13Hf0wtn+AVG4Up5s1c48XBcLuQXi8mEkD7FCVC++YgxiXDvEO70u3w
         q7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+gdomP34bExz5vswR3uMTpg5ypgbG8IaKGTNQlEkJs=;
        b=fU2iYWh7SEkXGXPZ9f6DYIAcm/1LLrm5m0xdGtShq6qpRpU/SxmEH9hSeJ3dIEAcEU
         uYIGkE1ycyvLEPMZL1oJNqMuDM6sbxGjriZzg3J+kzkRUzqddbEvc4lQAv44ytW8Cq9W
         dFwlboqvuqxK4igFJinrEGG21rX4Q4AScR4YCmBbpUfeVMS/jTc79shS2ZDFMea9w/yI
         wg5fC8DfQMIQPl27KOJzRhuUVBUCFsjY0ECBZaULnsuU1Kc/5sxYZiP8H9f2X7TFCq8A
         FBE6Fo6vh4MXvc8HNFVEJlPLcBQLSiuIkEW3laP0bFVd7P0crluxdBSUGK3PwdNnXcKM
         99tw==
X-Gm-Message-State: AOAM530ARAxnBxZdRwpHP/LbAE7kFJr6mGFRWzJB0WxqBbicZiYiOnPw
        z3eu+hF33QBulTUxVtQBAdT7jtAPk5Y=
X-Google-Smtp-Source: ABdhPJzUpbNE8BFK/b6BOTZk/rRQ5Jvcxj0BmAdWonFmgp/MLokZSvjat1e3xwCcKnTJN1illgiB/w==
X-Received: by 2002:aca:fc11:: with SMTP id a17mr3515592oii.68.1616510756606;
        Tue, 23 Mar 2021 07:45:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a73sm3932358oii.26.2021.03.23.07.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:45:56 -0700 (PDT)
Subject: Re: [PATCH] net: ipv4: route.c: Remove unnecessary {else} if()
To:     Yejune Deng <yejune.deng@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210323102028.11765-1-yejune.deng@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52f5586c-6ad6-3e0f-59b1-01b742d14fa7@gmail.com>
Date:   Tue, 23 Mar 2021 08:45:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323102028.11765-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

subject line should have net-next as the target branch


On 3/23/21 4:20 AM, Yejune Deng wrote:
> Put if and else if together, and remove unnecessary judgments, because
> it's caller can make sure it is true. And add likely() in
> ipv4_confirm_neigh().
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ipv4/route.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index fa68c2612252..f4ba07c5c1b1 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
>  	struct net_device *dev = dst->dev;
>  	const __be32 *pkey = daddr;
>  
> -	if (rt->rt_gw_family == AF_INET) {
> +	if (likely(rt->rt_gw_family == AF_INET)) {
>  		pkey = (const __be32 *)&rt->rt_gw4;
>  	} else if (rt->rt_gw_family == AF_INET6) {
>  		return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
> @@ -814,19 +814,15 @@ static void ip_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_buf
>  
>  static struct dst_entry *ipv4_negative_advice(struct dst_entry *dst)
>  {
> -	struct rtable *rt = (struct rtable *)dst;
> +	struct rtable *rt = container_of(dst, struct rtable, dst);
>  	struct dst_entry *ret = dst;
>  
> -	if (rt) {
> -		if (dst->obsolete > 0) {
> -			ip_rt_put(rt);
> -			ret = NULL;
> -		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
> -			   rt->dst.expires) {
> -			ip_rt_put(rt);
> -			ret = NULL;
> -		}
> +	if (dst->obsolete > 0 || rt->dst.expires ||
> +	    (rt->rt_flags & RTCF_REDIRECTED)) {
> +		ip_rt_put(rt);
> +		ret = NULL;
>  	}
> +
>  	return ret;
>  }
>  
> 

This should be 2 separate patches since they are unrelated changes.

For the ipv4_negative_advice, the changelog should note that
negative_advice handler is only called when dst is non-NULL hence the
'if (rt)' check can be removed.
