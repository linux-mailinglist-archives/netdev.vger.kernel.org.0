Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1719664E4B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjAJVsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjAJVsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:48:45 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB375BA1E;
        Tue, 10 Jan 2023 13:48:44 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id tz12so32191236ejc.9;
        Tue, 10 Jan 2023 13:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M3b2Vz7EFrY4ZoAZ7zhZDOrT9y3BFK6sS3AzbYrmCT4=;
        b=SbL0sV3pbNJK6Bfyz2VD6czCXh94iQNaxKjXTjpArf+vHkqL2nrS4tK4IMhXZLfjob
         c09q+NtJP7jTDEHqrpo4z+vxiPked3kTWBAamhe6hgWly3pGWP1K2kIFb6xFE1EMHHuA
         W7zBN02N/9NXq5XxJ/cNLh3c3H5r4KcNP2TGEaQlZGQMQVMYxos6BKl4aN9W3LHnQDlo
         uGtcnMyr0/OMndxB8218GOxLOCJBH6euzCMpEExz1HDoJNY47/pGCsIUK7g0mauCBUMm
         nVxzqMQVGuqTMbJEYrlXPc7O60AVGYgvu35Ga9sqHDSFK9Pb5q0iDpNSZZ8SpIE1m8RL
         PTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M3b2Vz7EFrY4ZoAZ7zhZDOrT9y3BFK6sS3AzbYrmCT4=;
        b=fUMh71S66H28vZIRLr3XOsfl1hUdLK7jQExEefa90/maNxxcnsg2umxkOUy/n5GtD3
         M3dRv879gscuiH4j6nhIYW++efFY1fCE4Gj3Uf2emGU4STYvRHtKsWFslsvIKkP64XfM
         r1gTin2au4hefq7I4f5s6f8VvKF4jWcKuONuJhEbAaileqdfkHEMdN21nAKKTXbAya9P
         qjoXWdRC5lcdJG2m68XBUcOSOqRqabBtDftf6+oTAaHa7HQHy1ioAOKXAhv0adtgcHd5
         aiDGTPdzmaYmSDRH2Iwn+eUfOUGjbCgySiG2AuYbTktJS2fei65EZg45jFlybi2SDDye
         /znA==
X-Gm-Message-State: AFqh2kp/8mKR5J4tw7pIM86QkCUZqYig3J+qakrqBK7wPpYieKmBRHpL
        2NUTJx63O+mZ8AUXka7KKgeTrHFUhVJKIsonF+w=
X-Google-Smtp-Source: AMrXdXvZWTCfsyyAyIXqF03H40iDiOq0blSYlASCBEmUrGVmKB7QN5KAlN7UDroP7DZCIIDm9TmpeUqouJfNZE/s2tk=
X-Received: by 2002:a17:906:e4f:b0:7c0:ae1c:3eb7 with SMTP id
 q15-20020a1709060e4f00b007c0ae1c3eb7mr4388606eji.510.1673387322980; Tue, 10
 Jan 2023 13:48:42 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v2-4-36ad050bb625@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-4-36ad050bb625@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 10 Jan 2023 22:48:32 +0100
Message-ID: <CAFBinCDd1MJEmSHR1XPsfBoRasBq+cV1F+66sCBXALtCCmoyUA@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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

On Mon, Jan 9, 2023 at 1:53 PM Neil Armstrong <neil.armstrong@linaro.org> wrote:
[...]
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - amlogic,meson6-wdt
> +          - amlogic,meson8-wdt
Technically this is not an identical representation of what we had
before which was:
-       "amlogic,meson8-wdt" and "amlogic,meson6-wdt" on Meson8 SoCs

We're not using the "amlogic,meson8-wdt" compatible anywhere at the moment.
In the meson_wdt driver it's defined with the same per-SoC data as
"amlogic,meson6-wdt".

Long story short: In my opinion there's no need to change what you
have right now.
If you have to re-spin this then maybe you can add a note to the patch
description.
Please add my:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>


Best regards,
Martin
