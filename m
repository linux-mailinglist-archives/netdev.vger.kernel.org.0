Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0EE63AB45
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiK1Okg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiK1Okd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:40:33 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DCE220E2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 06:40:31 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id bn5so13397840ljb.2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 06:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rxl7YrMvA0F9XMtLgK6+hpZFxRBfqgt+eTWoNu6iRo8=;
        b=NF3MUsLO+B6UNx8ExIv7IuRKSaM0xTVI3KgPrPUJQrbRqxLFD/3YZjeE6FP35wcoCP
         YHsCeFThsTdhZLMIOY8ClukFneGUA70nkSiNjcICbs9vVrXf0o6apXuVxh3AVE2wA55h
         57XgK4oF1DosZhWCtO12W0hd3mWrhY+jDRm2uvzJSa3FHPF95eB/JkKZ6iOVUIhBpvVM
         RFsMt4uenAXgLsm72nL8xuWoa9A91tJuHUJ4ioOTGcNZrcLD1YieyWMeWy7Isg+sbjPs
         /d4VB5tSa6mfjZfOzTeWIV85dBsGVY7Cmd8cZWckqQFZjW2gofi2ESsrLMFt6LKmZU8m
         tAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxl7YrMvA0F9XMtLgK6+hpZFxRBfqgt+eTWoNu6iRo8=;
        b=aU2eU8vC2KhmJGKMOTee990/Yeg0yWolFg063UUDwegKJVK9eB4S/VIKk0HTWWMogK
         gdhtOeuJ3DxH0R93Tn+ycc+APFQh5y4qCVgg7xfQm7yv1RfLX1/KjTeAzdE2fh6mCjxs
         /FYXB05NDqvdG1JSHsOB8WKwt5grtzgooj5nbNqgRWky5Vff+K4v4vITqAlgVdOSxQlG
         9ukqVWfwEpKuP4btrjc7wEv6uw4mmoEIQ1BApPeG5ZnHd6E/jvE0saO0F2NHnmmki328
         LBMt8NIL4MHF5mJrUvOD56AXqtHKJuCQpXZ0vMzSzDdXSVwoz1NW+jCE/ToCQtL7kQU7
         VIIQ==
X-Gm-Message-State: ANoB5pmzYuAf7fnhdd9Rs0Pqvv5lYr/kN4eJVIyFiRo+Xg32eaad90jz
        9IjhPThVyyo7i8ULnHM/WgNNwg==
X-Google-Smtp-Source: AA0mqf48AqNNUd1yKamAjh8q6tpCyrE7XgdMx5TWOco6SlMkf2Yjc+7xVsRjJ9kEtkN47K+bUqOc+A==
X-Received: by 2002:a2e:9611:0:b0:276:b134:b04c with SMTP id v17-20020a2e9611000000b00276b134b04cmr11149799ljh.492.1669646431213;
        Mon, 28 Nov 2022 06:40:31 -0800 (PST)
Received: from [192.168.1.101] (95.49.125.236.neoplus.adsl.tpnet.pl. [95.49.125.236])
        by smtp.gmail.com with ESMTPSA id q21-20020a05651232b500b004ac980a1ba1sm1754473lfe.24.2022.11.28.06.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 06:40:30 -0800 (PST)
Message-ID: <28991d2d-d917-af47-4f5f-4e8183569bb1@linaro.org>
Date:   Mon, 28 Nov 2022 15:40:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Linus Walleij <linus.walleij@linaro.org>,
        Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "~postmarketos/upstreaming@lists.sr.ht" 
        <~postmarketos/upstreaming@lists.sr.ht>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
 <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
 <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.11.2022 22:45, Linus Walleij wrote:
> On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> wrote:
>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>
>>> On 25.11.2022 12:53, Kalle Valo wrote:
>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>
>>>>> On 21.11.2022 14:56, Linus Walleij wrote:
>>>>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>>>>>>
>>>>>>> I can think of a couple of hacky ways to force use of 43596 fw, but I
>>>>>>> don't think any would be really upstreamable..
>>>>>>
>>>>>> If it is only known to affect the Sony Xperias mentioned then
>>>>>> a thing such as:
>>>>>>
>>>>>> if (of_machine_is_compatible("sony,xyz") ||
>>>>>>     of_machine_is_compatible("sony,zzz")... ) {
>>>>>>    // Enforce FW version
>>>>>> }
>>>>>>
>>>>>> would be completely acceptable in my book. It hammers the
>>>>>> problem from the top instead of trying to figure out itsy witsy
>>>>>> details about firmware revisions.
>>>>>>
>>>>>> Yours,
>>>>>> Linus Walleij
>>>>>
>>>>> Actually, I think I came up with a better approach by pulling a page
>>>>> out of Asahi folks' book - please take a look and tell me what you
>>>>> think about this:
>>>>>
>>>>> [1]
>>>>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
>>>>> [2]
>>>>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7
> 
> Something in this direction works too.
> 
> The upside is that it tells all operating systems how to deal
> with the firmware for this hardware.
> 
>>>> Instead of a directory path ("brcm/brcmfmac43596-pcie") why not provide
>>>> just the chipset name ("brcmfmac43596-pcie")? IMHO it's unnecessary to
>>>> have directory names in Device Tree.
>>>
>>> I think it's common practice to include a full $FIRMWARE_DIR-relative
>>> path when specifying firmware in DT, though here I left out the board
>>> name bit as that's assigned dynamically anyway. That said, if you don't
>>> like it, I can change it.
>>
>> It's just that I have understood that Device Tree is supposed to
>> describe hardware and to me a firmware directory "brcm/" is a software
>> property, not a hardware property. But this is really for the Device
>> Tree maintainers to decide, they know this best :)
> 
> I would personally just minimize the amount of information
> put into the device tree to be exactly what is needed to find
> the right firmware.
> 
> brcm,firmware-compatible = "43596";
> 
> since the code already knows how to conjure the rest of the string.
> 
> But check with Rob/Krzysztof.
> 
> Yours,
> Linus Walleij

Krzysztof, Rob [added to CC] - can I have your opinions?

Konrad


