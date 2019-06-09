Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143113AC67
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 00:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfFIW3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 18:29:02 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35462 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbfFIW3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 18:29:02 -0400
Received: by mail-ot1-f66.google.com with SMTP id j19so6630701otq.2;
        Sun, 09 Jun 2019 15:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sePl1BxoH8M2Ag9hWKHMM9PC7HT35mw+FBXMYc8ap6c=;
        b=Yw5lxz2MiGWV6OwbaX63dQW+cirM/W4o6b7Xia0ej4yEhpRzVI0DltV0GAL7UAgwaM
         91vcaOnjNUJVMHrChqbrsdrWY1l2Pa5hrSha6gqLWFmHolBLQThdwquKORq0rFPGJTEn
         gZn4TkcAPDzh40IsgK0PORqVgyrCwVi4/QyzPw03MCCouiZZuHfzu16PhSjZnuX7pkA7
         eJ0xRRqfgEK1OJNXktIsRvAD4kIC/8m+yQgBfYmzQnLkefvqmaESBfZ+7XJoqqfzlx87
         i0dDU/jG2ZRsV61cQKa9bl8ip8+MV72DncqyaXYNGoJxCZHJLUbY0n7nRGhZ/GjAfjKk
         ZZ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sePl1BxoH8M2Ag9hWKHMM9PC7HT35mw+FBXMYc8ap6c=;
        b=cR80pgrn0UQWgQDdgj8MjyJmrz/5D/5MVj0MVFZVX8HowBATlpqGds+JGdeqKlHiYk
         0vQJj+i7W3sHI6PfCFDk7sFPE20kIsIUmV81XlLo7RigPpZIi77/ZH2VKn0sdx/4eaGU
         hkTn5CS0pvZmmm7Sun1XmUQ7DR1VTU6Utnf0m8xiAVwZBuGN0HF6bOE2wOKHzVNqde98
         +uNBu3bfU0zvoAbwYXRlsVAgdzw9efu6/SiEuNPupu48qb535mh0V35HU8TazAPMlizy
         LDrylnZDkyTbiDME0P5pRnrJJUsyE9I/wt4P1jtzoF0xofotUiZjsvZ/9JR8geWODFlb
         fUdA==
X-Gm-Message-State: APjAAAWGcNpDgAAeW+QGYH3vQxwL6PDjFi6XyV5izyqN1rwBI8lsU7/n
        kB4NoZxbDhV2eGyWK0mSj1gFp46zhrijnVcGdW4=
X-Google-Smtp-Source: APXvYqy+T7mpPqt6GkRiQjZzGluZ3AiR4EAUVviHS6NHy+UPPLubdx6ZNTH4stn3vXNw9TQ8wcN2BMs2ClwdoqNifV0=
X-Received: by 2002:a9d:6405:: with SMTP id h5mr16693612otl.42.1560119341436;
 Sun, 09 Jun 2019 15:29:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609180621.7607-6-martin.blumenstingl@googlemail.com>
 <CACRpkdYzeiLB7Yuixv6NsnLJoa_FnGKRHHQm=t4gMH34NdFSYA@mail.gmail.com>
 <CAFBinCBgoLb+Hfdo-sZ_0H6ct=UJm7j6wD_C6udbA6BTRvFOWQ@mail.gmail.com> <CACRpkdYur+dwC1LqasQR-cvTWcpV12vr+8Wi5o9kXVWe-0teZw@mail.gmail.com>
In-Reply-To: <CACRpkdYur+dwC1LqasQR-cvTWcpV12vr+8Wi5o9kXVWe-0teZw@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 10 Jun 2019 00:28:50 +0200
Message-ID: <CAFBinCDOhBUqNx4y+j1NeE08wWuZ-bhX5DsE8kcG4LUHKEQ+nQ@mail.gmail.com>
Subject: Re: [RFC next v1 5/5] arm64: dts: meson: g12a: x96-max: fix the
 Ethernet PHY reset line
To:     Linus Walleij <linus.walleij@linaro.org>
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

Hi Linus,

On Mon, Jun 10, 2019 at 12:06 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Sun, Jun 9, 2019 at 11:36 PM Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>
> > > If "snps,reset-active-low" was set it results in the sequence 1, 0, 1
> > > if it is not set it results in the sequence 0, 1, 0.
> >
> > I'm changing this logic with earlier patches of this series.
> > can you please look at these as well because GPIO_OPEN_SOURCE doesn't
> > work with the old version of stmmac_mdio_reset() that you are showing.
>
> OK but the logic is the same, just that the polarity handling is moved
> into gpiolib.
>
> > > The high (reset) is asserted by switching the pin into high-z open drain
> > > mode, which happens by switching the line into input mode in some
> > > cases.
> > >
> > > I think the real reason it works now is that reset is actually active high.
> >
> > let me write down what I definitely know so far
> >
> > the RTL8211F PHY wants the reset line to be LOW for a few milliseconds
> > to put it into reset mode.
> > driving the reset line HIGH again takes it out of reset.
> >
> > Odroid-N2's schematics [0] (page 30) shows that there's a pull-up for
> > the PHYRSTB pin, which is also connected to the NRST signal which is
> > GPIOZ_15
>
> Looks correct, R143 is indeed a pull up indicating that the line is
> open drain, active low.
good so far

> > > It makes a lot of sense, since if it resets the device when set as input
> > > (open drain) it holds all devices on that line in reset, which is likely
> > > what you want as most GPIOs come up as inputs (open drain).
> > > A pull-up resistor will ascertain that the devices are in reset.
> >
> > my understanding is that the pull-up resistor holds it out of reset
> > driving GPIOZ_15's (open drain) output LOW pulls the signal to ground
> > and asserts the reset
>
> Yep that seems correct.
>
> Oh I guess it is this:
>
>         amlogic,tx-delay-ns = <2>;
> -       snps,reset-gpio = <&gpio GPIOZ_14 0>;
> +       snps,reset-gpio = <&gpio GPIOZ_15 GPIO_OPEN_SOURCE>;
>         snps,reset-delays-us = <0 10000 1000000>;
> -       snps,reset-active-low;
>
> Can you try:
> snps,reset-gpio = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
> ?
I tried it and it works!

> Open source is nominally (and rarely) used for lines that are active high.
> For lines that are active low, we want to use open drain combined
> with active low.
thank you for the explanation - I'll take your version for v2 :)


Martin
