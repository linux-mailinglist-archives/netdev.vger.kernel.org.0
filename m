Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E327E648DF4
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 10:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiLJJbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 04:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLJJbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 04:31:20 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382614081
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 01:31:18 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a7so7328673ljq.12
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 01:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M+HZ2UMBdem2ooBDTFN6oxFPfKBOmQHSueRlKfK2c/4=;
        b=mNLaJ39vpYQFEKXM/SGxUbeLc2o4WU9TeoCA9Lw9p428her6/0WdNMWT7A40m92yX0
         Ffi33NGqd+a5W7g1QDlgE7OwQBlFwSSay4WUivpyiS3WAkcxEr976NlNoORBaoBsLlAF
         4+D0d+2LlMMHcximGWbyoP1VtP0N5ZUQN8QCljVyvvhmboo27IEbH9emw2ZmKdRTQ3zP
         PwBLJeiGTFJ/5LvhhkUpN+ewknRK7D807n60ivLycbASq+THoJfoeaNjsQ617uDoylHv
         pNojOFGqIfm8IQMXKLo8tr+ffmMqodMMW0YYGU+j8A2UMeWe6AZH0jF59ZjxZzXGPSqY
         5aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+HZ2UMBdem2ooBDTFN6oxFPfKBOmQHSueRlKfK2c/4=;
        b=mEd1sW8gaik/TrtmMDcZ4863cbU6KYk/iYrAUJVGMCWZ5Ws2TlJQjgGKqF2wNXRdzG
         T2p10m4a2Ei0nBlzJh5rhBum72d1f9TOuwJnqG9BN45u8Cn5hw97ZTjvBgD10XggX8aI
         RaPQYX7ukoKWeYnjWNE1j+SyQzitzCkVvccuCT1vjuXgBbrul+QUpjEETdNSUTR4VkQg
         elRXl4FCpWD7MkxbQXcNfvFOYpmt+Rw9mZBLic7MdW1YFWVn40M/+7fhYdlvpk4gMLAr
         aOguBYKch5Eh+uQ+RR2OujF0KB0HJdX7YpWJ9CCEaOxynw7JopQAUvx0vMOqZVrgI19Q
         Dr7w==
X-Gm-Message-State: ANoB5pk9SrldPR/k9n3JIGRCf+qNJ0FptRFmJGWmZNWoLiw50dwx9CwD
        dE+tQMpfBLCuLoQUGMmtfUuFtg==
X-Google-Smtp-Source: AA0mqf4BoK/U9B+Rh9EtaxBLhf3STxEGHiaY0hpQOQ8M8qltYekFMwQ1P3PvGG6uaIqRsP/AuFYexA==
X-Received: by 2002:a05:651c:12c4:b0:26f:db34:b387 with SMTP id 4-20020a05651c12c400b0026fdb34b387mr2051621lje.3.1670664676955;
        Sat, 10 Dec 2022 01:31:16 -0800 (PST)
Received: from [192.168.1.101] (abxh44.neoplus.adsl.tpnet.pl. [83.9.1.44])
        by smtp.gmail.com with ESMTPSA id z19-20020a05651c11d300b00279c10ae746sm515008ljo.140.2022.12.10.01.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Dec 2022 01:31:16 -0800 (PST)
Message-ID: <48bef9dd-b71c-b6aa-e853-1cf821e88b50@linaro.org>
Date:   Sat, 10 Dec 2022 10:31:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 2/2] net: ipa: add IPA v4.7 support
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, agross@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
References: <20221208211529.757669-1-elder@linaro.org>
 <20221208211529.757669-3-elder@linaro.org>
 <47b2fb29-1c2e-db6e-b14f-6dfe90341825@linaro.org>
 <fa6d342e-0cfe-b870-b044-b0af476e3905@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <fa6d342e-0cfe-b870-b044-b0af476e3905@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9.12.2022 21:22, Alex Elder wrote:
> On 12/8/22 3:22 PM, Konrad Dybcio wrote:
>>
>>
>> On 8.12.2022 22:15, Alex Elder wrote:
>>> Add the necessary register and data definitions needed for IPA v4.7,
>>> which is found on the SM6350 SoC.
>>>
>>> Co-developed-by: Luca Weiss <luca.weiss@fairphone.com>
>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>> ---
>> [...]
>>> +
>>> +/* Memory configuration data for an SoC having IPA v4.7 */
>>> +static const struct ipa_mem_data ipa_mem_data = {
>>> +    .local_count    = ARRAY_SIZE(ipa_mem_local_data),
>>> +    .local        = ipa_mem_local_data,
>>> +    .imem_addr    = 0x146a9000,
>>> +    .imem_size    = 0x00002000,
>> Should probably be
>>
>> 0x146a8000
>> 0x00003000
>>
>> with an appropriate change in dt to reserve that region.
>>
>> Qualcomm does:
>> ipa@... { qcom,additional-mapping = <0x146a8000 0x146a8000 0x2000>; };
>>
>> which covers 0x146a8000-0x146a9fff
>>
>> plus
>>
>> imem@.. { reg = <0x146aa000 0x1000>; };
>>
>> which in total gives us 0x146a8000-0x146aafff
> 
> Can you tell me where you found this information?
[1], [2]

> 
>> That would also mean all of your writes are kind of skewed, unless
>> you already applied some offsets to them.
> 
> This region is used by the modem, but must be set up
> by the AP.
> 
>> (IMEM on 6350 starts at 0x14680000 and is 0x2e000 long, as per
>> the bootloader memory map)
> 
> On SM7250 (sorry, I don't know about 7225, or 6350 for that matter),
> the IMEM starts at 0x14680000 and has length 0x2c000.  However that
> memory is used by multiple entities.  The portion set aside for IPA
> starts at 0x146a9000 and has size 0x2000.
> 
Not sure how 7250 relates to 6350, but I don't think there's much
overlap..


Konrad

[1] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.9.12.r1/arch/arm64/boot/dts/qcom/lagoon.dtsi#L3698-L3707

[2] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.9.12.r1/arch/arm64/boot/dts/qcom/lagoon.dtsi#L1004-L1045
>                     -Alex
> 
>> Konrad
> 
