Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89AC633A7A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfFCV6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:58:47 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36115 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFCV6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:58:47 -0400
Received: by mail-it1-f193.google.com with SMTP id e184so29151366ite.1
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 14:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NL9f6XOx3J7Q95bQTD2irmDDqpKCOFl2i8nQhxBNDIw=;
        b=m/hzuj78pl71Wo8rW22CJeRYXmI9rm2OBckcAMeuUhBYgTu7PRD5fNj9ZO00sWOivQ
         GU/Rp3zpESrgP4fPe9x4dBokq/BjLwNo+CvMas2wQYkgWZl2Svut+qMxVR7AB13voQqv
         raIuUhwQS4hno9FZ34PLRsH3dRRxc1lE9GBmPycGwfeGYRBNC1qRjVaY3TjunH0iNopF
         fQDjuxVwXR3rY2Hc4DkBx1Xw8y1ODnVrAemb+Yih7AbGzDxsYyXmsNHZMD+MRBmRw5TD
         WLLomd6qSPE7LA/MGQmMvoqPVSm8ovQuL60XtjTYyskj7aTnvRiMQvIG1OPTwaEhDttd
         bZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NL9f6XOx3J7Q95bQTD2irmDDqpKCOFl2i8nQhxBNDIw=;
        b=gu0gzlJX4reDsb+CK+uoP6x9fJYCoTTJZytvMdBz8s5ru4xh4aImhL0MTc5nDSdavZ
         wP16L6qtLUqdRGFKhA13/Hyi7ahHunX5MRXmOfFko9NTR+Zysjo1oURSvCPxpVszVrHx
         HpzwZLdDIOFIPZg6qPn/nslunj4Zn/PDJdf4I1ghUiBQ5LEawVYkuSIKNNcqcZJfBoUy
         zg6A/8P/xAm5oXkTy1WZlMLQ+P+xLWNcO5OY0esWZli+9jSIaRE6XqAiS5IeXNhI48Cv
         Bov94/GiF+1KoE4ZI3g9qUUiWpWtdPow4jKuaprUNLUbaLgz5d323qldNe66bFbjdyWv
         TT8w==
X-Gm-Message-State: APjAAAUJ4JND6XbCBnnglSBuJl4OAKHxxaIggK/l63dVPM1C6O8hY4ci
        N3xY6+7CeYBpzdfkWVKwjDOvGrhv5Ch2Mnhk2WZECg==
X-Google-Smtp-Source: APXvYqz8NRIwLyy20sO2NMCwyyvOQch3Rnx0z6zTpmeJleYW0yBk6rUSKJnDg5YofKbCF/dZwGAdtKDo1f7C6Bb7Vzo=
X-Received: by 2002:a24:dc5:: with SMTP id 188mr18232821itx.63.1559599126140;
 Mon, 03 Jun 2019 14:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190603040817.4825-1-dsahern@kernel.org> <20190603040817.4825-5-dsahern@kernel.org>
 <CAEA6p_AgK08iXuSBbMDqzatGaJj_UFbNWiBV-dQp2r-Y71iesw@mail.gmail.com> <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
In-Reply-To: <dec5c727-4002-913f-a858-362e0d926b8d@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 3 Jun 2019 14:58:34 -0700
Message-ID: <CAEA6p_Aa2eV+jH=H9iOqepbrBLBUvAg2-_oD96wA0My6FMG_PQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/7] ipv6: Plumb support for nexthop object in
 a fib6_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        idosch@mellanox.com, saeedm@mellanox.com,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 1:42 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/3/19 12:09 PM, Wei Wang wrote:
> >> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> >> index fada5a13bcb2..51cb5cb027ae 100644
> >> --- a/net/ipv6/route.c
> >> +++ b/net/ipv6/route.c
> >> @@ -432,15 +432,21 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
> >>         struct fib6_info *sibling, *next_sibling;
> >>         struct fib6_info *match = res->f6i;
> >>
> >> -       if (!match->fib6_nsiblings || have_oif_match)
> >> +       if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
> >>                 goto out;
> >
> > So you mentioned fib6_nsiblings and nexthop is mutually exclusive. Is
> > it enforced from the configuration?
>
> It is enforced by the patch that wires up RTA_NH_ID for IPv6.
>
> >> @@ -1982,6 +2010,14 @@ struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
> >>                 rcu_read_unlock();
> >>                 dst_hold(&rt->dst);
> >>                 return rt;
> >> +       } else if (res.fib6_flags & RTF_REJECT) {
> >> +               rt = ip6_create_rt_rcu(&res);
> >> +               rcu_read_unlock();
> >> +               if (!rt) {
> >> +                       rt = net->ipv6.ip6_null_entry;
> >> +                       dst_hold(&rt->dst);
> >> +               }
> >> +               return rt;
> >>         }
> >>
> > Why do we need to call ip6_create_rt_rcu() to create a dst cache? Can
> > we directly return ip6_null_entry here? This route is anyway meant to
> > drop the packet. Same goes for the change in ip6_pol_route_lookup().
>
> This is to mimic what happens if you added a route like this:
>    ip -6 ro add blackhole 2001:db8:99::/64
>
> except now the blackhole target is contained in the nexthop spec.
>
>
Hmm... I am still a bit concerned with the ip6_create_rt_rcu() call.
If we have a blackholed nexthop, the lookup code here always tries to
create an rt cache entry for every lookup.
Maybe we could reuse the pcpu cache logic for this? So we only create
new dst cache on the CPU if there is no cache created before.

> >
> > And for my education, how does this new nexthop logic interact with
> > the pcpu_rt cache and the exception table? Those 2 are currently
> > stored in struct fib6_nh. They are shared with fib6_siblings under the
> > same fib6_info. Are they also shared with nexthop for the same
> > fib6_info?
>
> With nexthop objects IPv6 can work very similar to IPv4. Multiple IPv4
> fib entries (fib_alias) can reference the same fib_info where the
> fib_info contains an array of fib_nh and the cached routes and
> exceptions are stored in the fib_nh.
>
> The one IPv6 attribute that breaks the model is source routing which is
> a function of the prefix. For that reason you can not use nexthop
> objects with fib entries using source routing. See the note in this
> patch in fib6_check_nexthop
>
> > I don't see much changes around that area. So I assume they work as is?
>
> Prior patch sets moved the pcpu and exception caches from fib6_info to
> fib6_nh.

Understood. Basically, for every nexthop object, it will have its own
fib6_nh which contains pcpu_rt and exception table.
And we only use the built-in fib6_nh in struct fib6_info when nexthop
is not used.
And if src addr routing is used, then nexthop object will not be used.
