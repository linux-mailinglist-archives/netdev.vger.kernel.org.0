Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EDE1974E4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgC3HKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:10:12 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:31904 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728685AbgC3HKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:10:11 -0400
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 02U79xvR024938;
        Mon, 30 Mar 2020 16:10:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 02U79xvR024938
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585552200;
        bh=ln1CQt+YaUVnJf/8SbMK3iPTVvG1KE5EE/FUul8MWQc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1sthGaoHw8qoSp3F/D3eH8NqZjk++zLNoSrFExAge5M5k4o6izC7znUZmDsjrR95d
         3LRi45OyZDxUKTfu4A/3P4aV5+yY39DtCxwP5T2nox/GAPp7PJ3ZaF7u226D4E6kMs
         pxp3tchjSZY1dsGYXfpp7Fyf63ssOrWN+V8tr3iI8kkkZhdSc6hQrcCJehpowCH1tV
         t5Ybjs0wWAwMh0SzhZruoB9o66WBYJD1t+qP7ZqRNrr7efxFSXjCoLMubpsREjCj3w
         uh2OG10xugvGzdVuKY1o+FeM5bjbz3bVeCv27FcaCEJ6WsaSLhERu5H58t5BiMZ2Xi
         G3vbpTZyiHDew==
X-Nifty-SrcIP: [209.85.217.45]
Received: by mail-vs1-f45.google.com with SMTP id z125so10303326vsb.13;
        Mon, 30 Mar 2020 00:09:59 -0700 (PDT)
X-Gm-Message-State: AGi0PuaxIQ01k2OIzzRmX0pmP4+GKnL2dKkEkaAhViRjVhNEthRWBKXc
        iLGdsfopkiPxzS20T9vORC2VKBgWqZ276l6JheA=
X-Google-Smtp-Source: APiQypLmGnB9GmkGFIr7L8MQtdRTKDMNPR3ere0jKX6O5/r2adqpWFQ5TPcwWpLgYxRGXDf4dZ6YCv27RE8dCFz54+s=
X-Received: by 2002:a67:2d55:: with SMTP id t82mr7452280vst.215.1585552198446;
 Mon, 30 Mar 2020 00:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-5-robh@kernel.org>
In-Reply-To: <20200325220542.19189-5-robh@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 30 Mar 2020 16:09:22 +0900
X-Gmail-Original-Message-ID: <CAK7LNARJn4uugHxcjK+WOWBs0gPVZQsCu4y6M8hkNK1U5FehRA@mail.gmail.com>
Message-ID: <CAK7LNARJn4uugHxcjK+WOWBs0gPVZQsCu4y6M8hkNK1U5FehRA@mail.gmail.com>
Subject: Re: [PATCH 4/4] dt-bindings: Add missing 'additionalProperties: false'
To:     Rob Herring <robh@kernel.org>
Cc:     DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 7:06 AM Rob Herring <robh@kernel.org> wrote:
>
> Setting 'additionalProperties: false' is frequently omitted, but is
> important in order to check that there aren't extra undocumented
> properties in a binding.
>
> Ideally, we'd just add this automatically and make this the default, but
> there's some cases where it doesn't work. For example, if a common
> schema is referenced, then properties in the common schema aren't part
> of what's considered for 'additionalProperties'. Also, sometimes there
> are bus specific properties such as 'spi-max-frequency' that go into
> bus child nodes, but aren't defined in the child node's schema.
>
> So let's stick with the json-schema defined default and add
> 'additionalProperties: false' where needed. This will be a continual
> review comment and game of wack-a-mole.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---


>  .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml      | 2 ++


You may have already queue this up, but just in case.

Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>

-- 
Best Regards
Masahiro Yamada
