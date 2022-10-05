Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECFF5F507D
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJEHyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJEHyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:54:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052F61ED
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 00:54:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id y5so4787465lfl.4
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 00:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=HIQiD4rxFsd5dH3nMVqlPOd1Sb3NYZbeQQm1mzSwnV4=;
        b=lrgyI70bsWbp6T2v7mNCaLIuB2btVF3QBrquibHb4YuoEbB/LL30jCk7wEHi3W7Sto
         /64YHSSOvR7YECjnltjVOoklXfKYLpzjrfj7hqrt1vPKp2mTQZsj3pYBiNjC3oovOSno
         Zi60hP/DjPZbTsys7nsfpg5LSgCarbFaHXonOAZxntd3QoWUtfXRYkukAoFyMeC+1tEt
         or+StY099N0tPoQKBykzlylAFpJH0bmSrvswMN/4fUUOtiw6kYHfs1MBnZ5KxvzrN177
         P6dlu77ryIf6clf3mfs+9PIztUF1X8eW1cLoi0+cwCka1f3sGtMuOaQsPjsxga87b771
         wQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=HIQiD4rxFsd5dH3nMVqlPOd1Sb3NYZbeQQm1mzSwnV4=;
        b=rtng+ph3SDyDXTIt1fO+Tei9qLkTUbvLNEZso+2Px7o8a5lHZP/hXtkFpYNNUnnEkO
         PaoMKCXnJ7m6i2/J8WJABvwXoqjkUcCuiutt/0bLfR7RUkCxPfTH8FE6aYo/D1ybxU08
         dVaeYi7/lTab4WZaJTrqfTll4KK5jWimloSmUuSaLceoXnEfAlmnGdUDOHXrzf4quB8B
         rdut+QEtFOY3f5uVeRf4oxBdbtFMhgYZ5PPR9pkPfJC2mop8AcpuL/EcClQVlSC9J6ke
         7rd8tLGW/WpjlZ4+i4cZ5HvZAaRU9pAaZ85zHxHj10J4E3vgNQL4It8G5hxB8iqT3B9v
         2v2A==
X-Gm-Message-State: ACrzQf1DB8UD6gd7F9cZ9UP2lkHzvmbJ+sTI5GM+jyaMV+tMI1Vyh8rE
        tCnUog3iCFUfHd8LbhDKR/0Qng==
X-Google-Smtp-Source: AMsMyM647KSEfdK1s9YqL1xht+20nnUv8L2EKDFihJnKCCc3CfaHAi84e2yc4z9pIoM+3cSTyI8Bug==
X-Received: by 2002:a05:6512:1522:b0:4a0:2dd4:bab3 with SMTP id bq34-20020a056512152200b004a02dd4bab3mr11163828lfb.130.1664956472274;
        Wed, 05 Oct 2022 00:54:32 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id i8-20020a056512318800b00498f1eddad0sm2249573lfe.122.2022.10.05.00.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 00:54:31 -0700 (PDT)
Message-ID: <2ab2940d-36b5-d4b3-da8c-9dc0bded7bd8@linaro.org>
Date:   Wed, 5 Oct 2022 09:54:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <c1b64758-219b-9251-cea8-d5301f01ee7f@linaro.org>
In-Reply-To: <c1b64758-219b-9251-cea8-d5301f01ee7f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 19:48, Krzysztof Kozlowski wrote:
> On 03/10/2022 18:46, Jerry Ray wrote:
>> Adding the dt binding yaml for the lan9303 3-port ethernet switch.
>> The microchip lan9354 3-port ethernet switch will also use the
>> same binding.
>>
>> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
>> ---
>> v3->v4:
>>  - Addressed v3 community feedback
>> v2->v3:
>>  - removed cpu labels
>>  - now patching against latest net-next
>> v1->v2:
>>  - fixed dt_binding_check warning
>>  - added max-speed setting on the switches 10/100 ports.
>> ---
>>  .../devicetree/bindings/net/dsa/lan9303.txt   | 100 -------------

Beside that you got errors reported by kernel test robot.

Best regards,
Krzysztof

