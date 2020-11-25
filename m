Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6B2C3663
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 02:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgKYByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 20:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgKYByi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 20:54:38 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED725C0613D4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 17:54:37 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l11so928042lfg.0
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 17:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xj2GOPEG0NzB2gTOtm/M9hbw1pvfunjVV06O7LhawW8=;
        b=eRf/VPnkDJvjIxvbe1ieMfaIGk5/RApw+o50qB0w5omBpo84RSfV3H7YI4vTPjozNy
         SadeIaaqECqiekMw0DtF9pREQbhUBQbUM107Eg9bDOIlNHBDfq1SCvHz0uzUDZfPAGCR
         DFWEzzhyjNOZ4qsBsPLqsSpruo4jBHXdZNTSVBURiwAEfqT/FUgD4PYPoPH4we7jHIT7
         2FpNvwak1epJNAxoSZqm1mfgv0xGHfEhiXuRTLDiNKUjmUd/MSm4gyv6vxJVsckS5b25
         VAdVf1qMBmuAaR1BwcOpGFiI5gV0pAsLHeahuUsD5SRbRt5z8bYfBiPuM5l3DwFyeuy1
         /CEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xj2GOPEG0NzB2gTOtm/M9hbw1pvfunjVV06O7LhawW8=;
        b=LgrtEY/QcHgRTP+nSr4Tfm6MEAmRh0dWhfzMebd50DuDvgq4WdJ+eehWr3EyaAZg6V
         9vfOA6AYcqPd6fbv/7PXG5Eoit1vzUle49eRuF7yCkVoxVCf/o4isQB9moNPo/tDTOGx
         pQGfhs3Ar/Vzgxidc4du91pSQ9/G0YixqsEVeP1RJ+m28vh+KgKu0PRaCzt9ODQA9QBs
         adJtcse7euXFS/8v0AYR3FtT9waaBDZ63s4KHLKS/dGD/xO6H2mfLLuiIunueMf3TqHd
         B8KzuncPM5Y3J3QVYL1fYVTvONrVcy20P2uI+KLJoHolgg54PKStedM9ENHl2c5gIAva
         6ZUA==
X-Gm-Message-State: AOAM5326tylJfs/Tt15PwiBxg4NA5/oBpUa+hiKy3+k74OudiTMPnzQ8
        o50I8wc2zDbst4SrBuNShdC374+29VpF3b1oWIw=
X-Google-Smtp-Source: ABdhPJzsrxDt5uKrnJOUo9G2aL1pCcrgRrLDwoPK0JEN/AY2wj876Zp7AfTiCHdJ+hivJf+wuwcfgJw6tXaYmFbb28g=
X-Received: by 2002:a19:8c1c:: with SMTP id o28mr363382lfd.263.1606269276414;
 Tue, 24 Nov 2020 17:54:36 -0800 (PST)
MIME-Version: 1.0
References: <20201124235755.159903-1-kuba@kernel.org>
In-Reply-To: <20201124235755.159903-1-kuba@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 24 Nov 2020 17:54:24 -0800
Message-ID: <CAADnVQJ4CEsWJeksTwX-ksB8xGWDwco4sfthZ_7psCyD3meEQg@mail.gmail.com>
Subject: Re: [PATCH net] Documentation: netdev-FAQ: suggest how to post
 co-dependent series
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        andrea.mayer@uniroma2.it, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 4:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Make an explicit suggestion how to post user space side of kernel
> patches to avoid reposts when patchwork groups the wrong patches.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdev-FAQ.rst | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/netw=
orking/netdev-FAQ.rst
> index 21537766be4d..553eda8da9c7 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -254,6 +254,26 @@ you will have done run-time testing specific to your=
 change, but at a
>  minimum, your changes should survive an ``allyesconfig`` and an
>  ``allmodconfig`` build without new warnings or failures.
>
> +Q: How do I post corresponding changes to user space components?
> +----------------------------------------------------------------
> +A: Kernel patches often come with support in user space tooling
> +(e.g. `iproute2`). It's best to post both kernel and user space
> +code at the same time, so that reviewers have a chance to see how
> +user space side looks when reviewing kernel code.
> +If user space tooling lives in a separate repository kernel and user
> +space patches should form separate series (threads) when posted
> +to the mailing list, e.g.::
> +
> +  [PATCH net-next 0/3] net: some feature cover letter
> +   =E2=94=94=E2=94=80 [PATCH net-next 1/3] net: some feature prep
> +   =E2=94=94=E2=94=80 [PATCH net-next 2/3] net: some feature do it
> +   =E2=94=94=E2=94=80 [PATCH net-next 3/3] selftest: net: some feature
> +
> +  [PATCH iproute2-next] ip: add support for some feature

That's a good suggestion for iproute2 vs kernel patches
that actually live in separate repos.
When kernel and user components (like in often happens in bpf world)
happen to be in one repo it's better to keep them as a single patch set.
So it would be good to clarify in the above paragraph.

> +
> +Posting as one thread is discouraged because it confuses patchwork
> +(as of patchwork 2.2.2).

Right. Not as much patchwork, but kernel.org special email processing
pipeline that has an auto-delegation feature.
https://git.kernel.org/pub/scm/infra/patchwork/procmail.git/tree/netdevbpf.=
rc
Not sure whether doc needs to go to this level of details.
