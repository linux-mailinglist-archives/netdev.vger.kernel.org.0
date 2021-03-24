Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707543476B6
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 12:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhCXLBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 07:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhCXLBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 07:01:32 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAC9C061763;
        Wed, 24 Mar 2021 04:01:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id q26so12257634qkm.6;
        Wed, 24 Mar 2021 04:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E01fHFK8B0CwUT/NlAoEwx2voqfnNCEWOzjDvw2m6n4=;
        b=NY7yAw8cgzTULkuOmQLe2iktQaWt4puHb7S1TNfzJGWZHdxtmXziQBVPoR8kCKTFyn
         +Yz3LuSF505XWHMfmShaq4dINFkf7D/si3f92ZufU9SQt7w7Kmal8sIzimlIC4BqiXdu
         4sROjr2nLVbDC5t+0JYOUe1av60D0+MHPpWc6DIbOfOw+Tvfg009WQlpu+BtOLpIQV/U
         OnGCIS1DM0wDVi4oZIAL216VlCG/xmFKx5bdG2JmVp4MHiNi+DJJRB3RaCfsAgDeV7Nn
         N+KBIbxgQe+aRb2AoiXomVW4ZromWvkZvHY8HGdCHCYWcLMsU3lq1wa0dD+N8PatFXGx
         ZD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E01fHFK8B0CwUT/NlAoEwx2voqfnNCEWOzjDvw2m6n4=;
        b=AUNDkNTr5+0VedCBimKq+86r+awWk2W7dWKKGgL/RIZ7B4Tdy/1JExkg7LTyLRrfxA
         1rDnBQ+24Uvj63sHOWr5E6SC75g26DmZJW9NmtM4gQQqzBFaaEJimvk2nDzTJJXLwS7W
         WVZ8oYPoIzThDbcs3c4VcDXle4lGNqFwhE4FI8fmspwy62Dwc0RaoIpC7XcQHMCSrpDj
         cOUgqnquFSjr+Smxr8uu1ozms7DrYEfoCSCFvoU9Mb5r1mR/D/WNamaQrFZW4rR6Urd+
         KOc7vuwCevSR3W/GFXQ6KzT+ubZISYmxzTqAesjYPhSAl+9DUEXolS7nKIWL6BPx564A
         FQzw==
X-Gm-Message-State: AOAM531lMmTJSPEBhStdbCE5+FV9FUsgfW8eYp3nFnWBjoMqFMjhcvgK
        vaEL1Cy5OGyLRTvX0wUiQbVrxcwxsRQPzgp0BGAu5W5fdEKWYg==
X-Google-Smtp-Source: ABdhPJytap/S1ltJf1op8lX8miHVyKrZXtLRsceZm6unF3ougp9sQStKo5N+OsDjX6fVMFoTNGd+nFyhniTnt3rIt8s=
X-Received: by 2002:a37:6c3:: with SMTP id 186mr2289123qkg.279.1616583691583;
 Wed, 24 Mar 2021 04:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210324030923.17203-1-yejune.deng@gmail.com> <YFsVzP6P9l0aaIVo@unreal>
In-Reply-To: <YFsVzP6P9l0aaIVo@unreal>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Wed, 24 Mar 2021 19:01:19 +0800
Message-ID: <CABWKuGUPkMHZj6qsAYmCnc==4pP8vyYK-3TRJ9oG8mk=nJBLAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: ipv4: route.c: add likely() statements
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yejune@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My reasons are as following: ipv4_confirm_neigh() belongs to
ipv4_dst_ops that family is AF_INET, and ipv4_neigh_lookup() is also
added likely() when rt->rt_gw_family is equal to AF_INET.

On Wed, Mar 24, 2021 at 6:34 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Mar 24, 2021 at 11:09:22AM +0800, Yejune Deng wrote:
> > Add likely() statements in ipv4_confirm_neigh() for 'rt->rt_gw_family
> > == AF_INET'.
>
> Why? Such macros are beneficial in only specific cases, most of the time,
> likely/unlikely is cargo cult.
>
> >
> > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > ---
> >  net/ipv4/route.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index fa68c2612252..5762d9bc671c 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
> >       struct net_device *dev = dst->dev;
> >       const __be32 *pkey = daddr;
> >
> > -     if (rt->rt_gw_family == AF_INET) {
> > +     if (likely(rt->rt_gw_family == AF_INET)) {
> >               pkey = (const __be32 *)&rt->rt_gw4;
> >       } else if (rt->rt_gw_family == AF_INET6) {
> >               return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
> > --
> > 2.29.0
> >
