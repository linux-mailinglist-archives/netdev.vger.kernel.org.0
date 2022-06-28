Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3655ED7C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiF1TET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiF1TBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:01:17 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDF3CE18;
        Tue, 28 Jun 2022 12:00:47 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v38so13098560ybi.3;
        Tue, 28 Jun 2022 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfrZZUEEnusraqTcoBwljzuTX+gSwEEKqtBGfjRQA5s=;
        b=Fjr1Ac23mV/gAq32rtrGhHFbiAtx7Z/rqECiXYYFvDabBSHfwkresVl4zV4BHJdgXL
         BLMyCajzhrK84VdRjqrhOtDnZm4/X8iuNxXeTJm1qsWD3joGoa7VoiTCktl2aFuvDG/8
         1IJjrLsSBbKE2raRCPJeTs34T93kFvT1Ay+raFqYsBhz1GM2+5erS+hp1ZL6N8oesb0q
         E5NoJKh3QOGwmAOUBKnnrnfPWFopo7ls7rzGsOQCloKeaMn5R9ROtlECpO87RRCKd0ma
         Kng+5H0c53E1HoHKIv3FYgHdYWWHBYjYsZg8D9i16tPHAOzzS4rXP4i9w7zDLvRSzZ6Y
         8yFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfrZZUEEnusraqTcoBwljzuTX+gSwEEKqtBGfjRQA5s=;
        b=Yy43Qu9RGoPdubg8DX4YjoS6+LJz7D5mJQjysek5bQtKD/L+HCKs0l9810tXyEXPlK
         7SzBVvrKRXNpknx/YqRZW/JmXhSrCeCG/W7Fwc9RLn1uMLT4RCpZXIYxu5DHxBeos7a/
         VFuDoUoujyNhV2sPvC1OjB0H0JBwlsEBP+1HsZUtPBuLbSZBnVRqLM6+ZJSyZ72U3w3/
         UJSHIvs8Ej6EN6YtgBADqDyIprhD1ldbK4qVnAqBSKGUkLjp1gMGSkY+84ubmlSsiU4G
         YDwYgVOLVbZUCgttyxtAllyz3YSyPmNHrwGhsBWZMuZvbKIO9PGGcJ0v4eK2zuR66fx7
         WIgQ==
X-Gm-Message-State: AJIora/zTnXKQ1PszPiF4gniNVy0DpHoO9ES4Dhxf6CKKXoLXbTlc/6G
        l8mLjR/Oi3UrdRWalDDhdtL4GLn7Ul5jFJP8jM8=
X-Google-Smtp-Source: AGRyM1ubmnldUYfOH5scD10FhmXU1zZDYRVh2ucvLL7Z7EYE8yjowr6ydYCwm+ayjB00+OKR6o9rr9MjILNWmBIOCbg=
X-Received: by 2002:a25:dd83:0:b0:66c:8d8d:4f5f with SMTP id
 u125-20020a25dd83000000b0066c8d8d4f5fmr19106724ybg.79.1656442846932; Tue, 28
 Jun 2022 12:00:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
 <20220628081709.829811-4-colin.foster@in-advantage.com> <CAHp75Vcm=Zopv2CZZFWwqgxQ_g8XqNRZB6zEcX3F4BhmcPGxFA@mail.gmail.com>
 <20220628182535.GC855398@euler>
In-Reply-To: <20220628182535.GC855398@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jun 2022 21:00:06 +0200
Message-ID: <CAHp75VejZB8Wg4tuz51r1ezLw0vawP+LNcYkmHd5FjyQTW4asA@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 3/9] pinctrl: ocelot: allow pinctrl-ocelot to
 be loaded as a module
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

On Tue, Jun 28, 2022 at 8:25 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
> On Tue, Jun 28, 2022 at 02:53:49PM +0200, Andy Shevchenko wrote:
> > On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
> > <colin.foster@in-advantage.com> wrote:

...

> > >  builtin_platform_driver(ocelot_pinctrl_driver);
> >
> > This contradicts the logic behind this change. Perhaps you need to
> > move to module_platform_driver(). (Yes, I think functionally it won't
> > be any changes if ->remove() is not needed, but for the sake of
> > logical correctness...)
>
> I'll do this. Thanks.
>
> Process question: If I make this change is it typical to remove all
> Reviewed-By tags? I assume "yes"

I would not. This change is logical continuation and I truly believe
every reviewer will agree on it.

-- 
With Best Regards,
Andy Shevchenko
