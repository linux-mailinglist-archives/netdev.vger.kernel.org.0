Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A35F639212
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiKYXLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYXK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:10:58 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA80753EDE;
        Fri, 25 Nov 2022 15:10:57 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id n20so13301230ejh.0;
        Fri, 25 Nov 2022 15:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7U7G5CiQhnzMThzAFGcx2s+uHerZTRaEXypLXgixeA=;
        b=UVMyss+7rEYxSPmb8p82Mv6D8rx8V5naJGOde7hXp+cosnBNL9xoyXahQ1mQYKYnNd
         Lua1xFxAK17/ooO492vC49X+luSzix/pD+lVfTH2ZK+c5u+IK34+v7gvt/Gh/vGINusx
         2jxFPSUsb2U4kcU5SkxVPIuki3NalU3fcOHSzoM2QDNCbTs2WLohr8vDm6HLl9GjBMmI
         Pl8IQrfN7F93OROvLZjI1vbx+ClSjlx2dEQIyhxhXEvmRIOxHN0wXhJWdDYp+jKFQW4O
         O0ZItoUA0e4H4dX6/MjXpenaKHNs9WOF5SYidalNj8S367LHiqHHRo4NucIfStWJ+G+W
         Z9mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q7U7G5CiQhnzMThzAFGcx2s+uHerZTRaEXypLXgixeA=;
        b=54FwdKytzyK5ol8LnwDmOEyV5T11KNqvFfckVwWXxvH1HCABwP6PPAZhrOwMOjl3dc
         6i8OYuTIIN7EY0ZCIEQ+gnYh0OVstYOf3ordNfY5OsQtCHv+/uV4Y2ayBP4Kq0bcneHK
         ntMjTDSe7ivCX444y7fgmCsqJFCJxPgsE0Ik4e6c0/M+4l21rpJiVqd9a86lRtFjEwlh
         Hm5LY9yGfPmiHMI0aiZfqAxGOXSBGQNO1RVs/3m7p5uswCQ7rcm10Kp3jXnxRIR1a2gT
         lvPFaKmLKcH3l8afoNhG+PVoEMccBpQWqkXGF/DDmw8ziQRulnAfhHw7r6GFJccRs3wT
         Lipg==
X-Gm-Message-State: ANoB5plLtk6GV2O7bpXYawSMg3YuA7DWM/rtxHykksfACFkEGDmr8raV
        MY3tiqpaAYCHffmVUXfY7zm27pI/Vkz7jXkdWkI=
X-Google-Smtp-Source: AA0mqf4eckeBj0/Wph7U7qMN8zegn2m4M80Mi8LIoBZHcXLcZcwyhvtCy2QiSp7o9N+U4CA/QRN9W/V0xDqjX61QtAY=
X-Received: by 2002:a17:906:6bd8:b0:78b:a8d:e76a with SMTP id
 t24-20020a1709066bd800b0078b0a8de76amr35199024ejs.725.1669417856212; Fri, 25
 Nov 2022 15:10:56 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-9-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-9-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:10:45 +0100
Message-ID: <CAFBinCBQi21vKuT_eScmswTx2rP1DsH_uEL=+Lp9a5EfgfFUTQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] dt-bindings: phy: convert meson-gxl-usb2-phy.txt to dt-schema
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

On Fri, Nov 18, 2022 at 3:33 PM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
>
> Convert the Amlogic Meson GXL USB2 PHY bindings to dt-schema.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
