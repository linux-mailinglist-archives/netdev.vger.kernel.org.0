Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6543A1413FF
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 23:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgAQWRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 17:17:44 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44332 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgAQWRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 17:17:44 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so12293316pgl.11
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 14:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZnBC+pUM60HMYNm298jK2VvAS07CUtpZQXfQvpoZ09c=;
        b=FViJtX5d2gSP+GSJeDspt1ZO/kEaCXaXmGhPR/N6uvyWYjFlLkM31jZS30z25Q/Qpv
         bk0bVqA9KhrM5/nHz3/vxgy+hffXjfXC3TDt7zvlHLD0M0sHj+jvQS8Vqhcmo+jzI1aQ
         JF5JLIKQ4iqkXwCx/jDtPrgdul7vZZjMc2mkQo5d5Q3jblsuhYcgqrnzI+wzGscBh+Nk
         s4jLOzeW3DM0fN4ZobFabtARenyBlS8DEDUmufFL4Qka7OFVeKUjYfluhGqF9J26Qpkc
         hXVhMD5nsHNdfN1603ouYA8bZLmFJ19GbgGVV5p8QNS8DVZMQIVGgbJEXvjJsrWwgHxj
         Mzbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZnBC+pUM60HMYNm298jK2VvAS07CUtpZQXfQvpoZ09c=;
        b=ryPLcjZxgZz7oARdeWeCWBatj+NW5UMAKe3QVp2UFIGjY1zmOV5EC54PVVGgVhs1BW
         1zTxb+E+5bR8+QhayrlpGpzS64IMsOa9TtaGOQjuNPksdQ/nTbE7SaxKujwWHiJuT4Mx
         e90DZ7K6OvwfYGSNFdMNLPS5rr/SayhZcYs0UHtdGnZgHekju0ITPfBRsb3EeaAg8pi+
         rmQrTvmPK5KhU2x1XAICGhB6gyUmDddqCwkbjZ6WMoKsbWAmSNtcjI1WcVrRPVGp6rHm
         0RmP/y1fhPa0IlarpOeh4HJ8P9b3tbEBqF/Oy8CCWOcToa7m2LbX7+xmZE4C4PeiwHR0
         5zlw==
X-Gm-Message-State: APjAAAWUwuEQp8XmJYkjEbDtwdhmvu6zMRGRRb6i3wHFeSLWvjh6zq+5
        QCaRIXcm7FweA5So5qklWh7m9f0+
X-Google-Smtp-Source: APXvYqz17wvusZTRfcRlwihiYkh5dXtjFEajqh1Zog9swblF3Dm1ZXiBlbaPCzL+i52Q0mLRFQlARw==
X-Received: by 2002:a63:6507:: with SMTP id z7mr49180171pgb.322.1579299462899;
        Fri, 17 Jan 2020 14:17:42 -0800 (PST)
Received: from [192.168.43.128] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n14sm30321457pff.188.2020.01.17.14.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:17:42 -0800 (PST)
Subject: Re: [RFC net-next PATCH] ipv6: New define for reoccurring code
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <693b94d6-eece-9334-4157-69f562836f3a@gmail.com>
Date:   Fri, 17 Jan 2020 14:17:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200117215642.2029945-1-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 1:56 PM, Jeff Kirsher wrote:
> Through out the kernel, sizeof() is used to determine the size of the IPv6
> address structure, so create a define for the commonly used code.
> 
> s/sizeof(struct in6_addr)/ipv6_addr_size/g
> 
> This is just a portion of the instances in the kernel and before cleaning
> up all the occurrences, wanted to make sure that this was a desired change
> or if this obfuscates the code.
> 
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
...

>  };
> +#define ipv6_addr_size		sizeof(struct in6_addr)
>  #endif /* __UAPI_DEF_IN6_ADDR */
>  
>  #if __UAPI_DEF_SOCKADDR_IN6
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ef01c5599501..eabf42893b60 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5053,7 +5053,7 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
>  	case SEG6_LOCAL_ACTION_END_X:
>  		if (!seg6_bpf_has_valid_srh(skb))
>  			return -EBADMSG;
> -		if (param_len != sizeof(struct in6_addr))
> +		if (param_len != ipv6_addr_size)

Hmm...

I vote seeing sizeof(struct in6_addr) rather than dealing
with yet another thing to remember and additional backports conflicts.

And I prefer not seeing dozens of followup trivial patches because
people will forget about this new pseudo variable.

