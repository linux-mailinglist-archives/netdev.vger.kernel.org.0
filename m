Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9674B1484
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbiBJRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:47:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiBJRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:47:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D434CF6F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:47:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d9-20020a17090a498900b001b8bb1d00e7so6288049pjh.3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p1FyLLeeHKWstzVDY3n9BvmRqMBcKsRBi54tS79EQaU=;
        b=m+QNhQeuH+RQwG+chGF0jjyBl2Tg/Nhs22EY0ufEYk03skKI7FydfE65C6VOP/goSb
         4ZgthvrhYV5SNy52BqoS/aH8g4DmbugUNN0ZOKUhkzNRD0q3rA8H7LKYWOqbPb7hBA4K
         p7uzcSDv1x/YbNZAXbUTHDVMNbEwe5lkxROLMge0LQLRVUxI7nSb9X+yaLfTSD5lCaNs
         2iPUf6g2EET+7i8P2dWOS5Hemea45CnmZa168n3PFuRKpsI1YrPl0QCqIyz+dBHzpTKS
         wdT6Oks1eLIiGzGTNzGFB/c6+kIOKmRr97CZ+vzaJeRkGLNypvkPUSLuslEFvYAmpT7j
         JaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p1FyLLeeHKWstzVDY3n9BvmRqMBcKsRBi54tS79EQaU=;
        b=hI24Wpg/bIdq4AnTNEBXCyN8+B5IwmFek1qgGD7GrK6nPcM1ddqSHzRjOoAZAnSkQb
         ehD6mMlXaStjBhE+TtVDDmEQVIVvPOq/bpXK7VeXkqmNir8LIMVUPHU0B7J7Jr+IApID
         hewhe+UWO8/R9O42j3BZh8FRWsLS4lQbzcF/RGzp65hkirEHxdKVyierGZCW2V8RE1dD
         1d1PEmPSSp6gqUfmDNcBTq1XpXNf4PGvYK7T6lmZpLDKBij8iZ9lNlcJsXd2Gx3sWgzg
         BtsznNtWVaSOy29XITQbAHlF4PuBxM6n1traQkDKFQI9V+xtscbVjsMW6xnsbmzR/Zyy
         0rpQ==
X-Gm-Message-State: AOAM531rXWWfj/5Dvi7Kx20Dnk02dnukrOkv1aUuHKBCWwDruxKK2NVm
        8BrjWMIjwMOmAitV0zuOi+P+SR4dQuc=
X-Google-Smtp-Source: ABdhPJyPcZ+qn9YycROpy9RLWqPhKsJoSlqNtRRtrvZKL47asYzUb+NpEcmBGMnuvwhKNPgJdRXl4A==
X-Received: by 2002:a17:902:ecc3:: with SMTP id a3mr6529207plh.84.1644515247285;
        Thu, 10 Feb 2022 09:47:27 -0800 (PST)
Received: from [10.20.86.120] ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id t1sm17073716pgj.43.2022.02.10.09.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:47:26 -0800 (PST)
Message-ID: <dffe2ca3-b3f1-e742-f239-9724cf0c1e83@gmail.com>
Date:   Thu, 10 Feb 2022 09:47:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 1/1] net: Add new protocol attribute to IP
 addresses
Content-Language: en-US
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20220209163453.186889-1-Jacques.De.Laval@westermo.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220209163453.186889-1-Jacques.De.Laval@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/22 8:34 AM, Jacques de Laval wrote:
> diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
> index dfcf3ce0097f..2c487a9de658 100644
> --- a/include/uapi/linux/if_addr.h
> +++ b/include/uapi/linux/if_addr.h
> @@ -35,6 +35,7 @@ enum {
>  	IFA_FLAGS,
>  	IFA_RT_PRIORITY,  /* u32, priority/metric for prefix route */
>  	IFA_TARGET_NETNSID,
> +	IFA_PROTO,

Good to self-document attributes for userspace. See IFA_RT_PRIORITY above.


>  	__IFA_MAX,
>  };
>  
> @@ -69,4 +70,12 @@ struct ifa_cacheinfo {
>  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
>  #endif
>  
> +/* ifa_protocol */
> +#define IFAPROT_UNSPEC		0
> +#define IFAPROT_KERNEL_LO	1       /* loopback */
> +#define IFAPROT_KERNEL_RA	2       /* auto assigned by kernel from router
> +					   announcement
> +					 */

comment style should be:
/* auto assigned by kernel from router
 * announcement
 */

but I think the comment can be shortened to:
/* set by kernel from router announcement */


> +#define IFAPROT_KERNEL_LL	3       /* link-local set by kernel*/

space between kernel and '*'

> +
>  #endif
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 4744c7839de5..4c72ccd72ceb 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -102,6 +102,7 @@ static const struct nla_policy ifa_ipv4_policy[IFA_MAX+1] = {
>  	[IFA_FLAGS]		= { .type = NLA_U32 },
>  	[IFA_RT_PRIORITY]	= { .type = NLA_U32 },
>  	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
> +	[IFA_PROTO]		= { .type = NLA_U8 },
>  };
>  
>  struct inet_fill_args {
> @@ -577,8 +578,10 @@ static int inet_set_ifa(struct net_device *dev, struct in_ifaddr *ifa)
>  		in_dev_hold(in_dev);
>  		ifa->ifa_dev = in_dev;
>  	}
> -	if (ipv4_is_loopback(ifa->ifa_local))
> +	if (ipv4_is_loopback(ifa->ifa_local)) {
>  		ifa->ifa_scope = RT_SCOPE_HOST;
> +		ifa->ifa_proto = IFAPROT_KERNEL_LO;

inet_set_ifa is used by the old ioctl interface. Even if this is a
loopback address, there is no guarantee this particular assignment is
done by the kernel so the ifa_proto should not be set here.

> +	}
>  	return inet_insert_ifa(ifa);
>  }
>  
> @@ -887,6 +890,9 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
>  	if (tb[IFA_RT_PRIORITY])
>  		ifa->ifa_rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
>  
> +	if (tb[IFA_PROTO])
> +		ifa->ifa_proto = nla_get_u8(tb[IFA_PROTO]);
> +
>  	if (tb[IFA_CACHEINFO]) {
>  		struct ifa_cacheinfo *ci;
>  
> @@ -1623,6 +1629,7 @@ static size_t inet_nlmsg_size(void)
>  	       + nla_total_size(4) /* IFA_BROADCAST */
>  	       + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
>  	       + nla_total_size(4)  /* IFA_FLAGS */
> +	       + nla_total_size(1)  /* IFA_PROTO */
>  	       + nla_total_size(4)  /* IFA_RT_PRIORITY */
>  	       + nla_total_size(sizeof(struct ifa_cacheinfo)); /* IFA_CACHEINFO */
>  }
> @@ -1697,6 +1704,7 @@ static int inet_fill_ifaddr(struct sk_buff *skb, struct in_ifaddr *ifa,
>  	     nla_put_in_addr(skb, IFA_BROADCAST, ifa->ifa_broadcast)) ||
>  	    (ifa->ifa_label[0] &&
>  	     nla_put_string(skb, IFA_LABEL, ifa->ifa_label)) ||
> +	    nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto) ||

if (ifa->ifa_proto && nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto

only set attribute if protocol is set.


>  	    nla_put_u32(skb, IFA_FLAGS, ifa->ifa_flags) ||
>  	    (ifa->ifa_rt_priority &&
>  	     nla_put_u32(skb, IFA_RT_PRIORITY, ifa->ifa_rt_priority)) ||



> @@ -4946,6 +4956,7 @@ static inline int inet6_ifaddr_msgsize(void)
>  	       + nla_total_size(16) /* IFA_ADDRESS */
>  	       + nla_total_size(sizeof(struct ifa_cacheinfo))
>  	       + nla_total_size(4)  /* IFA_FLAGS */
> +	       + nla_total_size(1)  /* IFA_PROTO */
>  	       + nla_total_size(4)  /* IFA_RT_PRIORITY */;
>  }
>  
> @@ -5023,6 +5034,9 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
>  	if (nla_put_u32(skb, IFA_FLAGS, ifa->flags) < 0)
>  		goto error;
>  
> +	if (nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto))

only add attribute if proto set.

> +		goto error;
> +
>  	nlmsg_end(skb, nlh);
>  	return 0;
>  

