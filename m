Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C75C2456
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731978AbfI3Pcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:32:47 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:41174 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbfI3Pcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:32:47 -0400
Received: by mail-yb1-f196.google.com with SMTP id 206so3994356ybc.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKwHnwgbGKdkEqVYuygiGYmvXm0znKHNO7QOUaYYf1g=;
        b=l9/enaGSlNXxAypJ2DQznVq0Uf8hi7G1K4q0zXscSv4y5Br+P6miMs790bypRCGlsp
         QlI/xgqELI+f4rLhrxbQBY+uJ3EUfnplRFS2GERqVGfIxEsIxz3cMoVDygXzuT+tvX9g
         U7Y4wWPNnQGBdAPvqI/VXUlCnxvedAbi4G9aLATlbSRjnLH/8qdSP4DnSHxGnHxLhIW7
         nLq5bjmjdOPYdz9Os+RhFXJCNbW5Nx9XSJmGho9YT5Px7Zqwb13RcH+D429OR5e1M/xz
         Lqh0B+ul5FExLDiu4q7yqogR9KMoq+0JEEZqIH+XkJmpcmdOTrd2bIpDsEuTp0Z+IosN
         wBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKwHnwgbGKdkEqVYuygiGYmvXm0znKHNO7QOUaYYf1g=;
        b=q8motPlIApefv8eO/hnz+rtDlsTzFXa9JXDJ+1N6pvRIoz/5FGrMlLY9fwzfGjj3ge
         0cqxact8DMMqtxPXFR0kbFizMlAlj2boDraPN6hpewTN1leFK786QK10prHf32wVCRkd
         tUtkjgeZ+JvbgW3abav5NI4ehIG2oXoeY7B+IQ/+eSa1TsIDPgaYwun7zD+vyxuAnOUb
         PBV22D4mXh3eqPzsGRZ5+kabBEC4rk35Sk2EVl0p+HfTrN/mN7bahAtIb5VlOOb2uPgD
         LqVQ011TNmcKTXzoQy0GX+RgKylBZHlsKusM5PnQo2002JHSUDY5MgHdZQVDLLkJuSjB
         XwqQ==
X-Gm-Message-State: APjAAAXpZkEJg+Tdli6R994Ou2XvXijE95xPb8X7yd9j+ASTZWj8A0vu
        un8fIuuZvEcru6Cx5TAg5EX4NbKT
X-Google-Smtp-Source: APXvYqyp+KXMlfauIfK7nnPGnYzH+KZSje6MbaD4harmsaI7cTmfBWQfRnxQbWjmdE7x3BUu3XHxgQ==
X-Received: by 2002:a25:8708:: with SMTP id a8mr14107547ybl.1.1569857564893;
        Mon, 30 Sep 2019 08:32:44 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id s1sm2862944ywa.67.2019.09.30.08.32.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:32:43 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id x65so3640962ywf.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:32:43 -0700 (PDT)
X-Received: by 2002:a81:3182:: with SMTP id x124mr12264421ywx.411.1569857563058;
 Mon, 30 Sep 2019 08:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-6-steffen.klassert@secunet.com> <CA+FuTScYar_FNP9igCbxafMciUEYnjbnGiJyX3JhrU74VEGksg@mail.gmail.com>
 <20190930063048.GG2879@gauss3.secunet.de>
In-Reply-To: <20190930063048.GG2879@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 30 Sep 2019 11:32:06 -0400
X-Gmail-Original-Message-ID: <CA+FuTSedVCAUK3LBZXp31KaAcHNrsENLECSfqEyJr4adfe-55Q@mail.gmail.com>
Message-ID: <CA+FuTSedVCAUK3LBZXp31KaAcHNrsENLECSfqEyJr4adfe-55Q@mail.gmail.com>
Subject: Re: [PATCH RFC 5/5] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 2:30 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Sep 23, 2019 at 09:01:13AM -0400, Willem de Bruijn wrote:
> > On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > This patch extends UDP GRO to support fraglist GRO/GSO
> > > by using the previously introduced infrastructure.
> > > All UDP packets that are not targeted to a GRO capable
> > > UDP sockets are going to fraglist GRO now (local input
> > > and forward).
> > >
> > > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> >
> > > @@ -538,6 +579,15 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
> > >         const struct iphdr *iph = ip_hdr(skb);
> > >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> > >
> > > +       if (NAPI_GRO_CB(skb)->is_flist) {
> > > +               uh->len = htons(skb->len - nhoff);
> > > +
> > > +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> > > +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> > > +
> > > +               return 0;
> > > +       }
> > > +
> > >         if (uh->check)
> > >                 uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
> > >                                           iph->daddr, 0);
> > > diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> > > index 435cfbadb6bd..8836f2b69ef3 100644
> > > --- a/net/ipv6/udp_offload.c
> > > +++ b/net/ipv6/udp_offload.c
> > > @@ -150,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
> > >         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
> > >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> > >
> > > +       if (NAPI_GRO_CB(skb)->is_flist) {
> > > +               uh->len = htons(skb->len - nhoff);
> > > +
> > > +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> > > +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> > > +
> > > +               return 0;
> > > +       }
> > > +
> >
> > This is the same logic as in udp4_gro_complete. Can it be deduplicated
> > in udp_gro_complete?
>
> The code below would mess up the checksum then. We did not change
> the packets, so the checksum is still correct.

Uh, right, of course. I guess it's not enough code to create a
separate udp_gro_fraglist_complete helper for. Okay, never mind.

> >
> > >         if (uh->check)
> > >                 uh->check = ~udp_v6_check(skb->len - nhoff, &ipv6h->saddr,
> > >                                           &ipv6h->daddr, 0);
