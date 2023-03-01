Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1D56A6EBE
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCAOqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 09:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjCAOqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 09:46:09 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27B043934
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 06:45:39 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-53852143afcso368707197b3.3
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 06:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c5fRwh/q88qnR4rLODR5aN06oeaTsbFFIXqxWtKoAdA=;
        b=Skkgc1pJVdMg4lM3S/QvC70xPPr5jlTmvz4EOn+Pc6rF3VpQhVc4iGugen9Q06wzaW
         YU5vBuwqleOCYoFdAyxRZHQORMrJn2alOT/fjacfQLA291X6YhVykyxziMNBllMvYuaY
         rKWSJgX2G7dhiWsfoI33lKF5ZUW3nVjhcxCb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c5fRwh/q88qnR4rLODR5aN06oeaTsbFFIXqxWtKoAdA=;
        b=7N8Or/dZTPxlHPrjTVC4lOn6UxHkFQoyC+490vVHJk1cSi2E8pWJCR5Hbl9Oxspll0
         5jHRlRe8YsMSqwj8L/w/kmhHeEz5Y6ElU+UNjKrbaPRjBC+pMCJ/7zoCXe3XyutlJKJ0
         bG/m772IDjOAqMD8HJQZt2zHxmqASKZj4CFW18do4NB3hgk0AezWLyMapb4O1J3mItGo
         hBml8lMuJ5Vie3t6O5j96SANKbvsvQr1CrPry37bENJP5TSkFPXRkoduTg3zR2coVj6s
         iHFBmj9Hu+74xJaBI/7oX8JXwaAqy2QIaJocQV4jrvrm64H5ADyHjqDt9PxIJy0Oup7k
         L+aA==
X-Gm-Message-State: AO0yUKXwzncDWZ0fDmVtc+49byAIDWEZki2VWytdNnQ3Le46gk5NRITO
        vLPVPp0cBqxYJA4PdDtHxlw55S2HoiB3ka/ppDtccQ==
X-Google-Smtp-Source: AK7set/9RgMm3XRu83JsW4Wbbsi1f43oJuRNJ4GJnMD9Ynj6+QG8QTN/H949zZF90kB3oY5EYLAgq26FWAoCc+/6F5A=
X-Received: by 2002:a81:ae0e:0:b0:53c:7c33:9d25 with SMTP id
 m14-20020a81ae0e000000b0053c7c339d25mr726867ywh.8.1677681938671; Wed, 01 Mar
 2023 06:45:38 -0800 (PST)
MIME-Version: 1.0
References: <20230228215433.3944508-1-robh@kernel.org>
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
From:   Simon Glass <sjg@chromium.org>
Date:   Wed, 1 Mar 2023 07:45:19 -0700
Message-ID: <CAPnjgZ1=UPMf72JjejpdSvss5+d1tnMv=efYUgJcH6T09YAKTw@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Feb 2023 at 14:54, Rob Herring <robh@kernel.org> wrote:
>
> SPI and I2C bus node names are expected to be "spi" or "i2c",
> respectively, with nothing else, a unit-address, or a '-N' index. A
> pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
> cases. Mostly scripted with the following commands:
>
> git grep -l '\si2c[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/i2c[0-9] {/i2c {/'
> git grep -l '\sspi[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/spi[0-9] {/spi {/'
>
> With this, a few errors in examples were exposed and fixed.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Robert Foss <rfoss@kernel.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> ---

Reviewed-by: Simon Glass <sjg@chromium.org>
