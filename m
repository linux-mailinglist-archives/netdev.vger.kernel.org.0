Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB85E389321
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 17:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355040AbhESQAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 12:00:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35236 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347042AbhESQAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 12:00:09 -0400
Received: from mail-qk1-f197.google.com ([209.85.222.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1ljOau-0007Bx-6L
        for netdev@vger.kernel.org; Wed, 19 May 2021 15:58:48 +0000
Received: by mail-qk1-f197.google.com with SMTP id d18-20020a05620a2052b02902eabc6fa35eso10097922qka.17
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 08:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pyV2d2Dm7FbLW6jpU1vNqIjLufpoIxq3GNUEX32r3y8=;
        b=r+w45QW/kaVFsAMEJ31Cx8xnFq0pHvJgExaudPAuEYzfT81bgt1/jNhasiENZTXEdv
         sZbOmNlQeTYcntZtX9qmN1hxDuGQqSSLNorpvpihpeQupt8MYd/w82S6C7VkHCIxV5xI
         CwHfgL4zVIdFibyqXZvOakp04Aos92k0y//xZOKzrygi1LUTe8XPNIf9LPKLh16VPXa6
         WDMFnfiKhcip20ZFPB0o2ko8lU2uY7vO4E6gljsDd0ogqqtNJiRsd4qHBdgHnNZjekAJ
         1+PH2NOBPogW2nE8Vin8YNlh8Vuc+DgGQaDgG5S0/1EMTraH81wsDNtfCCX3/34TfOy8
         VXxg==
X-Gm-Message-State: AOAM533HhVxCXDuaKb1IkLYMCgcUWWXR2qzlN+5PgXjlJSGhiTjmhQ8I
        vk2aNC3XyN4tNyC8hmojiGZMKQg5Y4t3yC0wOKKprHYdBjYAKTEzYnZpsB6A58qQU5AELTwAQ2A
        +yHPK7ri2aLcYDGTDVr1zyzeDjg/EwC+1Ww==
X-Received: by 2002:ac8:7303:: with SMTP id x3mr66815qto.271.1621439927340;
        Wed, 19 May 2021 08:58:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxKfWZ9Hkx87AFnUL08UP+63a3AXZ8GTgf1NHuUoE14S1QmoHmuzXJprpkAAEkUZ/aGGa1tA==
X-Received: by 2002:ac8:7303:: with SMTP id x3mr66800qto.271.1621439927143;
        Wed, 19 May 2021 08:58:47 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id r62sm46061qkc.128.2021.05.19.08.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 08:58:46 -0700 (PDT)
Subject: Re: [linux-nfc] Re: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
To:     Stephan Gerhold <stephan@gerhold.net>,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
 <YKPWgSnz7STV4u+c@gerhold.net>
 <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
 <YKTHXzUhcYa5YJIs@gerhold.net>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <10b3a50e-877c-d5b1-3e35-e5dff4ef53d8@canonical.com>
Date:   Wed, 19 May 2021 11:58:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKTHXzUhcYa5YJIs@gerhold.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2021 04:07, Stephan Gerhold wrote:
> On Tue, May 18, 2021 at 11:25:55AM -0400, Krzysztof Kozlowski wrote:
>> On 18/05/2021 11:00, Stephan Gerhold wrote:
>>> On Tue, May 18, 2021 at 10:30:43AM -0400, Krzysztof Kozlowski wrote:
>>>> On 18/05/2021 09:39, Stephan Gerhold wrote:
>>>>> s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
>>>>> the clock is needed for the current operation. This GPIO can be either
>>>>> connected directly to the clock provider, or must be monitored by
>>>>> this driver.
>>>>>
>>>>> As an example for the first case, on many Qualcomm devices the
>>>>> NFC clock is provided by the main PMIC. The clock can be either
>>>>> permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
>>>>> only when requested through a special input pin on the PMIC
>>>>> (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
>>>>>
>>>>> On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
>>>>> is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
>>>>> only when necessary. However, to make that work the s3fwrn5 driver
>>>>> must keep the RPM_SMD_BB_CLK2_PIN clock enabled.
>>>>
>>>> This contradicts the code. You wrote that pin should be kept enabled
>>>> (somehow... by driver? by it's firmware?) but your code requests the
>>>> clock from provider.
>>>>
>>>
>>> Yeah, I see how that's a bit confusing. Let me try to explain it a bit
>>> better. So the Samsung Galaxy A5 (2015) has a "S3FWRN5XS1-YF30", some
>>> variant of S3FWRN5 I guess. That S3FWRN5 has a "XI" and "XO" pin in the
>>> schematics. "XO" seems to be floating, but "XI" goes to "BB_CLK2"
>>> on PM8916 (the main PMIC).
>>>
>>> Then, there is "GPIO2/NFC_CLK_REQ" on the S3FWRN5. This goes to
>>> GPIO_2_NFC_CLK_REQ on PM8916. (Note: I'm talking about two different
>>> GPIO2 here, one on S3FWRN5 and one on PM8916, they just happen to have
>>> the same number...)
>>>
>>> So in other words, S3FWRN5 gets some clock from BB_CLK2 on PM8916,
>>> and can tell PM8916 that it needs the clock via GPIO2/NFC_CLK_REQ.
>>>
>>> Now the confusing part is that the rpmcc/clk-smd-rpm driver has two
>>> clocks that represent BB_CLK2 (see include/dt-bindings/clock/qcom,rpmcc.h):
>>>
>>>   - RPM_SMD_BB_CLK2
>>>   - RPM_SMD_BB_CLK2_PIN
>>>
>>> (There are also *_CLK2_A variants but they are even more confusing
>>>  and not needed here...)
>>>
>>> Those end up in different register settings in PM8916. There is one bit
>>> to permanently enable BB_CLK2 (= RPM_SMD_BB_CLK2), and one bit to enable
>>> BB_CLK2 based on the status of GPIO_2_NFC_CLK_REQ on PM8916
>>> (= RPM_SMD_BB_CLK2_PIN).
>>>
>>> So there is indeed some kind of "AND" inside PM8916 (the register bit
>>> and "NFC_CLK_REQ" input pin). To make that "AND" work I need to make
>>> some driver (here: the s3fwrn5 driver) enable the clock so the register
>>> bit in PM8916 gets set.
>>
>> Thanks for the explanation, it sounds good. The GPIO2 (or how you call
>> it NFC_CLK_REQ) on S3FWRN5 looks like non-configurable from Linux point
>> of view. Probably the device firmware plays with it always or at least
>> handles it in an unknown way for us.
>>
> 
> FWIW, I was looking at some more s3fwrn5 code yesterday and came
> across this (in s3fwrn5_nci_rf_configure()):
> 
> 	/* Set default clock configuration for external crystal */
> 	fw_cfg.clk_type = 0x01;
> 	fw_cfg.clk_speed = 0xff;
> 	fw_cfg.clk_req = 0xff;
> 	ret = nci_prop_cmd(info->ndev, NCI_PROP_FW_CFG,
> 		sizeof(fw_cfg), (__u8 *)&fw_cfg);
> 	if (ret < 0)
> 		goto out;
> 
> It does look quite suspiciously like that configures how s3fwrn5 expects
> the clock and possibly (fw_cfg.clk_req?) how GPIO2 behaves. But it's not
> particularly useful without some documentation for the magic numbers.

Right, without documentation of FW protocol there is not much we can
deduct here. There is no proof even that the comment matches actual code.

Dear Bongsu,
Maybe you could share some details about clock selection?

> 
> Personally, I just skip all firmware/RF configuration (which works thanks
> to commit 4fb7b98c7be3 ("nfc: s3fwrn5: skip the NFC bootloader mode")).
> That way, S3FWRN5 just continues using the proper configuration
> that was loaded by the vendor drivers at some point. :)

But isn't that configuration lost after power off?


Best regards,
Krzysztof
