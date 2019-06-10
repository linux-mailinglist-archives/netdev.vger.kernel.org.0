Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E573B511
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 14:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389940AbfFJMba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 08:31:30 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34970 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389167AbfFJMb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 08:31:29 -0400
Received: by mail-oi1-f194.google.com with SMTP id y6so6089945oix.2;
        Mon, 10 Jun 2019 05:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFynJG6GkMrt4lyp8IC+dRaN8zX6LxP0uU9NEUWvbzI=;
        b=cXohEkVc0ZP8pvQlDl8p6OE4YZbfDSAvS5aWQeuKTLlZqlj7v78cTJ15xSpsOzjR22
         xqW8m8BQQTHBCyUybgg4cjc9zpHtLHToZBnVKwVpPrd2gMNZEaQEY+U2aASQmhONplHu
         xCN+NI806+E9j8cNzavcdXo5PAqDEEspH4deJbZqbsj2prDFodwaiUI3/We1XgFxezKC
         nUwyXdytL8UYR+4FW0gFx5nL4COz2G9KZnTvc6tRryCozSSCylWM6PxbPnrrKKLOPF4y
         QKkBohVJzmnYPPPYwQEoIC2AXqhhVVwSaWDLT5t/w7U2D7lWdPCdL9uK58kqqA82/8t4
         vL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFynJG6GkMrt4lyp8IC+dRaN8zX6LxP0uU9NEUWvbzI=;
        b=mQ5EYUbQkMQ9gvxu8OEZCmkvjE0x8ntIetK5Qnud+8/shwOD4FgUdyIIHqssXjnkw+
         Tood+m2WpuwslX6QPXTnFyQtEGVs8LUJ52W494XtN7+H455z2I1YZEic/u6sEqZXf7Uq
         hiXE/ElgtGA1vVRrL2wG/V9LMl1QR+Jz2KMC9ztC01d2hTsEhV3ja6dByzcToH7bWJ5d
         5uVC28j3aNiIwD5WAhkJGidcpgVAIEzRRwCcSYD3ftqEQ/UeYMKZlhB5m3IBX3mLTf/e
         X4Y0eP19JxZBAJLnaPqW9oXevMXbPWb3PJU4q4zgOwq6Gv/ljs1LHGvtZ60dRQRTYOPL
         z0LA==
X-Gm-Message-State: APjAAAXKIfJ8F7ixw9CUmfM9Hp/zs30bnuRdrkSyqTrfJy1pAtAiAA0t
        zYibsdpjskFM0zjCe4s52KK9723TnUsB3Ir00Lw=
X-Google-Smtp-Source: APXvYqxpBiHP08OPhwvFiE1hD4gx+oq+4oIRwCJaMPkj/6FYkD61ABAJqXsC6FpliWoKBw4Uc0ZVvhgV6HFS3Jve/S4=
X-Received: by 2002:aca:51cf:: with SMTP id f198mr10179250oib.140.1560169888423;
 Mon, 10 Jun 2019 05:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
 <20190609204510.GB8247@lunn.ch> <20190610114700.tymqzzax334ahtz4@flea>
In-Reply-To: <20190610114700.tymqzzax334ahtz4@flea>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 10 Jun 2019 14:31:17 +0200
Message-ID: <CAFBinCCs5pa1QmaV32Dk9rOADKGXXFpZsSK=LUk4CGWMrG5VUQ@mail.gmail.com>
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset GPIO
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linus.walleij@linaro.org, bgolaszewski@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Mon, Jun 10, 2019 at 1:47 PM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Hi Andrew,
>
> On Sun, Jun 09, 2019 at 10:45:10PM +0200, Andrew Lunn wrote:
> > > Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> > > "Always leave the campground cleaner than you found it."
> >
> > > I
> > > am also looking for suggestions how to handle these cross-tree changes
> > > (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> > > go through the net-next tree. I will re-send patch #5 separately as
> > > this should go through Kevin's linux-amlogic tree).
> >
> > Patches 1 and 4 don't seem to have and dependencies. So i would
> > suggest splitting them out and submitting them to netdev for merging
> > independent of the rest.
>
> Jumping on the occasion of that series. These properties have been
> defined to deal with phy reset, while it seems that the PHY core can
> now handle that pretty easily through generic properties.
>
> Wouldn't it make more sense to just move to that generic properties
> that already deals with the flags properly?
thank you for bringing this up!
if anyone else (just like me) doesn't know about it, there are generic
bindings defined here: [0]

I just tested this on my X96 Max by defining the following properties
inside the PHY node:
  reset-delay-us = <10000>;
  reset-assert-us = <10000>;
  reset-deassert-us = <10000>;
  reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;

that means I don't need any stmmac patches which seems nice.
instead I can submit a patch to mark the snps,reset-gpio properties in
the dt-bindings deprecated (and refer to the generic bindings instead)
what do you think?


Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/phy.txt?id=b54dd90cab00f5b64ed8ce533991c20bf781a3cd#n58
