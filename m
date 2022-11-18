Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A829362F841
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbiKROwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiKROwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:52:34 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288D98FB20
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:52:33 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id g7so8590119lfv.5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XKTObKEL8gc5S/Q51M+L8voEMredlLnbihUYlLO76vs=;
        b=gMK7qVcD+/wXm6dGhENohbvUGU846z0Znfnyn4YkIaWmMt7X1/cw5naSy36DVIxHYk
         uZVj98I4oB6xd9bZLUQf19Ph1O9dDQPRXIfyTYw7E6xdNwIF1NhCnr/5k2PO705Nc5k0
         XQ1QiUNA3VL6Ip1u8qqtVQ7z8uICNwotEUJYWA+QgjTBfmuihMV3qsZhFJ+lRubn1aKy
         070XoR3LZfwbwMUH7Ky7T1eOGmByPNFlfsvaWR9IGBsggX8t4Eo+ZmpB2Exc/X6bY3JA
         gWZH4YYoZmpnbfFNMeuBEXtm68vEAQ3zeK3h6H7/zWrLl9hhTz0jCBxLBOvQFXbbLTV+
         vM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XKTObKEL8gc5S/Q51M+L8voEMredlLnbihUYlLO76vs=;
        b=GtO8Qw10v5hzCNhZZvDu++d+skQYk0CHJS4ulLtbysLhaHLERlRI+YBCs2MtI/Qi/W
         22UcQ5y0cAMX6c5cGLJdd1ulp/AJKTl8BwEcKt9JEgMoITR1fsG65mT5xY915FsoZ11x
         aN9WBoew5E46EF7ohhoKGpVWcaBFtgm10lIkkKcetNeafucIJjizUnn3rtcfqiSv+gne
         zKHRuJIQM2uN2106I6amd8FJIEcWU3YMK0OqbKX7xnlr/4VuCrjqP8FAy8PDzrc1lpLX
         JVSgyY3IX63LCgXJzp+WfqyJ83WG7etXK4m8xkreAEGsm3A8GwFn+EI7qFEVuXe1zgCh
         Gz3w==
X-Gm-Message-State: ANoB5plDBeJTYJL3VEhYGreaYaeZ2TvhLfRLlCFCStWiVgCDJYQpowwg
        VfddA3IJA72QdoldeE946tZcHg==
X-Google-Smtp-Source: AA0mqf74ROBTKaMUlZ8NEw2cWsCNjWuZzHLL5P0E9Dx63d7vUFRfCBhAqltBWgz7cA7TlfbXf1i4BA==
X-Received: by 2002:ac2:5281:0:b0:4b3:ff4b:80a2 with SMTP id q1-20020ac25281000000b004b3ff4b80a2mr2379143lfm.281.1668783151407;
        Fri, 18 Nov 2022 06:52:31 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id be34-20020a05651c172200b0026bf43a4d72sm676049ljb.115.2022.11.18.06.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:52:30 -0800 (PST)
Message-ID: <15840da8-bae2-3bb2-af0c-0af563fdc27d@linaro.org>
Date:   Fri, 18 Nov 2022 15:52:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 07/12] dt-bindings: power: remove deprecated
 amlogic,meson-gx-pwrc.txt bindings
Content-Language: en-US
To:     Neil Armstrong <neil.armstrong@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v1-7-3f025599b968@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-7-3f025599b968@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/11/2022 15:33, Neil Armstrong wrote:
> Remove the deprecated amlogic,meson-gx-pwrc.txt bindings, which was
> replaced by the amlogic,meson-ee-pwrc.yaml bindings.
> 
> The amlogic,meson-gx-pwrc-vpu compatible isn't used anymore since [1]
> was merged in v5.8-rc1 and amlogic,meson-g12a-pwrc-vpu either since [2]
> was merged in v5.3-rc1.
> 
> [1] commit 5273d6cacc06 ("arm64: dts: meson-gx: Switch to the meson-ee-pwrc bindings")
> [2] commit f4f1c8d9ace7 ("arm64: dts: meson-g12: add Everything-Else power domain controller")

As of next-20221109 I see both compatibles used, so something here is
not accurate.

> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/power/amlogic,meson-gx-pwrc.txt       | 63 ----------------------
>  1 file changed, 63 deletions(-)
> 


Best regards,
Krzysztof

