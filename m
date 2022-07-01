Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8200A563AFA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiGAUYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiGAUYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:24:16 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAB32ED5B;
        Fri,  1 Jul 2022 13:24:13 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 205so3467617ybe.3;
        Fri, 01 Jul 2022 13:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MRsD2vJA8bDPtwGkMOr5/5qFkYCaN1HrNYJP8Aooaw=;
        b=MRMpkkkXd/AxaYKSqzVZ+JHGaNVydSScCwxeeTHy7nH9KnkQVHPCiFczxXqDZ++Eou
         oVPL5T2xx4TJ6WrEVruW23jgn5i0TbeLnhYhbNHWvJ/WJyf7ev8SxZF2YbGAfdUj2bqR
         BNRaRznaCwOa3BaYlKZi1g5WgSO4/Zg0olrORzny6nh9qIbQkP1FZTOltjqjit/0/vUF
         sbk8BerO6Qd9qJj9xpU62MQ5wpEivT03M+gjvTjP0AdvLDgncvTpscUSJsa7ULEq+aKc
         glVbZ9ngxZixwRW1/pJd4TNQON1BiMrb4owcn1YR3jIn8IJFW+EUDYQmgPdBlky6fwIs
         93/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MRsD2vJA8bDPtwGkMOr5/5qFkYCaN1HrNYJP8Aooaw=;
        b=FfyIZFlG3h28qdvwFuWaM1KzACweZp8PyTE7063p9+3F9Fy+txjx3YH2QCxzAeHyrD
         Bir+V+HbHb2DCzVe03/BJ7uNxpQQHn8W8OZtazrL1Ob6MGwmZvk4aojZynUJgBBkiUyH
         AD4DWsGG1CQKR0lMhLMqb/85PChuCq/6VvUovbA4hb5GCxCTHxn8gSqRKjVKhA5MFz2p
         ZsljI1KABvIzKGdTOYVkR11oR78x5R2lAfSKcpNK8T5cIIiRL2gsLsso3zCCEGP5Cam1
         BdMpjRqG+O1HuTa1GZ+2gPTYBnBt+UG6R8U8K70y6lzhyqJX5TflZz4VEyec3UcvrnP7
         qXmg==
X-Gm-Message-State: AJIora8P72FZszn/0raMeO5JMO68YLVzTYq/lwE7+PiWNfidsaVSl1VK
        1M2iMzlqxj12vg4sd6PzquXCpDTKYWSriI2rP2c=
X-Google-Smtp-Source: AGRyM1vq5LZzi17RwsZX1h8W1o/LdR7lMKPEJ+/xA1ayuCIn2yWQfXjsi0iDyG5el8EluNbqyOSP9Fylvctdu7Yr1Ss=
X-Received: by 2002:a05:6902:c4:b0:64b:4677:331b with SMTP id
 i4-20020a05690200c400b0064b4677331bmr17139233ybs.93.1656707052779; Fri, 01
 Jul 2022 13:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220701192609.3970317-1-colin.foster@in-advantage.com> <20220701192609.3970317-2-colin.foster@in-advantage.com>
In-Reply-To: <20220701192609.3970317-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 22:23:36 +0200
Message-ID: <CAHp75Vf0FPrUPK8F=9gMuZPUsuTbSO+AB3zfh1=uAKu6L2eemA@mail.gmail.com>
Subject: Re: [PATCH v12 net-next 1/9] mfd: ocelot: add helper to get regmap
 from a resource
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        katie.morris@in-advantage.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 9:26 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource and
> devm_regmap_init_mmio.
>
> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
>
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.

...

> +       res = platform_get_resource(pdev, IORESOURCE_MEM, index);
> +       if (res) {
> +               regs = devm_ioremap_resource(dev, res);
> +               if (IS_ERR(regs))
> +                       return ERR_CAST(regs);

Why can't it be devm_platform_get_and_ioremap_resource() here?

  regs = devm_platform_get_and_ioremap_resource();
  if (res) {
    if (IS_ERR(regs))
      return ERR_CAST();
   return ...
  }

> +               return devm_regmap_init_mmio(dev, regs, config);
> +       }

...

> +       return (map) ? map : ERR_PTR(-ENOENT);

Too many parentheses.

Also you may use short form of ternary operator:

       return map ?: ERR_PTR(-ENOENT);

-- 
With Best Regards,
Andy Shevchenko
