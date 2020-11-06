Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6562A90C9
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgKFHzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFHzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:55:47 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEC4C0613CF;
        Thu,  5 Nov 2020 23:55:47 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r186so345059pgr.0;
        Thu, 05 Nov 2020 23:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yLvWXVX6liYEaFi9mLIkaDtFLXkVvPy5TrfgxDeoklM=;
        b=gVGWtcIQ4dt0CWuqNVPQjw8NNlJaEQ5ME1BLjpKRmxM27YT5l3U15GlAAdwHRcC9x7
         ZLj75WrWYydyTwUlY/nTMx27MEpg8z46XJyDIImrTWgN26lk4gLG6gFko+uTI+H4Hmj9
         IM6JChznpvDP71Sjdvn6kl/2KkCYBe9+y1w4HUF7PeYdFYviE8su7BrU+oB8nER51U3J
         cpsoi2QPPjPKV3OsAnOUslTM9+Wx/MYDZa+KCJVFvVbBKEY1BxtKC7Mcqo9YSQWKXq1N
         QXbwNk0OUF7buSDiiD5GltaC53azKwcV3BM5/MTgNlZRcP5BjEZamT8PzywqI3fu53wE
         h6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yLvWXVX6liYEaFi9mLIkaDtFLXkVvPy5TrfgxDeoklM=;
        b=o7BfHeUcHH5sz8PEwkNInSwPiR4+F2YWjewHdXzUr/L5t6Tv8HwBKcwo01VsAfes0u
         HFLo69//TpVHw2wWuwmKjXohmD8NrmD2SjQcdWVUogbxN0jlKxtsO98WmMRPjiXAkaAV
         as1nJw2c3VjG95byy2+TjxABLIerDwnL//GVLPr4oxyqtYzWFLMfzIQuCK1JpwsVxvYE
         A1C8cGu69wtQCiRICmy2lSwH7KAUzNS4qHJKCzcb2/TsbQg0PC3wLXzNsK8N85c8S6S/
         JxXSvlFFvvpHHczlxLAfjgpPGORJMtBakYYR6aJ8X6q3+zs9ci2LREN0og4n2X/4nTlF
         tVew==
X-Gm-Message-State: AOAM531ppMwivUtF3hZ60qWhP9JoZQoCPu7VoeE6kVtfBrNCg18lRYWg
        /IrrJQRpMwtXvW49COShV7U=
X-Google-Smtp-Source: ABdhPJyRGMATywSTZzAEtMaVlFi1H0GStOAp/I1PgxpTVBzKIsAy6sJOSGtELe8fXU5sfNc7oMjung==
X-Received: by 2002:a17:90a:3b07:: with SMTP id d7mr1113686pjc.134.1604649346865;
        Thu, 05 Nov 2020 23:55:46 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r205sm1025201pfr.25.2020.11.05.23.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 23:55:46 -0800 (PST)
Date:   Fri, 6 Nov 2020 15:55:36 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: remove unused bpf tunnel
 testing code
Message-ID: <20201106075536.GT2531@dhcp-12-153.nay.redhat.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201103042908.2825734-3-liuhangbin@gmail.com>
 <20201106073035.w2x4szk7m6nkx5yj@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106073035.w2x4szk7m6nkx5yj@kafai-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 11:30:35PM -0800, Martin KaFai Lau wrote:
> [ ... ]
> 
> > @@ -585,12 +571,11 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
> >  	struct bpf_tunnel_key key = {};
> >  	void *data = (void *)(long)skb->data;
> >  	struct iphdr *iph = data;
> v4 hdr here.

Ah, right, I didn't notice this. I will fix it, maybe by checking
skb->family and use different IPv4,v6 hdr.

> > -SEC("ip6ip6_set_tunnel")
> > -int _ip6ip6_set_tunnel(struct __sk_buff *skb)
> > -{
> > -	struct bpf_tunnel_key key = {};
> > -	void *data = (void *)(long)skb->data;
> > -	struct ipv6hdr *iph = data;
> IIUC, the patch is to replace _ip6ip6_set_tunnel with _ipip6_set_tunnel.
> 
> Are they testing the same thing?  At least, _ip6ip6_set_tunnel()
> is expecting a v6 hdr here.

Yes, the v4/v6 hdr here is just to check the data length.

> 
> > -	struct tcphdr *tcp = data + sizeof(*iph);
> > -	void *data_end = (void *)(long)skb->data_end;
> > -	int ret;
> > -
> > -	/* single length check */
> > -	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
> > -		ERROR(1);
> > -		return TC_ACT_SHOT;
> > -	}

^^ here

> > -
> > -	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
> > -	key.tunnel_ttl = 64;

The code logic is same. It set tunnel remote addr to dst IPv6 address, as
they are both testing IP(v4 or v6) over IPv6 tunnel.

Thanks
Hangbin
