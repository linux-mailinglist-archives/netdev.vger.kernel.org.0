Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B715387C69
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350183AbhERP1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 11:27:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53621 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350166AbhERP1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 11:27:18 -0400
Received: from mail-qv1-f72.google.com ([209.85.219.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lj1ba-0008Cu-Ub
        for netdev@vger.kernel.org; Tue, 18 May 2021 15:25:59 +0000
Received: by mail-qv1-f72.google.com with SMTP id i14-20020a0cf10e0000b02901eeced6480dso6091001qvl.4
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 08:25:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QFV1CgFry6db6OpdS2HnSeaH64FcPIlgQKjVPjfh0tM=;
        b=ILY59RwWo5g7PEpwtrTDbfxbeYkZya2bpU2UeWySaTh5N1vv0ck38oYMMTGOrNbva6
         XhP6ltZQF5BNAoaT1syyqqS1baFv/PR/xSPdwAjqb//de+9QmY2BTyx6HBhN72UtU1iU
         W6shtzXLYajeJsxbQnhXADpcd1Uzl78HMEt2CpVspqSgJqC8MLoUC1KrJsljNKdz+ZaA
         rfqBfFUCg3Kw/0yCsIwqVfMAxLWovEhxyNxxQI1QBi+l3+WWeYYc7y1bUPwlXh47KYTA
         W1VpaVwdEYY+PXI3LVnDXaYxSbqLo3Dg5sIOHsgxZPBvwLsdBXqLn017svC5dKKshtm0
         neNA==
X-Gm-Message-State: AOAM531OxPLdrSwWLZKAgaFhHhO/SrYsl1ZewMa9oKy7Kz6E21AaHA/0
        sCkGjtTbN9BWMuH4Z6qZGnOVOIlwViYT3VEJUEqimXrzhd+sKdIl/M4XJB2hdCRkKsYwFVEGls7
        KFp9F8QAOuG6hPnKKX7Z8NvEVUrcA6XWG+A==
X-Received: by 2002:a37:6410:: with SMTP id y16mr5916797qkb.463.1621351558049;
        Tue, 18 May 2021 08:25:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoChMjPCGN+C66udK0IuPehIMZ37NnIZl3M1GC49UMXTNzStjojRPo+sTWNOcCR27vxKLKwA==
X-Received: by 2002:a37:6410:: with SMTP id y16mr5916775qkb.463.1621351557811;
        Tue, 18 May 2021 08:25:57 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.2])
        by smtp.gmail.com with ESMTPSA id q192sm13214584qke.89.2021.05.18.08.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 08:25:57 -0700 (PDT)
Subject: Re: [linux-nfc] Re: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
 <YKPWgSnz7STV4u+c@gerhold.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
Date:   Tue, 18 May 2021 11:25:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKPWgSnz7STV4u+c@gerhold.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2021 11:00, Stephan Gerhold wrote:
> Hi,
> 
> On Tue, May 18, 2021 at 10:30:43AM -0400, Krzysztof Kozlowski wrote:
>> On 18/05/2021 09:39, Stephan Gerhold wrote:
>>> s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
>>> the clock is needed for the current operation. This GPIO can be either
>>> connected directly to the clock provider, or must be monitored by
>>> this driver.
>>>
>>> As an example for the first case, on many Qualcomm devices the
>>> NFC clock is provided by the main PMIC. The clock can be either
>>> permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
>>> only when requested through a special input pin on the PMIC
>>> (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
>>>
>>> On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
>>> is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
>>> only when necessary. However, to make that work the s3fwrn5 driver
>>> must keep the RPM_SMD_BB_CLK2_PIN clock enabled.
>>
>> This contradicts the code. You wrote that pin should be kept enabled
>> (somehow... by driver? by it's firmware?) but your code requests the
>> clock from provider.
>>
> 
> Yeah, I see how that's a bit confusing. Let me try to explain it a bit
> better. So the Samsung Galaxy A5 (2015) has a "S3FWRN5XS1-YF30", some
> variant of S3FWRN5 I guess. That S3FWRN5 has a "XI" and "XO" pin in the
> schematics. "XO" seems to be floating, but "XI" goes to "BB_CLK2"
> on PM8916 (the main PMIC).
> 
> Then, there is "GPIO2/NFC_CLK_REQ" on the S3FWRN5. This goes to
> GPIO_2_NFC_CLK_REQ on PM8916. (Note: I'm talking about two different
> GPIO2 here, one on S3FWRN5 and one on PM8916, they just happen to have
> the same number...)
> 
> So in other words, S3FWRN5 gets some clock from BB_CLK2 on PM8916,
> and can tell PM8916 that it needs the clock via GPIO2/NFC_CLK_REQ.
> 
> Now the confusing part is that the rpmcc/clk-smd-rpm driver has two
> clocks that represent BB_CLK2 (see include/dt-bindings/clock/qcom,rpmcc.h):
> 
>   - RPM_SMD_BB_CLK2
>   - RPM_SMD_BB_CLK2_PIN
> 
> (There are also *_CLK2_A variants but they are even more confusing
>  and not needed here...)
> 
> Those end up in different register settings in PM8916. There is one bit
> to permanently enable BB_CLK2 (= RPM_SMD_BB_CLK2), and one bit to enable
> BB_CLK2 based on the status of GPIO_2_NFC_CLK_REQ on PM8916
> (= RPM_SMD_BB_CLK2_PIN).
> 
> So there is indeed some kind of "AND" inside PM8916 (the register bit
> and "NFC_CLK_REQ" input pin). To make that "AND" work I need to make
> some driver (here: the s3fwrn5 driver) enable the clock so the register
> bit in PM8916 gets set.

Thanks for the explanation, it sounds good. The GPIO2 (or how you call
it NFC_CLK_REQ) on S3FWRN5 looks like non-configurable from Linux point
of view. Probably the device firmware plays with it always or at least
handles it in an unknown way for us.

In such case there is no point to do anything more with the provided
clock than what you are doing - enable it when device is on, disable
when off.

I think it is enough to rephrase the msg:
1. Add at beginning that device has one clock input (XI pin). The clock
input was so far ignored (assumed to be routed to some always-on
oscillator).
2. The device should enable the clock when running.
3. Add all of your paragraph about detailed logic on GPIO.

Since the GPIO is non-controllable, it actually does not matter that
much for the driver, so you can add it for relevance, but not as main
point of the patch.

> 
>>>
>>> This commit adds support for this by requesting an optional clock
>>
>> Don't write "This commit".
>> https://elixir.bootlin.com/linux/latest/source/Documentation/process/submitting-patches.rst#L89
>>
> 
> OK, will fix this in v2 (I guess there will be a v2 to clarify things
> at least...)
> 
>>> and keeping it permanently enabled. Note that the actual (physical)
>>> clock won't be permanently enabled since this will depend on the
>>> output of NFC_CLK_REQ from S3FWRN5.
>>
>> What pin is that "NFC_CLK_REQ"? I cannot find such name. Is it GPIO2?
>> What clock are you talking here? The one going to the modem part?
>>
> 
> It's indeed GPIO2 on S3FWRN5, but that's pretty much all I can say since
> I can't seem to find any datasheet for S3FWRN5. :( I don't know what it
> is used for. As I mentioned above, BB_CLK2 goes to "XI" on S3FWRN5.
> 
>> I also don't see here how this clock is going to be automatically
>> on-off... driver does not perform such. Unless you speak about your
>> particular HW configuration where the GPIO is somehow connected with AND
>> (but then it is not relevant to the code).
>>
> 
> I hope I covered this above already and it's a bit clearer now.
> Sorry for the confusion!

Yes, thanks!


Best regards,
Krzysztof
