Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE7455E8E6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347572AbiF1Pey convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jun 2022 11:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347906AbiF1Pes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 11:34:48 -0400
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2829C2B24F;
        Tue, 28 Jun 2022 08:34:47 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id 59so20583793qvb.3;
        Tue, 28 Jun 2022 08:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9TFwdpU9SDvPROx3CuYdr/usbBC2kew7C8d8p5fl8bo=;
        b=wxlTWHZ3QZc+Mpj83H0x4Q7EEQOBiQVuync4YyyqZW18qUht6yqQa9MukLrewRxTyT
         uMy74rFCRdiN54P9NmFnEusDsJDo4k7NIAxVlG9gb4dJEn7Ugw0zC0Vq0E2QFwhbLmUv
         xnNh14U2OxgV5Z5xbpYyAS8tp3hzbv7EHr82O0XxRxTC+ldoOA5vCvMfOyAtgPhYf9A8
         /2DvgCTH90CjJmI+gawVlEYqzyNZGTBFnLT/2Mb1B+/Q2TiSPIo0+q1287bpeA0dujVy
         h+hPcK+3UBv05ntd2nn0wnvPuz+1PIg77rjaT78wRfCA1dkjyFV/fNG37f7bPar4SeBy
         VZEA==
X-Gm-Message-State: AJIora/AG8S7E0GMTJJ/4qoB2yVQhJKMCT94+7IDK+8iONSt1BKvtJO3
        erRvfiehrdyTa8S9Zupf1RkAgHfOiNyYHQ==
X-Google-Smtp-Source: AGRyM1s9Q4nj4fYtHzQWb3kTl56q+sREdxY6Z2UPcNT2rORetoy2ksScOQbjZu48SzwXYzWuUaBMMA==
X-Received: by 2002:ac8:7f15:0:b0:306:6adf:8ae9 with SMTP id f21-20020ac87f15000000b003066adf8ae9mr13543398qtk.137.1656430486116;
        Tue, 28 Jun 2022 08:34:46 -0700 (PDT)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id bs7-20020a05620a470700b006af33c08e77sm4174642qkb.121.2022.06.28.08.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 08:34:45 -0700 (PDT)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3176b6ed923so120851677b3.11;
        Tue, 28 Jun 2022 08:34:44 -0700 (PDT)
X-Received: by 2002:a81:574c:0:b0:317:7c3a:45be with SMTP id
 l73-20020a81574c000000b003177c3a45bemr21605898ywb.316.1656430484420; Tue, 28
 Jun 2022 08:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220624144001.95518-1-clement.leger@bootlin.com> <20220624144001.95518-16-clement.leger@bootlin.com>
In-Reply-To: <20220624144001.95518-16-clement.leger@bootlin.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Jun 2022 17:34:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXwe0YmZr+BjArnWWALAsC28_Q+zy3F0cHMZDxOxdnCLg@mail.gmail.com>
Message-ID: <CAMuHMdXwe0YmZr+BjArnWWALAsC28_Q+zy3F0cHMZDxOxdnCLg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 15/16] ARM: dts: r9a06g032-rzn1d400-db: add
 switch description
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

On Fri, Jun 24, 2022 at 4:42 PM Clément Léger <clement.leger@bootlin.com> wrote:
> Add description for the switch, GMAC2 and MII converter. With these
> definitions, the switch port 0 and 1 (MII port 5 and 4) are working on
> RZ/N1D-DB board.
>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks for your patch!

> --- a/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> +++ b/arch/arm/boot/dts/r9a06g032-rzn1d400-db.dts
> @@ -31,3 +33,118 @@ &wdt0 {
>         timeout-sec = <60>;
>         status = "okay";
>  };
> +
> +&gmac2 {

Please keep the nodes sorted (everywhere).

> +&pinctrl{
> +       pins_mdio1: pins_mdio1 {
> +               pinmux = <
> +                       RZN1_PINMUX(152, RZN1_FUNC_MDIO1_SWITCH)
> +                       RZN1_PINMUX(153, RZN1_FUNC_MDIO1_SWITCH)
> +               >;

This is not a single value, but an array of 2 values.  Hence they
should be grouped using angular brackets, to enable automatic
validation.

I will fix the above while applying, so no need to resend.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
