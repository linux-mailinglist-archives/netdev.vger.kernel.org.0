Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFCD40ED93
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhIPWzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 18:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbhIPWzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 18:55:16 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F22C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:53:55 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id g1so24813983lfj.12
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64aRGDxfXVoa1qTlY3upuJ19yGXpI/+Kdh+ykSMARUA=;
        b=PTTrrtcAQ0MZYQljqcAEHN2QYzJVOe5PNdmKDLNHnXNOiptmi9UeFaAlszfg18iSvT
         eiofM9HmyYDvNuV1FZzVEmPcDKqNj4trR4GHfSKgNODjbzaFWGTvt+LhT0S7iUvFa+AQ
         tNcfKN8zWtSBaXEAawLyLfvAWYTDFL/WImrGXyAdrERGD8EuOsrZ0iMqBb9GzDaWes0k
         2FtXnVaX6RrQ+Ov8K0KA1+1V7MJvBEB/ztwWsdRpr8+5qiMtqZfuBKUI7wE/orRw8Wsa
         Q50iSggylqcR6T2ihn2SYgYbNLABcZISk7Vp0Ml3MQtXVnF6F6r2As0l1+n1UzjVz61k
         1ZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=64aRGDxfXVoa1qTlY3upuJ19yGXpI/+Kdh+ykSMARUA=;
        b=BHpbkv6EpHLqZGhMmXpq1SlRZ0c9BtXqbOmzg5bUoRvMdj1sme3eNOuKAUj5CMPybx
         3ia0euZ+VWhtFe4xPapPt59pYqu5fTWOyOEZnwIkM/mVWf7fyGHQZ0oownSi1nbsZ5V1
         sjb681pRRxrooSRJzXR+7mOd8cz1CYHJFEOkss6XaLsV8EtrB97/Gr4hOVTZ36RF35hI
         AcycSDy7X4CEp3bJgj0ylRnhcjxw0FTQLC3A4pwNjwsB+GmSHJKIbdunUTEA5Xf5tvOy
         MYV1QgJ7Qi1gO7X2WS33fU8pNTac/eQWihO0bh4H8BLcby8/8bCw+lKmh5Z6QOau5a9G
         33jg==
X-Gm-Message-State: AOAM531zwJ1y7EVF3JYC4nZ7bZSikwlEgjNuL79FIqqebBe/1yAxAc3p
        QImF7XdCUaevgA2OeuDH+WZ4Swshx36ngq6LajDFpw==
X-Google-Smtp-Source: ABdhPJwx8ITFkSsQzaVlRuqb8ifRkDnCbGjxFukpklP6ZORMZwGg6j2a4KP6PgB3oxlHxBr2VGB/Qe7r2bMKHCu2gfY=
X-Received: by 2002:a05:6512:e89:: with SMTP id bi9mr5641322lfb.95.1631832833481;
 Thu, 16 Sep 2021 15:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210901091852.479202-1-maxime@cerno.tech> <20210901091852.479202-8-maxime@cerno.tech>
In-Reply-To: <20210901091852.479202-8-maxime@cerno.tech>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 17 Sep 2021 00:53:42 +0200
Message-ID: <CACRpkdYGnCd8fkAPPTP6VHFXC9k-_BNGqTE4cvPORyXJ=rVWLA@mail.gmail.com>
Subject: Re: [PATCH v2 07/52] dt-bindings: bluetooth: broadcom: Fix clocks check
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 11:19 AM Maxime Ripard <maxime@cerno.tech> wrote:

> The original binding was mentioning that valid values for the clocks and
> clock-names property were one or two clocks from extclk, txco and lpo,
> with extclk being deprecated in favor of txco.
>
> However, the current binding lists a valid array as extclk, txco and
> lpo, with either one or two items.
>
> While this looks similar, it actually enforces that all the device trees
> use either ["extclk"], or ["extclk", "txco"]. That doesn't make much
> sense, since the two clocks are said to be equivalent, with one
> superseeding the other.
>
> lpo is also not a valid clock anymore, and would be as the third clock
> of the list, while we could have only this clock in the previous binding
> (and in DTs).
>
> Let's rework the clock clause to allow to have either:
>
>  - extclk, and mark it a deprecated
>  - txco alone
>  - lpo alone
>  - txco, lpo
>
> While ["extclk", "lpo"] wouldn't be valid, it wasn't found in any device
> tree so it's not an issue in practice.
>
> Similarly, ["lpo", "txco"] is still considered invalid, but it's
> generally considered as a best practice to fix the order of clocks.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: netdev@vger.kernel.org
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Looks good to me!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
