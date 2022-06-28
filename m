Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E855E3E5
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345991AbiF1M4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345249AbiF1M4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:56:05 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7F22F660;
        Tue, 28 Jun 2022 05:56:04 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id r3so22065082ybr.6;
        Tue, 28 Jun 2022 05:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggwF5g1h8Ead4FuQw5zkAX1BhU9Zyqolzn8TdYVGstg=;
        b=KeCLJ5ykrnqYEpWJJO9nXzaPfE5yt0z4Iq/Nje/aq0a043RgdvwLLQV9N99LTC6o66
         neO4UcQYMDBwdFwCXMIaMYvKQxZ6v1pFmZJsxFGltIYh2by2CXKx3NmpbLgaSmEp9iE2
         xXp9GVm1KHZ8TIeaVu1XWRPW1IUGhAmRvk0VSWKgoeogO+AJEtl1dKvTIzv2Br+KO6iH
         uknuFW/Dy88sbBADAhdqNAk/Rr7YAxjywb6zMGIJ/n5LOomZvFrMS5rD5f7UZGZSAmhH
         rg7WjkZtrtjJyayI4yLWQIe4J0IY96As42R+OlnJwepW6Ie/omPO4jukd5ozyg4JMo+i
         bDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggwF5g1h8Ead4FuQw5zkAX1BhU9Zyqolzn8TdYVGstg=;
        b=V10Q+hd9a0gB+/X90e6RGRt65TJLT3TwZS0xWBr2XnPKEwvEiXWO0qJ33VxDOyx+K4
         xWG9IcPlez45YZttfKn/vLthk+mIcRazMzy+tvdQWvIfdM9NDgarLk7GFsRh8ZbWSoMr
         K8tWbPOuedaPBUg8iOnae4U4FdFYDeA/mKAn/JBKNPVW0Qk2IEcicptyzOsUvIjsvp56
         hGdIcDx8kbb7b4drGFa9b+rd9MwY65xX7p32xAHyOZBePiEEzFs7350BfwEPS9OpAXnY
         2FYU5ETLq1/y2fi9W8WQPGHJE62KvE4VJc/yR+yNc0UkEOlJU+pU56nJxun4NDiSYiMQ
         0s9A==
X-Gm-Message-State: AJIora8u2hxeT9N0PfKRBPETtmOu6BgIQOzrY6ZzPSZs3q7UsuHJ6Jyp
        R7TTeF2fvocg+eIkvbYz3LVabgwxEcOg/h5bQZ4=
X-Google-Smtp-Source: AGRyM1tJmBePXIn17WC/ITK/MV0xG89V4LBimXqbrTG2bJTr+PdbMYfS52+jNtpI0qjpMFF1BO0XbyVnla79lsfFCWM=
X-Received: by 2002:a25:b2a8:0:b0:66c:8110:3331 with SMTP id
 k40-20020a25b2a8000000b0066c81103331mr20100404ybj.460.1656420963675; Tue, 28
 Jun 2022 05:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com> <20220628081709.829811-6-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-6-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jun 2022 14:55:23 +0200
Message-ID: <CAHp75VcEcHxExFsdJGYu2FO0YZVOr5dNYPhCTqYNwRrE1wEQZA@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 5/9] pinctrl: microchip-sgpio: allow sgpio
 driver to be used as a module
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
        Florian Fainelli <f.fainelli@gmail.com>
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
> As the commit message suggests, this simply adds the ability to select
> SGPIO pinctrl as a module. This becomes more practical when the SGPIO
> hardware exists on an external chip, controlled indirectly by I2C or SPI.
> This commit enables that level of control.

...

>  builtin_platform_driver(microchip_sgpio_pinctrl_driver);

As per one of the previous patches. And repetitive if needed.

-- 
With Best Regards,
Andy Shevchenko
