Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2EE148A66
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389365AbgAXOrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:47:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42655 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389914AbgAXOrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 09:47:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id p9so865841plk.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 06:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZoYv+bzovQuSOXb+w5Rac2L2fPdV1EgC6IGdHhnQB5s=;
        b=DwmTTLRsI8kyAFQNqq5bBadClrgikux3E72iZkvz1myzhGbmFRetQEgVMNiR/yHi4r
         Xri0Agf9m/kkoEcXkzsA80mz+weqxHJTLg9ZsAlr+p4qzR76K2hCn7r0ouzQNiOJmDhV
         qw8/X1l2kSh4IeQUUBvDjTspHRJ5ts+FUfLi0NLRheSMIEBxpClEc8UKBjpXWgGLGsRE
         7OSadFn2fu4lTkq2zXU4KcxnFxWQNfwYKjuxZbjgs4rtaUPFoLHyjnvQ5YQ42lQjDmvk
         doojc4YGf1TqnowjJHjcKt2SJ2ZjbZZ/bjSraUdTk0MHrqPGmWKL66fmnv95GAcpI9Hb
         eTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZoYv+bzovQuSOXb+w5Rac2L2fPdV1EgC6IGdHhnQB5s=;
        b=Fmxpoe/c47qJIcoPEMB+SxaO3584gcWkPFohy2hD1O+HTl/lgkJcN5dr4tzQ1fVJnI
         5N7SZi4C8xkc8RC4nK5/LOSrnRa/bgFg16pZSvN50esmFyt+oq54fKFAKROKEELRNHK9
         FIEwLPrBsmvgc8iDPwf16xH0fWH6UINlfso08hewUoW1KfEV9OjfqqJCOjWZ0zR2oRXW
         6yCMqxncRBpQfZjC5pIjJCZM2BUcXmkpkRPpUKmsmUlMiFEywBkQ1UEXZ//rD4acfRbu
         fiuhVVc6cXdspz0Si5feM2xOW/iZUAZ3XwqLRGUH/+wzMcvBReTETpstUqfTtAN2u67J
         c9Nw==
X-Gm-Message-State: APjAAAUIhauEgdHPtpsSHJdo22TSaeYQhs5O0GkLBcQxQ0FqkyOtCAgm
        NNVV/dIY6/wtXKTOQC7J5K0=
X-Google-Smtp-Source: APXvYqwSZcmVjOJtxt0guGwUyDxRvmynQYGZTv9Qw9zPVLeOGA83If4uQVP0C/g9ez+vF6ftZimupg==
X-Received: by 2002:a17:90b:258:: with SMTP id fz24mr3469267pjb.6.1579877239986;
        Fri, 24 Jan 2020 06:47:19 -0800 (PST)
Received: from martin-VirtualBox ([122.178.219.138])
        by smtp.gmail.com with ESMTPSA id s131sm7122675pfs.135.2020.01.24.06.47.18
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 06:47:19 -0800 (PST)
Date:   Fri, 24 Jan 2020 20:17:11 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20200124144711.GA8532@martin-VirtualBox>
References: <cover.1579798999.git.martin.varghese@nokia.com>
 <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
 <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 05:42:25PM -0500, Willem de Bruijn wrote:
> On Thu, Jan 23, 2020 at 1:04 PM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The Bareudp tunnel module provides a generic L3 encapsulation
> > tunnelling module for tunnelling different protocols like MPLS,
> > IP,NSH etc inside a UDP tunnel.
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> > diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
> > index 028eaea..8215d1b 100644
> > --- a/include/net/ip6_tunnel.h
> > +++ b/include/net/ip6_tunnel.h
> > @@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
> >                 iptunnel_xmit_stats(dev, pkt_len);
> >         }
> >  }
> > +
> > +static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
> > +                                                 struct net_device *dev,
> > +                                                 struct net *net,
> > +                                                 struct socket *sock,
> > +                                                 struct flowi6 *fl6,
> > +                                                 const struct ip_tunnel_info *info,
> > +                                                 bool use_cache)
> > +{
> > +       struct dst_entry *dst = NULL;
> > +#ifdef CONFIG_DST_CACHE
> > +       struct dst_cache *dst_cache;
> > +#endif
> 
> I just noticed these ifdefs are absent in Geneve. On closer look,
> CONFIG_NET_UDP_TUNNEL selects CONFIG_NET_IP_TUNNEL selects
> CONFIG_DST_CACHE. So they are indeed not needed.
> 
> Sorry, should have noticed that in v4. It could conceivably be fixed
> up later, but seems worth one more round to get it right from the
> start.
> 
But unlike geneve i have placed this definition in ip_tunnels.h &
ip6_tunnels.h which doesnt come under NET_IP_TUNNEL.Hence build 
will fail in cases where NET_UDP_TUNNEL is disabled
Kbuild robot has shown that in v3.

Even with  #ifdef CONFIG_DST_CACHE Kbuild robot reported another issue.
when ip6_tunnel.h included in ip4_tunnel_core.c.
dst_cache_get_ipv6 comes under ipv6 flag  and hence the compilation of 
ip4_tunnel_core.c fails when IPV6 is disabled.

Ideally this functions should be defined in ip_tunnel.c & ip6_tunnel.c
as these function has no significance if IP Tunnel is disabled.


> Glad you found the previous reviews helpful. I will also miss a lot.
> For more assurance and also as regression test, it might be
> worth looking into adding a bareudp mode to
> tools/testing/selftests/net/pmtu.sh. That looks like it exercises a
> variety of tunnel types already. Extending it might be little work
> (once ip supports bareudp).
> 
> To be clear, not for this patch set. Let's not delay that further.
> Just a thought.
