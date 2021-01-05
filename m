Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C352EAB40
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbhAEMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbhAEMyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:54:06 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EBDC061574;
        Tue,  5 Jan 2021 04:53:26 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q137so28044171iod.9;
        Tue, 05 Jan 2021 04:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K79eXZC/Zmmt2A7zkyWNbssvWSflnyrmEKHoezkqZ24=;
        b=TjRq6EUrmxaMZI2yT57rLdCc+HPWMANWnsF5tA119UKg8fel0rlvaXSK/62AOFRUo/
         gNqA/oPjVsKYaubGPBNVzMUBZT7RWnkPGn97v/SDVqJ2mDjVQcj2O12j9CHsDIJRRKO6
         cdvKm3JzMIACMJbraIqGfqI1jhDwohAGZu49HFeOaBZUslnz7G1BmwCp0IasQL3AjLB0
         vQrkQ2VXJFjk1ZyZVumXvEOJC7lVC8Y8Mkk7OPsw3qDqs7M5UuRke/etX1m2jkidDX9j
         eeyp345mB6gQYeBaMF1WdVzp9UMfgeGd81vPE5CMsC21GxQ8IzoprFlhAJAXsWPnKJi3
         DNYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K79eXZC/Zmmt2A7zkyWNbssvWSflnyrmEKHoezkqZ24=;
        b=DTl6C9N7C/mM3DT6k7GltFQEpkL4vF0+c5k2nFiJ/dTfsIbSM606Ylb5o6lwuAzZGd
         ojxuWHO5qFWTl5c0kyw7zX3kiaOvEq8iH93FdLRysWmm0g8HiGna6Fs3U8XSnUSt2BKd
         6uXWQhQ0XzyiwISQrL88xDmMc5rar9Gj4274MbuegzYw1Q3Gf3rB7ynHNnbDzaGnRlBN
         SoBAohJ+eGTH1bc4YKAF1nxZJkdZJ6cgSM1P9JLFD+9ADVUXdVoK+ri7vM7MwrG7B9HK
         /J0EHZiLhRny+Ma0HfTR4x5BIW+o8MOQx38/7jD6ApuR3FN82Zy9YmjM+/1jPALh4GBJ
         JrxA==
X-Gm-Message-State: AOAM533mp7YFM2zkJs7QVgT43T8EcLRj4A9vKdMp6S5sf6dMCtNNFCpB
        l3x0Kzgm/Ef51hlOOm1YRukylWFZddYAy3bChleUHzOZ
X-Google-Smtp-Source: ABdhPJy+xl2oI1UvjCXfcYUlgNcKNWFiiu+kttdPrBY+8CZh9AgWwQVAab76cv4Cr9pEdsJXPPQxdYrYweYeS9NTNjs=
X-Received: by 2002:a5d:9a8e:: with SMTP id c14mr63963527iom.178.1609851205863;
 Tue, 05 Jan 2021 04:53:25 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <20201228213121.2331449-4-aford173@gmail.com>
 <CAMuHMdUCsAGYGS8oygT2xySRSm3Op4cJJmcnEK9BC732ZvN6JA@mail.gmail.com>
In-Reply-To: <CAMuHMdUCsAGYGS8oygT2xySRSm3Op4cJJmcnEK9BC732ZvN6JA@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 5 Jan 2021 06:53:14 -0600
Message-ID: <CAHCN7xJmNU_1XS-hqP1VdaO9j3phepG4eF-S7EiNEzOUyZKX-w@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: ethernet: ravb: Name the AVB functional clock fck
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 4:41 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> > The bindings have been updated to support two clocks, but the
> > original clock now requires the name fck to distinguish it
> > from the other.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Thanks for your patch!
>
> > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > @@ -2142,7 +2142,7 @@ static int ravb_probe(struct platform_device *pdev)
> >
> >         priv->chip_id = chip_id;
> >
> > -       priv->clk = devm_clk_get(&pdev->dev, NULL);
> > +       priv->clk = devm_clk_get(&pdev->dev, "fck");
>
> This change is not backwards compatible, as existing DTB files do not
> have the "fck" clock.  So the driver has to keep on assuming the first
> clock is the functional clock, and this patch is thus not needed nor
> desired.

Should I post a V2 with this removed, or can this patch just be excluded?

adam
>
> >         if (IS_ERR(priv->clk)) {
> >                 error = PTR_ERR(priv->clk);
> >                 goto out_release;
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
