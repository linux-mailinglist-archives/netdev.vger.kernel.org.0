Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866F123FDBA
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 12:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHIKwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 06:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHIKw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 06:52:28 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC87CC061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 03:52:24 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so5558189wrl.4
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 03:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+kQ1KrsIJ+FkTFLVFU2A1N4jx4X8shYKGwpY2heK7PY=;
        b=E2QNeO8VJ5bN6g3rujjALFmYlqdGWDLjA1DuwgL5wY7sNYAwk3eE4YrK90OEqANebJ
         T4Tmgd7rlcdZlr0nA9TAVCSMLFElTqWWT6BeMFHA0WGmuUTVy35L2nbsy9Rs4Ss0rxgG
         +CKKSeUjV9BlF/mD5MRRFf05TLq9velrVV5XNCzRVqIVw21SiDHrWfWAibtFHE18k1Ln
         68QN9QTbi65b4CNJUa/EkRQ4YMKJZD2NIk5+mOf+OG5XkzGgK9CKmTzoZ1JrbwKCRZ1I
         vQorQXM2PERpFTxQ6F/pSkgQwhrln5HydlhoN83E5IIdsZxB1O/kTHH7qGxYfKVLt0g4
         9NiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+kQ1KrsIJ+FkTFLVFU2A1N4jx4X8shYKGwpY2heK7PY=;
        b=oY7PzLGADRMnrZLEuiFefLxtkHJMiQkXlaVmI2pV8ePq/Af68EMJ7VpZoi5rQU9IYF
         QDDphdmRZd9w5suQjFlgpK7DUxWESO3no13hNjctKWN+23zwmnCPAuGtIasQvVu9POTv
         ztdDycTE673EHiKYReizjOvBBSfe29nuysS5krz7fYPvqx+2vXPudPaSR6AJiRyU09s9
         mw2jGDQi1I3k+/9IQ+2iZwFwsDbiJPnLFralBAF3IoxFETGcp1Ka7OLeP5uRlhsVfRFw
         u2KOmmSPJ4L66mMKQ+yVlhjfQzlG+ERjdkuP+v6bXfB966Xqko57zmWAvzlPyknTzkCD
         XdYA==
X-Gm-Message-State: AOAM531z2IZBGlq+v7YdztWKPletN2rWcHi0j5wTqMx5iINIbT15koTR
        tSXcC/97miMlj+uOWQjUv5NvJPHmjLWNeS7+xJc=
X-Google-Smtp-Source: ABdhPJx8G9rbY/hJ7hzU15iFMZ6kUYOUYAAFwjobxbuT4i25VETaH90hk7slhIdDB/2tPJm4q58Sh03FO6jy5g7vaC8=
X-Received: by 2002:adf:fd91:: with SMTP id d17mr19118093wrr.234.1596970342782;
 Sun, 09 Aug 2020 03:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596468610.git.lucien.xin@gmail.com> <7ba2ca17347249b980731e7a76ba3e24a9e37720.1596468610.git.lucien.xin@gmail.com>
 <CAPA1RqCz=h-RBu-md1rJ5WLWsr9LLqO8bK9D=q6_vzYMz7564A@mail.gmail.com>
 <CADvbK_dSnrBkw_hJV8LVCEs9D-WB+h2QC3JghLCxVwV5PW9YYA@mail.gmail.com>
 <1f510387-b612-6cb4-8ee6-ff52f6ff6796@gmail.com> <CAPA1RqAFkQG-LBTcj80nt4CbWnE7ni+wgCBJU3-up7ROoR9-3w@mail.gmail.com>
In-Reply-To: <CAPA1RqAFkQG-LBTcj80nt4CbWnE7ni+wgCBJU3-up7ROoR9-3w@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 9 Aug 2020 19:04:21 +0800
Message-ID: <CADvbK_eEQJUEZuJh4TwxFedR3qawt0HTyQ28rVeZVzecLk5_Ow@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: add ipv6_dev_find()
To:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, jmaloy@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 5:26 PM Hideaki Yoshifuji
<hideaki.yoshifuji@miraclelinux.com> wrote:
>
> Hi,
>
> 2020=E5=B9=B48=E6=9C=886=E6=97=A5(=E6=9C=A8) 23:03 David Ahern <dsahern@g=
mail.com>:
> >
> > On 8/6/20 2:55 AM, Xin Long wrote:
> > > On Thu, Aug 6, 2020 at 10:50 AM Hideaki Yoshifuji
> > > <hideaki.yoshifuji@miraclelinux.com> wrote:
> > >>
> > >> Hi,
> > >>
> > >> 2020=E5=B9=B48=E6=9C=884=E6=97=A5(=E7=81=AB) 0:35 Xin Long <lucien.x=
in@gmail.com>:
> > >>>
> > >>> This is to add an ip_dev_find like function for ipv6, used to find
> > >>> the dev by saddr.
> > >>>
> > >>> It will be used by TIPC protocol. So also export it.
> > >>>
> > >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >>> ---
> > >>>  include/net/addrconf.h |  2 ++
> > >>>  net/ipv6/addrconf.c    | 39 ++++++++++++++++++++++++++++++++++++++=
+
> > >>>  2 files changed, 41 insertions(+)
> > >>>
> > >>> diff --git a/include/net/addrconf.h b/include/net/addrconf.h
> > >>> index 8418b7d..ba3f6c15 100644
> > >>> --- a/include/net/addrconf.h
> > >>> +++ b/include/net/addrconf.h
> > >>> @@ -97,6 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr=
 *addr,
> > >>>
> > >>>  int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device=
 *dev);
> > >>>
> > >>> +struct net_device *ipv6_dev_find(struct net *net, const struct in6=
_addr *addr);
> > >>> +
> > >>
> > >> How do we handle link-local addresses?
> > > This is what "if (!result)" branch meant to do:
> > >
> > > +       if (!result) {
> > > +               struct rt6_info *rt;
> > > +
> > > +               rt =3D rt6_lookup(net, addr, NULL, 0, NULL, 0);
> > > +               if (rt) {
> > > +                       dev =3D rt->dst.dev;
> > > +                       ip6_rt_put(rt);
> > > +               }
> > > +       } else {
> > > +               dev =3D result->idev->dev;
> > > +       }
> > >
> >
> > the stated purpose of this function is to find the netdevice to which a=
n
> > address is attached. A route lookup should not be needed. Walking the
> > address hash list finds the address and hence the netdev or it does not=
.
> >
> >
>
> User supplied scope id which should be set for link-local addresses
> in TIPC_NLA_UDP_LOCAL attribute must be honored when we
> check the address.
Hi, Hideaki san,

Sorry for not understanding your comment earlier.

The bad thing is tipc in iproute2 doesn't seem able to set scope_id.
I saw many places in kernel doing this check:

                         if (__ipv6_addr_needs_scope_id(atype) &&
                             !ip6->sin6_scope_id) { return -EINVAL; }

Can I ask why scope id is needed for link-local addresses?
and is that for link-local addresses only?

>
> ipv6_chk_addr() can check if the address and supplied ifindex is a valid
> local address.  Or introduce an extra ifindex argument to ipv6_dev_find()=
.
Yeah, but if scope id means ifindex for  link-local addresses, ipv6_dev_fin=
d()
would be more like a function to validate the address with right scope id.

Thanks for your reviewing.
