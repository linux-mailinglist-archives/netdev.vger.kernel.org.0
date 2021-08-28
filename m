Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5D3FA68E
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 17:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhH1PrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhH1PrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 11:47:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C44AC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 08:46:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id dm15so14521786edb.10
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 08:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oTocAbjetXItnv/iu4F61TrmDwYv1m0YpAQCT+2rEQ8=;
        b=TUdPiLclFpnyhDKZke+5BvXcyby2c3HJQDC1aVr0lL/BLsa8vi40AsOvzBLUc6tagq
         CuADODCkTQPSkCxfhDaggGvxaukzKCmpA70K5ksv9kQkb6ONM3vzpEAwsj4RM0barNNQ
         EhmrSv5IiN3Y7FfEsfZA85E4TeGViKCFRuRmuSQar+5NLUqoXgGcne8UEgd5BdfPvbZk
         fnMovpVECAOZANY8UDde+5YFczhaQAqaAQOHBd50wUiuf4SrAJWGIfd0SH4YkzRb44nk
         JyDMx8bm2QWhqJmsez3FPRJQAPPzZOpXKso/gONqIYQIdhyQwmi3QhZvaf4xcku8GvQ+
         ewsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oTocAbjetXItnv/iu4F61TrmDwYv1m0YpAQCT+2rEQ8=;
        b=MkpMidRjuT5Lmrc0lIu+TKSyuzEQkvFCVki1aS4h70wC82T2pZVkVe8+XgnY18y1dC
         wVYOVrP+LVmRJbDxqT6jkao/jt0i48bXuhj9uZd7bn2KGMId2NALMIKw08f8COxA1Bjh
         9b9BKY6g8qLGM5r4y+VGyYP2sAfLE/5k9TSmixvjbF8NHS8XRDL2dovNteEmoiltv2Ny
         PyBDaxaOFBBmjyshHUtJToGSIG0vx6VZzUhg3QaIlveQIspl/58GHzT7KG0LTVJr8LS5
         9AlOIWr+ZiRYtyBULxwd5GC7UK5CUyxCNn0PM1b95YUwLC44qbbq1LGfbYUCN2/e3jDK
         nFVg==
X-Gm-Message-State: AOAM531dvcxEFJ706+AP4Jz4eBkvOc+0lUviysrl699S/lokCDyvRqEM
        zWGdtk3ukHhovbdkTyjrcQWbsgTGXm/kqqacdmc=
X-Google-Smtp-Source: ABdhPJwMI4pOrcJSj68DCaj4gahlcbQNXrB2h/eXQ7hlBxopw3aPLJzgZr0QoehyluPPkCpSq0B/ravQYaXZ0h/abgo=
X-Received: by 2002:aa7:d645:: with SMTP id v5mr15610473edr.145.1630165583781;
 Sat, 28 Aug 2021 08:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210828084307.70316-1-shjy180909@gmail.com> <44c13ff2-e693-605c-1851-c161492166cb@nvidia.com>
In-Reply-To: <44c13ff2-e693-605c-1851-c161492166cb@nvidia.com>
From:   =?UTF-8?B?7KeE7ISx7Z2s?= <shjy180909@gmail.com>
Date:   Sun, 29 Aug 2021 00:46:12 +0900
Message-ID: <CAJg10rJGQ1P7eNYbvZhWXL9gvJPbcsnkD0c8LQEBRaoLu5s5nQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bridge: use mld2r_ngrec instead of icmpv6_dataun
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021=EB=85=84 8=EC=9B=94 28=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 6:51, N=
ikolay Aleksandrov <nikolay@nvidia.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On 28/08/2021 11:43, shjy180909@gmail.com wrote:
> > From: MichelleJin <shjy180909@gmail.com>
> >
> > using icmp6h->mld2r_ngrec instead of icmp6h->icmp6_dataun.un_data16[1].
> >
> > Signed-off-by: MichelleJin <shjy180909@gmail.com>
> > ---
> >  net/bridge/br_multicast.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index 2c437d4bf632..8e38e02208bd 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -2731,8 +2731,8 @@ static int br_ip6_multicast_mld2_report(struct ne=
t_bridge_mcast *brmctx,
> >       struct net_bridge_mdb_entry *mdst;
> >       struct net_bridge_port_group *pg;
> >       unsigned int nsrcs_offset;
> > +     struct mld2_report *mld2r;
> >       const unsigned char *src;
> > -     struct icmp6hdr *icmp6h;
> >       struct in6_addr *h_addr;
> >       struct mld2_grec *grec;
> >       unsigned int grec_len;
> > @@ -2740,12 +2740,12 @@ static int br_ip6_multicast_mld2_report(struct =
net_bridge_mcast *brmctx,
> >       int i, len, num;
> >       int err =3D 0;
> >
> > -     if (!ipv6_mc_may_pull(skb, sizeof(*icmp6h)))
> > +     if (!ipv6_mc_may_pull(skb, sizeof(*mld2r)))
> >               return -EINVAL;
> >
> > -     icmp6h =3D icmp6_hdr(skb);
> > -     num =3D ntohs(icmp6h->icmp6_dataun.un_data16[1]);
> > -     len =3D skb_transport_offset(skb) + sizeof(*icmp6h);
> > +     mld2r =3D (struct mld2_report *) icmp6_hdr(skb);
> > +     num =3D ntohs(mld2r->mld2r_ngrec);
> > +     len =3D skb_transport_offset(skb) + sizeof(*mld2r);
> >
> >       for (i =3D 0; i < num; i++) {
> >               __be16 *_nsrcs, __nsrcs;
> >
>
> Indeed it should be equivalent, have you run the bridge selftests with th=
is change?
>
>

I did printk tests.

There's no difference between mld2r->mld2r_ngrec and

icmp6h->icmp6_dataun.un_data16[1].

Also, there is no difference between sizeof(*mld2r) and sizeof(*icmp6h).

test code:
static int br_ip6_multicast_mld2_report(struct net_bridge_mcast *brmctx,
                                        struct net_bridge_mcast_port *pmctx=
,
                                        struct sk_buff *skb,
                                        u16 vid)
{
...
        struct mld2_report *mld2r; //
        struct icmp6hdr *icmp6h; //
...

        mld2r =3D (struct mld2_report *) icmp6_hdr(skb); //
        icmp6h =3D icmp6_hdr(skb); //

        num =3D ntohs(mld2r->mld2r_ngrec);
        printk("[TEST]%s %u num1 =3D %u num2 =3D %u \n",
                  __func__, __LINE__,
                  ntohs(mld2r->mld2r_ngrec),
                  ntohs(icmp6h->icmp6_dataun.un_data16[1]));
        printk("[TEST]%s %u size1 =3D %lu size2 =3D %lu \n",
                  __func__, __LINE__,
                  sizeof(*mld2r),
                  sizeof(*icmp6h));

        len =3D skb_transport_offset(skb) + sizeof(*mld2r);


result:
[ 4932.345658] [TEST]br_ip6_multicast_mld2_report 2751 num1 =3D 2 num2 =3D =
2
[ 4932.345665] [TEST]br_ip6_multicast_mld2_report 2752 size1 =3D 8 size2 =
=3D 8

The num1 and num2 are indeed equivalent.
Also, the size1 and size2 are equivalent.
