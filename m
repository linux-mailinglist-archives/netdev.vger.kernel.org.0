Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2262E337
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiKQRiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239416AbiKQRiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:38:14 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AFB7CB9A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:38:12 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id b9so3645621ljr.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dbw2/XXeLln7vDrFafq738GUmCXZ0AXEtj+PRDpKT1E=;
        b=hQ9lX8JNIWXAUodyaRmLxPAJdg0px72d9/dzwFaory5wXPbFCPfv32g92k+ZVcpanq
         8bFgh6MoJnqbmWiiiuRSUHXXnwkdwojle+Vth2A4SjG0PUkrp1tKnavpq0SG1owCthYZ
         M+j784DQwUiORoPcHUPWftjuyyA3wlJg9IFOBI23tZKZFwhyHHDGrp2gx5CtAbwtc6oJ
         W33t9eyrnFLnczrl6cvlbVWRE3FaOQxi6+Xk8e/m2VRQ+bTMq525+aTzYafZG8ihuDFn
         zZR6wwOeFF1+EJZm0ip7yEYJ/J3FQmPnJ1uVyX/pxjGnwlE0Ule+jSjgq8Q7PGx74oqG
         qQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dbw2/XXeLln7vDrFafq738GUmCXZ0AXEtj+PRDpKT1E=;
        b=ydJt27y5drJ7U6go4Csm/qg+ZZlfxnpN/xqxeUObtcu7IiEGc216lG9csDJNJbSw+G
         rGTo9Fhu88AE0psOEVcXGYbtZyrCr3UofWBdJh+d4H0c7gx0MiB6kg/StkBfYMs0jfbh
         n267Vrayo6nFSyDDmfnoY+DZ0HCkrE5qNKPp04t6EkQsFA4bKgrrMMy2vZkIVsDwz3Te
         2TAVeyADPvy8Nx0K9J4ltq5foKgOyPSAULpan9LLYnZ87kRnhvY2As5Z3Rpnb7EzoQ5x
         bREmWW++rO/hojnmpGAJd0yOQ3GHx/Qig0PoMvS8ihgkyGOoU70AYcefEJN95zDsJLtT
         evPA==
X-Gm-Message-State: ANoB5pl/oVPim8m4ltIGG0s+e6wkdozDjwnCBmEvp/FadnbTzMKP8NBN
        lIB9QTUvxeJ3ljd/N9NA98SR+Q==
X-Google-Smtp-Source: AA0mqf6Z6xAfpPfyQq1ZNnfmmz/+hTdfCIaaYUwg7Hel8p9ZM3aS2yrhDoEu+n0o+Rfz/XHJI4Eicw==
X-Received: by 2002:a2e:9d4f:0:b0:277:5928:f2fd with SMTP id y15-20020a2e9d4f000000b002775928f2fdmr1448180ljj.239.1668706690417;
        Thu, 17 Nov 2022 09:38:10 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f29-20020a05651c02dd00b002778a76a3c3sm301692ljo.112.2022.11.17.09.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 09:38:09 -0800 (PST)
Message-ID: <39383122-414f-f795-ab76-dad206198651@linaro.org>
Date:   Thu, 17 Nov 2022 18:38:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 1/9] dt-bindings: drop redundant part of title of
 shared bindings
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
 <20221117123850.368213-2-krzysztof.kozlowski@linaro.org>
 <20221117171916.GA3116476-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221117171916.GA3116476-robh@kernel.org>
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

On 17/11/2022 18:19, Rob Herring wrote:
> On Thu, Nov 17, 2022 at 01:38:42PM +0100, Krzysztof Kozlowski wrote:
>> The Devicetree bindings document does not have to say in the title that
>> it is a "binding", but instead just describe the hardware.  For shared
>> (re-usable) schemas, name them all as "common properties".
> 
> It's titles, so capitalize 'Common Properties'. Someday we may generate 
> a document from all the schemas.
> 

Ack.

Best regards,
Krzysztof

