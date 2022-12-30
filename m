Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2D659AFB
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 18:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiL3R2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 12:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiL3R2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 12:28:05 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FB21A232
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 09:28:04 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id v2so11413021ioe.4
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 09:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X6dzcadWG965pjXXGhRbOuxD3/hHkIfiEhSRMzTbYQg=;
        b=kZhoNNlFcLnGllEIgDT/7CXdj2TjQt8Qh+7ARl8Orcp1KeUK+VeotBlpKhLTuVxzXW
         MQHGfQepe2ok1lpP90gRGcrydNAd4wsF9hWeydamcQHg9JX1pUQEMGdjRtTRai7T8WHu
         yDISr88HRL6ZXF3btw0DLeXsl/60WWVQuODS+AlCkt6CQ04RH5tBLDhexR6qwwhctXP/
         VkSI35XZ4cLVlmYOqNW0ofRjtmQ1d+QmlkWXjKLbniw0jNlQXLKov2aKbgmvMd51EHtZ
         bq2hPCG0AGAlK8ZsOPhH4mQi3FoLlLbQ7N0a647X1UxXCFjladZ58fflDayv4rirmd2e
         m1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6dzcadWG965pjXXGhRbOuxD3/hHkIfiEhSRMzTbYQg=;
        b=AVswXZpzcnrjNnn70r8ETwD2YWGLNlqtqhdXL6/96TAVgtyVKALgwTUP/7eDBtZ+nT
         IPVRzh7BaDML7AC6ZS77jagEmcCNQ+uqZKAQdc2DhHSJr7TheN5pRDR7+/E97lA/SAJw
         CuuveAyuCaK8qrc7oSSWhL5E9Bit6uyxc3UFWxEoNrtktVFo039ALxbchHVqpOAXMRgK
         T6kjTaVPJFUsxLB4USUgs/pKuWe6bXBQp1OVPuDjUI+cGqm6NweKectQJZwzrajbkVto
         4tF8TgfG1UF/c19EqutnRepniKwSbycBt2AlxV51hTbeC0wduCfBg5Xe5KSBnrfyHJLM
         /SEA==
X-Gm-Message-State: AFqh2kpIlvm2LQyCSsyT9a95uIaXn9ZeYsNopjCK09OpA4Iy04SXheou
        dzCw2fNrFBDd8JsMEHElJPKb6Q==
X-Google-Smtp-Source: AMrXdXuo6HE7NOLaBqIP976Rae9ut1/0OVFHv6OHWbSC8uoDU2l8xUjDGS5VDFDHYWqtHDKbQeDOUA==
X-Received: by 2002:a5d:8f8f:0:b0:6e5:ef2:8451 with SMTP id l15-20020a5d8f8f000000b006e50ef28451mr21864429iol.20.1672421283282;
        Fri, 30 Dec 2022 09:28:03 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id q8-20020a0566022f0800b006cecd92164esm7828319iow.34.2022.12.30.09.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 09:28:02 -0800 (PST)
Message-ID: <20b2f7c3-6481-eabf-7c46-f5f38d258c62@linaro.org>
Date:   Fri, 30 Dec 2022 11:28:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 2/2] net: ipa: add IPA v4.7 support
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>, davem@davemloft.net,
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
 <48bef9dd-b71c-b6aa-e853-1cf821e88b50@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <48bef9dd-b71c-b6aa-e853-1cf821e88b50@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/22 3:31 AM, Konrad Dybcio wrote:
> 
> 
> On 9.12.2022 21:22, Alex Elder wrote:
>> On 12/8/22 3:22 PM, Konrad Dybcio wrote:
>>>
>>>
>>> On 8.12.2022 22:15, Alex Elder wrote:
>>>> Add the necessary register and data definitions needed for IPA v4.7,
>>>> which is found on the SM6350 SoC.
>>>>
>>>> Co-developed-by: Luca Weiss <luca.weiss@fairphone.com>
>>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> ---
>>> [...]

I'm finally getting back to this...  I'm about to send an
update to net-next to address your comment.  But before
doing that I'm going to explain my thinking on it.

>>>> +
>>>> +/* Memory configuration data for an SoC having IPA v4.7 */
>>>> +static const struct ipa_mem_data ipa_mem_data = {
>>>> +    .local_count    = ARRAY_SIZE(ipa_mem_local_data),
>>>> +    .local        = ipa_mem_local_data,
>>>> +    .imem_addr    = 0x146a9000,
>>>> +    .imem_size    = 0x00002000,
>>> Should probably be
>>>
>>> 0x146a8000
>>> 0x00003000

The IMEM memory region is a distinct from main memory, but
is "local" to certain parts of the SoC and is used for
specific things for faster access.  The size and location
of this region differs per-SoC.  Previously I believed this
to be the same for a given version of IPA, and as such the
range was defined in the "config data".  But I now know
that is not the case, and during this release cycle I
intend to get that fixed.

Anyway, for a given SoC, the whole IMEM region is used
by different entities.  For SM7550, for example, it is
divided into 6 parts of various sizes (100KB, 24KB, 32KB,
8KB, 8KB, and 4KB).  For IPA on this SoC, the offset is
0x146a9000, with size 0x2000.  Hence the range defined
above.

>>> with an appropriate change in dt to reserve that region.
>>>
>>> Qualcomm does:
>>> ipa@... { qcom,additional-mapping = <0x146a8000 0x146a8000 0x2000>; };
>>>
>>> which covers 0x146a8000-0x146a9fff
>>>
>>> plus
>>>
>>> imem@.. { reg = <0x146aa000 0x1000>; };
>>>
>>> which in total gives us 0x146a8000-0x146aafff
>>
>> Can you tell me where you found this information?
> [1], [2]

Following the first link, I see that this Sony device (which uses
IPA v4.7) uses MSM7225 as its SoC.  I am not able to verify the
values shown in the DTS file elsewhere, so in this case, that DTS
file is my best source for information.

The first link defines the IPA portion of IMEM at offset
0x146a8000, size 0x2000.  That's what I'll use here instead.

The other region you mention (in the second link) appears to
be a distinct part, which follows the part set aside for IPA
to use.  For SM7550, that part is "shared" and immediately
follows the IPA part, with size 0x1000.  So I believe that
is what the qcom,msm-imem@146aa000 is defining in the second
link you supply.

>>> That would also mean all of your writes are kind of skewed, unless
>>> you already applied some offsets to them.

Luca tested the code the way I defined it initially and found
it worked.  It's possible the part of IMEM defined by my patch
was just not used for it's intended purpose during his testing
and therefore he saw no obvious problems.

My plan is to patch "ipa_data-v4.7.c" to change the IMEM region
to have offset 0x146a8000, size 0x2000, as you suggested.  I will
supply this to Luca for testing (actually I think he already did),
and we'll go with that as the final location for the IPA portion
of IMEM for IPA v4.7.

Later (sometime soon) the definition of this IPA IMEM area will
get done differently--not defined in the "config data" files and
instead defined in DTS.  There is already an imem node available
(for example imem@146a5000 in "sc7280.dtsi"), so the fix *might*
involve using that.

					-Alex

>> This region is used by the modem, but must be set up
>> by the AP.
>>
>>> (IMEM on 6350 starts at 0x14680000 and is 0x2e000 long, as per
>>> the bootloader memory map)
>>
>> On SM7250 (sorry, I don't know about 7225, or 6350 for that matter),
>> the IMEM starts at 0x14680000 and has length 0x2c000.  However that
>> memory is used by multiple entities.  The portion set aside for IPA
>> starts at 0x146a9000 and has size 0x2000.
>>
> Not sure how 7250 relates to 6350, but I don't think there's much
> overlap..
> 
> 
> Konrad
> 
> [1] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.9.12.r1/arch/arm64/boot/dts/qcom/lagoon.dtsi#L3698-L3707
> 
> [2] https://github.com/sonyxperiadev/kernel/blob/aosp/LA.UM.9.12.r1/arch/arm64/boot/dts/qcom/lagoon.dtsi#L1004-L1045
>>                      -Alex
>>
>>> Konrad
>>

