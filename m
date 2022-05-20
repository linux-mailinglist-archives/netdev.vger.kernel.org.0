Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6189052EAD7
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 13:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243408AbiETLb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 07:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348547AbiETLbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 07:31:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60643587F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:31:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id jx22so1602055ejb.12
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 04:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0NvptFqrj7j0InVdvvMmgqzBzN84J9LRB794rQxkFdY=;
        b=re4Sm8tWAvFHp6bKgAYMf09Z79Kgi3OEdhOIiBZ7/Rn2QXbgu5Ly14y4/nQN7Y/aTo
         VlgbB9yG7Rlr2cuoabCyBxc2bGDLVKK0lXBLnASl6zsHCcOeA+1KzIBeqFsR+y75i5XZ
         XvFFiPa9GJ2QyyaAdSmJuFi5RyYukwsFD78F77Gu/KxBhoXO8QeL/xhxXqgh8n2pVQ16
         5uSsdoWXuRrwj+2ip8smJzRExeR9DRqgQ7nZOdTto/19ei6AXbORk/Mx4Jr1TH0FheIZ
         Rjk53cTk2OReyJUGfCv97XHsZ5d+q5q5c0jA2xxlOnKUomCD8mRuslxc9zsWStq2ZrCv
         ptCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NvptFqrj7j0InVdvvMmgqzBzN84J9LRB794rQxkFdY=;
        b=l1/2aXdDsK19p9bKh/m2WdU6Za6m0P+nkylYwiOuSpjYn68pyba1eTUfRxBjDyNwju
         doN+pDyg/pM36DlGaJS4GtgdlZmUMRvUcqUnz6VgiAJbidrDXgBqiiUobX5TFvVeqh8y
         ivJ63SCdBDBXFZNmL5P0uhaMeTLcrP2m3nk4q/Ug6767SzoWXIcktdvAeWvwKY369skz
         nSqSeybXhJLURUhUOoI9NQbv+lZgon5TAr/gKCRyF5ZuvDpmY4Y6oObM8Ku43FZfcmF0
         4Zqd4XiE5SOWog6ErSbQ/mv+URhVDSDInueklCyIUl5dKvVJDwUX99wFUWaEWSq//HOm
         jdkg==
X-Gm-Message-State: AOAM5316WW9dSeuSVUy6qbQu0PrDFfR52N4RDbRJuhWxQ/s3zb4d9+DT
        vd/Hrd37VKDxlysk8l/cOQckr42Fe1YluGfNm/WWdQ==
X-Google-Smtp-Source: ABdhPJyAADo7d4aXCmDNCVnTVXprJXf99iw8JPsCwtJN6tP2yH5Av5Yx22hVAD/QFIma8grUrwXZC/mCf6Av3T8PJbw=
X-Received: by 2002:a17:907:6eab:b0:6fe:b5e2:7b0e with SMTP id
 sh43-20020a1709076eab00b006feb5e27b0emr1053811ejc.736.1653046309443; Fri, 20
 May 2022 04:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220519211411.2200720-1-robh@kernel.org>
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Fri, 20 May 2022 13:31:38 +0200
Message-ID: <CAMRc=McjvTE27BMbN-_W+Fdd7CJcswZQYsB-4N8cj=WfAQ9QOQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        chrome-platform@lists.linux.dev,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-pci@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 11:14 PM Rob Herring <robh@kernel.org> wrote:
>
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
>
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../arm/hisilicon/controller/hip04-bootwrapper.yaml       | 5 +++--
>  .../bindings/display/bridge/toshiba,tc358768.yaml         | 1 +
>  .../devicetree/bindings/display/panel/panel-timing.yaml   | 5 +++++
>  .../bindings/display/panel/raydium,rm67191.yaml           | 1 +
>  .../bindings/display/panel/samsung,s6e8aa0.yaml           | 1 +
>  .../devicetree/bindings/gpio/fairchild,74hc595.yaml       | 1 +
>  .../devicetree/bindings/input/google,cros-ec-keyb.yaml    | 1 +
>  .../devicetree/bindings/input/matrix-keymap.yaml          | 4 ++++
>  Documentation/devicetree/bindings/media/i2c/adv7604.yaml  | 3 ++-
>  Documentation/devicetree/bindings/mux/reg-mux.yaml        | 8 ++++++--
>  Documentation/devicetree/bindings/net/cdns,macb.yaml      | 1 +
>  Documentation/devicetree/bindings/net/ingenic,mac.yaml    | 1 +
>  .../devicetree/bindings/net/ti,davinci-mdio.yaml          | 1 +
>  .../devicetree/bindings/net/wireless/ti,wlcore.yaml       | 2 ++
>  .../devicetree/bindings/pci/snps,dw-pcie-ep.yaml          | 6 ++++--
>  Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml   | 2 ++
>  .../devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml    | 2 ++
>  Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml | 1 +
>  .../devicetree/bindings/power/supply/battery.yaml         | 7 ++++++-
>  .../devicetree/bindings/power/supply/charger-manager.yaml | 1 +
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml   | 1 +
>  Documentation/devicetree/bindings/serial/8250.yaml        | 1 +
>  .../devicetree/bindings/sound/audio-graph-card2.yaml      | 3 +++
>  .../devicetree/bindings/sound/imx-audio-hdmi.yaml         | 3 +++
>  Documentation/devicetree/bindings/usb/smsc,usb3503.yaml   | 1 +
>  25 files changed, 55 insertions(+), 8 deletions(-)
>

For GPIO:

Acked-by: Bartosz Golaszewski <brgl@bgdev.pl>
