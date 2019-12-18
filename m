Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DC124529
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfLRK4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:56:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45116 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfLRK4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:56:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so1735253wrj.12
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 02:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BpUElI+M5C9/ta9jhQbbZ9gDwxVwC3xb7CVY6634APs=;
        b=n4jKZSdafpLMH3vl3g2Lh1wPl3Cxbhb5440RlqnVagUVhB78LKsS3tX3+IC98oBtYS
         oV04ymIi7LpLDGEBPi0nfH5/ALZhwbZ4NQ1rMT/3VTc6SD/QK8+P2vB0zS/fdPuA7Ya7
         RZzWFzR1GQ9ooq0WcG5A2BByOG3/P0ukVZ5DCbbFfAMekPdBNk6b3NiNNeG3IzJRFK+0
         ylxVtXEbQJHh0Hl4rvAn0/tKCOXzx3Hago9XDnetWtdlS0zFfGXb7LR5g93Ow8ccyqU3
         bLkDhbVg3C3AOfWifuohjDrh9eLYXnUAbY4GPh2rENhWaVRvwHdMjJ572fP3Or2qebvf
         qF8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BpUElI+M5C9/ta9jhQbbZ9gDwxVwC3xb7CVY6634APs=;
        b=HI7U5cbJeAeihthxVRtdpQbc94ZvM8B5bYyr4ZI0UQBIXYEH/XDGaD/2RfAtM3Fj2+
         xxnFJFq24cWJY71fGhRnGLu7a4YqGXl5iLS52FI4HKbQATSpmBB+Zj7HzWa1Uu2vAPGk
         Em1oywMoiBi+ANoSdCjQoEyX2zDuT79qqZyeWXAXOUIROYMru3dFrnuFIutK++UjMA8X
         oUwlAfMBws95tftWpKYqJwatZtJJUY8wrmGL12EqIMtV1YeQNiJa9Iln6DCbcG8HpJ+8
         TQsTI9uMDM5+kiGfabeUxFfasRDEfdgjli2nReeTurrGCrmeE9grBCp8XLLP87Nxzir3
         FfQw==
X-Gm-Message-State: APjAAAXO07Iw0VXp8+Y3RwYkQuvED7evCzl6tSig6uBnr5A7Bdi9uo1D
        VFZ/WQSjn0IanGsmI55xPZ3dxA==
X-Google-Smtp-Source: APXvYqw+5rNTsHbenZOc7LF/GXTG1sTSaY29qzZp2BqHMVQfzUMdqZDpUsBy8BSw4WvCpvt8NL+0HA==
X-Received: by 2002:adf:f1d0:: with SMTP id z16mr2010714wro.209.1576666568487;
        Wed, 18 Dec 2019 02:56:08 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id u24sm2043343wml.10.2019.12.18.02.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:56:07 -0800 (PST)
Date:   Wed, 18 Dec 2019 11:56:07 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 2/7] ipeh: Move generic EH functions to
 exthdrs_common.c
Message-ID: <20191218105606.GB22367@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-3-git-send-email-tom@herbertland.com>
 <20191006130030.rv4tjcu2qkk7baf6@netronome.com>
 <CALx6S36wkNaWhHhgkTs12Zphm+u6OZjWucrUkByYxBZA2aGE+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALx6S36wkNaWhHhgkTs12Zphm+u6OZjWucrUkByYxBZA2aGE+w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 10:47:17AM -0800, Tom Herbert wrote:
> On Sun, Oct 6, 2019 at 6:00 AM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Thu, Oct 03, 2019 at 02:57:59PM -0700, Tom Herbert wrote:
> > > From: Tom Herbert <tom@quantonium.net>
> > >
> > > Move generic functions in exthdrs.c to new exthdrs_common.c so that
> > > exthdrs.c only contains functions that are specific to IPv6 processing,
> > > and exthdrs_common.c contains functions that are generic. These
> > > functions include those that will be used with IPv4 extension headers.
> > > Generic extension header related functions are prefixed by ipeh_.
> > >
> > > Signed-off-by: Tom Herbert <tom@herbertland.com>
> >
> > ...
> >
> > > diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> > > index 25aab67..b8843c1 100644
> > > --- a/net/dccp/ipv6.c
> > > +++ b/net/dccp/ipv6.c
> > > @@ -515,7 +515,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
> > >       if (!opt)
> > >               opt = rcu_dereference(np->opt);
> > >       if (opt) {
> > > -             opt = ipv6_dup_options(newsk, opt);
> > > +             opt = ipeh_dup_options(newsk, opt);
> > >               RCU_INIT_POINTER(newnp->opt, opt);
> > >       }
> > >       inet_csk(newsk)->icsk_ext_hdr_len = 0;
> > > diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> > > index ae1344e..700fcea 100644
> > > --- a/net/ipv6/Kconfig
> > > +++ b/net/ipv6/Kconfig
> > > @@ -3,9 +3,13 @@
> > >  # IPv6 configuration
> > >  #
> > >
> > > +config EXTHDRS
> > > +     bool
> > > +
> > >  #   IPv6 as module will cause a CRASH if you try to unload it
> > >  menuconfig IPV6
> > >       tristate "The IPv6 protocol"
> > > +     select EXTHDRS
> > >       default y
> > >       ---help---
> > >         Support for IP version 6 (IPv6).
> >
> > Hi Tom,
> >
> > could you expand on the motivation for this new Kconfig symbol.
> > It seems that at this time exthdrs_common.o could simply depend on IPV6.
> >
> It anticipates other uses cases of extension headers, in particular
> IPv4 extension headers
> (https://tools.ietf.org/html/draft-herbert-ipv4-hbh-destopt-00)

Thanks Tom,

I would lean towards adding the new Kconfig option when it is needed,
but I don't feel strongly aout this.

> > Otherwise this patch seems fine to me.
> >
> > > diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
> > > index df3919b..0bcab81 100644
> > > --- a/net/ipv6/Makefile
> > > +++ b/net/ipv6/Makefile
> > > @@ -44,6 +44,7 @@ obj-$(CONFIG_IPV6_SIT) += sit.o
> > >  obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
> > >  obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
> > >  obj-$(CONFIG_IPV6_FOU) += fou6.o
> > > +obj-$(CONFIG_EXTHDRS) += exthdrs_common.o
> > >
> > >  obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
> > >  obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
> >
> > ...
> 
