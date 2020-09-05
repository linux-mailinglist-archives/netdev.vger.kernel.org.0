Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F3125E739
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 13:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgIELOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 07:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbgIELN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 07:13:58 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FEEC061244;
        Sat,  5 Sep 2020 04:13:58 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id 4so2240520ooh.11;
        Sat, 05 Sep 2020 04:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/XArF7YkfR7Xc8oDp/mlL0SvXioqFNhsgLxnlOfCQdA=;
        b=hnremNRXz4b+ZQBzXHkjSpbQZ3YZv/MzE9jT4UBX0Ixf/2FBFExeTtrHkNq0Q1gYJ6
         YFzvOUKt7mQuBbnOHCUkrKuTu+xpgNwnGY7HvCROmmRKSw3ybMpaWOSdjjKuhB0p0wGV
         0jBxxMzShRk6DkapfwjrC/xmj8+WjCFlZjQHC0LO9p7F+j8Gty0y19AU2YFcekir6PH2
         Hn2R89p/9f6sMxy3vHoBwjKFHT1JY/L90djM32qd1ZUg/inSzFDdu2hlkhMYOZE9GcC4
         t5mJYr7PjPXIQKamrJH+DmAXxs7OqWOMK6PZV2RH73pi6nF36qdGo5iWeqQNjHWz1SCX
         9GkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/XArF7YkfR7Xc8oDp/mlL0SvXioqFNhsgLxnlOfCQdA=;
        b=k5zDuY/dMR2by5VbT3fIB4bHIq0XS366QxbrxtzihRvHplEexnDqzK6Z3XIDkuqeql
         wgOO70WYArgeGPzIjkAqHhofl4MYvgU19EszSMqdjRFJK3cKkmjaS41I2FX4Yo3DWXTY
         CLbuBfDDsCP4IG0QTuAddfb32Xv1Xlxt17O7t6V4iIloDh19unz2Pk9CoSaW8krLI+j4
         BA7dElwjZLWfx9sCyk3T8aXtBuSjVPNBgDthbjC33vSzoXDw9tv5JtKVHOQChB/qIyVL
         d59YT7rMvNfNt0tgyVF7mN3etotb7wQlIJxD1uXBMShxDEtFFix6TW1fjGmBIIOLJbpj
         Fvxw==
X-Gm-Message-State: AOAM532KwbNQWM5vM2kyAWW9GIrOjoBkKVtCJqiNc4RqmfFKL+SBc+bE
        2OPWX6LmNAiHGN0og5SG0PKP51F46F1Th1iU7GpwG24tK8U=
X-Google-Smtp-Source: ABdhPJxG5nR8mTIynzeaeylQx4Pf/BO28EuOT21qMFksM5LGJSsl3XPyK7rctgLWw9Xqno/9B5p4rYEkzMh1lJUbYmk=
X-Received: by 2002:a4a:c541:: with SMTP id j1mr9103042ooq.13.1599304437587;
 Sat, 05 Sep 2020 04:13:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598517739.git.lukas@wunner.de> <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
 <5f49527acaf5d_3ca6d208e3@john-XPS-13-9370.notmuch> <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
 <CAF90-WgMiJkFsZaGBJQVVrmQz9==cq22NErpcWuE7z-Q+A8PzQ@mail.gmail.com> <5f5261535a32a_1932208c8@john-XPS-13-9370.notmuch>
In-Reply-To: <5f5261535a32a_1932208c8@john-XPS-13-9370.notmuch>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Sat, 5 Sep 2020 13:13:45 +0200
Message-ID: <CAF90-Wiy+GG=kMZRA6VPxCuA=zETf2SX2if42jkd-TiCNYVN5w@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Fri, Sep 4, 2020 at 5:46 PM John Fastabend <john.fastabend@gmail.com> wr=
ote:
>
> Laura Garc=C3=ADa Li=C3=A9bana wrote:
> > Hi,
> >
> > On Thu, Sep 3, 2020 at 7:00 AM John Fastabend <john.fastabend@gmail.com=
> wrote:
> > >
> > [...]
> > >
> > > I don't think it actualy improves performance at least I didn't obser=
ve
> > > that. From the code its not clear why this would be the case either. =
As
> > > a nit I would prefer that line removed from the commit message.
> > >
> >
> > It hasn't been proven to be untrue either.
>
> huh? Its stated in the commit message with no reason for why it might
> be the case and I can't reproduce it. Also the numbers posted show such a
> slight increase (~1%) its likely just random system noise.
>
> Sorry maybe that was a joke? Just poured some coffee so might be missing =
it.
>
> >
> >
> > [...]
> > >
> > > Do you have plans to address the performance degradation? Otherwise
> > > if I was building some new components its unclear why we would
> > > choose the slower option over the tc hook. The two suggested
> > > use cases security policy and DSR sound like new features, any
> > > reason to not just use existing infrastructure?
> > >
> >
> > Unfortunately, tc is not an option as it is required to interact with
> > nft objects (sets, maps, chains, etc), more complex than just a drop.
> > Also, when building new features we try to maintain the application
> > stack as simple as possible, not trying to do ugly integrations.
>
> We have code that interacts with iptables as well. How I read the
> above is in your case you have a bunch of existing software and you
> want something slightly faster. Even if its not as fast the 10%
> overhead is OK in your case and/or you believe the overhead of all
> the other components is much higher so it will be lost in the noise.
>

Not a bunch of software, but the other way around. We replaced, a year
now, all the existing iptables, ip6tables, ebtables, arptables,
x_tables, ipset and ipvs components (both in-kernel and user-space)
with just nftables. As all these components features are integrated
natively, objects (sets, maps, chains, stateful objects, etc.) are
created in a form of nftables scheme that are integrated all together.
That is why the tc workaround is not an option for people that are
moving to nftables to use just a hook.


> > I understand that you measure performance with a drop, but using this
> > hook we reduce the datapath consistently for these use cases and
> > hence, improving traffic performance.
>
> I measured drops because it was the benchmark provided in the patch
> series. Also it likely looks a lot like any DDOS that might be put
> there. You mentioned security policies which should probably include
> DDOS so I would expect drop performance to be at least a useful
> metric even if its not the only or most important in your case.
>
> Lets post a selftest that represents the use case so folks like
> myself can understand and benchmark correctly. This gives the extra
> benefit of ensuring we don't regress going forward and can add it
> to CI.
>

From the 4 use cases we found until now (although I'm sure there will
be many more), 2 are related to filtering (not necessarily related to
DDoS mitigation though) and 2 are related to packet mangling. One of
the packet mangling DSR case, it is working great from ingress but in
certain traffic generated from user-space in the node, we require the
egress hook. In addition to that, having this hook available in nft,
we could improve performance by optimizing the datapath for several
load balancing cases.

As I said, I understand that you're worried about dropping performance
but this hook will allow many more possibilities to improve the
traffic datapath.

Thank you!
