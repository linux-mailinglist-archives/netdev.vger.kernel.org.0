Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFF762EF48
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241451AbiKRI2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241379AbiKRI2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:28:30 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33D2C69
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:28:24 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z24so5904415ljn.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MrA5CDs46lQZm6VaAVmPmV1Nyk9XIySNq9lvhXdo7k8=;
        b=yIT6wd8Tn/4EigMdSev3RTx1dShvONUZ1o2LJic5y3UzW8LgMuG7uFp80Y8Mw7p+2i
         u+Hx+MWiciMmXSYnrFx98cxa4sbmSAURAUt99p8E3r2tMmF0ygoLGxcFQPJrif3jPMLj
         y0DxRVohO6j383Jju+uqZkJFVPAKCT7G1d+SNz0aRrDl59ec+iH3SvLunNJnRAN3fFHp
         uj/yuz8SV/cGRRKi6lGP5BHU+Y9YeVlbn5zwGo+B4clkg1nQfYqsfFdJXz60NiVE7C5x
         xoWYk/DHjlYtipany3Ms311spap+ZgR86DO9tnSirVslPkUYj7drcMZpd/Ds56w7qUSX
         eO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MrA5CDs46lQZm6VaAVmPmV1Nyk9XIySNq9lvhXdo7k8=;
        b=ru2BoFnad7jFW9oWxh470UX36P1W94Q0rxH3I/isX7Tq1JDiDMET76h9e2SJEQBWzm
         D/fce0lgUaaTrtq3OfmcZ1YCqK4TUXZfAz1LqZECZpYw1u96gFzV+l555pi6I95u/npC
         TH2rxrR9ySbAPBzQU6p1544NvJ5yPhKeZdoQqCjYTUCDQ8OapVMuH2O4eU07XZXW+a/5
         vCW8A8Ky5xnO5itxYvdv5nWHNxmWRo5HbfqAHy/dAXLoo2dB+DHKT12y1Bn7IJHIa6r7
         KtQyrqux+hnC7p5D9rh0OUsibMmrkwidxiX/WEdaLORyy3E157JPM+xANx+teJBr4pV5
         O0WA==
X-Gm-Message-State: ANoB5pmzjwCzsEwYlwcRpxP4H3DEaa55vRJei1fWkAgU3wglFjvzqGSw
        sRxOeYPawIXpef49VeoeHcQcMQ==
X-Google-Smtp-Source: AA0mqf4FSTsj7jWLGFDuUM1KolU0pAAAlYx7n+VRF6tfHUnjgf3Tz4kJo9qfndGCbN01BGn3foVCSQ==
X-Received: by 2002:a2e:9052:0:b0:26e:eeb:f9cf with SMTP id n18-20020a2e9052000000b0026e0eebf9cfmr2211769ljg.480.1668760070041;
        Fri, 18 Nov 2022 00:27:50 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id g27-20020a2eb0db000000b0026bf0d71b1esm573326ljl.93.2022.11.18.00.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 00:27:49 -0800 (PST)
Message-ID: <06ac1c86-22f7-97ff-bf59-6fb0994dfcc5@linaro.org>
Date:   Fri, 18 Nov 2022 09:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 1/9] dt-bindings: drop redundant part of title of
 shared bindings
Content-Language: en-US
To:     Conor Dooley <conor@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
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
 <Y3Z0w6JH1f5zgwvW@spud>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Y3Z0w6JH1f5zgwvW@spud>
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

On 17/11/2022 18:52, Conor Dooley wrote:
> On Thu, Nov 17, 2022 at 01:38:42PM +0100, Krzysztof Kozlowski wrote:
>> The Devicetree bindings document does not have to say in the title that
>> it is a "binding", but instead just describe the hardware.  For shared
>> (re-usable) schemas, name them all as "common properties".
> 
> 
>> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
>> index 1ab416c83c8d..d2de3d128b73 100644
>> --- a/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
>> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc.yaml
>> @@ -4,7 +4,7 @@
>>  $id: http://devicetree.org/schemas/clock/qcom,gcc.yaml#
>>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>>  
>> -title: Qualcomm Global Clock & Reset Controller Common Bindings
>> +title: Qualcomm Global Clock & Reset Controller common parts
>>  
>>  maintainers:
>>    - Stephen Boyd <sboyd@kernel.org>
> 
> 
>> diff --git a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
>> index cf9c2f7bddc2..20ac432dc683 100644
>> --- a/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
>> +++ b/Documentation/devicetree/bindings/opp/opp-v2-base.yaml
>> @@ -4,7 +4,7 @@
>>  $id: http://devicetree.org/schemas/opp/opp-v2-base.yaml#
>>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>>  
>> -title: Generic OPP (Operating Performance Points) Common Binding
>> +title: Generic OPP (Operating Performance Points) common parts
>>  
>>  maintainers:
>>    - Viresh Kumar <viresh.kumar@linaro.org>
> 
> Hey Krzysztof,
> 
> Hopefully I've not overlooked something obvious, but it wasnt noted in
> the commit message - how come these two are "parts" rather than
> "properties"? The opp one at least don't seem to have much more than
> properties and patterProperties in it.

They should be properties, will fix in v2.


Best regards,
Krzysztof

