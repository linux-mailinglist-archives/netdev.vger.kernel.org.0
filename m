Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EDB3B0625
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhFVNqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhFVNqJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 09:46:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC2F861353;
        Tue, 22 Jun 2021 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624369432;
        bh=NqFXh1RzaIB7T3yUivBhV+3jLDLAyj/zzCtWY0JA0SQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=n2C4l95B/w+7fm3Hy/W1ls3BjWTgUnPkeMWPcJwuHNhjALViq36NSNRvf1J+UxXwT
         W1of8Zg2OiipKGz+JaQJVEN0Rymz9BqpYAiOBzmrtdT5/mgiDbEVBsHlr3gDk+TOBO
         Fe7qpiKq+UgUir5JlR9fsJDRZtySIEJhB36NWX9yf5t0mO64+Z1mYCq7ew8ZAwg0KI
         F5hwQr8sPPDgEGs9UTcylTzkdsRMaQyTccf/acpKJhxDJxKtULLFNQYEsUOGj4MJxK
         B3a0hJqzs9FjH4X1uUrkMDUidT5NSByby5xfUTkfYV6nW2261SSjbz6fXsdgEAv5QU
         qCbHec6qB4IfA==
Received: by mail-ed1-f48.google.com with SMTP id t3so23726766edc.7;
        Tue, 22 Jun 2021 06:43:52 -0700 (PDT)
X-Gm-Message-State: AOAM530naL8j0CKzvJfrllBmASUFsX2bsI1GjGzC0mAXDpPnd7e/OVpX
        4EDZT2wnXe4JGzDS7JIUEAN3Ta5uIGiYDz5J5Q==
X-Google-Smtp-Source: ABdhPJzR0Ub3ZgSNkr3MEhjSHq6x9DynzmvMX7quMzOS1boijoDJs7nsAsYPAJuJ3rupM/aSXMVZuLXS4ayPZR+vCGA=
X-Received: by 2002:a05:6402:ca2:: with SMTP id cn2mr2897976edb.62.1624369431373;
 Tue, 22 Jun 2021 06:43:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210615191543.1043414-1-robh@kernel.org> <CAMuHMdUGXu8yj3JWKwM8mt7axkrzGMiowC1t0PHrbpxRCBME3w@mail.gmail.com>
In-Reply-To: <CAMuHMdUGXu8yj3JWKwM8mt7axkrzGMiowC1t0PHrbpxRCBME3w@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 22 Jun 2021 07:43:37 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ8jjkufTAmoFHuqpWB0bMUfCCkUR-pFFa2MoyeGzgBvA@mail.gmail.com>
Message-ID: <CAL_JsqJ8jjkufTAmoFHuqpWB0bMUfCCkUR-pFFa2MoyeGzgBvA@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Drop redundant minItems/maxItems
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, linux-clk <linux-clk@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-can@vger.kernel.org,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-phy@lists.infradead.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 2:17 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Rob,
>
> On Tue, Jun 15, 2021 at 9:16 PM Rob Herring <robh@kernel.org> wrote:
> > If a property has an 'items' list, then a 'minItems' or 'maxItems' with the
> > same size as the list is redundant and can be dropped. Note that is DT
> > schema specific behavior and not standard json-schema behavior. The tooling
> > will fixup the final schema adding any unspecified minItems/maxItems.
> >
> > This condition is partially checked with the meta-schema already, but
> > only if both 'minItems' and 'maxItems' are equal to the 'items' length.
> > An improved meta-schema is pending.
>
> > Signed-off-by: Rob Herring <robh@kernel.org>
>
> > --- a/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/stm32-dwmac.yaml
> > @@ -46,7 +46,6 @@ properties:
> >
> >    clocks:
> >      minItems: 3
> > -    maxItems: 5
> >      items:
> >        - description: GMAC main clock
> >        - description: MAC TX clock
>
> While resolving the conflict with commit fea99822914039c6
> ("dt-bindings: net: document ptp_ref clk in dwmac") in soc/for-next,
> I noticed the following construct for clock-names:
>
>   clock-names:
>     minItems: 3
>     maxItems: 6
>     contains:
>       enum:
>         - stmmaceth
>         - mac-clk-tx
>         - mac-clk-rx
>         - ethstp
>         - eth-ck
>         - ptp_ref
>
> Should this use items instead of enum, and drop maxItems, or is this
> a valid construct to support specifying the clocks in random order?
> If the latter, it does mean that the order of clock-names may not
> match the order of the clock descriptions.

'contains' is true if one or more entries match the strings. So it is
really saying one of these is required. That's not really much of a
constraint. There's 'minContains' and 'maxContains' in newer
json-schema versions (not yet supported) that could add some
constraints if there has to be at least N entries from contains. An
'items' schema (as opposed to a list) would say all items have to
match one of the strings. I'm sure that's too strict.

TLDR: clocks for this binding are a mess and the above is probably all
we can do here.

Rob
