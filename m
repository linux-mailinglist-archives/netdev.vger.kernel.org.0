Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1645350AA
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343888AbiEZObv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiEZObr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:31:47 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90691145F
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:31:46 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id x137so3179935ybg.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 07:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sbL61ctw82P2A4WPRzF6tE5aFrqygXMPVbMeO/7loWs=;
        b=Aa/xpxJfUJEtkPC2P6B5K+jNu93PEtR9INvuitdtSZej0KWZYz+uYRLw6bXJIK6fmD
         dckEtHXGA7gHkWbOwQ1Z31cNEpuzO05Y734nIpY5OSylET/vEq1BrytLYuj64kFsaXvz
         HMGVnvd5T75eRKOVebEF/b+xD4nT8bSLGkHPUsSPUOFX4NFqBZvX2IV5qx+HY3lBZ33o
         0PbGM0m+dfyZJvug00qOwo2FJQ3NObMXBckreZoWqjTO4S282+CKv7JjRrh3eXqvuedC
         l8L1AOBcKNnPZXcn5nft92sOXO1oa7dpzsaa84ckFLIfNKCUI0a9SZONaPw0lRzyzuJ4
         g/yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sbL61ctw82P2A4WPRzF6tE5aFrqygXMPVbMeO/7loWs=;
        b=s13DwXNUDi+na7iWqWHhgYCfjnS+1OZi9VBjbCRK1qKeGIksf3vS/DBjdrsenirXNr
         7IL0BlDqrzAGDnUeWYMSPG0qcS7Tpb5EyyPWD2xWqcyEimjXXI4pXfTRZpckvuWifhBA
         WbAuUmToUXH4BML+x5+SsH3krADWmQQc3wjs91ZYuo0F03Uc2ZVxtfFJKvQZ3/VkL59v
         DvQC0EGwlV3FTxGobDwzkQ6ZE4ah9Eh2/om+5FBRlXdkNYa3XRnAIrmNKwN/3lzGuyly
         a6+DCR3woFMzuAp5to77oLj80+nS8jPECTD+cEWBpV6nVnhlbJocgt6VYfLX6tUBB9CZ
         fbCQ==
X-Gm-Message-State: AOAM533TH2oc95dyNiub5LuoxG8EKMdSMUsqsGT5gCxCfgkwrUC646CH
        UPswME5NtnX9fhzaaGjsAUZmKU5hu2diRNACm6KGMA==
X-Google-Smtp-Source: ABdhPJx7gOUCjc2MLJ/GIFd4QOjf/SsPC/dpO5bDtA9KcdYYTVdFSAhYeKnVTXLHvvywMv4Ke/VQvCmCy8e/0FB09YU=
X-Received: by 2002:a5b:691:0:b0:64d:ab44:f12e with SMTP id
 j17-20020a5b0691000000b0064dab44f12emr35458511ybq.533.1653575506073; Thu, 26
 May 2022 07:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220525205752.2484423-1-robh@kernel.org>
In-Reply-To: <20220525205752.2484423-1-robh@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 26 May 2022 16:31:34 +0200
Message-ID: <CACRpkdYyq4rKFFmrx23qabT=XtRZJMhdsN1XOnqLcnczT5ZTMw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml references
To:     Rob Herring <robh@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 10:58 PM Rob Herring <robh@kernel.org> wrote:

> SPI peripheral device bindings need to reference spi-peripheral-props.yaml
> in order to use various SPI controller specific properties. Otherwise,
> the unevaluatedProperties check will reject any controller specific
> properties.
>
> Signed-off-by: Rob Herring <robh@kernel.org>

Very nice!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
