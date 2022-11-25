Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D61639230
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiKYXZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKYXZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:25:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1B1537F6;
        Fri, 25 Nov 2022 15:25:30 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id f18so13258629ejz.5;
        Fri, 25 Nov 2022 15:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tCTtF6fAWhMLt7sZbiPuunRpHFkZ2q0bqUFL/SjTMsw=;
        b=XO5fYO1oOwtpueIZWfSn0cCi0laQdhB3hXs3PtHdd4OHe23GYCorc0y8Plc2H8qhYv
         LH9Um4yafmwcg0CwYKDPPynP/ma2fvcmVr/dI+jLh3VXEEYqfRxf55tsTOHgkANnUVdk
         YYNgNvWH9oeYbutAzNf78VU2xm5n8CzkJQ1sYSm06g9m7ahaQFRQtoF8zTjxoIptgdRX
         GFvQGOfDC6UouP3xpg6y8h18RDmHkGu6d6J42lQritKDbeS4o5k1bR5+NSYQVUYvst69
         CT0ftvSz4BZ3AvUuRXFcsEitCTsNAlvScg9LFgPAGVyOscN277hzZtrcGIP99iABJqXZ
         1zyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tCTtF6fAWhMLt7sZbiPuunRpHFkZ2q0bqUFL/SjTMsw=;
        b=4hqBDWgkXfSnNKIGBeTFDfvb/KAvKMgcD87bOsCQzVoDx6hp+mj8VErY3OqoeuwheV
         xZu/mvnOSrWDDu+fa2gvfQhk1H67er2hDxvJkdaq1vUqp01Hyt1og2e/tcdj6wRSQo70
         rpLv/rcCk1FsimPbODdyGLILUW78KFCKKG7S/HS9zQZ+ofdO/nLRH8em8AF+ic3WuZ5E
         qMngHxyPw7eXl3Tvud8bRf3HMBheXqJE7pZkgznl7395fUdlfhpTVfX6tZm17vXN5vYj
         Uj7c+2948h/R+2Hmydn7MJJlG+FpLNO40FOIbt4ajkQMXcimIRm9gjGqqd8SkCVsn/Mg
         CTPA==
X-Gm-Message-State: ANoB5pkxxo8vnTuxuX+Q8XkMKHvJ+LjbDQqxKHNHm4mzIvdW/6keypPr
        /rmuowUtohIKIue/kchv3+l7BwAx2hc/2nTj7Co=
X-Google-Smtp-Source: AA0mqf6r8ZGoAmftNYWkAPDE8cV+ClfDfHNDigYfV7F4RFfaaXo6kES5wXG//eSV5jPV/Jc+P7ogrsCm0bmN17yrNT4=
X-Received: by 2002:a17:906:6bd8:b0:78b:a8d:e76a with SMTP id
 t24-20020a1709066bd800b0078b0a8de76amr35243355ejs.725.1669418728706; Fri, 25
 Nov 2022 15:25:28 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-5-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-5-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:25:17 +0100
Message-ID: <CAFBinCC_hGBNTwAfLAZmyNz7vjedWyQ0vhPT_vAKXQ5LKhA3Tg@mail.gmail.com>
Subject: Re: [PATCH 05/12] dt-bindings: media: convert meson-ir.txt to dt-schema
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
> Convert the Amlogic Meson IR remote control receiver bindings to
> dt-schema.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Before this is applied we need an additional patch removing the
un-documented "amlogic,meson-gx-ir" compatible string from
arch/arm64/boot/dts/amlogic/meson-gx.dtsi though.
