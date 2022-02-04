Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15594A92F8
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 05:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356648AbiBDEQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 23:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiBDEQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 23:16:52 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FF9C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 20:16:52 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id o10so3912975ilh.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 20:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+tvYtdY23LsSmw4oAOrbNOPdpPMORoVnOTm0A3QhHbs=;
        b=h0xT2eJDqmBFSecjDWXj9oIkdK9bn/h+BY8QzYBSnWP8N6o5Mcdl/qbGQeK2ovvK2j
         0BSSYjsgfsW7oys9lVvV5KH0aepHWYErHnuN08XBRne5LHjO/JqTOiUI8Tgs99uAmcqN
         H+1EdfoLDijJSxloejfHE/hzqFtHrk/2AuM24qZY9R4qSs9WYIiERP/4FMelckYA+T6P
         nkDuqeit7SOIf81BJJ3R3oHNtCyyUGrCGpbXrKTiLtlCZ0+TGNrM4jMqy8Fn7xxxSDWJ
         CQr4GXlpPOrOiR7hoE3oyFPWNbeQiPL6gXXOp2ZV8SKIghlN8tE1AARMwAUhf1b0G3m6
         iG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+tvYtdY23LsSmw4oAOrbNOPdpPMORoVnOTm0A3QhHbs=;
        b=wcGDLKDVYSF3RereSeFF524C2Px0JgLoCv6Zm0TEYD/SMYj/6knb3uvDWWe0Idtp/X
         YhJUU43XBFwrWZOqFc1ByXM50nfvhHYhBpoICmrQ6HyVv5Jo7jdxBA0kKdX6tScWq+lp
         BgVCNTb8e6TAsIDlzBo/DI/+pQTXYXeKpfhdHsSPJ3hacwlMDzPb1gBcVmFAEW+QQidG
         RUAX7x2vSC4FySVVT27x5Kbmyxv3vh2CCX6JC5W6h+b58X85e+w73paBZ9cvBNz5oito
         dj2XsrSep/hjg5YhUb4gmY5LadFfWKHi7hWJ/nJGfjpGaj8EqQOz453jKhRMW45EudAD
         S8xg==
X-Gm-Message-State: AOAM533rR5kks+3+pXBvgMZm6PFy11hYK+ncFC0MiNyri8H0aQf5aE8h
        2VKw+Z3C+e9WtsiKW8BzZ8g=
X-Google-Smtp-Source: ABdhPJxOV1GQf/3GHJFhU6JA2CMqbJeri/n1YSvICwUkqrJoWrbCYSMNs/AGf05br+0bz06EelA87w==
X-Received: by 2002:a05:6e02:12c3:: with SMTP id i3mr574545ilm.250.1643948211587;
        Thu, 03 Feb 2022 20:16:51 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id d2sm497776ilg.43.2022.02.03.20.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 20:16:51 -0800 (PST)
Message-ID: <42653bf5-ba76-2561-9cf9-27b0ae730210@gmail.com>
Date:   Thu, 3 Feb 2022 21:16:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP
 addresses
Content-Language: en-US
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20220203163106.1276624-1-Jacques.De.Laval@westermo.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220203163106.1276624-1-Jacques.De.Laval@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 9:31 AM, Jacques de Laval wrote:
> This patch adds a new protocol attribute to IPv4 and IPv6 addresses.
> Inspiration was taken from the protocol attribute of routes. User space
> applications like iproute2 can set/get the protocol with the Netlink API.
> 
> The attribute is stored as an 8-bit unsigned int. Only IFAPROT_UNSPEC is
> defined. The rest of the available ids are available for user space to
> define.
> 
> Grouping addresses on their origin is useful in scenarios where you want
> to distinguish between addresses coming from a specific protocol like DHCP
> and addresses that have been statically set.
> 
> Tagging addresses with a string label is an existing feature that could be
> used as a solution. Unfortunately the max length of a label is
> 15 characters, and for compatibility reasons the label must be prefixed
> with the name of the device followed by a colon. Since device names also
> have a max length of 15 characters, only -1 characters is guaranteed to be
> available for any origin tag, which is not that much.
> 
> A reference implementation of user space setting and getting protocols
> is available for iproute2:
> 
> Link: https://github.com/westermo/iproute2/commit/9a6ea18bd79f47f293e5edc7780f315ea42ff540
> 
> Signed-off-by: Jacques de Laval <Jacques.De.Laval@westermo.com>
> ---
>  include/linux/inetdevice.h   |  1 +
>  include/net/addrconf.h       |  1 +
>  include/net/if_inet6.h       |  2 ++
>  include/uapi/linux/if_addr.h |  4 ++++
>  net/ipv4/devinet.c           |  8 ++++++++
>  net/ipv6/addrconf.c          | 12 ++++++++++++
>  6 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
> index a038feb63f23..caa6b7a5b5ac 100644
> --- a/include/linux/inetdevice.h
> +++ b/include/linux/inetdevice.h
> @@ -148,6 +148,7 @@ struct in_ifaddr {
>  	unsigned char		ifa_prefixlen;
>  	__u32			ifa_flags;
>  	char			ifa_label[IFNAMSIZ];
> +	unsigned char		ifa_proto;

there is a hole after ifa_prefixlen where this can go and not affect
struct size.

>  
>  	/* In seconds, relative to tstamp. Expiry is at tstamp + HZ * lft. */
>  	__u32			ifa_valid_lft;
> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> index 78ea3e332688..e53d8f4f4166 100644
> --- a/include/net/addrconf.h
> +++ b/include/net/addrconf.h
> @@ -69,6 +69,7 @@ struct ifa6_config {
>  	u32			preferred_lft;
>  	u32			valid_lft;
>  	u16			scope;
> +	u8			ifa_proto;
>  };
>  
>  int addrconf_init(void);
> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> index 653e7d0f65cb..f7c270b24167 100644
> --- a/include/net/if_inet6.h
> +++ b/include/net/if_inet6.h
> @@ -73,6 +73,8 @@ struct inet6_ifaddr {
>  
>  	struct rcu_head		rcu;
>  	struct in6_addr		peer_addr;
> +
> +	__u8			ifa_proto;

similarly for this struct; couple of holes that you can put this.


>  };
>  
>  struct ip6_sf_socklist {
> diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> index dfcf3ce0097f..2aa46b9c9961 100644
> --- a/include/uapi/linux/if_addr.h
> +++ b/include/uapi/linux/if_addr.h
> @@ -35,6 +35,7 @@ enum {
>  	IFA_FLAGS,
>  	IFA_RT_PRIORITY,  /* u32, priority/metric for prefix route */
>  	IFA_TARGET_NETNSID,
> +	IFA_PROTO,
>  	__IFA_MAX,
>  };
>  
> @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
>  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
>  #endif
>  
> +/* ifa_protocol */
> +#define IFAPROT_UNSPEC	0

*If* the value is just a passthrough (userspace to kernel and back), no
need for this uapi. However, have you considered builtin protocol labels
- e.g. for autoconf, LLA, etc. Kernel generated vs RAs vs userspace
adding it.
