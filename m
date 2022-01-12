Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4A48C7A9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 16:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354836AbiALPzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 10:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354847AbiALPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 10:54:44 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAD8C06173F;
        Wed, 12 Jan 2022 07:54:44 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id v1so4215116ioj.10;
        Wed, 12 Jan 2022 07:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pFJ/5YX2hKQMWWd4jbVdAiQQ3E9iCyV59fKnRpe2rjE=;
        b=AeyaDt32H7QGfKGP7f1XnQSjfL1GC1itGsgMnC3MtpGpnjCf/39HnH9CDDGZNfBErq
         oBTl5kiT5CKBdLZK11Kt59aDugyecduZrgL+KDNGzah3NBqFJHDSjFZ9NhYjrKyXLoCt
         O2KqPkAuqVO6sJTSxx4binn3lmJvDjBiVlsHfibT3hEeDoxDlYaaw9XhkV8KRkmTVQ/P
         p6b2WscKVwHeDo+cWLguuuf5h2Cfcxwl7S1xreFqmil+tmYYWbPnfjj+aX8ja/OYFakh
         +NGQxZ/O3Tz1hfpCAo44oRzqUZh8nXPQzf/gMlxaKd/qkmCb3WXf5bQQQu6HGD2KjUEy
         mQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pFJ/5YX2hKQMWWd4jbVdAiQQ3E9iCyV59fKnRpe2rjE=;
        b=EJe9kzq7QAyk/aEfeI55a7sLkMhsmUgerFhAwaxnteoW43SOVdO4M+Xb5E0c3tiSgq
         jiolCmHSCTywmBoVUGl3P/t3i/YSh313kXELYWVgI2INDysOw/FrxsanFRtrwziztiq5
         wF1/7UcLce+joEX0JzcmxeSOEgtsD9SILZ+6L3bbeBuD2ipFDwHfXt2YuSxci9cQUXnL
         0OuYdhCQoSNYXd2zlWHH0CLapkPeWZa49p7zNYelJF5pk++SepU72pf+8KA94lV13N1z
         awWaCwkJpDjWUks/XrcsHOFw1FFtC+fjdcvDnL1Ljfcz3Mxs/QI37YRJSclrd0Mmz2mw
         SCDg==
X-Gm-Message-State: AOAM5328KLDr7fFkHxuXoigPD4GSjDam4JR3KUkFdDNf4carfztJH4Eh
        x9nvyR+8FkgOwWFlYa0NaKk=
X-Google-Smtp-Source: ABdhPJwI+dhtW0LgtXpTKLjpztLTIjus7FlvV/KgUFLadovNp27M9fbNP+IS0zeAzZ/HhsWpjnByrg==
X-Received: by 2002:a02:6f13:: with SMTP id x19mr152979jab.35.1642002883650;
        Wed, 12 Jan 2022 07:54:43 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id a8sm74318ilt.42.2022.01.12.07.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 07:54:42 -0800 (PST)
Message-ID: <33308db2-a583-165c-cae0-b055c7976f33@gmail.com>
Date:   Wed, 12 Jan 2022 08:54:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Content-Language: en-US
To:     cgel.zte@gmail.com, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220112082655.667680-1-chi.minghao@zte.com.cn>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220112082655.667680-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 1:26 AM, cgel.zte@gmail.com wrote:
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index fe786df4f849..897194eb3b89 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -698,13 +698,12 @@ mplsip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>  	    u8 type, u8 code, int offset, __be32 info)
>  {
>  	__u32 rel_info = ntohl(info);
> -	int err, rel_msg = 0;
> +	int rel_msg = 0;

this line needs to be moved down to maintain reverse xmas tree ordering.

You need to make the subject
'[PATCH net-next] net/ipv6: remove redundant err variable'

and since net-next is closed you will need to resubmit when it is open.

>  	u8 rel_type = type;
>  	u8 rel_code = code;
>  
> -	err = ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
> +	return ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
>  			  &rel_msg, &rel_info, offset);
> -	return err;
>  }
>  
>  static int ip4ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,

