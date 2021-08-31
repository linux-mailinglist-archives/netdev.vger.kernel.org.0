Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50CE3FC85A
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237646AbhHaNiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238028AbhHaNiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:38:04 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFB3C0617A8;
        Tue, 31 Aug 2021 06:37:09 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id l4so10287459qvl.12;
        Tue, 31 Aug 2021 06:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5Gx+da6dDuqX2X2jy+iLAiI++WqiH4CLbDqLcJwtDQ=;
        b=cVdZJDOpln5dQl57gPBfEnbyS7ELywYok6JW3P+5tQEog8VKZ2aoFr3Gr/HvgwtY6x
         QIvRMRlMhbiKcIrmDJrUuYvp9psCiVn/lujbgONFFT7VNSOvktVqZ6gpbNCRC6xcEfX1
         gQ1/Zgh63u/s9YvRo8wFZs4YHiP0kjFjuZ6x8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5Gx+da6dDuqX2X2jy+iLAiI++WqiH4CLbDqLcJwtDQ=;
        b=sI31kJDj0wnuxb5y38Mf+odd+49/x16+X7Z/war6cyEy/sZkGdEADgPG0YPZzwLlml
         9zKb4cUzeGWQclJ9SlnpmRoASCX3szv5v8KikhW3NAEAG9CQ4uCykoV6tcg/6yYFeur1
         RlotsnPIpeajbAQcoVKZxeBz7IVPx5dx7X6uDghqyM1jFbUTTUIyQ77Xf+w2KVzvC4wv
         idiOGVsH/9fTQAf0aYs9Mo8FnIBCOgx2cfFbLYvmdvKmd2nXH/aNikQbbW0n7uWk4u2i
         DtnHGxrFnPufALGuOQrKCDk7/iVwC7q3K0ZOOrl2YZBQ9VAzXqSEpXJ1U3DNnnqXLXdD
         FbXw==
X-Gm-Message-State: AOAM533l+guIzPWZU8+A2kIWx/hhNuRo93tABQG/+yPJCt8o72f2lvnC
        z7qkjJYAko0FiNf02o+81W9olNB/sOm4ujCpSb4=
X-Google-Smtp-Source: ABdhPJyScrXRyrJucburp3ZoxrFjwrIrrdvFzIXMmhkX9NmsV8jV9/P/A+kY5G7tuYvEBRRZToG+xZCF7k3jXen68j8=
X-Received: by 2002:a0c:a709:: with SMTP id u9mr11019420qva.3.1630417028407;
 Tue, 31 Aug 2021 06:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <72bc8926dcfc471ce385494f2c8c23398f8761d2.1630415944.git.geert+renesas@glider.be>
In-Reply-To: <72bc8926dcfc471ce385494f2c8c23398f8761d2.1630415944.git.geert+renesas@glider.be>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 31 Aug 2021 13:36:55 +0000
Message-ID: <CACPK8XfyYpWTmaASuG7Jkyp06fRrg_zXvg93JB7igZgVDWjumw@mail.gmail.com>
Subject: Re: [PATCH] net: NET_VENDOR_LITEX should depend on LITEX
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Stafford Horne <shorne@gmail.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 at 13:21, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> LiteX Ethernet devices are only present on LiteX SoCs.  Hence add a
> dependency on LITEX, to prevent asking the user about drivers for these
> devices when configuring a kernel without LiteX SoC Builder support.

nak.

They can be present on any soc that uses them. We have an example in
mainline already; microwatt uses liteeth but is not a litex soc.

Cheers,

Joel

>
> Fixes: ee7da21ac4c3be1f ("net: Add driver for LiteX's LiteETH network interface")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/litex/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> index 265dba414b41ec22..bfad1df1368866d3 100644
> --- a/drivers/net/ethernet/litex/Kconfig
> +++ b/drivers/net/ethernet/litex/Kconfig
> @@ -5,6 +5,7 @@
>  config NET_VENDOR_LITEX
>         bool "LiteX devices"
>         default y
> +       depends on LITEX || COMPILE_TEST
>         help
>           If you have a network (Ethernet) card belonging to this class, say Y.
>
> --
> 2.25.1
>
