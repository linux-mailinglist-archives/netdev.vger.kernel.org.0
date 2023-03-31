Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9521D6D221A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjCaOLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjCaOLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:11:31 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712AA1D2E8
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:11:30 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id dg15so7612557vsb.13
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680271889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lG/WYsq29l19IPVJ1k1HveeXpXEw8n6whXP0RBXQsVE=;
        b=EvtZrKsNbHzwyuTtRqHQROrrofpQ/sG01uOiuhmiI8aPts7n7Ee5Ir4NvfrBMC9uI+
         rP59rZDcNbSrbcJgAHZuzWOVqM440qSkPSsXQam8gLhm6JrqARMEWp7hP37azlVW4org
         fBACV9jHeMc/fcIgXarc7w17iylr7tNHGmieksiQNlIzpXJ80+yWU+CJGHU8lpI3k2C8
         ICYW0V27W/2DBLWul+Ja7q7aEtfylH/JCpUFcy+E+zrhYwff5tk/+w+43pgclTvoUdaY
         JKB3eTBzT085pwnm7cEdG1xRDF3HVWkUIWkzjjSc40AzCnbk/tZvpSB9Tq3T3RIS9CKy
         06FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lG/WYsq29l19IPVJ1k1HveeXpXEw8n6whXP0RBXQsVE=;
        b=VUQUr0D+CRLGPBrVEArV6POVrgUIf0AaGExh3v5x+Ij7LXs7XpbCwzV9Yu3GsMyQjn
         5Z9fZ+Eb8ZV8XBxpiZPzHdgHVSGFyHZ135jhrUbyTXlEHrNpYT30tEw90Sj65/BrtMHU
         LLXqMlRAhTYalcTkRvKG3uBA6MNzzpps4HzSi0SC55tgZgu24Q1tckcfFjRnCFwcWpBp
         ZpTbFx2bgjV1A+YFcMP6XbTFzHLWQZJHXCZAQRh0att09wpsvJLPtkgs8RnnGn0+e9GW
         cSkNRM3JqfHvR6qFJO6xV7edwa9c9Bqo83aHfLLfjIosIRx+ws0NM37WyiPnoiaZkfnJ
         mFGQ==
X-Gm-Message-State: AAQBX9fxww0RKtyYmxFpnanwHqbIUjZiN+UQpP8I0u3VuHpZa+9+CqTG
        FPG2QaViKp+z/DUDyLjsAGfSWNLMxy9fd+ODNALXxw==
X-Google-Smtp-Source: AKy350Ya9O0j2IJ/iXVAszn5aY9fHDH1jV5pYhAfg5ER4OEHtZmmlP21NIaPy6SQjGvX406cL1yK9LBdk5p7JcyHINc=
X-Received: by 2002:a67:e095:0:b0:426:b051:1c4 with SMTP id
 f21-20020a67e095000000b00426b05101c4mr9141092vsl.0.1680271889495; Fri, 31 Mar
 2023 07:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230331-topic-oxnas-upstream-remove-v1-0-5bd58fd1dd1f@linaro.org>
 <20230331-topic-oxnas-upstream-remove-v1-15-5bd58fd1dd1f@linaro.org>
In-Reply-To: <20230331-topic-oxnas-upstream-remove-v1-15-5bd58fd1dd1f@linaro.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Fri, 31 Mar 2023 16:11:18 +0200
Message-ID: <CAMRc=Mdp48+DitzSV5gq3arPL75TJXQLoBxTujsWSH4UVpd2ww@mail.gmail.com>
Subject: Re: [PATCH RFC 15/20] dt-bindings: gpio: gpio_oxnas: remove obsolete bindings
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        soc@kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:35=E2=80=AFAM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
>
> Due to lack of maintainance and stall of development for a few years now,
> and since no new features will ever be added upstream, remove the
> OX810 and OX820 gpio bindings.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../devicetree/bindings/gpio/gpio_oxnas.txt        | 47 ----------------=
------
>  1 file changed, 47 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/gpio/gpio_oxnas.txt b/Docu=
mentation/devicetree/bindings/gpio/gpio_oxnas.txt
> deleted file mode 100644
> index 966514744df4..000000000000
> --- a/Documentation/devicetree/bindings/gpio/gpio_oxnas.txt
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -* Oxford Semiconductor OXNAS SoC GPIO Controller
> -
> -Please refer to gpio.txt for generic information regarding GPIO bindings=
.
> -
> -Required properties:
> - - compatible: "oxsemi,ox810se-gpio" or "oxsemi,ox820-gpio"
> - - reg: Base address and length for the device.
> - - interrupts: The port interrupt shared by all pins.
> - - gpio-controller: Marks the port as GPIO controller.
> - - #gpio-cells: Two. The first cell is the pin number and
> -   the second cell is used to specify the gpio polarity as defined in
> -   defined in <dt-bindings/gpio/gpio.h>:
> -      0 =3D GPIO_ACTIVE_HIGH
> -      1 =3D GPIO_ACTIVE_LOW
> - - interrupt-controller: Marks the device node as an interrupt controlle=
r.
> - - #interrupt-cells: Two. The first cell is the GPIO number and second c=
ell
> -   is used to specify the trigger type as defined in
> -   <dt-bindings/interrupt-controller/irq.h>:
> -      IRQ_TYPE_EDGE_RISING
> -      IRQ_TYPE_EDGE_FALLING
> -      IRQ_TYPE_EDGE_BOTH
> - - gpio-ranges: Interaction with the PINCTRL subsystem, it also specifie=
s the
> -   gpio base and count, should be in the format of numeric-gpio-range as
> -   specified in the gpio.txt file.
> -
> -Example:
> -
> -gpio0: gpio@0 {
> -       compatible =3D "oxsemi,ox810se-gpio";
> -       reg =3D <0x000000 0x100000>;
> -       interrupts =3D <21>;
> -       #gpio-cells =3D <2>;
> -       gpio-controller;
> -       interrupt-controller;
> -       #interrupt-cells =3D <2>;
> -       gpio-ranges =3D <&pinctrl 0 0 32>;
> -};
> -
> -keys {
> -       ...
> -
> -       button-esc {
> -               label =3D "ESC";
> -               linux,code =3D <1>;
> -               gpios =3D <&gpio0 12 0>;
> -       };
> -};
>
> --
> 2.34.1
>

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
