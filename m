Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F66B47E
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 04:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfGQC0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 22:26:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34006 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfGQC0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 22:26:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so10041204pfo.1;
        Tue, 16 Jul 2019 19:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YrC43cySLmvhT7jcXqIESrh9T+esJb3VyruAtGvWklQ=;
        b=iC5k5od51hFItFL9tL4vr8o7TW6pB/GeaSaCUilaHkVfhIiHYdfaYIhENt5DviJvq6
         p8I7v4kU1XcVqywJRWgICyCIiGkg0Sjqwjb84mxGAb1hjHhjYF6P3ehcC96NivIrHJdB
         mu/+fDB+XjLQJJqWyXWw8f62HVh+gFOYM71/7DaSTf5jAllW//K9glgl78VSNFscMWLz
         b4u5Na6WflqAg71GHTXpfJGfkkXDglMJlbVurmv7Wdue4ojqiKZm5zAf22WctU6CuPuq
         pbvxMRQepM0NpwGon8JJG0SLDyB0Yq+ZE4VdSO+k4ylmfavjTbcqnAqY+sCpyHDUY8rw
         fFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YrC43cySLmvhT7jcXqIESrh9T+esJb3VyruAtGvWklQ=;
        b=YDlrA8ImcR5kbYbnaczBkLHNCxTR/mIeRZ9rYOrWzuI11DmBWBJNqXGBi8D/GeV4s0
         naSOGorX8R7mt47hTfC3hsjZotO3kQAtkhHKoxECgWfcJCUhIjoI7a9soBG+BxSS2nRR
         o4ocy4rt7i2dffDVtO/TPRtlXIPq2zdW0/hoLrpwsOeXhAEkERp1rPUK/k5mhy/R9G0n
         ODMs78gu04Erq8q2qXsi/X4KirECz72VGv57zAEYMoZwN3PuFtLyp7RpdB1W3vSoO5dj
         Qrg6bdi2g3VXZOhgSJY1YoVMBKYyhGXx6yTr4ZuzZeaEucUHimwMA57kMVmZVHAUwOBw
         89IQ==
X-Gm-Message-State: APjAAAW2T4SI+JSrwGU8Q90M+BHgcCngx5kxhpAOofWX5KgmH37uogD4
        I7EG14cYkQ+MsW1usXcauSk=
X-Google-Smtp-Source: APXvYqypKZ19FyqVMLMyasN2rkZg0ulvBbwu96S5BDCgbzkBr/fwMRO0hSjyg/FI8IeZ0NkI95m+AQ==
X-Received: by 2002:a63:6904:: with SMTP id e4mr10262795pgc.321.1563330399256;
        Tue, 16 Jul 2019 19:26:39 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::b82a])
        by smtp.gmail.com with ESMTPSA id k70sm26336954pje.14.2019.07.16.19.26.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 19:26:38 -0700 (PDT)
Date:   Tue, 16 Jul 2019 19:26:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Petar Penkov <ppenkov.kernel@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, lmb@cloudflare.com,
        sdf@google.com, Petar Penkov <ppenkov@google.com>
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
Message-ID: <20190717022635.yt7kczxa73kbi7ep@ast-mbp.dhcp.thefacebook.com>
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-4-ppenkov.kernel@gmail.com>
 <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 09:59:26AM +0200, Eric Dumazet wrote:
> 
> 
> On 7/16/19 2:26 AM, Petar Penkov wrote:
> > From: Petar Penkov <ppenkov@google.com>
> > 
> > This helper function allows BPF programs to try to generate SYN
> > cookies, given a reference to a listener socket. The function works
> > from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
> > socket in both cases.
> > 
> ...
> >  
> > +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> > +	   struct tcphdr *, th, u32, th_len)
> > +{
> > +#ifdef CONFIG_SYN_COOKIES
> > +	u32 cookie;
> > +	u16 mss;
> > +
> > +	if (unlikely(th_len < sizeof(*th)))
> 
> 
> You probably need to check that th_len == th->doff * 4

+1
that is surely necessary for safety.

Considering the limitation of 5 args the api choice is good.
struct bpf_syncookie approach doesn't look natural to me.
And I couldn't come up with any better way to represent this helper.
So let's go with 
return htonl(cookie) | ((u64)mss << 32);
My only question is why htonl ?

Independently of that...
Since we've been hitting this 5 args limit too much,
we need to start thinking how to extend BPF ISA to pass
args 6,7,8 on stack.

