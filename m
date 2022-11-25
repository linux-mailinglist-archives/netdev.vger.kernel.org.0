Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9627063920A
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiKYXJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKYXJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:09:42 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873FE27B0E;
        Fri, 25 Nov 2022 15:09:41 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id bj12so13111100ejb.13;
        Fri, 25 Nov 2022 15:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0XioFARl1h+9O4FdVBDeUHFWIc6Iha9ExJeFsC7agBo=;
        b=ijem6b9zdomha6/vwYCcu6q8sRZEnyYMC+N/TfI2betHX8h/17lEvcObNDwAQZJrG1
         CyZg1GysIN3LJ6SCN+fz3ZbQ0s5Tv99nsSKleNi1cMo4HZr6+dqNoyz0huHMEsUKblbo
         j0iZ8uZIUhy4GKX8DuQdVW9dJAeRPmOdo8wBpvyB4DGVk6RFhKFlvSC6nHSvFV45a7GV
         lzTF7YNPMIzzTc7iDwJt6lA682jcC7xhATg7OxVhqLcIYkgwlIJUf08RD07lTP6m43xu
         p3UHG5Dp/A/fg39MCY4C9PQ6p5pXNBt0+B08vp6X1ohQfD/1CGL0eDy8QZLi3Eh7sP1A
         p+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XioFARl1h+9O4FdVBDeUHFWIc6Iha9ExJeFsC7agBo=;
        b=aAHSnzppymRH2FX0AeENFyeX5WghwTUqfIaTPFFVNhRMAL11Y2D/RsGDXcD0GKXqo2
         NSk5iQHljF0D7Q76ACbuuF1Xs1k32FGxCi/DYL8gBdgzyOnuajcoNxQBCi8Rn32pUMwM
         Zd3GA38zAthLS+uaMr4Z6t7YtQxVzgOojIrR5/xSwixdWMTQnAYUTWiyvZcahm1+IF2u
         OPNKelY2KLbpv8waitIBl9iebSAhUv0/IX47QWvtukhOhm90W3nYZqbC92ZxtiQI5tEZ
         tvTWgy+EYXtAXRc68osnYIXa7Hqn68aZfNcthAdA9rfR6jGa77RTe1vVTVEmJs1omdrl
         jWRQ==
X-Gm-Message-State: ANoB5pkx+d8iV7gJABYq4dojKz24VcRnyWoTJWahJe6Aq+jU6ORB7hFX
        wyxBQl+Qh3Sgre8F7cR+D8E3xNm+jk8tB01UT5Q=
X-Google-Smtp-Source: AA0mqf6ewtl/tvr8AuX1o3Xv/HwzUQiWRCO/BLv6pZISPImaHV2Rdm1l6LFkGhHL2TOQaHdJhN8otAdj5S+OkRcsIHY=
X-Received: by 2002:a17:906:1498:b0:73f:40a9:62ff with SMTP id
 x24-20020a170906149800b0073f40a962ffmr34923198ejc.678.1669417779871; Fri, 25
 Nov 2022 15:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-8-3f025599b968@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-8-3f025599b968@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 26 Nov 2022 00:09:28 +0100
Message-ID: <CAFBinCBgj-SCh8-BN6aG49GxfNXshjV3XGi0uWkZ26zT3mOceg@mail.gmail.com>
Subject: Re: [PATCH 08/12] dt-bindings: timer: convert timer/amlogic,meson7-timer.txt
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

there's a typo in the subject line: it should be meson6-timer.txt
(instead of meson7-timer.txt)

On Fri, Nov 18, 2022 at 3:33 PM Neil Armstrong
<neil.armstrong@linaro.org> wrote:
>
> Convert the Amlogic Meson6 SoCs Timer Controller bindings to dt-schema.
>
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
If you re-send this with the subject updated and the per-timer
interrupt description (that Krzysztof mentioned) added then please add
my:
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
