Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971B06A36E
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 10:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfGPH7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:59:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39156 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfGPH7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 03:59:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id u25so7251689wmc.4;
        Tue, 16 Jul 2019 00:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zmF5vO91VQIdhbfWAwsujsXtrVSUylGqN9P3a+D5A9E=;
        b=Gro2wpByZEQfe/o/HSufE99K92BTY5Ft2aKfyZPyPXQ7NJarfsrdYvdDk1NQ9+le8w
         3sDeA0ILYfFBa6gRS7O2fjKLXWJY4bxFuLwZ3dXpmgkWBPEIqtDqGSbLOYshYmtZrBQv
         F3P71QU1bR0fVSDv3JGGd8oXfMEU71AGZqkximbRs/+acPZdOoPIQuoKmLEvQRFJCa8U
         4FJR2e2gY67PjkFYrt7DLZyLkX0Mi8L5V0KM6oUelMddUp3BveoeLsQ/J97hFMZ5ieOA
         6TCAMgIgvLWK6EsZFs1/B4mnVPW76+kFOpWUfSiWoQngpJofJRj1005/uAosCpzUnZwZ
         TGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zmF5vO91VQIdhbfWAwsujsXtrVSUylGqN9P3a+D5A9E=;
        b=b8PrjFKolzhnTFyrWQMMH+QBBaLFq/42B7/AC6z0Hi6ZJL8uXGXhXzm/StGlU7lgVy
         afpSkbuIrVA0KuzQ9icdkcfLgBSW0T8RpzYa6ims6rH82qZ/KwpqYOlcKI0DgIBJubBC
         uC/2JQLp8GKeBX3pFRJOLIwR/4qbq2KNLjUbN8XBTb4XwmXCp0ztmyMg/1ZmRsNCYqLO
         EYJ+phWBr4rNTLfQp6DnOHqtZMr1gaiQLA71N813u1FxPSZZ7zf5Fq8hiF4olItWjbuD
         yRBZ/+FA7vSKbpBXamm0+U43YOW3ncwUTi2UblVcJEh6EThL8Q9rmm2osbt6YiVrhJHm
         ZpzQ==
X-Gm-Message-State: APjAAAUKkWNwPpvzpRf6+Kl6SXYaMLxwLJCu87/cCGJlM18T1GZ0tOST
        AP9PNSYMv5i2WfzN94ROGO8=
X-Google-Smtp-Source: APXvYqzAvPES/n2krv3nhpYP3dW++1qRrZ7xxxf2r6uDqr2kjejQfGVQ2yTmF26B4iF5VfS8mDpjiQ==
X-Received: by 2002:a1c:cb0a:: with SMTP id b10mr28737606wmg.41.1563263969118;
        Tue, 16 Jul 2019 00:59:29 -0700 (PDT)
Received: from [192.168.8.147] (127.171.185.81.rev.sfr.net. [81.185.171.127])
        by smtp.gmail.com with ESMTPSA id d10sm23025983wro.18.2019.07.16.00.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 00:59:28 -0700 (PDT)
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     Petar Penkov <ppenkov.kernel@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, lmb@cloudflare.com, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-4-ppenkov.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
Date:   Tue, 16 Jul 2019 09:59:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190716002650.154729-4-ppenkov.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/19 2:26 AM, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> This helper function allows BPF programs to try to generate SYN
> cookies, given a reference to a listener socket. The function works
> from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
> socket in both cases.
> 
...
>  
> +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> +	   struct tcphdr *, th, u32, th_len)
> +{
> +#ifdef CONFIG_SYN_COOKIES
> +	u32 cookie;
> +	u16 mss;
> +
> +	if (unlikely(th_len < sizeof(*th)))


You probably need to check that th_len == th->doff * 4

> +		return -EINVAL;
> +
> +	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> +		return -EINVAL;
> +
> +	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> +		return -EINVAL;
> +
> +	if (!th->syn || th->ack || th->fin || th->rst)
> +		return -EINVAL;
> +
> +	switch (sk->sk_family) {

This is strange, because a dual stack listener will have sk->sk_family set to AF_INET6.

What really matters here is if the packet is IPv4 or IPv6.

So you need to look at iph->version instead.

Then look if the socket family allows this packet to be processed
(For example AF_INET6 sockets might prevent IPv4 packets, see sk->sk_ipv6only )

> +	case AF_INET:
> +		if (unlikely(iph_len < sizeof(struct iphdr)))
> +			return -EINVAL;
> +		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
> +		break;
> +
> +#if IS_BUILTIN(CONFIG_IPV6)
> +	case AF_INET6:
> +		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> +			return -EINVAL;
> +		mss = tcp_v6_get_syncookie(sk, iph, th, &cookie);
> +		break;
> +#endif /* CONFIG_IPV6 */
> +
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +	if (mss <= 0)
> +		return -ENOENT;
> +


