Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A1D2B762E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgKRGPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgKRGPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:15:02 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAD1C0613D4;
        Tue, 17 Nov 2020 22:15:02 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id b6so996853wrt.4;
        Tue, 17 Nov 2020 22:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dIH+s1+Zpj14XWt2KpCVb23dtGbzmzslIvD+/D2vu6M=;
        b=ViXh1yHmfykfHvFzElxHW/1yHq6VmM/dgcg6wow1+Dk4lkVXde11OdU8hIOBG9UJQs
         aaTI7CzPqzrq5hUkQ4r6WhC/xYYssH5oZ9gyJXmc7lnUrWXoU4WG0EGFIxXhCldjCpGb
         qLueb6jDci3l38GSl9rhJgP13iH1AxbmtFuMurNnvfJldsfWsNpr/280cacaFLbq2LhA
         WvbY9fimyy+jj1qoLdruhCJXRj6w2XSG2tzCi5CAq1vm5j6cktpqKMasz0vmP7YWuvoz
         x5L4vhrc73tgVkbdgEB0R9dzoK9OTaJWYjMbnjtgIPRlSuIJwekTgdkG3tUBySjdNlr+
         Rfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dIH+s1+Zpj14XWt2KpCVb23dtGbzmzslIvD+/D2vu6M=;
        b=r5Gbqh3sUbE8FNsaxxQ+5jGTDFeAvrARpZ87rUBFZE7ma9E//6uVoe1gnU8VvkKdvQ
         lJaC5IRpw1VvZWwZQD+dGBmSppXBHJiFJTRqVEFcCnSMeWeikdOEbIaj9M+33g0tiCDD
         Pjwesd8AEUCUiwUHDGDWV2fER8xVYo/PJbwmZZzYWyzvYmHc+G3zDq+XYUUOiQj/PZjX
         d/B/ggtaamL63o02EtuhSe9W9snBBcyI7puTWHbLl2u6FUUC4cjHZkTm2yW1s26v31zE
         XtylwHfzuWhbl5MLyqHJ2t93e6DfwI9Jzlwso0H6jHF5Lle8tIFsiapBklOPhDD3O6q4
         yX7w==
X-Gm-Message-State: AOAM5333zGF0FqJ2NXe6g5qMtQbZk4zOqxyVlNgVame/2ueO0x1eX2Ak
        ZLUVByXi3Lrx+TE3szTH1F841F8CJpR+xUQyrX4=
X-Google-Smtp-Source: ABdhPJxt6PFdDgnPi3gmrA2zUwR/hjaFQGZ6UaEAOOTr5b20F5wzzDQUxw5Dv+QiQnt9BzhaoMMoOyuAP3qRwYOwbvc=
X-Received: by 2002:a5d:5701:: with SMTP id a1mr2985209wrv.120.1605680100936;
 Tue, 17 Nov 2020 22:15:00 -0800 (PST)
MIME-Version: 1.0
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
 <20201117162952.29c1a699@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117162952.29c1a699@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 18 Nov 2020 14:14:49 +0800
Message-ID: <CADvbK_eP4ap74vbZ64S8isYr5nz33ZdLB7qsyqd5zqqGV-rvWA@mail.gmail.com>
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem <davem@davemloft.net>, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, lorenzo@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 8:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Nov 2020 17:15:47 +0800 Xin Long wrote:
> > This patch is to let it always do CRC checksum in sctp_gso_segment()
> > by removing CRC flag from the dev features in gre_gso_segment() for
> > SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> > sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> >
> > It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> > after that commit, so it would do checksum with gso_make_checksum()
> > in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> > gre csum for sctp over gre tunnels") can be reverted now.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> Makes sense, but does GRE tunnels don't always have a csum.
Do you mean the GRE csum can be offloaded? If so, it seems for GRE tunnel
we need the similar one as:

commit 4bcb877d257c87298aedead1ffeaba0d5df1991d
Author: Tom Herbert <therbert@google.com>
Date:   Tue Nov 4 09:06:52 2014 -0800

    udp: Offload outer UDP tunnel csum if available

I will confirm and implement it in another patch.

>
> Is the current hardware not capable of generating CRC csums over
> encapsulated patches at all?
There is, but very rare. The thing is after doing CRC csum, the outer
GRE/UDP checksum will have to be recomputed, as it's NOT zero after
all fields for CRC scum are summed, which is different from the
common checksum. So if it's a GRE/UDP tunnel, the inner CRC csum
has to be done there even if the HW supports its offload.

>
> I guess UDP tunnels can be configured without the csums as well
> so the situation isn't much different.
>
> > diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> > index e0a2465..a5935d4 100644
> > --- a/net/ipv4/gre_offload.c
> > +++ b/net/ipv4/gre_offload.c
> > @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >                                      netdev_features_t features)
> >  {
> >       int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> > -     bool need_csum, need_recompute_csum, gso_partial;
> >       struct sk_buff *segs = ERR_PTR(-EINVAL);
> >       u16 mac_offset = skb->mac_header;
> >       __be16 protocol = skb->protocol;
> >       u16 mac_len = skb->mac_len;
> >       int gre_offset, outer_hlen;
> > +     bool need_csum, gso_partial;
>
> Nit, rev xmas tree looks broken now.
Will fix it in v2, :D

Thanks.
>
> >       if (!skb->encapsulation)
> >               goto out;
> > @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >       skb->protocol = skb->inner_protocol;
> >
> >       need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> > -     need_recompute_csum = skb->csum_not_inet;
> >       skb->encap_hdr_csum = need_csum;
> >
> >       features &= skb->dev->hw_enc_features;
> > +     features &= ~NETIF_F_SCTP_CRC;
> >
> >       /* segment inner packet. */
> >       segs = skb_mac_gso_segment(skb, features);
> > @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
> >               }
> >
> >               *(pcsum + 1) = 0;
> > -             if (need_recompute_csum && !skb_is_gso(skb)) {
> > -                     __wsum csum;
> > -
> > -                     csum = skb_checksum(skb, gre_offset,
> > -                                         skb->len - gre_offset, 0);
> > -                     *pcsum = csum_fold(csum);
> > -             } else {
> > -                     *pcsum = gso_make_checksum(skb, 0);
> > -             }
> > +             *pcsum = gso_make_checksum(skb, 0);
> >       } while ((skb = skb->next));
> >  out:
> >       return segs;
>
