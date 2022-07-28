Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1D958442D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiG1QcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiG1Qbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:31:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62472A70A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:31:36 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bf9so3571969lfb.13
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0Qrp1aC7ii4l+FdZJbsIzM1JU8ekTQaZIFWORS0YhME=;
        b=yOYlyKgvos/05p6jY1ecXbckNmfg3Mp8u9eEL/FG5WoJQlIVSW4Wt15soFBSdg3DbK
         MZKnX4UD8Mrs67cU8Lh7LWrVM7dFQJROTOP9oHyGKP3Q9U53B+VMZAKpJzu1rYwfKjqI
         cuOfm0wia1rOHbe/CP6zk9qP1t6tcSsnPs4COz/C0QMizLpFO5kJpces4fvL1wXgQktW
         gnlRfSt4JWCEjGkra3Xd+enNrD1CDHOSwCKFpUIz6E7X8TGhlY4fT6wgX8esaFHClmcV
         /4TMxl2WogYqSfHjIYuzIS8IpJF1HtlLixOkRKWIAtuGxYunJODuyk6XquNYDzZeqpcP
         cQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0Qrp1aC7ii4l+FdZJbsIzM1JU8ekTQaZIFWORS0YhME=;
        b=P7rYfE1Dlpuc1tlKh7D/b6+skJrnTuR5Ma+aHzA9rAU7Ci2RnpSGmynRb1uQs5qf3i
         gsh03aMPaWN/RMfAZ5dYQNjS32oDxALsCCpirEZk6NKD5pw1oEboIw68uZlb9rwEdQia
         mG7hPsQZLowlPNpnSLt0SzhULkMo50xgRcCLsZAnxNkBG3v9463UP7+YbhhPGvPm6o4v
         V1RIQUO1RMsbyPz8xra+ZaeN2AyimHDZKq1LJ3EXdM3oSeSkhhpDsvZj25LTt54K18Ci
         5I0X+DqNURa3a6AJE1pp5qkw5R4xU4zeW6C7YWdVqInHPWn34b1pIzZQXzich6fNFLEA
         0QqQ==
X-Gm-Message-State: AJIora8uogK/UDlIVeTFGOWJJkPVVtwnWAVpRWoezwsJPjBuSYuDyfnx
        z7cwYZrv4wCUw3sH4OMrV4rCrQ==
X-Google-Smtp-Source: AGRyM1vQbNnKAzNUxSU0neBQyxzQa6mDwQFmjvcMDN7uctQh6GF1gf3S5rEkvDVrNvEcqXGUIUiupw==
X-Received: by 2002:a19:e007:0:b0:481:c74:37b7 with SMTP id x7-20020a19e007000000b004810c7437b7mr10138465lfg.439.1659025894853;
        Thu, 28 Jul 2022 09:31:34 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id m8-20020a195208000000b004894b6df9e2sm264175lfb.114.2022.07.28.09.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 09:31:34 -0700 (PDT)
Message-ID: <ea684136-bdbb-1b2c-35d3-64fdbd1d1764@linaro.org>
Date:   Thu, 28 Jul 2022 18:31:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Mark Greer <mgreer@animalcreek.com>
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
 <20220728151802.GA900320-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220728151802.GA900320-robh@kernel.org>
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

On 28/07/2022 17:18, Rob Herring wrote:
> On Wed, 27 Jul 2022 18:41:29 +0200, Krzysztof Kozlowski wrote:
>> Instead of listing directly properties typical for SPI peripherals,
>> reference the spi-peripheral-props.yaml schema.  This allows using all
>> properties typical for SPI-connected devices, even these which device
>> bindings author did not tried yet.
>>
>> Remove the spi-* properties which now come via spi-peripheral-props.yaml
>> schema, except for the cases when device schema adds some constraints
>> like maximum frequency.
>>
>> While changing additionalProperties->unevaluatedProperties, put it in
>> typical place, just before example DTS.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>
>> ---
>>
>> Technically, this depends on [1] merged to SPI tree, if we want to
>> preserve existing behavior of not allowing SPI CPHA and CPOL in each of
>> schemas in this patch.
>>
>> If this patch comes independently via different tree, the SPI CPHA and
>> CPOL will be allowed for brief period of time, before [1] is merged.
>> This will not have negative impact, just DT schema checks will be
>> loosened for that period.
> 
> I don't think these need to go via the same tree.

Yeah, I wanted to express it that almost no impact is expected if it
goes independently. I could be more explicit here.


Best regards,
Krzysztof
