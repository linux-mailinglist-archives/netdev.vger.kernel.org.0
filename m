Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57438169C4E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBXCUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 21:20:22 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35832 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 21:20:22 -0500
Received: by mail-yw1-f65.google.com with SMTP id i190so4585604ywc.2
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 18:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRQxVDaJ1XFd+2gKP5koCi+yrog7TADP37AlnwbHICc=;
        b=p1VO7ppj9uy8w2idlD8cuF5L3F45Xm6XCYCiJV4wr5C0unMp6d+88psZlvpc2lM7Zm
         DdV939WkNBVXCWXu2D+S3YNitNyw6CXpG7auR5pwaZJp4z53XCFNVX5gnoHJIB/9m3Uz
         Ga3G6qu0x+AEn6pnv71n+H4WTyuDEWaxbYVQI++9REaZLYZPJrRB8HT2MgDoGws9N2pC
         vvWiDg4f0n00dTiDieFcnYMRByDoAWSiri6C3P7ijp3d9f7oKEaIHBlWptvOHwe27eib
         CfwY+xsD5907tjI1Y91L/Xxct2BRhS38Gt063DnJhusabW5WGqbpHUpncTzvRX50EnTw
         CTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRQxVDaJ1XFd+2gKP5koCi+yrog7TADP37AlnwbHICc=;
        b=fTUXfk9J+TPHjN/nic+nGDplLvag4Jtf5m2ZCJ7qXXRirHRGPSLGsaveoG7xidKp7q
         hsRK5O47nleAvdVn66crGaqMNSdX3oKGNEqBffjqXj13rgfwQB4J710QVvdjbE8c4qMj
         dtFRzre8Ahm5eLNdNDu0StPIQRObNfk2XutuIUCd/SGbuRu7cp5IBnlVFGBC8RzYoSxZ
         QVmzqRw6JjHUl2ZiCC14HrbuUCE3Ubs0RP3F40OyvMx3qSbxL4UEp5cxs+i9b4SuOWQJ
         0FRkP7whwVrM4CKRuaz2bOZ1UE64tFwj+M6rsioq3285iYgoinIP037r+RPmroU4imoH
         BUMQ==
X-Gm-Message-State: APjAAAUtMuXayD/Ve/IcZea+3zkT3SVXamJZ6I7Y2smyKRGG/9cD2WaC
        ClqS/6kmlOImU83atdSVDiPdP3M/
X-Google-Smtp-Source: APXvYqwVkMjmO9+XS3Keqx4YaH/UELdKy6EsT0M2zH+kbqeyOQ9W2SC58Jej+Qepq9TrDJFTJGJ1Aw==
X-Received: by 2002:a81:3e25:: with SMTP id l37mr40465171ywa.212.1582510820863;
        Sun, 23 Feb 2020 18:20:20 -0800 (PST)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id w128sm4550868ywf.72.2020.02.23.18.20.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 18:20:19 -0800 (PST)
Received: by mail-yb1-f179.google.com with SMTP id b196so3543177yba.4
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 18:20:19 -0800 (PST)
X-Received: by 2002:a25:1042:: with SMTP id 63mr43978973ybq.165.1582510818853;
 Sun, 23 Feb 2020 18:20:18 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581745878.git.martin.varghese@nokia.com>
 <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
 <CA+FuTSfHFn=niNFmd0yuHYt39a3P8Sfq7RMSBjqK1iro8EWGaQ@mail.gmail.com>
 <20200217024351.GA11681@martin-VirtualBox> <CA+FuTSeMBFu44266y_JkkxduUcXVcbVctjaFCuFaCnEwS_LwEQ@mail.gmail.com>
 <20200223161447.GA2682@martin-VirtualBox>
In-Reply-To: <20200223161447.GA2682@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 23 Feb 2020 21:19:41 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdOBhd=7q=4PdGVEo-r=O6ZqoEbHmSA6PJmG4OFUk4cNQ@mail.gmail.com>
Message-ID: <CA+FuTSdOBhd=7q=4PdGVEo-r=O6ZqoEbHmSA6PJmG4OFUk4cNQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 11:15 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Sun, Feb 16, 2020 at 09:16:34PM -0800, Willem de Bruijn wrote:
> > > > There are also a couple of reverse christmas tree violations.
> > > >
> > > In Bareudp.c correct?
> >
> > Right. Like bareudp_udp_encap_recv.
> >
> > > Wondering if there is any flag in checkpatch to catch them?
> >
> > It has come up, but I don't believe anything is merged.
> >
> > > > > +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> > > > > +                                     struct net_device *dev,
> > > > > +                                     struct net *net, __be32 *saddr,
> > > > > +                                     const struct ip_tunnel_info *info,
> > > > > +                                     u8 protocol, bool use_cache)
> > > > > +{
> > > > > +#ifdef CONFIG_DST_CACHE
> > > > > +       struct dst_cache *dst_cache;
> > > > > +#endif
> > > > > +       struct rtable *rt = NULL;
> > > > > +       struct flowi4 fl4;
> > > > > +       __u8 tos;
> > > > > +
> > > > > +       memset(&fl4, 0, sizeof(fl4));
> > > > > +       fl4.flowi4_mark = skb->mark;
> > > > > +       fl4.flowi4_proto = protocol;
> > > > > +       fl4.daddr = info->key.u.ipv4.dst;
> > > > > +       fl4.saddr = info->key.u.ipv4.src;
> > > > > +
> > > > > +       tos = info->key.tos;
> > > > > +       fl4.flowi4_tos = RT_TOS(tos);
> > > > > +#ifdef CONFIG_DST_CACHE
> > > > > +       dst_cache = (struct dst_cache *)&info->dst_cache;
> > > > > +       if (use_cache) {
> > > > > +               rt = dst_cache_get_ip4(dst_cache, saddr);
> > > > > +               if (rt)
> > > > > +                       return rt;
> > > > > +       }
> > > > > +#endif
> > > >
> > > > This is the same in geneve, but no need to initialize fl4 on a cache
> > > > hit. Then can also be restructured to only have a single #ifdef block.
> > > Yes , We need not initialize fl4 when cache is used.
> > > But i didnt get your point on restructuing to have a single #ifdef block
> > > Could you please give more details
> >
> > Actually, I was mistaken, missing the third #ifdef block that calls
> > dst_cache_set_ip[46]. But the type of info->dst_cache is struct
> > dst_cache, so I don't think the explicit cast or additional pointer
> > variable (and with that the first #ifdef) is needed. But it's clearly
> > not terribly important.
> I tried to remove the additional pointer variable and the explicit cast.But Compiler warns as
> the info is a const variable (same for geneve)
>
> So shall we keep as it is ?

Thanks for giving it a try. Yes, that's fine then.
