Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E003E282D
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244942AbhHFKJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244918AbhHFKJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:09:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BD5C061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 03:09:03 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h14so10336749wrx.10
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 03:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9TcQUErF6kGMwloADz8tjauGd442Uaan9uU/4Tjkpuc=;
        b=O7ZiCJh1m5Gm39prdAy7ARxQy8Asx9ZVwCG4QwcmC59lG6l0ylWuu1TZxoQnhuSVaK
         GnKcwMiyQlO0QKmHG3RZ9FMMLDNNikpcwxmmW7FLT81J0qumSpBceRJs/cqKm3Xosehx
         3X1Pu/I6N0+WXmp8lGhWzzgJtNjRClwQ0YN+OLjqhaqd1Njc66gHBiEEPj8Fi3tkhd45
         c17F5XTDoyftt62AUmn3k1hrmeQuwyfq6llyqv8WrjRLeazhBT967GjZsL0fNMag5HWi
         xNOHPuTiWLPAKqRUUzqKL08gWnUYcvQOFGS7krTQlC+CTve5U+g8d/92hy36TJwAYAR1
         JQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9TcQUErF6kGMwloADz8tjauGd442Uaan9uU/4Tjkpuc=;
        b=RakqTxTkqZU+Y7ctSP2wFvLoRdfy7Q3OhroOFx6noRphF6u233a8t3nF5pS6CB7haw
         fJQULDqA55SIZtueg0GDVMuUS0WqF8oICR0NeQ6gIA3Efc7d9b2ZBbQlBqnCsdk0D9y6
         C9+GqfPvK+a76P7RprzBIhX3R0cD9NXPALAhQMRmEqWL0dwKGJzisrvbTnBElATvZDm6
         /1A6Hyp1X8kD8ym5/T1KG3sfaf8i/6RE5G/NAtpq3EYf/aw9viiDHDJ/d9KltIvY/4pP
         hllIw3L6ughztMz7otApHzgMy/JyCq1Sj64MYJaIBdvu0LTu3+Rb4HOt7asYZWO0ZR53
         TqYQ==
X-Gm-Message-State: AOAM532zKVWry/5gdXxvfrZxDLw6kGkcgZs4GqMMTQtnJqs3C/Kjogr0
        xfS6DpfcLF5JUr/61LMUm5U=
X-Google-Smtp-Source: ABdhPJwrSSgHPTl27e6EZHT5C/HFUMSoV8RqXbIcjVM5QUTUeYZ5XZ2ZkUlof4wwoGh/UDqFX8tZKQ==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr9755610wrp.315.1628244541637;
        Fri, 06 Aug 2021 03:09:01 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.149.227])
        by smtp.gmail.com with ESMTPSA id c15sm9033414wrw.93.2021.08.06.03.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:09:01 -0700 (PDT)
Subject: Re: [Patch net-next 02/13] ipv4: introduce tracepoint
 trace_ip_queue_xmit()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
 <20210805185750.4522-3-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5c565b2c-85a5-9141-112f-be854cccc558@gmail.com>
Date:   Fri, 6 Aug 2021 12:08:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210805185750.4522-3-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/5/21 8:57 PM, Cong Wang wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Tracepoint trace_ip_queue_xmit() is introduced to trace skb
> at the entrance of IP layer on TX side.
> 
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
> ---
>  include/trace/events/ip.h | 42 +++++++++++++++++++++++++++++++++++++++
>  net/ipv4/ip_output.c      | 10 +++++++++-
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
> index 008f821ebc50..553ae7276732 100644
> --- a/include/trace/events/ip.h
> +++ b/include/trace/events/ip.h
> @@ -41,6 +41,48 @@
>  	TP_STORE_V4MAPPED(__entry, saddr, daddr)
>  #endif
>  
> +TRACE_EVENT(ip_queue_xmit,
> +
> +	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
> +
> +	TP_ARGS(sk, skb),
> +
> +	TP_STRUCT__entry(
> +		__field(const void *, skbaddr)
> +		__field(const void *, skaddr)
> +		__field(__u16, sport)
> +		__field(__u16, dport)
> +		__array(__u8, saddr, 4)
> +		__array(__u8, daddr, 4)
> +		__array(__u8, saddr_v6, 16)
> +		__array(__u8, daddr_v6, 16)
> +	),
> +
> +	TP_fast_assign(
> +		struct inet_sock *inet = inet_sk(sk);
> +		__be32 *p32;
> +
> +		__entry->skbaddr = skb;
> +		__entry->skaddr = sk;
> +
> +		__entry->sport = ntohs(inet->inet_sport);
> +		__entry->dport = ntohs(inet->inet_dport);
> +
> +		p32 = (__be32 *) __entry->saddr;
> +		*p32 = inet->inet_saddr;
> +
> +		p32 = (__be32 *) __entry->daddr;
> +		*p32 =  inet->inet_daddr;
> +
> +		TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
> +			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
> +	),
> +
> +	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c skbaddr=%px",
> +		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
> +		  __entry->saddr_v6, __entry->daddr_v6, __entry->skbaddr)
> +);
> +
>  #endif /* _TRACE_IP_H */
>  
>  /* This part must be outside protection */
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 6b04a88466b2..dcf94059112e 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -82,6 +82,7 @@
>  #include <linux/netfilter_bridge.h>
>  #include <linux/netlink.h>
>  #include <linux/tcp.h>
> +#include <trace/events/ip.h>
>  
>  static int
>  ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
> @@ -536,7 +537,14 @@ EXPORT_SYMBOL(__ip_queue_xmit);
>  
>  int ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl)
>  {
> -	return __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
> +	int ret;
> +
> +	ret = __ip_queue_xmit(sk, skb, fl, inet_sk(sk)->tos);
> +	if (!ret)
> +		trace_ip_queue_xmit(sk, skb);
> +
> +	return ret;
> +
>  }
>  EXPORT_SYMBOL(ip_queue_xmit);
>  
> 

While it is useful to have stuff like this,
ddding so many trace points has a certain cost.

I fear that you have not determined this cost
on workloads where we enter these functions with cold caches.

For instance, before this patch, compiler gives us :

2e10 <ip_queue_xmit>:
    2e10:	e8 00 00 00 00       	callq  2e15 <ip_queue_xmit+0x5> (__fentry__-0x4)
    2e15:	0f b6 8f 1c 03 00 00 	movzbl 0x31c(%rdi),%ecx
    2e1c:	e9 ef fb ff ff       	jmpq   2a10 <__ip_queue_xmit>


After patch, we see the compiler had to save/restore registers, and no longer
jumps to __ip_queue_xmit. Code is bigger, even when tracepoint is not enabled.

    2e10:	e8 00 00 00 00       	callq  2e15 <ip_queue_xmit+0x5>
			2e11: R_X86_64_PLT32	__fentry__-0x4
    2e15:	41 55                	push   %r13
    2e17:	49 89 f5             	mov    %rsi,%r13
    2e1a:	41 54                	push   %r12
    2e1c:	55                   	push   %rbp
    2e1d:	0f b6 8f 1c 03 00 00 	movzbl 0x31c(%rdi),%ecx
    2e24:	48 89 fd             	mov    %rdi,%rbp
    2e27:	e8 00 00 00 00       	callq  2e2c <ip_queue_xmit+0x1c>
			2e28: R_X86_64_PLT32	__ip_queue_xmit-0x4
    2e2c:	41 89 c4             	mov    %eax,%r12d
    2e2f:	85 c0                	test   %eax,%eax
    2e31:	74 09                	je     2e3c <ip_queue_xmit+0x2c>
    2e33:	44 89 e0             	mov    %r12d,%eax
    2e36:	5d                   	pop    %rbp
    2e37:	41 5c                	pop    %r12
    2e39:	41 5d                	pop    %r13
    2e3b:	c3                   	retq   
    2e3c:	66 90                	xchg   %ax,%ax
    2e3e:	44 89 e0             	mov    %r12d,%eax
    2e41:	5d                   	pop    %rbp
    2e42:	41 5c                	pop    %r12
    2e44:	41 5d                	pop    %r13
    2e46:	c3                   	retq  
---- tracing code --- 
    2e47:	65 8b 05 00 00 00 00 	mov    %gs:0x0(%rip),%eax        # 2e4e <ip_queue_xmit+0x3e>
			2e4a: R_X86_64_PC32	cpu_number-0x4
    2e4e:	89 c0                	mov    %eax,%eax
    2e50:	48 0f a3 05 00 00 00 	bt     %rax,0x0(%rip)        # 2e58 <ip_queue_xmit+0x48>
    2e57:	00 
			2e54: R_X86_64_PC32	__cpu_online_mask-0x4
    2e58:	73 d9                	jae    2e33 <ip_queue_xmit+0x23>
    2e5a:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 2e61 <ip_queue_xmit+0x51>
			2e5d: R_X86_64_PC32	__tracepoint_ip_queue_xmit+0x3c
    2e61:	48 85 c0             	test   %rax,%rax
    2e64:	74 0f                	je     2e75 <ip_queue_xmit+0x65>
    2e66:	48 8b 78 08          	mov    0x8(%rax),%rdi
    2e6a:	4c 89 ea             	mov    %r13,%rdx
    2e6d:	48 89 ee             	mov    %rbp,%rsi
    2e70:	e8 00 00 00 00       	callq  2e75 <ip_queue_xmit+0x65>
			2e71: R_X86_64_PLT32	__SCT__tp_func_ip_queue_xmit-0x4
    2e75:	44 89 e0             	mov    %r12d,%eax
    2e78:	5d                   	pop    %rbp
    2e79:	41 5c                	pop    %r12
    2e7b:	41 5d                	pop    %r13
    2e7d:	c3                   	retq   

