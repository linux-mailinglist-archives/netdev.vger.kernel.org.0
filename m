Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAA639225
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiKYXTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKYXTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:19:19 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2505B537F6;
        Fri, 25 Nov 2022 15:19:18 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z63so8169053ede.1;
        Fri, 25 Nov 2022 15:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SVELpdKFSXD3c/9YMUBWzdfVkz3skoAI+P1PdlwZ1ss=;
        b=YSHAbUBSvo9r6T1r9rnau1eANbw67fxthr/a4DBDvymBqEJFvDqj/w+5NQAdr2dJ8l
         82TzhSK/JnFmfyY2OX1lLZwCEcufyALIBwO8HDFhEEtgongMozj7XQ2E4U+mjweAEbrF
         Z1yMXWPUeTZuy3eFmzIFTMUCXrOs223UNE0O2hAVhNwkzEHRclze5qPUQVN0BJ5LnO/1
         XvSUttB1eO7QS7wEz5/JswGPOzphjNv7JuEVV+mqiIjuD4gIbA9EWNbRda9+Gm7giS78
         llOVgdJ4hikn3/tWyHxx7FrEfHipN2AXXg6zkcBhzSdsHWPHsH3iaWUJ6+JhB7DOQJ8Z
         mEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SVELpdKFSXD3c/9YMUBWzdfVkz3skoAI+P1PdlwZ1ss=;
        b=EeMkXvTvmdP7x0dPGVTXNzu7Zv1caRmU0POXqEhPfgKCpZ4ctwaSxGo2ZbbEO7kRJs
         EshlTXN1R1L2D6LaxY0yiqoSbM/4b4SDzoreqkuWqTOw+jEeGvcLdMwf+D9Fkgw1fNE/
         dEsG0CobeN4TJ7VYxjN+og8+o/ncHus4SFwpFrzpGx8zHVDLIkfx4mkdRNQ92rFhily4
         z6qCMDEPfNglzYy72z561gDTtQ4E7vfUPwlFlQmWXZTFuGCY3OT3BHgo1e3B2mtkpVw+
         ja8opbExOCoo3dvhlVh/BiggvDW4bRSAmOXlGJMqRg2xwVUE1B/Wy3aNMXChqqgZhZRU
         42lw==
X-Gm-Message-State: ANoB5pmUOg1kvylWdnLOX0b6CqSsZBXHq3MXKE37Zmeax7GDWr0MHWmd
        r4CpFlatAvyJusKhXrcgFIT6iE7JRgVtW28MyGw=
X-Google-Smtp-Source: AA0mqf4OqxkdoB0Ayiso+cMz67UQ77gNB96oROCtdv1hhdodGHiM13wZPNLLJ+nWz1FxwjqEbKw549M2HtAULGuy9LQ=
X-Received: by 2002:a05:6402:cb0:b0:46a:5df2:8d56 with SMTP id
 cn16-20020a0564020cb000b0046a5df28d56mr12461892edb.238.1669418356538; Fri, 25
 Nov 2022 15:19:16 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-11-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-11-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:19:05 +0100
Message-ID: <CAFBinCC+XNkyCoTNu881FVVZDSMerzTuEk5CDBXg7o2R595QhQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] dt-bindings: pcie: convert amlogic,meson-pcie.txt
 to dt-schema
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
> +  phy-names:
> +    const: pcie
At least SM1 has a PCIe power domain
So we need to allow this property as well

[...]
> +required:
> +  - compatible
clocks and clock-names are missing (you have them in your example though)


Best regards,
Martin
