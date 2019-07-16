Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39E6A082
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 04:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387960AbfGPCSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 22:18:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41607 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387939AbfGPCSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 22:18:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so15908827wrm.8;
        Mon, 15 Jul 2019 19:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tn8Q62o1MgY48Mx+DllWlgBdVj6RmFfgXYsNBaQSZ5o=;
        b=V46i+hrPbWUvgvrzDR/9EzpLX1v1cyAkGkD91Mjz/c9J+pPQpFGu4D+rS+dUFZag+f
         0hQm+etps2AyanmliTDyA3hkJc/VMkmYtBIaUbogLnh2A5ma0prtiUfI3/a0SpD7tAsh
         UuZ1TdkZjkhhHc3ypMtJJmt1XKWLVhkCe3L4NFWlXOWoNy0OXbuPnVVdlfs9g0QEB44Q
         a0I1AeAQ4y5h86sqW6QoMcIo4po3Dp23IgyunOq+ybsBaiS55wWlGv5s/p0fVJpO+DXW
         5hkTRCN/2p0HAqGjQUIwnmnsoncJ7Q3MhoqEyiF77RoTnJjT7EUHmAdq2/zlDGary92v
         dKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tn8Q62o1MgY48Mx+DllWlgBdVj6RmFfgXYsNBaQSZ5o=;
        b=cFdc1XtOqOKxOtLsGv9lVHcHF6SLIITalJ5EC3JILFdxvUKKtmI/6r0gGH7dsdUSPk
         9fu4hlqDOs0htnHFOeDQy4lZqq8Y8eRQI+6Z4Bie1e07Mnr3HSd87C9G+wO8wYAiMsUo
         MaW0PBd81f3j6R/7Rz5NaSlXekAnkBBhbO0qU/kYhOpxGJqFYvTeeoWvQKjmCVf6DHNl
         5YTPYij2M8VwpsGCRia2PBvR54mSLr0HiKJwnmGcedIJ+W1dqRxQI1vh0r8yX9uHoE05
         p72xj4J0xD3TZ9WgMmrksPmrrMga/o/nD+YbYbx0F2qiierzggcIvMdYtXJEt7+V/brZ
         yLyQ==
X-Gm-Message-State: APjAAAXhh7L855rkxftO5hY68asxDT2UrvLE3pxaI4dRhw9Fst+aTK7d
        5yu6zWP8WKOI6ZvNlONFhNvKNw9zyRhFpEaLGJE=
X-Google-Smtp-Source: APXvYqw5k51vPdH+MPyeHt8Xk2DH9OvBtNrXtY2oqeThWPTsX9JElKP296bWVBdpetUdaTPsX38OkGraE9Ld1WOpkG8=
X-Received: by 2002:adf:80e1:: with SMTP id 88mr30984324wrl.127.1563243492462;
 Mon, 15 Jul 2019 19:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190710074552.74394-1-xingwu.yang@gmail.com> <20190710080609.smxjqe2d5jyro4hv@verge.net.au>
 <20190715082747.fdlpvekbqyhwx724@salvia>
In-Reply-To: <20190715082747.fdlpvekbqyhwx724@salvia>
From:   yangxingwu <xingwu.yang@gmail.com>
Date:   Tue, 16 Jul 2019 10:18:01 +0800
Message-ID: <CA+7U5JsvP5gyO_xRboPsF+m4Zg5g9XCsZwpjqAs4OZqmUqAbeg@mail.gmail.com>
Subject: Re: [PATCH] ipvs: remove unnecessary space
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Simon Horman <horms@verge.net.au>, wensong@linux-vs.org, ja@ssi.bg,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo

v2 has been sent

I made the following changes:

1. remove all unnecessary spaces in one go
2. revert bitmap_alloc ( since it's irrelevant to this subject)
3. chenge subject to "net/netfiler:remove unnecessary space"

thanks

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2019=E5=B9=B47=E6=9C=8815=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:27=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Wed, Jul 10, 2019 at 10:06:09AM +0200, Simon Horman wrote:
> > On Wed, Jul 10, 2019 at 03:45:52PM +0800, yangxingwu wrote:
> > > ---
> > >  net/netfilter/ipvs/ip_vs_mh.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/ipvs/ip_vs_mh.c b/net/netfilter/ipvs/ip_vs=
_mh.c
> > > index 94d9d34..98e358e 100644
> > > --- a/net/netfilter/ipvs/ip_vs_mh.c
> > > +++ b/net/netfilter/ipvs/ip_vs_mh.c
> > > @@ -174,8 +174,8 @@ static int ip_vs_mh_populate(struct ip_vs_mh_stat=
e *s,
> > >             return 0;
> > >     }
> > >
> > > -   table =3D  kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > > -                    sizeof(unsigned long), GFP_KERNEL);
> > > +   table =3D kcalloc(BITS_TO_LONGS(IP_VS_MH_TAB_SIZE),
> > > +                   sizeof(unsigned long), GFP_KERNEL);
>
> May I ask one thing? :-)
>
> Please, remove all unnecessary spaces in one go, search for:
>
>         git grep "=3D  "
>
> in the netfilter tree, and send a v2 for this one.
>
> Thanks.
