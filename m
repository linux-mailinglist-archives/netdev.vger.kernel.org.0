Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94AA55E3C4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbiF1MvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240685AbiF1MvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:51:14 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D50228E12;
        Tue, 28 Jun 2022 05:51:13 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3176b6ed923so115539847b3.11;
        Tue, 28 Jun 2022 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CH4Pyqj8qPmLBBURKSPKNXwIf78EfOj9Be5JNsbd8XM=;
        b=deAEahjwrHbwfkQvJGhjE6repNNVh4eFNXQleZTBkNEFCYFe2wVgqh1M4cYNsVB3+T
         qw8/tmDv3eOW2gHe+FpDVnMYKHcybPPA2wuXoA0aW/13r7EOmfY0I/V3WgAVGZiMs5h8
         Q/6Z78eUd49B2FWnfOlyxXLWaJSf7zcayPGwzab8lM8i44AR/7S8yDVxUzH/IXuCOw57
         WWdfxd6yPc39eHwWlD1zMnXnPBLEW8ZwhrinOn/H4hAXHsw0iUDy2NhGDlcMmj9XNSe+
         JxDlXTjbPKy0CrPhD4f462cdPEWyDnbXGnb33QLaBAXeYzshiGSBvXUjhjYupzBjgMoH
         nPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CH4Pyqj8qPmLBBURKSPKNXwIf78EfOj9Be5JNsbd8XM=;
        b=U1yJRJiCcT+w8QAwBep8P6hLQkX4AzG4E3YoHaI0hnVlkvBGOF9YvgSSROjWAuNUEv
         DL2EtSbOvrAaYVxYkSwxcpJDOyg8de3K1XxdLBd69iQQUUj5xA0lu7MWU91PDvFOX/N2
         QQHTDjSh/72HQ2uYutpFLr3SWexvDXrIUm7yuRsQj+s+D3azMqviYxI1x7z0fyWPeqgn
         /wtAYDPlH1MLJQWP1h9W5bH5IIr7VOMHGNO4U22Eo8MA8LE86VDvjrlPgKpOgNmUNO3v
         EmBnIAcGfvRj2uENTBmCDuR5GFwm5Tc/XPMPYfigwYkKJKT3l5DuiEhnex3c6vMo/tYS
         GJZQ==
X-Gm-Message-State: AJIora9cxoCTeBJQc0pX0eiuCbJE18CHqU2rPmrpBE7lPxZssazLP9GT
        K1zcRZ53373top90iSYgXVrFEVSgNkLu3vtCg2k=
X-Google-Smtp-Source: AGRyM1u78nzO/495LmpCbD3jzYw8jhD6TT86tdZOiYA5F6G7CuTbiqjb1VQ4pyl5h5lxl4EKmsU9zWLtaaOs2RwWTbM=
X-Received: by 2002:a81:468b:0:b0:318:4cac:6576 with SMTP id
 t133-20020a81468b000000b003184cac6576mr20543609ywa.277.1656420672775; Tue, 28
 Jun 2022 05:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com> <20220628081709.829811-2-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-2-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jun 2022 14:50:36 +0200
Message-ID: <CAHp75VevH4LODkF4AELH=E5tQRZZ8LjbWN62sA14PydLMeDRgA@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap
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
        Terry Bowman <terry.bowman@amd.com>
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

On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
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

> +       regs = devm_platform_get_and_ioremap_resource(pdev, index, &res);
> +
> +       if (!res)
> +               return ERR_PTR(-ENOENT);

This needs a comment why the original error code from devm_ call above
is not good here.

> +       else if (IS_ERR(regs))
> +               return ERR_CAST(regs);
> +       else
> +               return devm_regmap_init_mmio(&pdev->dev, regs, config);
> +}

'else' is redundant in all cases above.

-- 
With Best Regards,
Andy Shevchenko
