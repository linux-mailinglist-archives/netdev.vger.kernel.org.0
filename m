Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CBA433F46
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbhJSTcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhJSTcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 15:32:48 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA03C06161C;
        Tue, 19 Oct 2021 12:30:34 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id u5so8120543ljo.8;
        Tue, 19 Oct 2021 12:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QtbIYKqyjuoCeOS42MgIvrpZ7Pn419j5CC8FsD29r50=;
        b=Jo6/1MckxITRPeE2qvas3MY1v6ySQgD1x0LuooElQnuiSzOryUoACqfKUkk5jtCQEF
         YHTmA/IjBTUnlc7z0n7o7GEabC2SCJOgsa/pgsqS36lorEZ8V3tvm60D3cJdNJPX8eSN
         LdLMGDO7mtQB8HiQVTuYgQ/s346NoZ3QOrbHHKymJFOpqMxWOwUggd1mAZM4FJ11lXE0
         v9dLOIEa/QBrFzH37OCCiu8uAI5K23v8u3E1K5njdB60CDRy7mSpGfN64dmLuQFVWxv1
         74cM/8RWVz9nBn7gSe0JsrYnNEF9fWnL8OJHWlUuPp4irJesHT4mkNrSGT7m9ZZdFp8l
         AjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QtbIYKqyjuoCeOS42MgIvrpZ7Pn419j5CC8FsD29r50=;
        b=XQYUu82T00PcJ0SD31p02kTyZPTiXtpiakLZFJPu3f1u9jljRxs1QauBX00FITibJk
         4j0+BtJHyFiTPbX51JFLGVDyvzjtQ4ZXyMKiNPXp2AS1rDavQGW+9QJs2M+PE144SPvg
         vvpLUV1fa0I1nwEVyZes7oGOm7jUHFVA1d6LbkQgZtzZmQXHGHqu+EvR7SYWUf6cpUax
         px1pO2HBghoBM+rNhLDth2sjLnkW0pzgMGiOXBYKBaDCKKtN5TPTSgmKgKyBoTcN1lgb
         dtCisY4YnvruwBk9DODjiDIpsCkeaHpgPJr41+5XN+N3R7sWTweEJYwpwHYUBFOq7VN6
         ax0Q==
X-Gm-Message-State: AOAM532vm6b2gpZZ4bB8pgb56asi5JD5jUvsfeBP6+2ccc+RY55kdN5H
        yqJPXcwrzWHWvklxX0sKxSD4Pl4Ptu5sgZZ0C0l4fcqprVg=
X-Google-Smtp-Source: ABdhPJxuey+7YvjOHCyb/UoYoYOYp+VMMAVfZL8a6SDIMzd3d4M/j2J0R7ViaL6W0Mv8sDSEhqUJK607TowX8O6OYWs=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr8786662ljp.15.1634671833366;
 Tue, 19 Oct 2021 12:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211014211828.291213-1-cpp.code.lv@gmail.com> <1d0a5e90-b878-61a1-99af-35702b72f2d9@ovn.org>
In-Reply-To: <1d0a5e90-b878-61a1-99af-35702b72f2d9@ovn.org>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Tue, 19 Oct 2021 12:30:22 -0700
Message-ID: <CAASuNyXe6OYPe0Utd4xG1-ZTHZet3sJDi2sxXJ-7RWQ-GaEW2w@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v7] net: openvswitch: IPv6: Add IPv6
 extension header support
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 6:56 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> On 10/14/21 23:18, Toms Atteka wrote:
> > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > packets can be filtered using ipv6_ext flag.
> >
> > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > ---
> >  include/uapi/linux/openvswitch.h |  16 +++-
> >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> >  net/openvswitch/flow.h           |  14 ++++
> >  net/openvswitch/flow_netlink.c   |  24 +++++-
> >  4 files changed, 192 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44cd5590..763adf3dce23 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -344,8 +344,17 @@ enum ovs_key_attr {
> >       OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> >
> >  #ifdef __KERNEL__
> > -     OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > +     OVS_KEY_ATTR_TUNNEL_INFO,/* struct ip_tunnel_info */
> > +     __OVS_KEY_ATTR_PADDING_1,/* Padding to match field count with ovs */
> >  #endif
> > +
> > +#ifndef __KERNEL__
> > +     __OVS_KEY_ATTR_PADDING_2,/* Padding to match field count with ovs */
> > +     __OVS_KEY_ATTR_PADDING_3,/* Padding to match field count with ovs */
> > +#endif
> > +
> > +     OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> > +
> >       __OVS_KEY_ATTR_MAX
> >  };
>
> Not a full review, but, I think, that we should not add paddings, and
> define OVS_KEY_ATTR_IPV6_EXTHDRS before the OVS_KEY_ATTR_TUNNEL_INFO
> instead.  See my comments for v6:
>   https://lore.kernel.org/netdev/8c4ee3e8-0400-ee6e-b12c-327806f26dae@ovn.org/T/#u
>
> Best regards, Ilya Maximets.

Maybe I am still missing the idea, but I think it's not possible.

If we consider userspace code:
OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */

#ifdef __KERNEL__
/* Only used within kernel data path. */
OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ovs_tunnel_info */
#endif

#ifndef __KERNEL__
/* Only used within userspace data path. */
OVS_KEY_ATTR_PACKET_TYPE,  /* be32 packet type */
OVS_KEY_ATTR_ND_EXTENSIONS, /* struct ovs_key_nd_extensions */
#endif

__OVS_KEY_ATTR_MAX
};

adding OVS_KEY_ATTR_IPV6_EXTHDRS before OVS_KEY_ATTR_PACKET_TYPE will
conflict on kernel update.

And we will see following warning:
00001|odp_util(handler1)|WARN|attribute packet_type has length 2 but
should have length 4

Best,
Tom
