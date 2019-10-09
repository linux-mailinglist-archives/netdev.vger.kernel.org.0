Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036BBD11E5
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbfJIO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 10:59:31 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35563 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730955AbfJIO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 10:59:31 -0400
Received: by mail-yb1-f194.google.com with SMTP id f4so837627ybm.2
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 07:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKaTpVSb8HhtLRcndvEz+zFdHKgkxiZkwEfvM+LYktw=;
        b=GA5FCTAaFpJASYhLs2SJ+8wh+3jLkx84p7GCO6Qkj2DBFP4C3iassfI/ARIQHN+G2J
         EY4jBVQXgR+ggEFoKovuLjG3U3oetnx4ATSmJWuubDuBNj8Tm/PDsA0bAxeQme5GMv+A
         60g5vjeuDEmBxQIDkM4Yl+4Y1sqPURs3Qof4CZr9yYB0tzjO+3fCyC2cs2ydmvnDWe5M
         FkLJdSMnn4OUtq5R7JJ/ea9aGkvM27z0OPQegqfNuqXzqvlJhA8d1ihUIokrmJL1Vsie
         rMsrcpyzcvOH2sh3jATk5AdftvzIocPZglgyuwhOwdzjNG3BOAKNUju3eqSgb9yhmfpT
         mAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKaTpVSb8HhtLRcndvEz+zFdHKgkxiZkwEfvM+LYktw=;
        b=ctMHp+KYXZR5paer83lttAGaltwsqKrN+k/TuODZKNYLWWswkGzOPM4WUfRmzaDH9L
         AnKf4fskDsci6QO03znybKE7acSBVhlobbGjiq0BThTQ1Z/yYAZnwYb+V9acBCimKQkj
         9vCwpfJ5mb745CPlncF4lp0KjnE3EGGkw8/h/UnA5B6LdkhRNSENQYbODLPRgKKX1aRy
         I/mCfcI5svFP86ssBS0bIkep7fprfoI1DvYhx69WHDkjQBWN/glw0vIh/EPUCc6Da5BC
         fqdpkFrWiZfre4uKpg7XXpo9ff9XijmTYOZkD/Y8cj5hG2RorgvYxsq+V2wf7RDvsjWp
         UP8w==
X-Gm-Message-State: APjAAAUBQyh51Waf6YIBSMb5uD+TbhEH9MirHy3RKCyhiBuY3h31iNwu
        w5niN0++97jrVUJdYmu7gjtaXJeV
X-Google-Smtp-Source: APXvYqycbZJpQ/xC7dught5lLZqWdd3tAD+c6z77Pc5NH/2Tm6zeY2N6t/fZ+QvvohVkB+ecOt0Sow==
X-Received: by 2002:a25:6651:: with SMTP id z17mr2393872ybm.523.1570633169279;
        Wed, 09 Oct 2019 07:59:29 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id 12sm667363ywu.59.2019.10.09.07.59.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 07:59:28 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id e205so919048ywc.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 07:59:28 -0700 (PDT)
X-Received: by 2002:a0d:e1c1:: with SMTP id k184mr3228081ywe.193.1570633167545;
 Wed, 09 Oct 2019 07:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com> <20191009124814.GB17712@martin-VirtualBox>
In-Reply-To: <20191009124814.GB17712@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Oct 2019 10:58:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
Message-ID: <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 8:48 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 08, 2019 at 12:28:23PM -0400, Willem de Bruijn wrote:
> > On Tue, Oct 8, 2019 at 5:51 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin <martin.varghese@nokia.com>
> > >
> > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > tunnelling module for tunnelling different protocols like MPLS,
> > > IP,NSH etc inside a UDP tunnel.
> > >
> > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > +++ b/Documentation/networking/bareudp.txt
> > > @@ -0,0 +1,23 @@
> > > +Bare UDP Tunnelling Module Documentation
> > > +========================================
> > > +
> > > +There are various L3 encapsulation standards using UDP being discussed to
> > > +leverage the UDP based load balancing capability of different networks.
> > > +MPLSoUDP (https://tools.ietf.org/html/rfc7510)is one among them.
> > > +
> > > +The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> > > +support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> > > +a UDP tunnel.
> >
> > This patch set introduces a lot of code, much of which duplicates
> > existing tunnel devices, whether FOU using ipip tunnels and
> > fou_build_header or separate devices like vxlan and geneve. Let's try
> > to reuse what's there (and tested).
> >
> > How does this differ from foo-over-udp (FOU). In supporting MPLS
> > alongside IP? If so, can it reuse the existing code, possibly with
> > patches to that existing tunnel logic?
> >
> > I happened to have been playing around with MPLS in GRE recently. Have
> > not tried the same over UDP tunnels, but most of it should apply?
> >
> >   ip tunnel add gre1 mode gre local 192.168.1.1 remote 192.168.1.2 dev eth0
> >   ip addr add 192.168.101.1 peer 192.168.101.2 dev gre1
> >   ip link set dev gre1 up
> >
> >   sysctl net.mpls.conf.gre1.input=1
> >   sysctl net.mpls.platform_labels=17
> >   ip addr add 192.168.201.1/24 dev gre1
> >   ip route add 192.168.202.0/24 encap mpls 17 dev gre1
> >   ip -f mpls route add 16 dev lo
> >
> >
> unlike FOU which does l4 encapsulation, here we are trying to acheive l3 encapsulation.
> For Example,  What is needed for MPLSoUDP is to take packets such as:
>
> eth header | mpls header | payload
>
> and encapsulate them to:
>
> eth header | ip header | udp header | mpls header | payload
> <--------- outer ------------------> <---- inner --------->
>
> which is later decapsulated back to:
>
> eth header | mpls header | payload
>
> Note that in the decapsulated case, the ethertype in the eth header is ETH_P_MPLS_UC, while in the encapsulated case, the ethertype in the eth header is ETH_P_IP. When decapsulating, ETH_P_MPLS_UC is
> restored based on the configured tunnel parameters.
>
> This cannot be done with FOU. FOU needs an ipproto, not ethertype.
>
> During receive FOU dispatches packet to l4 handlers which makes it impossible to patch it to get it working for l3 protocols like MPLS.

Yes, this needs a call to gro_cells_receive like geneve_udp_encap_recv
and vxlan_rcv, instead of returning a negative value back to
udp_queue_rcv_one_skb. Though that's not a major change.

Transmit is easier. The example I shared already encapsulates packets
with MPLs and sends them through a tunnel device. Admittedly using
mpls routing. But the ip tunneling infrastructure supports adding
arbitrary inner headers using ip_tunnel_encap_ops.build_header.
net/ipv4/fou.c could be extended with a mpls_build_header alongside
fou_build_header and gue_build_header?

Extending this existing code has more benefits than code reuse (and
thereby fewer bugs), it also allows reusing the existing GRO logic,
say.

At a high level, I think we should try hard to avoid duplicating
tunnel code for every combination of inner and outer protocol. Geneve
and vxlan on the one hand and generic ip tunnel and FOU on the other
implement most of these features. Indeed, already implements the
IPxIPx, just not MPLS. It will be less code to add MPLS support based
on existing infrastructure.

> > The route lookup logic is very similar to vxlan_get_route and
> > vxlan6_get_route. Can be reused?
>
> Yes  we could. We can move these to a common place. include/net/ip_tunnels.h ?

I think it will be preferable to work the other way around and extend
existing ip tunnel infra to add MPLS.
