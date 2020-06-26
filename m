Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC28520B7CB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgFZSDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgFZSDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:03:15 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBECC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:03:14 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u5so4961222pfn.7
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MIUMjSaMlS6zBGL91VS5XCO0Rvi6aDq5b10UCJka4lQ=;
        b=Ma2BehIm22spTdzAH1O9txmR5b2SNIrg4s0Z2PiKd9b/zAzJaJ2CgrUTFzHqcdHi3O
         dWLF7Cux0WFPfyG79wuKXyA/Ko5IgTdUE1qOoXpOFuwiTKZkbhzFcg0/ranRVuyZTItI
         a7lArD27JCULvRFKmmIMOxd1xzJHyax9Ier+KPf3FJOEAwm4P8XhP1kotKDPsHAeHSzY
         4Mi1mVIxtz4Dq6/8qK6EgHw+GwuiOk3N57Xa204l47YhD7l++wKLawVm06uv1gjzvSph
         SR5y23kIoo6vWYCpFaNGcf+azl9CK6DV/XRwmpn9jOzSw2asBXJNCwPHV9cWbRtuxwUZ
         5cgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MIUMjSaMlS6zBGL91VS5XCO0Rvi6aDq5b10UCJka4lQ=;
        b=pAbimBDOlRmlN7hLsn3fmjk+eeNW0eUgHNymnOybTTbXQ9U80ZE8Fqfi65NJH6jUQX
         JvFZi/ZJaoIYrTV1E6mRdJt3FgiNkAAvvWEX/aTfWLSf8NZzTdckqv/qS1Xrprjv3CRF
         /et6EPDmVS1tFqhKGk6aOkL9wNfUp0oxAev8uUVwwhkGOWJrCM3fsx2indiU0EMqK0SW
         sTJKhgYEbaleGbec4Kjanit8nCLgani52gFT+5cn7hUTUH0c1L1x5PckHyTiJbWPr3rF
         KjLmF0VyQrMkynt/i+aPFv+Y8N0PBsPvpSZENHAujHc0VJ22OOuf6tPsfL15z9LhAxUO
         g/iw==
X-Gm-Message-State: AOAM531EgmkLj3FKKZsdp8frlAxh8k2BPNN8x8PWXh+STw93qQzglurp
        zHs78UlkHkzgHKg/LYkr4vg5g3BUskttwhBtQwq3tg==
X-Google-Smtp-Source: ABdhPJz2D1+qK2ONgSPgAU70k5U8V1bJ1bUlhVaJNVCZCAKFfjaYNxdnhxmtCJ5RdM1jYN4Y7jIzsTZv8kaUVjQcF0Q=
X-Received: by 2002:a63:a119:: with SMTP id b25mr3701064pgf.10.1593194593326;
 Fri, 26 Jun 2020 11:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200626041001.1194928-1-natechancellor@gmail.com>
In-Reply-To: <20200626041001.1194928-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 26 Jun 2020 11:03:02 -0700
Message-ID: <CAKwvOdmOriZwmiq8XoKqLq0RR4fRnFoDVgS+X_n_5x1cK4G=RQ@mail.gmail.com>
Subject: Re: [PATCH net-next] bonding: Remove extraneous parentheses in bond_setup
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 9:10 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> drivers/net/bonding/bond_main.c:4657:23: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
>              ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
>
> drivers/net/bonding/bond_main.c:4681:23: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
>              ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
>
> This warning occurs when a comparision has two sets of parentheses,
> which is usually the convention for doing an assignment within an
> if statement. Since equality comparisons do not need a second set of
> parentheses, remove them to fix the warning.
>
> Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1066
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch.  I recently saw this in a report from KernelCI
this morning.  Adding a tag to reward the robot.

Reported-by: kernelci.org bot <bot@kernelci.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/bonding/bond_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 4ef99efc37f6..b3479584cc16 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -4654,7 +4654,7 @@ void bond_setup(struct net_device *bond_dev)
>
>  #ifdef CONFIG_XFRM_OFFLOAD
>         /* set up xfrm device ops (only supported in active-backup right now) */
> -       if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
> +       if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
>                 bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
>         bond->xs = NULL;
>  #endif /* CONFIG_XFRM_OFFLOAD */
> @@ -4678,7 +4678,7 @@ void bond_setup(struct net_device *bond_dev)
>
>         bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
>  #ifdef CONFIG_XFRM_OFFLOAD
> -       if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
> +       if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
>                 bond_dev->hw_features |= BOND_XFRM_FEATURES;
>  #endif /* CONFIG_XFRM_OFFLOAD */
>         bond_dev->features |= bond_dev->hw_features;
>
> base-commit: 7bed14551659875e1cd23a7c0266394a29a773b3
> --

-- 
Thanks,
~Nick Desaulniers
