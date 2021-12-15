Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3507476476
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 22:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhLOVVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 16:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLOVVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 16:21:31 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582AC061574;
        Wed, 15 Dec 2021 13:21:31 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id p65so32328349iof.3;
        Wed, 15 Dec 2021 13:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=62fzi/yubRlJ1sBEx4EIWF++cZfm17HNsL13nBxxScY=;
        b=FnY4329EiQnIIlKCdE/eGYP038H+XszAQu8X+JmwHj7aENONJIznCc72NuD3MSbCu4
         gfFJwgHHYUyKr6+4fJe+HJa7lxZauXP0uLbTZ1hUU5/srwqvJt5KVuMnCEiD7GqxBxd4
         JiD78WWpiP6i1V0DcOWjctH73X/l6vDsqxovik1QKnAzpCI8dA/ydgRpRWOYiPTvLabK
         D28Xzunp5XvOOvwYdp46l25816gA/SOgbGvqq5wIqWu9HuNiD4azi159w7H6tka3brdP
         31Bct/9CU569AAmJxWK0TV6gasma88cXS991F24m7NM/Y3fJMsqdpmeQCeV2XIEAiWcV
         uEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=62fzi/yubRlJ1sBEx4EIWF++cZfm17HNsL13nBxxScY=;
        b=xRNWWWTbQRGyFwtI5uaMayPQm2Zr9sKtum92Iww11MmjrC1oZSuIggWDkkRpZ6juoT
         D3k1y+WopFg0K68LAXBf9E32zDWiyFn/ZiRcah9MsQEOj1mcNFjsWeGeSkdKkbpsNQ2c
         c1o2uxHO4X5YOzC9DYQVE8uWsPZlpUxkKCotGGIGTkh6EWHXUVy7Sf3LbKVW/uh6Vqzf
         3YMFcvotdx6VFJkwDzDlfcn76JSU4QyXsQdfiNkQTvxWNCToGj1nFXRvquDjwk3PyWUX
         xTI7T8kfzHdswP9TTUgkyM4dQUsVspaaDPIdGYlcVkZLkOxFyy+S+ZPSQ3wvc0nnzFgr
         9cFA==
X-Gm-Message-State: AOAM5326dpHdh6Vd1KfKuP67rLWHka4nwNBwY0VVKo5nsAzmJYKWWAEI
        7n5lujXyHqYFtu7ea/tQC/TTOUv/v2rSmirw43SvyfD9
X-Google-Smtp-Source: ABdhPJx5hkdMklD2d++pgM0j9INz5YE67w868ETgHnmN1lJfTiALd1EQ9jK0c20iXP1gRsUifHN2ilgFkmy3Lpclq1k=
X-Received: by 2002:a05:6638:32aa:: with SMTP id f42mr6917063jav.115.1639603290833;
 Wed, 15 Dec 2021 13:21:30 -0800 (PST)
MIME-Version: 1.0
References: <CABJS2x78hO71EAUpe+4xNUb8b5BTypOSOfd4Ati+r6PTq3sopA@mail.gmail.com>
In-Reply-To: <CABJS2x78hO71EAUpe+4xNUb8b5BTypOSOfd4Ati+r6PTq3sopA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 15 Dec 2021 13:21:18 -0800
Message-ID: <CAA93jw6p47ZN4DgRjxGjeYEub5fibo3bwn6mDCd=DqkH-toDTg@mail.gmail.com>
Subject: Re: Question about QoS hardware offload
To:     Naveen Mamindlapalli <naveen130617.lkml@gmail.com>
Cc:     lartc <lartc@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, maximmi@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:46 PM Naveen Mamindlapalli
<naveen130617.lkml@gmail.com> wrote:
>
> Hi,
>
> Our NIC hardware provides a hierarchical QoS tree for each physical
> link with strict
> priority and DRR scheduling & also supports traffic shaping at each
> level. I'm curious what the closest qdisc that supports the above
> functionalities for offloading to hardware. I looked into htb/drr/prio
> qdiscs, but each qdisc supports a subset of the functionality enabled
> by our hardware.
>
> As per my understanding, The HTB hardware offload is used for shaping
> rather than scheduling (strict priority/DRR).

Correct.

> The PRIO qdisc seems to support strict priority but not DRR. Similarly
> DRR doesn't support strict priority.

My assumption is your hardware does not do 5 tuple FQ for the DRR, but
leverages the dscp field?

Instead, linux pretty much does a 5 tuple hash universally now for
packet steering (RPS) and in the sch_fq and fq_codel qdiscs.

I am not really big on strict priority with dscp, as whenever someone
lucks into the right dscp value they get most of the bandwidth, and
it's
more or less a matter of historical accident that the support in
mqprio/pfifo_fast is not more abused in the field. But that's me.

>
> Please advise on how to effectively offload all the features.
>
> Is the ETS - Enhanced Transmission Selection scheduler a better fit if
> we simply need to offload scheduling with strict priority and DRR?

Of course, my dream is to see 5 tuple fq-codel or cake land in some
offload somewhere.

I don't know enough about how when and where ets is used, it's pretty
new, and I'd lke to know more.

>
> Thanks,
> Naveen



--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
