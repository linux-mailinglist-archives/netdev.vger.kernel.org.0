Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDA83AC31
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 00:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfFIWHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 18:07:00 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:34815 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIWHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 18:07:00 -0400
Received: by mail-lj1-f179.google.com with SMTP id p17so1256048ljg.1
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 15:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50GXZwDHzCmpvzbBJ8yBES+uMhcVk2V2rV15ilN2B0c=;
        b=g+6Vbl0iiwSmN9H6YowhpGLJ73aounTBDzKhwymCbPXUe3YFtgu1z4wNCKLkILsZs/
         FKkBcFH//l4EcaLCokbemf+udf2+h3MZo4BZFRGYU0k7TFa+hJCq1VGJB8Umrkcd98kp
         lkU4Vk37IHqN9wT2FoTtsaWc4lSpIcqfaJWjxgoAuWi5z29YyrlYWbhjuKr84CHN2XUL
         C2Bgw1IznFw2WLjGRQbyFjkn0b3MoPs5N/0e4hn/Gacris0AR8lDHFeUzYiZwq4bXQfE
         jk4STLcb4kxRKe1TPxcO+kpC+f7ibP9nIBlvBlZvmdNUtRzohvJfxSy8G4TpJbomtPW1
         PR3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50GXZwDHzCmpvzbBJ8yBES+uMhcVk2V2rV15ilN2B0c=;
        b=d955TkQQPJ5KVK8xrP6MVrvg9E3j7sjlfe+kijwmhsRygW6pfDMfaSn631YxqEdZ3+
         2nGSjbas5A8KzWhA82K/6bUU1S59dzD4kinf7jFterPlyAYt9Ze98WKwLavzbaS6yefU
         3pnNmPVjwFPhXnFmoxj4BG1BXZgM4+LFKucyE40tu9f8Qob4K93wSTb+e1FjKXHcu1v9
         cSJlkgJjGEswfQ3xJzBqFzI4rFcFTqZoNWdEYPGrBxkJ7/R4e7wO2ButjLMUSKu1gmmm
         MqREeAfl2lbP24squidMncp+RGqBra2RTbErTeawIDAf9QbmvnNHxwKamV/+xYFYnXmg
         uLuA==
X-Gm-Message-State: APjAAAUakIHe/fDTn0b2ZOdt1ga6N7K8UavEjXv/eO+DKEECPrj/XuGL
        xjcSRHwVoy3Ag1Rvf1CSsyiYC1pbvt+rMcomp44mtQ==
X-Google-Smtp-Source: APXvYqyA9vzJYqRBM9b+TZM/4DaVcMYzTW8e9CaOv9ikhog+XAeu8+oeZTxmSSNapo5H1D99QLI3ZR7brOWlp3Po/C4=
X-Received: by 2002:a2e:5bdd:: with SMTP id m90mr25061179lje.46.1560118018248;
 Sun, 09 Jun 2019 15:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609180621.7607-6-martin.blumenstingl@googlemail.com>
 <CACRpkdYzeiLB7Yuixv6NsnLJoa_FnGKRHHQm=t4gMH34NdFSYA@mail.gmail.com> <CAFBinCBgoLb+Hfdo-sZ_0H6ct=UJm7j6wD_C6udbA6BTRvFOWQ@mail.gmail.com>
In-Reply-To: <CAFBinCBgoLb+Hfdo-sZ_0H6ct=UJm7j6wD_C6udbA6BTRvFOWQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 10 Jun 2019 00:06:51 +0200
Message-ID: <CACRpkdYur+dwC1LqasQR-cvTWcpV12vr+8Wi5o9kXVWe-0teZw@mail.gmail.com>
Subject: Re: [RFC next v1 5/5] arm64: dts: meson: g12a: x96-max: fix the
 Ethernet PHY reset line
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 9, 2019 at 11:36 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:

> > If "snps,reset-active-low" was set it results in the sequence 1, 0, 1
> > if it is not set it results in the sequence 0, 1, 0.
>
> I'm changing this logic with earlier patches of this series.
> can you please look at these as well because GPIO_OPEN_SOURCE doesn't
> work with the old version of stmmac_mdio_reset() that you are showing.

OK but the logic is the same, just that the polarity handling is moved
into gpiolib.

> > The high (reset) is asserted by switching the pin into high-z open drain
> > mode, which happens by switching the line into input mode in some
> > cases.
> >
> > I think the real reason it works now is that reset is actually active high.
>
> let me write down what I definitely know so far
>
> the RTL8211F PHY wants the reset line to be LOW for a few milliseconds
> to put it into reset mode.
> driving the reset line HIGH again takes it out of reset.
>
> Odroid-N2's schematics [0] (page 30) shows that there's a pull-up for
> the PHYRSTB pin, which is also connected to the NRST signal which is
> GPIOZ_15

Looks correct, R143 is indeed a pull up indicating that the line is
open drain, active low.

> > It makes a lot of sense, since if it resets the device when set as input
> > (open drain) it holds all devices on that line in reset, which is likely
> > what you want as most GPIOs come up as inputs (open drain).
> > A pull-up resistor will ascertain that the devices are in reset.
>
> my understanding is that the pull-up resistor holds it out of reset
> driving GPIOZ_15's (open drain) output LOW pulls the signal to ground
> and asserts the reset

Yep that seems correct.

Oh I guess it is this:

        amlogic,tx-delay-ns = <2>;
-       snps,reset-gpio = <&gpio GPIOZ_14 0>;
+       snps,reset-gpio = <&gpio GPIOZ_15 GPIO_OPEN_SOURCE>;
        snps,reset-delays-us = <0 10000 1000000>;
-       snps,reset-active-low;

Can you try:
snps,reset-gpio = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
?

Open source is nominally (and rarely) used for lines that are active high.
For lines that are active low, we want to use open drain combined
with active low.

Yours,
Linus Walleij
