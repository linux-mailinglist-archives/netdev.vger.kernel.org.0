Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6621310D98C
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfK2STS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 13:19:18 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45256 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfK2STS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 13:19:18 -0500
Received: by mail-yw1-f68.google.com with SMTP id j137so11244636ywa.12
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 10:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HF+fjTjv7Oq23CsonP++AGYWtN5qhnREJzjOYelF2OY=;
        b=PRY58aJLkO3/RkCMGiQ3dl4wqc+vEkLpJZtthcuGZG42ftGDSMUEBxUn51GbPQHvvx
         u/ctenpUBasOPie5A5cjep+xgmzChNfD8FAkGjAtvoruwrMO4vRPzwgi+FiWxSiqvUIA
         2RfUQXGm9lnvhhfSA+AZhfMyYaAzx7Jgo8rFh4mQBaWIAPtQtv11Hp4+K3dA2l3Zo+bX
         1BzKzyxv/5YTMnDHyHPyVgrTohk+R3L3+S/vaK/FiSjUTc3fcGDMf4ucqpLjDXiJ5lUS
         LDT6/KK5QRjiULwA2vyEM6VWm6VkG2cLU47pFihtYAzK/koXXjDqmYZXxhl3d0EgmJgU
         3vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HF+fjTjv7Oq23CsonP++AGYWtN5qhnREJzjOYelF2OY=;
        b=QXiy56UvV4VXFniKml860P9aIoMFn472DCiM+sMPODNbaOr4eDFpG22AUe/G1uN2qt
         OF3MR2j3jeu4fIdimYvoXEO3BW1QLCYWqafNHO70/h7Uf9R3dJtn8Viie0vaQudaqF5f
         jQF7iM92qK12FuqZ1cv34ICWKWXdn0HPPzudgG6Yravr0x15emuhBWjG7asOahxGdTP+
         80oQt6xQ2g8ukOobVyyU46qWK22Rd5fuKH/rDqENAv3X2HjCvle78IfH57HrOkokQGXi
         Lv+rQS45Yd80agxrCFYNeZFHwVPNdRHSG6x3Y/be25dP/dP2jo4Iwc/fZK85ZeqSmUxp
         K0QA==
X-Gm-Message-State: APjAAAUDJkDFNb4YelxGM7O+uCCm7zNNx6y16+XAQmhZOPDh8FTxyUcX
        HM96oNz2BF5Hb5uuQ+/m9zsrxD/x
X-Google-Smtp-Source: APXvYqzaVWiResD87rc12VqIjnCcK8BBYG6kYrC2+T7aTzwKKi2DpKbFk86oJ6JTIgbcYiGo82IgfA==
X-Received: by 2002:a81:e11:: with SMTP id 17mr12083916ywo.3.1575051555112;
        Fri, 29 Nov 2019 10:19:15 -0800 (PST)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id d138sm2166349ywe.102.2019.11.29.10.19.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 10:19:13 -0800 (PST)
Received: by mail-yw1-f44.google.com with SMTP id 192so3158697ywy.0
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 10:19:13 -0800 (PST)
X-Received: by 2002:a0d:e8ca:: with SMTP id r193mr11109733ywe.64.1575051552361;
 Fri, 29 Nov 2019 10:19:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573872263.git.martin.varghese@nokia.com>
 <5acab9e9da8aa9d1e554880b1f548d3057b70b75.1573872263.git.martin.varghese@nokia.com>
 <CA+FuTSeUGsWH-GR7N_N7PChaW4S6Hucmvo_1s_9bbisxz1eOAA@mail.gmail.com> <20191128162427.GB2633@martin-VirtualBox>
In-Reply-To: <20191128162427.GB2633@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Nov 2019 13:18:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc1GBxnWgMSVPNxx1wndFmauvTd7r54dDV92PeNprouWA@mail.gmail.com>
Message-ID: <CA+FuTSc1GBxnWgMSVPNxx1wndFmauvTd7r54dDV92PeNprouWA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 11:25 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Mon, Nov 18, 2019 at 12:23:09PM -0500, Willem de Bruijn wrote:
> > On Sat, Nov 16, 2019 at 12:45 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > From: Martin Varghese <martin.varghese@nokia.com>
> > >
> > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > tunnelling module for tunnelling different protocols like MPLS,
> > > IP,NSH etc inside a UDP tunnel.
> > >
> > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

> > > +static int bareudp_fill_metadata_dst(struct net_device *dev,
> > > +                                    struct sk_buff *skb)
> > > +{
> > > +       struct ip_tunnel_info *info = skb_tunnel_info(skb);
> > > +       struct bareudp_dev *bareudp = netdev_priv(dev);
> > > +       bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
> > > +
> > > +       if (ip_tunnel_info_af(info) == AF_INET) {
> > > +               struct rtable *rt;
> > > +               struct flowi4 fl4;
> > > +
> > > +               rt = iptunnel_get_v4_rt(skb, dev, bareudp->net, &fl4, info,
> > > +                                       use_cache);
> > > +               if (IS_ERR(rt))
> > > +                       return PTR_ERR(rt);
> > > +
> > > +               ip_rt_put(rt);
> > > +               info->key.u.ipv4.src = fl4.saddr;
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +       } else if (ip_tunnel_info_af(info) == AF_INET6) {
> > > +               struct dst_entry *dst;
> > > +               struct flowi6 fl6;
> > > +               struct bareudp_sock *bs6 = rcu_dereference(bareudp->sock);
> > > +
> > > +               dst = ip6tunnel_get_dst(skb, dev, bareudp->net, bs6->sock, &fl6,
> > > +                                       info, use_cache);
> > > +               if (IS_ERR(dst))
> > > +                       return PTR_ERR(dst);
> > > +
> > > +               dst_release(dst);
> > > +               info->key.u.ipv6.src = fl6.saddr;
> > > +#endif
> > > +       } else {
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       info->key.tp_src = udp_flow_src_port(bareudp->net, skb,
> > > +                                            bareudp->sport_min,
> > > +                                            USHRT_MAX, true);
> > > +       info->key.tp_dst = bareudp->conf.port;
> > > +       return 0;
> > > +}
> >
> > This can probably all be deduplicated with geneve_fill_metadata_dst
> > once both use iptunnel_get_v4_rt.
> >
>
> Do you have any preference of file to keep the common function

Perhaps net/ipv4/udp_tunnel.c
