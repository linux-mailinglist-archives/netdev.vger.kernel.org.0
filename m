Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4D663923B
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKYXdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKYXdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:33:09 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730771F2F1;
        Fri, 25 Nov 2022 15:33:07 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z18so8149929edb.9;
        Fri, 25 Nov 2022 15:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ul41aLivPpoStmBIkSe3PwxjiFmKEfN8civiUwQkxa0=;
        b=TsTP7xsKiWaL4D0DEw5NERyXETDLlo76uN/V9q+MEzuJornm/EOwKNzZhQq73S9955
         o8QCJhKYktAb++vUDJVobm7vqLP487mpTmUv5onvf0U9k7xDb1mZmMMmB4LH9Q0LuHDE
         eN2XwwIwocdxmZgm3YZGIIQt7kbNoQe0LIyIPk7B4vsvRs+vSgqORcDt/P+hjTxKeBtA
         lvPrf+XjMkFNPwZNHHNLysXxG3Nn8CZp9A/B0ZxbbSPuVCbKxpdxpmY3taLw27V4g7uT
         tqa0ulf6ccJUIzp8j7nHUHCqmkMiUcWnbIkpzrx5DON5WiCnhXQv1E52fFDeGGn8I5qE
         dcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ul41aLivPpoStmBIkSe3PwxjiFmKEfN8civiUwQkxa0=;
        b=nSbgdqYKKqNxiGRo8xR7FxwBfcu47+o9PqeWGgUZSdTX5HjQVgUEDEgPvsj3lAqAjw
         bTEr/CjljTOOEkXxVV22IM1/qfgqf9vn56qvlbfRX8ZqOfz/wcoxqXAdqTw1t57MYWZU
         kp0+i5KC5EVa7o6Zl0QQ8sPTBJPWppIAFZBqvQayTK2eH+6pfPhLXdlZ/Ep4rhVz+P5U
         83aD1N5uuNVLlnOXAUZfUAF5hwEqxz+5jKjoJJNXrpQiWVjA9rgVjgTWMcpJfcD1QHq4
         EpN1LwRj4R+HJalTMVYHKyQmMrdNb5j9h+66QUn3vPmXeHGaS/by7WxI3RrFMdaim7oX
         Wp4g==
X-Gm-Message-State: ANoB5pm2y91DfeJuEoulnBIoSz/bio4xILUEE0S49tOwJf56zysJa9vo
        QvZJpzjaxr5/KsdGES5b8wZB/rKQ57ec3T5sqPA=
X-Google-Smtp-Source: AA0mqf5un8E+VJYr8xkakEy/VtUbHh82LR9urvSYcLJYttWK02ci8Lrk7k46XZMqWxXRiTAywc/PrXQ5qe1vMXdN+kw=
X-Received: by 2002:a05:6402:2404:b0:467:67e1:ca61 with SMTP id
 t4-20020a056402240400b0046767e1ca61mr4218659eda.27.1669419186903; Fri, 25 Nov
 2022 15:33:06 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:32:55 +0100
Message-ID: <CAFBinCDNqyb+AydSyN19ddJsUMo3RXKVJh=8sZgy3nYEc+vcxQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Eric Dumazet <edumazet@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
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

Hi Neil,

On Fri, Nov 18, 2022 at 3:33 PM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
[...]
> +unevaluatedProperties: false
Could you please also add an "interrupts" property?
This watchdog IP can generate an interrupt instead of resetting the
SoC. We don't support this in the driver yet, but still it's w
Somehow the interrupt made it into the .dtsi but not the bindings.

[...]
> -- compatible : depending on the SoC this should be one of:
> -       "amlogic,meson6-wdt" on Meson6 SoCs
> -       "amlogic,meson8-wdt" and "amlogic,meson6-wdt" on Meson8 SoCs
> -       "amlogic,meson8b-wdt" on Meson8b SoCs
> -       "amlogic,meson8m2-wdt" and "amlogic,meson8b-wdt" on Meson8m2 SoCs
The last part did not quite make it into the new schema.
arch/arm/boot/dts/meson8m2.dtsi currently has:
  compatible = "amlogic,meson8m2-wdt", "amlogic,meson8b-wdt";


Best regards,
Martin
