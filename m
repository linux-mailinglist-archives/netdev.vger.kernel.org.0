Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB10762F8AC
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242034AbiKRPCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242205AbiKRPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:01:47 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB32B7664
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:58:27 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u11so7072760ljk.6
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gibrX75NV0o1Er7DAwf8HIM5v6cqoDdd2wUHdxJchhE=;
        b=xlP2/zPO44yPgOZyJLVvU2O64clebhkb2vmGo5gBNeig3Ow/Ikz9yC2MGIXKRCdvt0
         lgs97gHMJWxLzQeEWAWd4TUPsXItwsIf33R+z474tFpECaZSQxXSRD6nyNHMX84hbFpl
         qOa7JUfbLDERx1AP423afzv+JxxpmRbbuYMBS9sWqWe2PZtbeMfDS7x8nHBfJuKmHUxg
         kakz50WXbg0TKrdI7JcO6MbfKES672Ahu7rdE34KR75q5Ao4y9vUAEZc3V/1XQBycVcI
         +pVtG0Sy08uigqxmUV+gjtdpxRxna5Zpc+pLemPTUQsG29Ar43U8KQBsGmagHGetsxPX
         KQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gibrX75NV0o1Er7DAwf8HIM5v6cqoDdd2wUHdxJchhE=;
        b=52w7plANw7Q+wruZltzlxVhWzg+KgaeyR1CkCGliivQGJbHb1x6crt/ZJ/DI5gqLDN
         Fivp0SdwrLQXkB+9Afx1NmF2luLaSXxPWpAz9b0vgk3XmXlp6I0Ez+WtWxNfM36vsMUb
         mtmKaVyWKaLFI+pciBiJf91i3eGoHxCfUUs8r8Cqu7UERP+V4Ufhh2REtR+B5oG8PnSj
         LMzsTRPAmrAmMi+nRMSCaIySlk7Iip2F+azKZcfDMqm03vvn1ec3FRBLhFpKIdYCz7sr
         7XRrzlTnKyNPH3zJtfUGiXG8p2hplD+j6OWa0RvXWWgtJHEbnA5uNqWmQ9nMwSpr/mjb
         OKQA==
X-Gm-Message-State: ANoB5pn4bGqAIrU791ANVdos1keDZoSdKBBu+ELECGQ5IuvC3VScGrQH
        1KBtz0ZG2txGT/4l6nGjJhcOUQ==
X-Google-Smtp-Source: AA0mqf4GsDcErhuHhrxTsrc1he+Ga3A4CdIcSPLSlvDmnQTf+lXOnPMqUgqrM17z2dntyeUlAKEDoA==
X-Received: by 2002:a05:651c:301:b0:278:e996:d2b0 with SMTP id a1-20020a05651c030100b00278e996d2b0mr2640287ljp.50.1668783506295;
        Fri, 18 Nov 2022 06:58:26 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id s30-20020a05651c201e00b0027758f0619fsm681677ljo.132.2022.11.18.06.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 06:58:25 -0800 (PST)
Message-ID: <35c07fc0-574c-817a-93ed-4575659e767b@linaro.org>
Date:   Fri, 18 Nov 2022 15:58:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 07/12] dt-bindings: power: remove deprecated
 amlogic,meson-gx-pwrc.txt bindings
Content-Language: en-US
To:     neil.armstrong@linaro.org, Jakub Kicinski <kuba@kernel.org>,
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
 <15840da8-bae2-3bb2-af0c-0af563fdc27d@linaro.org>
 <95abd39d-b084-68e5-f012-6a1149bdb8a3@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <95abd39d-b084-68e5-f012-6a1149bdb8a3@linaro.org>
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

On 18/11/2022 15:55, Neil Armstrong wrote:
> On 18/11/2022 15:52, Krzysztof Kozlowski wrote:
>> On 18/11/2022 15:33, Neil Armstrong wrote:
>>> Remove the deprecated amlogic,meson-gx-pwrc.txt bindings, which was
>>> replaced by the amlogic,meson-ee-pwrc.yaml bindings.
>>>
>>> The amlogic,meson-gx-pwrc-vpu compatible isn't used anymore since [1]
>>> was merged in v5.8-rc1 and amlogic,meson-g12a-pwrc-vpu either since [2]
>>> was merged in v5.3-rc1.
>>>
>>> [1] commit 5273d6cacc06 ("arm64: dts: meson-gx: Switch to the meson-ee-pwrc bindings")
>>> [2] commit f4f1c8d9ace7 ("arm64: dts: meson-g12: add Everything-Else power domain controller")
>>
>> As of next-20221109 I see both compatibles used, so something here is
>> not accurate.
> 
> Yes driver still exists, was left for compatibility with older DTs during the migration.

Then the bindings should stay. You can add "deprecated" to its title.

Best regards,
Krzysztof

