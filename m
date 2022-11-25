Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3923063921C
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiKYXNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:13:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYXNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:13:06 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235132FFDD;
        Fri, 25 Nov 2022 15:13:05 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id e13so8135276edj.7;
        Fri, 25 Nov 2022 15:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YRXgY3Jj45tR352JHVnAGEWNDK4+LNF88JlctEC+BmA=;
        b=j3YfXXi2BK/0UmIyMEYU4Gb2t3KZRjWodKFfA0jiYv1dUB5lmqNn0PDEGb4yYPU93g
         pOnB9z7lPCqSCmdIDRrz7HPfJM+Pmllr7qI1szglZRA6i+NorVrK5ayHVx3EdC+JQ9dW
         q34It7p07BHIvQ1PqQSW/o5aYE7AKR7bi9USit5/aXNEB/0QLnz7dG7sr98f53TlP4W/
         RC3Ae2ve6tReSFOXusxBgVMtqNG9oae4pkLWd3JM9V7JOkTO7ojuFe66esG6PJZa7KUi
         +sHUexpTzevypIqqnWkuVjqyYrDP3kkAN0IEYD1aDEyBRuKfvKyWrTdHMBalPS2vGkHR
         Wuow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YRXgY3Jj45tR352JHVnAGEWNDK4+LNF88JlctEC+BmA=;
        b=yTg7worR0Js3mFmhtHv5gWqYjVvBp7DSTUnwgPLh3URRD1LYiJKqZKwroFV0LDus80
         F5uY1LigWLE7UJqDL3xkqSNXfm14ymLRIYKqiuKUZ2NonGDUnQiNjbUKxGLP3Zr16CQh
         tvpAGyps7NrJAyR1GiQENlvKBeqvjGoHgAzHY0lv5kpSpYj/lPx05gM3QzpQbJps6CZe
         1BpETFi3NwJYT/yczXn4cHGXEEKrZGQQ+wPLt9t/1vPxSn6fmE3YxuEtzq1duZEpzaHR
         f7xbgoJlu/8UJkAmbbdpgoBUIawuZnydGWfkdH36wuyL+4ccRx03PwUv7/mDg+QKtD4E
         QWmg==
X-Gm-Message-State: ANoB5pkpvMveEILg+D3XKGdo1BSbZprWmFuGeEFWUR99W6DqmF6x+enV
        +38DnZ1FBIY3zywYkwFI2iMGkxBS1KXJK+OIgxA=
X-Google-Smtp-Source: AA0mqf6z19L+80cdJdpiBrZekD7zi3b7v//rvam5MbPAwZbpIOcjE6QLP7tSIYyKnEp307OqAF+z+mpMYDtlI5ZbDxA=
X-Received: by 2002:a05:6402:3893:b0:461:b033:90ac with SMTP id
 fd19-20020a056402389300b00461b03390acmr25846123edb.257.1669417983555; Fri, 25
 Nov 2022 15:13:03 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-12-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-12-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:12:52 +0100
Message-ID: <CAFBinCC+v-301V2DV5TCMEOW8_q2-+NJCvY+4vCg-05ki+ETUQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] dt-bindings: net: convert mdio-mux-meson-g12a.txt
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

On Fri, Nov 18, 2022 at 3:33 PM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
>
> Convert MDIO bus multiplexer/glue of Amlogic G12a SoC family bindings
> to dt-schema.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
