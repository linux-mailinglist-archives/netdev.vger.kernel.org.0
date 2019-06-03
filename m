Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC41C32AC1
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfFCI1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:27:15 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:38279 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfFCI1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 04:27:15 -0400
Received: by mail-ot1-f68.google.com with SMTP id d17so1082385oth.5;
        Mon, 03 Jun 2019 01:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uv/TYWEESnDfEscWsGSPSE6N/KhRP3li2RzgDdqcb9s=;
        b=bYkYopunreF8aBv8dJzYYp8r1Tc6xLp7e7TvvhnVCjKyT3yI0dw7w9IgS5bVkP7azy
         z6h+xf5XS+2QD3nn5lK0+f5GdzgnEeuEx8IdFMMcy+5oxs1wdQaCTcMFACptJS+ZYeax
         DYGehZGIfjKHUDAz74wHNbbga7p0zQv+v2yRiowWZHmaCDoqzAbly76kHeNWf9sKSB6a
         0jGMvDkizbSLu8XWxpKXdqrg/hZ32sHhVxCX2gtZkj2c9VqwjJBKisyLIZ8IVj9G8LYv
         zmyKEdtyA8DIhHWGxQh1APk8SXjMYNU8nvhnubjz8QgijjNE6IHfhC1CAbIM4fOaE43Q
         sHmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uv/TYWEESnDfEscWsGSPSE6N/KhRP3li2RzgDdqcb9s=;
        b=thvZDDDmb6bQRBoyfotj7s2COe/ZZdRcJQYerbNBvzTg82XT7W1nJLvlpKwt1ws/2k
         pM6Bbx0vaEg1oUsQc4NFFf94Lce88p/7gyU235IMOOCkrVkFyhUGNHJKm7zcpWAgxCLc
         YkQXgQm+ij9bIWwaC/V+ZeRGHxogv9rU6y9wZ5pp/ascewDX3ue4KA8GoBcZuKtMqSM1
         nXhuK6A43ImsraVAfF58G2I4og5kswBD+Fp64UUfWgzOsNg6xBl8IyLiRHQev5tY6BeB
         FYIlmpTks/HSpcmUzewJgIHQAnF9MP10HHZ8eA/Qo+cAvo0ztWkRvKgJCweqD5PFxEU3
         LH2g==
X-Gm-Message-State: APjAAAU8cF5z3NPXwJmZjSkdJKTP4dpak8f9kWq7/MwAiYdPofY0gZdU
        Tfdvz+DP0y8vangODFQY5EZ/NXrFf5tjWmLbDfQ=
X-Google-Smtp-Source: APXvYqws1NHuRMJ3cst1WOeYWICtgUQP/IXjVREOK02PnlVFd/0ygeJ4jq+eB7TUSp2JDdAKcbrVcjI2LO66nGaFi2c=
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr302587oto.39.1559550434134;
 Mon, 03 Jun 2019 01:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190524093431.20887-1-maximmi@mellanox.com> <8b0450c2-ad5e-ecaa-9958-df4da1dd6456@intel.com>
 <c5f6ab402de93f0b675d19499490e8c99701b5cc.camel@mellanox.com>
In-Reply-To: <c5f6ab402de93f0b675d19499490e8c99701b5cc.camel@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 3 Jun 2019 10:27:02 +0200
Message-ID: <CAJ8uoz01-0B+-ePfPA2J+qrq4JM1aNUaesevQDmSZLJ1m91crA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yhs@fb.com" <yhs@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "bsd@fb.com" <bsd@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:59 PM Saeed Mahameed <saeedm@mellanox.com> wrote=
:
>
> On Fri, 2019-05-24 at 12:18 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > On 2019-05-24 11:35, Maxim Mikityanskiy wrote:
> > > This series contains improvements to the AF_XDP kernel
> > > infrastructure
> > > and AF_XDP support in mlx5e. The infrastructure improvements are
> > > required for mlx5e, but also some of them benefit to all drivers,
> > > and
> > > some can be useful for other drivers that want to implement AF_XDP.
> > >
> > >
> [...]
> >
> > Maxim, this doesn't address the uapi concern we had on your v2.
> > Please refer to Magnus' comment here [1].
> >
> > Please educate me why you cannot publish AF_XDP without the uapi
> > change?
> > It's an extension, right? If so, then existing XDP/AF_XDP program can
> > use Mellanox ZC without your addition? It's great that Mellanox has a
> > ZC
> > capable driver, but the uapi change is a NAK.
> >
> > To reiterate; We'd like to get the queue setup/steering for AF_XDP
> > correct. I, and Magnus, dislike this approach. It requires a more
> > complicated XDP program, and is hard for regular users to understand.
> >
> >
>
> Hi Bjorn and Magnus,
>
> It is not clear to me why you don't like this approach, if anything,
> this approach is addressing many concerns you raised about current
> limited approach of re-using/"stealing" only regular RX rings for xsk
> traffic !
>
> for instance
> 1) xsk ring now has a unique id. (wasn't this the plan from the
> beginning ?)
> 2) No RSS issues, only explicit steering rules got the the newly
> created isolated xsk ring, default RSS is not affected regular RX rings
> are still intact.
> 3) the new scheme is flexible and will allow as much xsk sockets as
> needed, and can co-exist with regular rings.
> 4) We want to have a solution that will replace DPDK, having such
> limitations of a limited number of RX rings and stealing from regular
> rings, is really not a worthy design, just because some drivers do not
> want to deal or don't know how to deal with creating dedicated
> resources.
> 5) i think it is wrong to compare xsk rings with regular rings, xsk
> rings are actually just a a device context that redirects traffic to a
> special buffer space, there is no real memory buffers model behind it,
> other than the rx/tx descriptors. (memory model is handled outside the
> driver).
> 6) mlx5 is designed and optimized for such use cases (dedicated/unique
> rx/tx rings for XDP), limiting us to current AF_XDP limitation without
> allowing us to improve the AF_XDP design is really not fair.

Hi Saeed,

Agree on all your statements. We need and should proceed in this
direction (as I have stated before) so I am all aligned with what you
want and hopefully also what other users or potential users want. The
only issue I personally have is that we identify the "create a new
channel/pipe/flow of packets from the NIC completely separated from
the regular SKB flows" with the queue id. The user really does not
care about queue ids. He/She only wants an endpoint that can be used
to receive and send packets and then to be able to program this
endpoint to receive the packets that the application is interested in.
Queue ids and conglomerates of queue ids expose too much of HW
concepts that we really should not care about in user space, IMHO.
What I would like is to be able to do all these things without
exposing queue ids. Maybe just with the socket instead.

Now I am going to argue for the other side :-). The above approach
would require some new plumbing for sure, since ethtool uses queue ids
today to set the redirection of packets. So maybe it is just a pipe
dream to get to this point (it will take too long, for example) and we
should just reuse the queue id space for a new set of queue ids that
have all the good properties that you describe. What I would
preferably not like to end up with is some new interface that we do
not need in one to two years time.

Is there some way we can extend the uapi so that it can be used for
both the intermediary step (tagging along the queue ids) and the end
goal (not having to use them at all)? Could we extend the bind() call
so that it creates a socket that is bound to some queue that we do not
specify (it can be created together with some other queues and bundled
with them, or some completely new queue and irq line, or whatever, we
do not care). It is bound to an "anonymous queue" you could say. Then
as an intermediary step, we can add a getsockopt that gets the real
queue id identifiers from the socket that we can use in ethtool, for
example. Other suggestions?

As I have said before, I like 99% of the work that Maxim has done. But
new uapis should not be take lightly as they have repercussions that
lasts forever. That is why your patch set is taking time as you
bundled them all together. Or maybe I am just chicken ;-).

/Magnus

> the way i see it, this new extension is actually a generalization to
> allow for more drivers support and AF_XDP flexibility.
>
> if you have different ideas on how to implement the new design, please
> provide your feedback and we will be more than happy to improve the
> current implementation, but requesting to drop it, i think is not a
> fair request.
>
> Side note: Our task is to provide a scalable and flexible in-kernel XDP
> solution so we can offer a valid replacement for DPDK and userspace
> only solutions, I think we need to have a scheme where we allow an
> unlimited number of xsk sockets/rings with full flow
> separation/isolation between different user sockets/apps, the driver/hw
> resources are really very cheap (as there is no buffer management) much
> cheaper than allocating a full blown regular socket buffers.
>
> Thanks,
> Saeed.
>
> > Thanks,
> > Bj=C3=B6rn
> >
> > [1]
> > https://lore.kernel.org/bpf/CAJ8uoz2UHk+5xPwz-STM9gkQZdm7r_=3DjsgaB0nF+=
mHgch=3DaxPg@mail.gmail.com/
> >
> >
