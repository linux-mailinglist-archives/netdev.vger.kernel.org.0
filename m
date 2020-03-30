Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A1C197696
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgC3IiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:38:12 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:56073 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3IiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 04:38:12 -0400
X-Greylist: delayed 5280 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 04:38:09 EDT
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 02U8bmN8026273;
        Mon, 30 Mar 2020 17:37:49 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 02U8bmN8026273
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585557470;
        bh=PxRmu3HuDIYTqEJxiJ5PqE2LXmQuo3D9zlavzY5jVI4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=brVEPKJScKZunXMPy14SQD8gmdtXfD/Z7CL8ZRWvjqvg8UYOEXDjY45m6LQp+Upry
         SgIqRIt+Vbfvxsnbg1Sa4ESbah6Ht4e+ygLsb2zMtFxzxi6m+CL+3akLM9W4IRUtrC
         8IrkWOugyFCF6k+q9DWaJ/RylMYkLVAXmcO1Y053y79in1DJ1SYDKl6QryZcJvymZW
         zhUI92s1QDExgPzlgqMqS+2VzRW+Hf/0CueUJkv89pUXdRGkEy/yT1U57PQSLpZHL5
         dpuemg5XzFyFNtnhwxT9TEaThfuk/wESfJfRmQy4YDPJPK/eWz1pRIvn+23Xa8wREx
         iiOBT5PkS+9Hg==
X-Nifty-SrcIP: [209.85.222.47]
Received: by mail-ua1-f47.google.com with SMTP id r47so5951861uad.11;
        Mon, 30 Mar 2020 01:37:49 -0700 (PDT)
X-Gm-Message-State: AGi0PuYfI1t4jOABvMJbBeheO5K31RVjKrp+v3PMdlyhGrfyx/pJ5lj8
        56rX/6bnMc6mi60tJtnMdm1005lbsmAaPgRPoO8=
X-Google-Smtp-Source: APiQypJeTOypTow5s/orWLiqA+luxDBNhpwR1xE86uZ7tA8NnJnWdBsJgIswlbl89EaZoapGrF/J2WDHqcRU1fH6V1M=
X-Received: by 2002:a9f:28c5:: with SMTP id d63mr6911883uad.25.1585557468135;
 Mon, 30 Mar 2020 01:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-5-robh@kernel.org>
 <CAK7LNARJn4uugHxcjK+WOWBs0gPVZQsCu4y6M8hkNK1U5FehRA@mail.gmail.com>
In-Reply-To: <CAK7LNARJn4uugHxcjK+WOWBs0gPVZQsCu4y6M8hkNK1U5FehRA@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 30 Mar 2020 17:37:11 +0900
X-Gmail-Original-Message-ID: <CAK7LNARXj3=1VPWL4kFmGkZuvV=yKb7gVaX2nbeiO54f-zWeHQ@mail.gmail.com>
Message-ID: <CAK7LNARXj3=1VPWL4kFmGkZuvV=yKb7gVaX2nbeiO54f-zWeHQ@mail.gmail.com>
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

Hi Rob,

On Mon, Mar 30, 2020 at 4:09 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Thu, Mar 26, 2020 at 7:06 AM Rob Herring <robh@kernel.org> wrote:
> >
> > Setting 'additionalProperties: false' is frequently omitted, but is
> > important in order to check that there aren't extra undocumented
> > properties in a binding.
> >
> > Ideally, we'd just add this automatically and make this the default, but
> > there's some cases where it doesn't work. For example, if a common
> > schema is referenced, then properties in the common schema aren't part
> > of what's considered for 'additionalProperties'. Also, sometimes there
> > are bus specific properties such as 'spi-max-frequency' that go into
> > bus child nodes, but aren't defined in the child node's schema.
> >
> > So let's stick with the json-schema defined default and add
> > 'additionalProperties: false' where needed. This will be a continual
> > review comment and game of wack-a-mole.
> >
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
>
>
> >  .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml      | 2 ++
>
>
> You may have already queue this up, but just in case.
>
> Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>



I take back Ack for socionext,uniphier-gpio.yaml



Now "make dt_binding_check" produces a new warning.

gpio@55000000: 'interrupt-parent' does not match any of the regexes:
'pinctrl-[0-9]+'


This binding uses 'interrupt-parent'
without 'interrupts'.

Instead, the mapping of the interrupt numbers
is specified by the vendor-specific property
socionext,interrupt-ranges



I cannot add   "interrupt-parent: true" because
dt-schema/meta-schemas/interrupts.yaml
has "interrupt-parent: false".


Is there any solution?



-- 
Best Regards
Masahiro Yamada
