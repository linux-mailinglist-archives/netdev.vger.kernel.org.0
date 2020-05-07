Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E50B1C8BC3
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgEGNHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725914AbgEGNHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 09:07:19 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9949EC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 06:07:17 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id g16so4545051qtp.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 06:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPH72IsS/vjPPE4Bcel0j14BrAkWxWmAXRskLb+dFck=;
        b=hrMZauiglG4TWhm+S8AD7j2MgJ5wGYT+1peUu1xCxY00w+yJ27B5CJw41GXnQ0V8am
         jPP4BTSWM8IuRtedF72tXimmMGn5X/Aq6njdKWXVW+2UQ29zvIKJ2qNAqbUlS/iZ94d+
         8Q1LVyQkLeoaE51bFLg26J6xDDmxaykK3xuMItHDUhiHGSlInP0XaiIPNVH36x1CaGdp
         iXfiNbZ++2k9UzOYj4JgTOBML9Y6ROmQefvCgeOlHoqxCpUKll9D9txy9KdtRH6fJt5+
         IvVOQiBFUli0f+NZ+kEvMeYuvLDe0qd0C3of8JxxZlEnZ8sAyuPsfH4/QXxYhQJ6puWb
         tOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPH72IsS/vjPPE4Bcel0j14BrAkWxWmAXRskLb+dFck=;
        b=Qvo1+GG17v8GLhZ/v62dfULpPu5IKMGLhp/FFzMCCmknwIiB/XT6H0zz+q9MDg4PPw
         4e5kw8fO5BhY6KCzN59lZSv9y6fcWMEXVvAc3d8O0ezSkF+kHwaJNE7SfNOem+grvkQw
         T87VBSyThfNeyoFTmS1rZoKd4ss9leP/7aDBLb421yCSFJR3GUR8HqmYIUi9ntwThkvR
         5/6WbL8A8EE4mj2qIU0ldh7ZaYnahOOqtiXlwNnONdJ7FTzUS9207JNDE61bTPz2xMkB
         w5atvN34fS1omqMwtQyTKTr0mjrYDsXCKA2IuHgnJ7lt349EH8qkT6Fme5bmmnUHOeTe
         5RfQ==
X-Gm-Message-State: AGi0PuaiC+3F+656YGpLbExlXDHaMbB1lRMEdJ4HguetiIKSPuT4FDpa
        4yXBtrv7luNAaGnQywG83TSjiD/ibRPmc3dLQEg=
X-Google-Smtp-Source: APiQypLDzh/Xb2YzFqDcKWIMWAF+Uk9dvd032IVjegaOXlXzxzMYnSh6v2tYNGiRMmlbrH21k1BOeHRofFGKTmXSZvA=
X-Received: by 2002:aed:3e87:: with SMTP id n7mr13902471qtf.301.1588856836571;
 Thu, 07 May 2020 06:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <1588694706-26433-1-git-send-email-u9012063@gmail.com> <9a4d33eb-7429-b852-cfa9-b47838672f37@gmail.com>
In-Reply-To: <9a4d33eb-7429-b852-cfa9-b47838672f37@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Thu, 7 May 2020 06:06:40 -0700
Message-ID: <CALDO+SbjBJOp3UdnfX-rmzwcV1UoRsTPTodUn5vxapXEJf-ksQ@mail.gmail.com>
Subject: Re: [PATCHv2] erspan: Add type I version 0 support.
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 7:42 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/5/20 9:05 AM, William Tu wrote:
> > The Type I ERSPAN frame format is based on the barebones
> > IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
> > Both type I and II use 0x88BE as protocol type. Unlike type II
> > and III, no sequence number or key is required.
> > To creat a type I erspan tunnel device:
> >   $ ip link add dev erspan11 type erspan \
> >             local 172.16.1.100 remote 172.16.1.200 \
> >             erspan_ver 0
> >
> > Signed-off-by: William Tu <u9012063@gmail.com>
> > ---
> > v2:
> >   remove the inline keyword, let compiler decide.
> > v1:
> > I didn't notice there is Type I when I did first erspan implementation
> > because it is not in the ietf draft 00 and 01. It's until recently I got
> > request for adding type I. Spec is below at draft 02:
> > https://tools.ietf.org/html/draft-foschiano-erspan-02#section-4.1
> >
> > To verify with Wireshark, make sure you have:
> > commit ef76d65fc61d01c2ce5184140f4b1bba0019078b
> > Author: Guy Harris <guy@alum.mit.edu>
> > Date:   Mon Sep 30 16:35:35 2019 -0700
> >
> >     Fix checks for "do we have an ERSPAN header?"
> > ---
> >  include/net/erspan.h | 19 +++++++++++++++--
> >  net/ipv4/ip_gre.c    | 58 ++++++++++++++++++++++++++++++++++++++--------------
> >  2 files changed, 60 insertions(+), 17 deletions(-)
> >
> > diff --git a/include/net/erspan.h b/include/net/erspan.h
> > index b39643ef4c95..0d9e86bd9893 100644
> > --- a/include/net/erspan.h
> > +++ b/include/net/erspan.h
> > @@ -2,7 +2,19 @@
> >  #define __LINUX_ERSPAN_H
> >
> >  /*
> > - * GRE header for ERSPAN encapsulation (8 octets [34:41]) -- 8 bytes
> > + * GRE header for ERSPAN type I encapsulation (4 octets [34:37])
> > + *      0                   1                   2                   3
> > + *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> > + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > + *     |0|0|0|0|0|00000|000000000|00000|    Protocol Type for ERSPAN   |
> > + *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > + *
> > + *  The Type I ERSPAN frame format is based on the barebones IP + GRE
> > + *  encapsulation (as described above) on top of the raw mirrored frame.
> > + *  There is no extra ERSPAN header.
> > + *
> > + *
> > + * GRE header for ERSPAN type II and II encapsulation (8 octets [34:41])
> >   *       0                   1                   2                   3
> >   *      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> >   *     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> > @@ -43,7 +55,7 @@
> >   * |                  Platform Specific Info                       |
> >   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >   *
> > - * GRE proto ERSPAN type II = 0x88BE, type III = 0x22EB
> > + * GRE proto ERSPAN type I/II = 0x88BE, type III = 0x22EB
> >   */
> >
> >  #include <uapi/linux/erspan.h>
> > @@ -139,6 +151,9 @@ static inline u8 get_hwid(const struct erspan_md2 *md2)
> >
> >  static inline int erspan_hdr_len(int version)
> >  {
> > +     if (version == 0)
> > +             return 0;
> > +
> >       return sizeof(struct erspan_base_hdr) +
> >              (version == 1 ? ERSPAN_V1_MDSIZE : ERSPAN_V2_MDSIZE);
> >  }
> > diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> > index 029b24eeafba..e29cd48674d7 100644
> > --- a/net/ipv4/ip_gre.c
> > +++ b/net/ipv4/ip_gre.c
> > @@ -248,6 +248,15 @@ static void gre_err(struct sk_buff *skb, u32 info)
> >       ipgre_err(skb, info, &tpi);
> >  }
> >
> > +static bool is_erspan_type1(int gre_hdr_len)
> > +{
> > +     /* Both ERSPAN type I (version 0) and type II (version 1) use
> > +      * protocol 0x88BE, but the type I has only 4-byte GRE header,
> > +      * while type II has 8-byte.
> > +      */
> > +     return gre_hdr_len == 4;
> > +}
> > +
> >  static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
> >                     int gre_hdr_len)
> >  {
> > @@ -262,17 +271,26 @@ static int erspan_rcv(struct sk_buff *skb, struct tnl_ptk_info *tpi,
> >       int len;
> >
> >       itn = net_generic(net, erspan_net_id);
> > -
> >       iph = ip_hdr(skb);
> > -     ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
> > -     ver = ershdr->ver;
> > -
> > -     tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> > -                               tpi->flags | TUNNEL_KEY,
> > -                               iph->saddr, iph->daddr, tpi->key);
> > +     if (is_erspan_type1(gre_hdr_len)) {
> > +             ver = 0;
> > +             tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> > +                                       tpi->flags | TUNNEL_NO_KEY,
> > +                                       iph->saddr, iph->daddr, 0);
> > +     } else {
> > +             ershdr = (struct erspan_base_hdr *)(skb->data + gre_hdr_len);
> > +             ver = ershdr->ver;
> > +             tunnel = ip_tunnel_lookup(itn, skb->dev->ifindex,
> > +                                       tpi->flags | TUNNEL_KEY,
> > +                                       iph->saddr, iph->daddr, tpi->key);
> > +     }
> >
> >       if (tunnel) {
> > -             len = gre_hdr_len + erspan_hdr_len(ver);
> > +             if (is_erspan_type1(gre_hdr_len))
> > +                     len = gre_hdr_len;
> > +             else
> > +                     len = gre_hdr_len + erspan_hdr_len(ver);
> > +
> >               if (unlikely(!pskb_may_pull(skb, len)))
> >                       return PACKET_REJECT;
> >
> > @@ -665,7 +683,10 @@ static netdev_tx_t erspan_xmit(struct sk_buff *skb,
> >       }
> >
> >       /* Push ERSPAN header */
> > -     if (tunnel->erspan_ver == 1) {
> > +     if (tunnel->erspan_ver == 0) {
> > +             proto = htons(ETH_P_ERSPAN);
> > +             tunnel->parms.o_flags &= ~TUNNEL_SEQ;
> > +     } else if (tunnel->erspan_ver == 1) {
> >               erspan_build_header(skb, ntohl(tunnel->parms.o_key),
> >                                   tunnel->index,
> >                                   truncate, true);
> > @@ -1066,7 +1087,10 @@ static int erspan_validate(struct nlattr *tb[], struct nlattr *data[],
> >       if (ret)
> >               return ret;
> >
> > -     /* ERSPAN should only have GRE sequence and key flag */
> > +     if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
>
> I do not see anything in the code making sure IFLA_GRE_ERSPAN_VER has been provided by the user ?
>
Hi Eric,

Thanks! at the iproute2 we always set the IFLA_GRE_ERSPAN_VER to 1 as
default when user
doesn't specify. But I should also make sure it is checked here for
non-iproute2 users.

If I understand correctly, I should add
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1087,7 +1087,7 @@ static int erspan_validate(struct nlattr *tb[],
struct nlattr *data[],
        if (ret)
                return ret;

-       if (nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
+       if (data[IFLA_GRE_ERSPAN_VER] &&
nla_get_u8(data[IFLA_GRE_ERSPAN_VER]) == 0)
                return 0;

        /* ERSPAN type II/III should only have GRE sequence and key flag */

Regards,
William
