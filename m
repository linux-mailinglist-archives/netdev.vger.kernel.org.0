Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50E55E3D7
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbiF1Mya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344839AbiF1My3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:54:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9BE2ED50;
        Tue, 28 Jun 2022 05:54:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r3so22057778ybr.6;
        Tue, 28 Jun 2022 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZb5sxIAZyqFSeUBv72kgXWLJxxiCuneWjOYk6qMHvY=;
        b=YvPNpQebc6BcmR/vGLnXDgkroOA6+J62fZMmhhY6q+2Ykw4RrJublEEIDd8uAe5I22
         Ggov82QkKumtxAypvS+UavkS+gQFZc/mrF2RqQZMNZlHt/td61LiMeXcF6dbkLp3DQ9L
         YkxPEd1PGjy7+t/kBLdb+N0wBDELJtb46QsTMmmdjqTuCUZ7BlOT4KTWT9pFzX66kjtB
         2oTraQwVU0buyQPwn//tADDBhtPxrGfpFuF6OvqbkVgjnf1DEsmIn+Husl0XGXSEYXW2
         0Eaoxf5egrtRQzzjSQYM1snzrhJMpV2fZ3SSmmhRAlHJTiMifBKJ3JJjFtWwZKLB0XTi
         yqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZb5sxIAZyqFSeUBv72kgXWLJxxiCuneWjOYk6qMHvY=;
        b=fv8DbvEM+ZaKkQVsU9cLW6nZDLzYVzdB+QGuyWpjIkUxYNn7+2tC2l0Li3ikGTbmBd
         f6Lsb4fqGcR8mlCCswkdf7a3Ki4QEUvItkFWj8MdIHnwyzZs8MxqayP0Wkv/Wr5TvzM6
         XVU/MDZ0wMMAdkuMzuwbg44e5np4g8n8sPLdRqNiEfcM0WEWJKt6UP7ILV0PYSOqWpmE
         v5h1TXeQv8mZ7zfQAIm69jTmvwGLSdyi4ozBz+CINnZC4KSoaTjfeUkKz5UyCuCKKWpK
         CCsN7DOrmm91fpfadhxoWD5bSJ8Gl58FKignytghlCKXaUxpDav8m0sDKKz9m+0AVt/X
         YYaQ==
X-Gm-Message-State: AJIora/2KIGdmHe61nnkFv3eerh0OS09BAjSsyRkFXmzezW2kp/zgyYb
        FkbEqZ8bSKwBq1gGF6XGZKa+T6FLYCuB8RmV/Ww=
X-Google-Smtp-Source: AGRyM1sWVHglhFy7q5w7V1jVc/Uf/+16scjXoUL/hiTXrXPSn54TrxGXrl8OmIW82bw/30sHpyojpqwJNqO8Bo7e7q4=
X-Received: by 2002:a05:6902:1142:b0:669:651:1bd4 with SMTP id
 p2-20020a056902114200b0066906511bd4mr19379795ybu.385.1656420867977; Tue, 28
 Jun 2022 05:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220628081709.829811-1-colin.foster@in-advantage.com> <20220628081709.829811-4-colin.foster@in-advantage.com>
In-Reply-To: <20220628081709.829811-4-colin.foster@in-advantage.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jun 2022 14:53:49 +0200
Message-ID: <CAHp75Vcm=Zopv2CZZFWwqgxQ_g8XqNRZB6zEcX3F4BhmcPGxFA@mail.gmail.com>
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

On Tue, Jun 28, 2022 at 10:17 AM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> Work is being done to allow external control of Ocelot chips. When pinctrl
> drivers are used internally, it wouldn't make much sense to allow them to
> be loaded as modules. In the case where the Ocelot chip is controlled
> externally, this scenario becomes practical.

...

>  builtin_platform_driver(ocelot_pinctrl_driver);

This contradicts the logic behind this change. Perhaps you need to
move to module_platform_driver(). (Yes, I think functionally it won't
be any changes if ->remove() is not needed, but for the sake of
logical correctness...)

-- 
With Best Regards,
Andy Shevchenko
