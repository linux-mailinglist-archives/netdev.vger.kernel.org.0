Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF52664E73
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbjAJWCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbjAJWBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:01:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C93183A4;
        Tue, 10 Jan 2023 14:01:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z11so19724815ede.1;
        Tue, 10 Jan 2023 14:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1zojtUlTJ41SuWrZfC5EvKnzTTlRKFzqNeYYEkay3v4=;
        b=cddZySA12Yq1swNWNYpIqK5JVInCajEv34dtVRX5iLyqxr5N3PemsxVXbnYOYIAGnr
         gKqEW06tcOHsUR8VcFS7DQXlbibMgWFmmH7wYHUh2NL0DKearGTJxtoM93CdEr7jbMDa
         O9ctWwjV5w20+4FuPz2Hrf6A4e+2EkHV+2R1k7gHfAtogBaDtnsVgEfWmQRtkix/YR5s
         5XEKKjiSszvnbWScuBp9OOtkHUJmcyyUHP0ylIIYBERyQsHDrotlg+UBh5g0M8HCQsQV
         oDCEclTpfv1WZWvEXDWC9pZsmAAQIsOWKCMhRAz34wryF5FxONHePBLWOopXe29o2SPe
         Ybkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1zojtUlTJ41SuWrZfC5EvKnzTTlRKFzqNeYYEkay3v4=;
        b=7dw73EJDXx730ot1K6TWeHa9Wbq0hKZ7qnUccOWXvPEQJNfyRTj4kqaKOwcADozyW3
         WYdZWUQJZLsXsnsQPoB6/TxRCw4ipRyiF8NxMCdnNla9C25fE8Wgp7/bjPh69cTjdyGl
         9RA/0QCxtueKbp+Skl51+qw5V/BMaq6+zmqPaLR2fj00229F4C/j0hxddFuQ/1UGxjam
         7394Lp35Oh4sbS1jcqc2kCaerjjv5+/ECKjTa1lYcobuFNWy8ffXRaRs6/kJPOn2pQn2
         MgnTPLqvgyBwL8rrfm6MxnHKihGQlXqCFaTAKdEfDkprHa18X28ZMcKRabo/FDJT3uQ6
         ZVYQ==
X-Gm-Message-State: AFqh2koy8tNQSDrKkywW4qV/S74epUpgSvYlMaGsD3uA2RfnckEp8kOn
        mmWk1rX/fV+shNVoW2CvCLKhSrqR0xLTqGKwey8=
X-Google-Smtp-Source: AMrXdXs/xAROFlmP1Z6gsP4nU76Fz9ohlobY7nC70UqqJ6A94oT0iQ6simlwUiEPavrP8bBYALj6XMxx0kprOzT+6D8=
X-Received: by 2002:a05:6402:4290:b0:498:61f5:5734 with SMTP id
 g16-20020a056402429000b0049861f55734mr1027278edc.238.1673388094576; Tue, 10
 Jan 2023 14:01:34 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v2-2-36ad050bb625@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-2-36ad050bb625@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 10 Jan 2023 23:01:23 +0100
Message-ID: <CAFBinCCP7xyFEa9GhRQ3NBhfSkn1WSP_qyoLKfaMPpqUTe11bA@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] dt-bindings: nvmem: convert amlogic-efuse.txt to dt-schema
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

On Mon, Jan 9, 2023 at 1:53 PM Neil Armstrong <neil.armstrong@linaro.org> wrote:
>
> Convert the  Amlogic Meson GX eFuse bindings to dt-schema.
>
> Take in account the used variant with amlogic,meson-gx-efuse.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

This will cause a warning in
arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
though (which is an existing issue, this patch just makes it visible).
I sent a fix for that: [0]


Best regards,
Martin


[0] https://lore.kernel.org/linux-amlogic/20230110215926.1296650-1-martin.blumenstingl@googlemail.com/T/#u
