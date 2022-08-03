Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D581F588B4D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiHCLcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiHCLck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:32:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B95371B1;
        Wed,  3 Aug 2022 04:32:39 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z2so10677490edc.1;
        Wed, 03 Aug 2022 04:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QWoNV73PMehvx7a/jO/4xAYjEo5H0FOcveRTEMgWVQE=;
        b=aDI7HGMNzsTTK/vushA+Zc1k4AFDuhGUhoCQ3ognq967PeVK3U4/TMNg1yC9KcJiF2
         eO95Bwjgmx2Vs2GJpLbIwwW9xlIbhKdyybUZFiYqjpYdXMIHdrtSqNlHCUWPEIlKKxH9
         shkB910bvZhpVD4FKFZbx83W8Mp8cjqJWJOa4R5qDuAddhWdud61Vq2wQ3yRl5cbiwTS
         M9AFliPeZThWtmwBltufkmb5VB8H6RBu9QnNrWH+FVxV8WyWKaF7IKQL1oGZC4JxVn9m
         L/G2AhTqyinVjYROYhur7eI3RFlhjrjdkIf2vpYtn4Q9HDdRMvS+Kp7AGb/jVnfbDdXX
         6EGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QWoNV73PMehvx7a/jO/4xAYjEo5H0FOcveRTEMgWVQE=;
        b=jqVCmo3gIcGM2nPh9AJOsSHCboPUzNmDw6f1pF/IgvcFqbC37joGkkjF7QJ7KwX5u2
         Pw2Yb+bfB8mfWCXH9oe0GSb5Av5K3uKn8wjgxRez2B5EY7GNP/ubzJVOAPjfg+7Ft4Ct
         dAxIWVsO4lo+BpA+Dpt14hDAxlk8bc1I3v/FKSknSPeTJyt9S0e0aduSGOsg8sZPVeZy
         isMHW6K39/cxt9OBeD4cVd4Oyj4Twm40ogktmCBeP0CEq8wDasW3sbPb9AuY8VEvMFIU
         zbemfXZ7sITtv9VoJN3bUEvhDnsD/IvvCt0JHNOaa9fF6Cuq0Q/55BxCpNAfLFQWTxE3
         wxGw==
X-Gm-Message-State: ACgBeo1tJ0qX700x9T1gDf1BNeWrzK/X1Khzk24mlUGYeDECZw5pfcGX
        EguVd+ivT4yfk/UQ5F7JaeMOaT2Up+vcbGh6Wbk=
X-Google-Smtp-Source: AA6agR7WPU4b66O7vu9tyKaNZOp/Kj9gJKxujzvrhpRpJW3NmDwGgdtvMkPM+iCHIXWLntV2TZ0n0rgIcJSpVZ6hNVw=
X-Received: by 2002:a50:fe91:0:b0:43d:c97d:1b93 with SMTP id
 d17-20020a50fe91000000b0043dc97d1b93mr11855157edt.67.1659526357473; Wed, 03
 Aug 2022 04:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-4-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-4-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:32:01 +0200
Message-ID: <CAHp75VeBzKW16ncVw+_BqmBkwg=B-Uk7+UiuXko8ymiEN08kzg@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 3/9] pinctrl: ocelot: allow pinctrl-ocelot to be
 loaded as a module
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
> Work is being done to allow external control of Ocelot chips. When pinctrl
> drivers are used internally, it wouldn't make much sense to allow them to
> be loaded as modules. In the case where the Ocelot chip is controlled
> externally, this scenario becomes practical.

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
>  drivers/pinctrl/Kconfig          | 7 ++++++-
>  drivers/pinctrl/pinctrl-ocelot.c | 6 +++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index f52960d2dfbe..ba48ff8be6e2 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
>           LED controller.
>
>  config PINCTRL_OCELOT
> -       bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
> +       tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
>         depends on OF
>         depends on HAS_IOMEM
>         select GPIOLIB
> @@ -321,6 +321,11 @@ config PINCTRL_OCELOT
>         select GENERIC_PINMUX_FUNCTIONS
>         select OF_GPIO
>         select REGMAP_MMIO
> +       help
> +         Support for the internal GPIO interfaces on Microsemi Ocelot and
> +         Jaguar2 SoCs.
> +
> +         If conpiled as a module, the module name will be pinctrl-ocelot.
>
>  config PINCTRL_OXNAS
>         bool
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index 5f4a8c5c6650..d18047d2306d 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -1889,6 +1889,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
>         { .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
>         {},
>  };
> +MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
>
>  static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
>  {
> @@ -1984,4 +1985,7 @@ static struct platform_driver ocelot_pinctrl_driver = {
>         },
>         .probe = ocelot_pinctrl_probe,
>  };
> -builtin_platform_driver(ocelot_pinctrl_driver);
> +module_platform_driver(ocelot_pinctrl_driver);
> +
> +MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
> +MODULE_LICENSE("Dual MIT/GPL");
> --
> 2.25.1
>


-- 
With Best Regards,
Andy Shevchenko
