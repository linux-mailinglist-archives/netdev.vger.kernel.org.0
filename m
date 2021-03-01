Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E1C3275E6
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 02:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbhCABoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 20:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhCABoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 20:44:03 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239ACC06174A;
        Sun, 28 Feb 2021 17:43:23 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id s7so4968466qkg.4;
        Sun, 28 Feb 2021 17:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aRJxGDa+J6w/kx8AzlgOwBwW/kGWEGGndzPstBNruVg=;
        b=eUqxoITuRO88v1pWT5sA1qBUfJlYWiVeQ4/LsJcucnDTR61Iq6mMPN3hTwt0Cumqps
         ZDesTo3gwF6xYFMluPlKADHHZlhRcpmPyF0GGvxczEGBIz26simOXlXBPjy7ch+ZXfIS
         cljfBrfjqzUhrltk2zY3PlwPUGJk6Wx78pSI9cETlOz4tm46mG8UF/99ezgZ/1molKdr
         jZxzn5qwgA23OC+BuYHNqXRkHY748qmh11U0CsfYnWehmDjyWKjRvhwtCY1LQdoyLVFw
         25g0Gix69SpNPm6isV2XvIO2H3swMXttmGNnL9aezPosvwWivtLdvB3+U9GTFc8Qr7QM
         OV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aRJxGDa+J6w/kx8AzlgOwBwW/kGWEGGndzPstBNruVg=;
        b=BuIHu/exttmsL2q9jUisOhFqNqx51IHJJkMC3NXPEDJSfyZl4P9QoV6f65Dm/ioGWo
         GhypeDtuvJ5Em0QsQRbTryWQaKLtnT9MUse1MNu0J+56K25Qwoo1hqqldrzZ8aW2yGQd
         TinCGq82MGeNqTViZu/pqAcp3BE6tVULBwUfSTvf1WwZpu473vw/T9s72WtSo6I6+OMH
         ZfYgSyfbNfFAODml5cJBJJAtu/+frBESdQf4+1gqB+/hDuqjL8PWruLg8a7o1j6FA3u+
         ysoffGQiTL3d5udNjB0K2mwJd71aYAx82qvjb+qTAq+vDRaKvKCurbaf9StBvQbbRxiD
         5LTQ==
X-Gm-Message-State: AOAM5333xpacasIcgdtklHrvQjTMS4MJTXqzDG9UemaZge7Vb8lmYRgr
        aCeSdoSK20MPU7pbabiH1POQjfhU50Ei11f9gOE=
X-Google-Smtp-Source: ABdhPJwNnsqeCX0zu627oXAjvEgz30921B/QXoR5MeBCgyozRuFZ/i198WE2IyNfUxP+RoTR4meys9KYZOBpGTT5fC4=
X-Received: by 2002:a37:9e56:: with SMTP id h83mr9223957qke.38.1614563002416;
 Sun, 28 Feb 2021 17:43:22 -0800 (PST)
MIME-Version: 1.0
References: <20210226105746.29240-1-yejune.deng@gmail.com> <d16327f3-33c0-61c1-3adf-78f7edcbec6a@gmail.com>
In-Reply-To: <d16327f3-33c0-61c1-3adf-78f7edcbec6a@gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Mon, 1 Mar 2021 09:43:10 +0800
Message-ID: <CABWKuGU=sjmMer2rY3eQ2ttO+6SqeJ7K5T6oJrTUrsfOARx1MA@mail.gmail.com>
Subject: Re: [PATCH] inetpeer: use else if instead of if to reduce judgment
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks=EF=BC=8CI will adopt it and resubmit.

On Fri, Feb 26, 2021 at 10:50 PM Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
>
>
>
> On 2/26/21 11:57 AM, Yejune Deng wrote:
> > In inet_initpeers(), if si.totalram <=3D (8192*1024)/PAGE_SIZE, it will
> > be judged three times. Use else if instead of if, it only needs to be
> > judged once.
> >
> > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > ---
> >  net/ipv4/inetpeer.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> > index ff327a62c9ce..07cd1f8204b3 100644
> > --- a/net/ipv4/inetpeer.c
> > +++ b/net/ipv4/inetpeer.c
> > @@ -81,12 +81,12 @@ void __init inet_initpeers(void)
> >        * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the va=
lues
> >        * myself.  --SAW
> >        */
> > -     if (si.totalram <=3D (32768*1024)/PAGE_SIZE)
> > +     if (si.totalram <=3D (8192 * 1024) / PAGE_SIZE)
> > +             inet_peer_threshold >>=3D 4; /* about 128KB */
> > +     else if (si.totalram <=3D (16384 * 1024) / PAGE_SIZE)
> > +             inet_peer_threshold >>=3D 2; /* about 512KB */
> > +     else if (si.totalram <=3D (32768 * 1024) / PAGE_SIZE)
> >               inet_peer_threshold >>=3D 1; /* max pool size about 1MB o=
n IA32 */
>
>
> If you really want to change this stuff, I would suggest updating comment=
s,
> because nowadays, struct inet_peer on IA32 uses 128 bytes.
>
> So 32768 entries would consume 4 MB,
>    16384 entries would consume 2 MB
>
> and 4096 entries would consume 512KB
>
> Another idea would be to get rid of the cascade and use something that
> will not need to be adjusted in the future.
>
> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index ff327a62c9ce9b1794104c3c924f5f2b9820ac8b..d5f486bd8c35234f99b22842e=
756a10531e070d6 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -65,7 +65,7 @@ EXPORT_SYMBOL_GPL(inet_peer_base_init);
>  #define PEER_MAX_GC 32
>
>  /* Exported for sysctl_net_ipv4.  */
> -int inet_peer_threshold __read_mostly =3D 65536 + 128;   /* start to thr=
ow entries more
> +int inet_peer_threshold __read_mostly; /* start to throw entries more
>                                          * aggressively at this stage */
>  int inet_peer_minttl __read_mostly =3D 120 * HZ; /* TTL under high load:=
 120 sec */
>  int inet_peer_maxttl __read_mostly =3D 10 * 60 * HZ;     /* usual time t=
o live: 10 min */
> @@ -73,20 +73,13 @@ int inet_peer_maxttl __read_mostly =3D 10 * 60 * HZ; =
 /* usual time to live: 10 min
>  /* Called from ip_output.c:ip_init  */
>  void __init inet_initpeers(void)
>  {
> -       struct sysinfo si;
> +       u64 nr_entries;
>
> -       /* Use the straight interface to information about memory. */
> -       si_meminfo(&si);
> -       /* The values below were suggested by Alexey Kuznetsov
> -        * <kuznet@ms2.inr.ac.ru>.  I don't have any opinion about the va=
lues
> -        * myself.  --SAW
> -        */
> -       if (si.totalram <=3D (32768*1024)/PAGE_SIZE)
> -               inet_peer_threshold >>=3D 1; /* max pool size about 1MB o=
n IA32 */
> -       if (si.totalram <=3D (16384*1024)/PAGE_SIZE)
> -               inet_peer_threshold >>=3D 1; /* about 512KB */
> -       if (si.totalram <=3D (8192*1024)/PAGE_SIZE)
> -               inet_peer_threshold >>=3D 2; /* about 128KB */
> +       /* 1% of physical memory */
> +       nr_entries =3D div64_ul((u64)totalram_pages() << PAGE_SHIFT,
> +                             100 * L1_CACHE_ALIGN(sizeof(struct inet_pee=
r)));
> +
> +       inet_peer_threshold =3D clamp_val(nr_entries, 4096, 65536 + 128);
>
>         peer_cachep =3D kmem_cache_create("inet_peer_cache",
>                         sizeof(struct inet_peer),
>
>
>
>
>
>
