Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404D5639243
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiKYXgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKYXgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:36:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B4C218A8;
        Fri, 25 Nov 2022 15:36:47 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ha10so13324818ejb.3;
        Fri, 25 Nov 2022 15:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=53pASLo6U2zzYHdiGPJru2sei7EMeIsybEcbugHJMGw=;
        b=aNmO4iy1jEBOxe4hLQffwUBwh9RXL7ogbj5yuKyKDk+Xzpa9rmxmLXt65tfNv5wpIX
         zCIgP3UXxPHLUlvesV043w+pnVAvv6aeeguf3WSjGGxzBGh+aGFCYvAO2eYViSso1InR
         eOGZh6VgaeO+Dmvu0OMjrZ0zg4rQqCRarVo3050M4z3zqJJCa0+ynj6CUT3S+u+xB6b0
         vn0mNPQGaf68AAHuzsCi7zOUJm60aMjynS55gdF+ou7JUayNoM4xyAM+nJwCMhQWg9XQ
         JoCTXbY/uWDqaBgF7oYHso/i7h9fojytw30ODsNPAnbkRuWDT8FHy4rdPIF3rXMBPTMf
         AFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53pASLo6U2zzYHdiGPJru2sei7EMeIsybEcbugHJMGw=;
        b=WIRDxrmoBezLK0KNCXAEA4ASMhgbZpyMo/ocEBVcTVY7OQfYcx0Pcc3CRoOQpePLLd
         0U+TmAV8GolW0AbMt57HmUIbaMu+El5GlMeYWjR65l3yJUuTzf1x3CkvDsSlWmnwIQ3v
         JeYGwrJ9Y4LE1y1aquTDCpUvtSLIMjNjgEmFE406DHs+U3S698kEesPFDCnG+pX2xfyu
         Sjf5ST1u3NF+0PUdRby2A2a+DabA3mh5FCmJJ+rWVIgoIBl1hNGBEn+DtZE77B7WL5qb
         HKwYRO2OgNzpVyGrZnZRgigECQPDlrJq2L6C8bIIHaJir+wwvJ1WKGAGlRVbEZITxe/0
         1H0w==
X-Gm-Message-State: ANoB5pn/JLzzcrXZbPeJ4i9cUGe2BaMXPbHycYlo/BZwC89LIRE0CBO6
        FLmU2C12g4FxYRbW2S8SubM4EKtRyfXXCu35GMI=
X-Google-Smtp-Source: AA0mqf45bdEJiOxhbUnLhIigBT0GjU47GsHYZmyiWPQnPoGEsgOfGs0TvhtmfqACF3pOoGPbacknnLPg3TD8cSTM64A=
X-Received: by 2002:a17:907:a709:b0:79f:cd7c:e861 with SMTP id
 vw9-20020a170907a70900b0079fcd7ce861mr33399680ejc.339.1669419406346; Fri, 25
 Nov 2022 15:36:46 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-6-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-6-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:36:35 +0100
Message-ID: <CAFBinCAmV7wuPq8y+g0YKxZ0W1G8_=WgY+E3OT9WT62eDkxXqw@mail.gmail.com>
Subject: Re: [PATCH 06/12] dt-bindings: rtc: convert rtc-meson.txt to dt-schema
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
>
> Convert the Amlogic Meson6 RTC bindings to dt-schema.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
With the comment below addressed please add my:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[...]
> +        mac@0 {
> +            reg = <0 6>;
> +        };
My understanding is that here you want to showcase the nvmem integration.
This IP block only supports 4 bytes of NVMEM. Instead of using MAC
(which is not what's stored here, the suspend firmware uses it
instead) I'd just use something like:
data@0 {
  reg = <0x0 4>;
};


Best regards,
Martin
