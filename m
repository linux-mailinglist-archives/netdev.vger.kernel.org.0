Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF5421CEBB
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 07:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgGMFO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 01:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMFO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 01:14:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38958C061794;
        Sun, 12 Jul 2020 22:14:58 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b185so11119104qkg.1;
        Sun, 12 Jul 2020 22:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJfMKkuixe8TcFmSgPVFQeX2ebVBk2NIfALDJvpOegk=;
        b=t1YTVsAOG7g2piVPzr9XqfcOnf1nl6fNsrPCzOhU25jJur4I0iJE19KVWcxP9TixlH
         hA57KrAkQoI5IRkXUIwJDb5X00QSGkNpOaOxcD3Nan/XQTZVduQjrEg9Z14YNRooh0xq
         YkYJUAB1lMa26uVrPQtmfvx05NKveu8jVXhT7ISzvFaojV/IuhzB9juQsNLM3nZX6QQD
         /qypLMf6oZvwdlxwTxzwIwzH7E9u7lNMkYjJAceAoVyAthjE9BnK7zA8TE7Rk6oyIh60
         ynOFniFe80hCUQ6h5+qkWRhJ8BTalGQHjoywwL3/780fkljffvktE9z46d8S7NnRo8NP
         Pcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HJfMKkuixe8TcFmSgPVFQeX2ebVBk2NIfALDJvpOegk=;
        b=RNSKVmAOg6thIvBcvJUq6+3eFdcH5xiFQhlXG6eDRxyKu1jh76dauF/Wcf8Gfr4Szj
         0mc0eBddzEBohWpVuIgzBXm+J3ucz7Uy/NZYrT3Kak9DHqdXsJ7L5xF+auWrBltrNpJE
         1ECRdrdmD3ujcWZKz9VC2KX6O7JV2riVu117BsaYF1WXKixyRsO05faBSCspLOjQ7A5W
         SuaLmRt1j7HQu5N65MUeW/CQOYEIenkt8L7eZPkTlKtf9YERTlTS/+6n/IJYbTaSXOUz
         QAs3n4P7vSqNjQe569CGCueTbwgqDKnLYUsqKWYmWZ2u702THHU71nTv6wSbEfMzgVeI
         G/Ew==
X-Gm-Message-State: AOAM530TRfWQQe0FuEMnTWGtHnCTIpHvAmpfk4oaAuE7NRB7AVjM1dDp
        rPt0QacZWdkpgA0zh26YNvuW9A2R841sMg9WzhU=
X-Google-Smtp-Source: ABdhPJzZeRI4Vo+yZmNHHCrZWhnaKiX6BuWRvS5dt2QggK3l73mOoFiEQTzrVHTr+lD9cXIK0pQuLgSHhO8q2rUM2KU=
X-Received: by 2002:a37:ec7:: with SMTP id 190mr75015576qko.421.1594617297477;
 Sun, 12 Jul 2020 22:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200705195110.405139-1-anarsoul@gmail.com> <20200705195110.405139-4-anarsoul@gmail.com>
 <20200706114709.l6poszepqsmg5p5r@gilmour.lan>
In-Reply-To: <20200706114709.l6poszepqsmg5p5r@gilmour.lan>
From:   Vasily Khoruzhick <anarsoul@gmail.com>
Date:   Sun, 12 Jul 2020 22:14:31 -0700
Message-ID: <CA+E=qVe30AEocwi62sJSX7=tRUJ3LeKdgEwtA8trQN4xtMpgTA@mail.gmail.com>
Subject: Re: [PATCH 3/3] arm64: allwinner: a64: enable Bluetooth On Pinebook
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 4:47 AM Maxime Ripard <maxime@cerno.tech> wrote:
>
> Hi,
>
> On Sun, Jul 05, 2020 at 12:51:10PM -0700, Vasily Khoruzhick wrote:
> > Pinebook has an RTL8723CS WiFi + BT chip, BT is connected to UART1
> > and uses PL5 as device wake GPIO, PL6 as host wake GPIO the I2C
> > controlling signals are connected to R_I2C bus.
> >
> > Enable it in the device tree.
> >
> > Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> > ---
> >  .../arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> > index 64b1c54f87c0..e63ff271be4e 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
> > @@ -408,6 +408,18 @@ &uart0 {
> >       status = "okay";
> >  };
> >
> > +&uart1 {
> > +     pinctrl-names = "default";
> > +     pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
> > +     status = "okay";
>
> You probably need uart-has-rtscts here

Will add in v2

> > +
> > +     bluetooth {
> > +             compatible = "realtek,rtl8723cs-bt";
> > +             device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_LOW>; /* PL5 */
> > +             host-wake-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
> > +     };
>
> And max-speed I guess?

There's no max-speed in the schema for this bluetooth controller.
Moreover it reads uart settings from firmware config. See
btrtl_get_uart_settings() in drivers/bluetooth/btrtl.c

> Maxime
> >
