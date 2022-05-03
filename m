Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A650A518382
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiECLyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiECLyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:54:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9F511A39
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:50:51 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y3so32871142ejo.12
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 04:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ih/ckUFePSBmNKQ4wfEcW+kXTymZe6omnd8bqMwTzbU=;
        b=vQbGs7HqPX5hkBXZ4kaKvK86yhyrxaELC2ypOHgX6amLyWX0ZLDnJtKQOvoYDx87Ie
         7X40eoIVECsILJvqYVoE4sYCx1+2MwtuxnS+3mv7xeNB+t0Bg6dtYskrmsu80APQC3Vl
         PESqXFi88lcUGXoRYM626Gk9VYLtcRx4gndsajUNtemFNk4Im2ea1PgdneRcGMTfDZFi
         rFuc04P39bsDEkloscYj/8qnwLVz/YQQ/6LJNcTKMyWfVnQI2fWqHmCdbbWINbK6PPd1
         SQJltIxDybOAlsEP7O16MQe0t81me/KJSRu2PWtEnXHisWoDOr3DVdrOIFsDG15yvUv6
         xvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ih/ckUFePSBmNKQ4wfEcW+kXTymZe6omnd8bqMwTzbU=;
        b=OyTkAG7L3QdhF9G5j3BU1DleyGEySVA+9vL04SsU4lPSeIKRN/R2eRqypO57+V1nTR
         JLMreAgoKaLIQob5GgHJyO04TqSc+ZMvlEFWE9h1XEVjvmgdOTKMNxM6cnWv6+ebCV+P
         rQfNx3sA9HQ+LUIQ5bHI4Ao6wEdG9LfxiWqBIWa8qYlmJgmir1xHr0iKO3IGv7waP//d
         NnS4ca0YD4Qxz87HJTfyryELxHF0zU4oCgLD5HoYoPwDeBRN/3jHp9uXTVUwAoroXJ34
         2tT/cRAR+SCrPjqHfZIVH4z6S3gyE5U5Nn1ptEtysn1AV1ezIM9jB7F0WappiyCu4pQ7
         MAqg==
X-Gm-Message-State: AOAM530k/sTVr1rI9YQA9nCUGeoSYQEN08TTbgwCcjqUJAB2ulmiV0Ls
        hXw5nYLlK5FUv22q6eB2VoHw0A==
X-Google-Smtp-Source: ABdhPJyQprW8f+96QHNflfHyUeqhDWbA2+9ZzCHMvoFFwihhF1wvvspxofZ7KeFe9xZmsxL78jZC9Q==
X-Received: by 2002:a17:906:a454:b0:6f3:98ab:473d with SMTP id cb20-20020a170906a45400b006f398ab473dmr15032220ejb.423.1651578650206;
        Tue, 03 May 2022 04:50:50 -0700 (PDT)
Received: from [192.168.0.202] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u21-20020aa7d0d5000000b0042617ba63aasm7794131edo.52.2022.05.03.04.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 04:50:49 -0700 (PDT)
Message-ID: <5d3bccb5-2b0e-9054-3302-d6962da0fee4@linaro.org>
Date:   Tue, 3 May 2022 13:50:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] dt-bindings: net: adin: document adi,clk_rcvr_125_en
 property
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Nate Drude <nate.d@variscite.com>,
        netdev@vger.kernel.org
Cc:     michael.hennerich@analog.com, eran.m@variscite.com,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
References: <20220429184432.962738-1-nate.d@variscite.com>
 <a11501d365b3ee401116e0f77c16f6c2f63ef69b.camel@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <a11501d365b3ee401116e0f77c16f6c2f63ef69b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2022 11:03, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-04-29 at 13:44 -0500, Nate Drude wrote:
>> Document device tree property to set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG),
>> causing the 125 MHz PHY recovered clock (or PLL clock) to be driven at
>> the GP_CLK pin.
>>
>> Signed-off-by: Nate Drude <nate.d@variscite.com>
>> ---
>>  Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> index 1129f2b58e98..5fdbbd5aff82 100644
>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> @@ -36,6 +36,11 @@ properties:
>>      enum: [ 4, 8, 12, 16, 20, 24 ]
>>      default: 8
>>  
>> +  adi,clk_rcvr_125_en:

No underscores in node names

>> +    description: |
>> +      Set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG), causing the 125 MHz
>> +      PHY recovered clock (or PLL clock) to be driven at the GP_CLK pin.

You are describing programming model but you should describe rather
hardware feature instead. This should be reflected in property name and
description. Focus on hardware and describe it.

>> +
>>  unevaluatedProperties: false
>>  
>>  examples:
> 
> The recipients list does not contain a few required ones, adding for
> awareness Rob, Krzysztof and the devicetree ML. If a new version should
> be required, please include them.

Thanks!

Nate,
Just please use scripts/get_maintainers.pl and all problems with
addressing are gone...


Best regards,
Krzysztof
