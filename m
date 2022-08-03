Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC89F588B7D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 13:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiHCLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237770AbiHCLpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 07:45:43 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D535A6424;
        Wed,  3 Aug 2022 04:45:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id s11so9703275edd.13;
        Wed, 03 Aug 2022 04:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=MggySC/34v95u8horOX4fhvIDiILlutWGFAft8N/YGI=;
        b=IPDZD57KsnEyGS89rvUheSefbJXYPUJtoK0CSwXMzK58XhRxzE0DTIn7+JFvINSI42
         jVUqGGST4/ZH9dmw39dr18oGorZ6giy5XSFBsIQ/JdDOYwgPg+47AO9lxfreDrhgOgi/
         oZZNp7Do5VMiajL2NbDBOHfgGHnajgYfcyrDDpE2jZ45WTooSZuuGwT9pa4T7tx6f9qb
         iCrMkpNOtQmMP4zBRJO8WZ0mENu4ggXupks4zmuysNM3ESrWA3HMMAsynmaMcb/8AuBW
         TIICi+nukWmR4MQNbyPlsuz5Id/S/nk2VKDtYFJC0lAz3YTfm1mSIOojI+ewch+yqkCw
         qZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=MggySC/34v95u8horOX4fhvIDiILlutWGFAft8N/YGI=;
        b=5nef6sVwte4YcmFmJ6JC8VdiMmYCEsznW6QbprG53Y2eypOPamTwBlKnr9Pb2opN4S
         gMYfzvpkh8mGY3SBReGTq+xU/1wK7/v8wS61f5NmfxLNTu2o3u8Vf8kiEIpWPuMQxXFd
         SX/PXEnu6P+Qs4QmKyTOZljTmV4vkugkTHhhQW6CEWheNKsIE+uAwbY+9p5AyIoM5CFI
         KqG3PWXb/PrH5YEUNCIiZuLWxmbVabEonbBGsFhb9yLyAkwIuH4bNOjgCbvo/Sb54Ldx
         +js96vY3MmVsWwCRviwc+JvUmthfPtUKBwfI3WXAMcdNoEeXPtJP64ocpq47dBxDJO4/
         FMGg==
X-Gm-Message-State: AJIora8Mo27HOfoTBh99ouOVd3GGDdUot1GfTOKALuVM9t/MMZ+xs895
        7fBKXy+qfFExmiD77FCaWe97D0BFiHfp8596JDo=
X-Google-Smtp-Source: AGRyM1v7s7fz6oebaJ8pxEnZ0Q7zm/d6bh8Ibd2cO+NgXJ6+7jUajtV6ZmbKtT/fbWSl3XVTzS4m2hKPgncfjm6Vu3M=
X-Received: by 2002:a05:6402:280b:b0:43b:5d75:fcfa with SMTP id
 h11-20020a056402280b00b0043b5d75fcfamr24735742ede.114.1659527141436; Wed, 03
 Aug 2022 04:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com> <20220803054728.1541104-10-colin.foster@in-advantage.com>
In-Reply-To: <20220803054728.1541104-10-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Aug 2022 13:45:04 +0200
Message-ID: <CAHp75Vc30VW_dYGodyw4mrMwFgTVyDFaMP2ZJXQEB2nFOB2RWw@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
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
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
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

On Wed, Aug 3, 2022 at 7:48 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> The VSC7512 is a networking chip that contains several peripherals. Many of
> these peripherals are currently supported by the VSC7513 and VSC7514 chips,
> but those run on an internal CPU. The VSC7512 lacks this CPU, and must be
> controlled externally.
>
> Utilize the existing drivers by referencing the chip as an MFD. Add support
> for the two MDIO buses, the internal phys, pinctrl, and serial GPIO.


...

> +#include <asm/byteorder.h>

Not sure I see the user of this header.

...

> +struct regmap *ocelot_spi_init_regmap(struct device *dev, const struct resource *res)
> +{
> +       struct regmap_config regmap_config;
> +
> +       memcpy(&regmap_config, &ocelot_spi_regmap_config, sizeof(regmap_config));
> +
> +       regmap_config.name = res->name;

> +       regmap_config.max_register = res->end - res->start;

Hmm... First of all, resource_size() is for that (with - 1 to the
result). But don't you need to use stride in the calculations?

> +       regmap_config.reg_base = res->start;
> +
> +       return devm_regmap_init(dev, &ocelot_spi_regmap_bus, dev, &regmap_config);
> +}

-- 
With Best Regards,
Andy Shevchenko
