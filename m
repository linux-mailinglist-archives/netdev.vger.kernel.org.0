Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14961588B55
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiHCLdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbiHCLdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:33:19 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679F4E61E;
        Wed,  3 Aug 2022 04:33:11 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gk3so18753668ejb.8;
        Wed, 03 Aug 2022 04:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vao2Cp7i5f6/k5QYAFT9/dBZf5yhq/l9mTWgGJqR6PY=;
        b=bWIMn9pC4xFcXuTK4bWw29xOdTVboCuIfO1+MCkkSWj4i30GZm2QG93Qmw2QCJGamO
         Cgrb9KXyDgBtTRh1j7tOsoRtCwJUAegKJ+y6Go1NlRhIJLc/0cNWdW8O1N1o8gZsglVW
         CbrG0u9x/x2rpo4d0VHdeqJ2TCMvLugC2oyZ8EJmwQl/6hhno0vtJBtx/8wyi0bEkZuB
         NNcxeYx1qIKFRr2yyLd4MARfZo8m7X0zfZjfyOFD8USyfmrMyGF7VIFMTA8zbi4Wfcci
         WeUK0HBL1RY1uKud3XQJjZpXnfWQuU+eqkbpQ3AHkKD9aen1I5A2iq8SYXIwSUXAnJZH
         O70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vao2Cp7i5f6/k5QYAFT9/dBZf5yhq/l9mTWgGJqR6PY=;
        b=ehQ33XYEQWWlyKRIDwsyzoV2Qa1u0FCxlaDKClbGopCFBUvcZ6GtQuNhku2IHmi7dc
         slvhmhQ0zNl8Vj5YiS0YrGheVv4GgPDMHfeUQk33cZTLgRgELeRFQM97fdYbdk4lXTkc
         n/4gCMVEdu4Ex06df1Mz27xkP6u6m2KRK7ZoY77nr6Eh8GzpLxY03sMzlJCH4+0SJBA5
         ojNXcj/vWQ33o1YjsL7VvvGHdGm/TJ1WJ0Z8S/hByV10zVdZFj3VmR8Q8YpLZTgcNegF
         zpY995SL8H9eIbFuNAmDzj/iEli4tFO2epo0VoYgJ3EOUa0FjHhvfGM+MZDvgOTxUTF2
         FGLA==
X-Gm-Message-State: AJIora9zEMypk8gszwenFiYI4eclOnbTwFJzNCMsJbKRSd1+Cn7aipYL
        g7EvzjzCqRNVH28tm+MNkaUb7vmJKXj6oAlJ10o=
X-Google-Smtp-Source: AGRyM1udxSQf76xVtwQpbkoB2qLWhTDDrQa++hbKCvIQy32osP8KAwyThml0YqEPpjzgdiCNXi/b7MNyT9hXQzjdWEA=
X-Received: by 2002:a17:907:2dab:b0:72f:f7:bdd6 with SMTP id
 gt43-20020a1709072dab00b0072f00f7bdd6mr20763646ejc.330.1659526390304; Wed, 03
 Aug 2022 04:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-6-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-6-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:32:33 +0200
Message-ID: <CAHp75Vd_AOSz68yzY86_ymbdOpQk_wtgJXKS47KuPcKH8S9-AQ@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 5/9] pinctrl: microchip-sgpio: allow sgpio driver
 to be used as a module
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 7:47 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> As the commit message suggests, this simply adds the ability to select
> SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> hardware exists on an external chip, controlled indirectly by I2C or SPI.
> This commit enables that level of control.

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>
> (No changes since before v14)
>
> v14
>     * No changes
>
> ---
>  drivers/pinctrl/Kconfig                   | 5 ++++-
>  drivers/pinctrl/pinctrl-microchip-sgpio.c | 6 +++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index ba48ff8be6e2..4e8d0ae6c81e 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -292,7 +292,7 @@ config PINCTRL_MCP23S08
>           corresponding interrupt-controller.
>
>  config PINCTRL_MICROCHIP_SGPIO
> -       bool "Pinctrl driver for Microsemi/Microchip Serial GPIO"
> +       tristate "Pinctrl driver for Microsemi/Microchip Serial GPIO"
>         depends on OF
>         depends on HAS_IOMEM
>         select GPIOLIB
> @@ -310,6 +310,9 @@ config PINCTRL_MICROCHIP_SGPIO
>           connect control signals from SFP modules and to act as an
>           LED controller.
>
> +         If compiled as a module, the module name will be
> +         pinctrl-microchip-sgpio.
> +
>  config PINCTRL_OCELOT
>         tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
>         depends on OF
> diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> index 6f55bf7d5e05..e56074b7e659 100644
> --- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
> +++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
> @@ -999,6 +999,7 @@ static const struct of_device_id microchip_sgpio_gpio_of_match[] = {
>                 /* sentinel */
>         }
>  };
> +MODULE_DEVICE_TABLE(of, microchip_sgpio_gpio_of_match);
>
>  static struct platform_driver microchip_sgpio_pinctrl_driver = {
>         .driver = {
> @@ -1008,4 +1009,7 @@ static struct platform_driver microchip_sgpio_pinctrl_driver = {
>         },
>         .probe = microchip_sgpio_probe,
>  };
> -builtin_platform_driver(microchip_sgpio_pinctrl_driver);
> +module_platform_driver(microchip_sgpio_pinctrl_driver);
> +
> +MODULE_DESCRIPTION("Microchip SGPIO Pinctrl Driver");
> +MODULE_LICENSE("GPL");
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
