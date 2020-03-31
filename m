Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070571998B9
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgCaOjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCaOjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 10:39:13 -0400
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A0F214D8;
        Tue, 31 Mar 2020 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585665552;
        bh=VQTYjDLJpBPL64v+KHcwfSavLEUmQ5VPbYuKeDQvfh4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=w9kKXD8z4sqI86PU33XbHmfq5R7o1rl1Yc6oUOAz42cwHppv6UAYyiBVNzHr/8rGq
         fiuijzJ4syHgX49+YFivKcsWhdJV6fv/bOG69I3vdo0Lq1npTDVuNQt+ItarZp4b9G
         a/bP28cpaoxY9yg7N1tSpyTZfOjD00o0nNDF4FO0=
Received: by mail-qk1-f175.google.com with SMTP id l25so23220051qki.7;
        Tue, 31 Mar 2020 07:39:12 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1Yn4A9Q6+UE+Fanv4lnS9wOsS2mOqlYHd34dkABj36/5Rng+QK
        5l9WpzStfcaqEjMA1sRPag/9oA3L9MsbAp5F3A==
X-Google-Smtp-Source: ADFU+vs96kIPVk/bUhQUvXuwHTzxBhEjf4smiGd+iZOn7jyc5rfIytLi140jinW+le6E+iSeEnGKe3qbfJEIB3it89g=
X-Received: by 2002:a37:aa92:: with SMTP id t140mr4802134qke.119.1585665551704;
 Tue, 31 Mar 2020 07:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-5-robh@kernel.org>
 <CAK7LNARJn4uugHxcjK+WOWBs0gPVZQsCu4y6M8hkNK1U5FehRA@mail.gmail.com> <CAK7LNARXj3=1VPWL4kFmGkZuvV=yKb7gVaX2nbeiO54f-zWeHQ@mail.gmail.com>
In-Reply-To: <CAK7LNARXj3=1VPWL4kFmGkZuvV=yKb7gVaX2nbeiO54f-zWeHQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 31 Mar 2020 08:39:00 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLDL6mVZ3Bb3f6eObF9SNwy6WK_srX5=m=NCN8Jq+-R+g@mail.gmail.com>
Message-ID: <CAL_JsqLDL6mVZ3Bb3f6eObF9SNwy6WK_srX5=m=NCN8Jq+-R+g@mail.gmail.com>
Subject: Re: [PATCH 4/4] dt-bindings: Add missing 'additionalProperties: false'
To:     Masahiro Yamada <masahiroy@kernel.org>
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
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 2:38 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Hi Rob,
>
> On Mon, Mar 30, 2020 at 4:09 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > On Thu, Mar 26, 2020 at 7:06 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > Setting 'additionalProperties: false' is frequently omitted, but is
> > > important in order to check that there aren't extra undocumented
> > > properties in a binding.
> > >
> > > Ideally, we'd just add this automatically and make this the default, but
> > > there's some cases where it doesn't work. For example, if a common
> > > schema is referenced, then properties in the common schema aren't part
> > > of what's considered for 'additionalProperties'. Also, sometimes there
> > > are bus specific properties such as 'spi-max-frequency' that go into
> > > bus child nodes, but aren't defined in the child node's schema.
> > >
> > > So let's stick with the json-schema defined default and add
> > > 'additionalProperties: false' where needed. This will be a continual
> > > review comment and game of wack-a-mole.
> > >
> > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > ---
> >
> >
> > >  .../devicetree/bindings/gpio/socionext,uniphier-gpio.yaml      | 2 ++
> >
> >
> > You may have already queue this up, but just in case.
> >
> > Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>
>
>
> I take back Ack for socionext,uniphier-gpio.yaml
>
>
>
> Now "make dt_binding_check" produces a new warning.
>
> gpio@55000000: 'interrupt-parent' does not match any of the regexes:
> 'pinctrl-[0-9]+'
>
>
> This binding uses 'interrupt-parent'
> without 'interrupts'.
>
> Instead, the mapping of the interrupt numbers
> is specified by the vendor-specific property
> socionext,interrupt-ranges
>
>
>
> I cannot add   "interrupt-parent: true" because
> dt-schema/meta-schemas/interrupts.yaml
> has "interrupt-parent: false".
>
>
> Is there any solution?

I'd meant to just drop socionext,uniphier-gpio.yaml.

Rob
