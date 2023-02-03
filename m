Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD02689029
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjBCHJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjBCHJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:09:46 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1BE6B003
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:09:32 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id y1so3798878wru.2
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=91H7aAbtElqTaptJ9Vb0dyS9FKfuyA5IbH1LTzOZk1w=;
        b=kxIW9UUpSvaia8/H81GLavJ4mQWTC9NVIF/UM8mTgquarXVcOYW223Tp1ZbgavI1u7
         2OCqXuAkDBtFRPciI5sntZWnwYqZEjZzskVKWufTIDy7NQNMgH0pg4MV8gAHiHtY9VR3
         0hcBk2FtFixn+Ot9diJncYJwYaKiytsJiCtQwf6CgqZ06g1fXS+SlbtLcGyRyt5gcHRA
         hpzfB3KH3SfxhQth5axvjIiwVLi1AmSiljimg8k/I84mFBVytz1RSqGvqTLcVC6tL6D/
         sqElxkSTdl5eV/XCsViXTGPTK5YR18lY7c5xvF3BF/eWlofQ9DuvgmoT7LYI+Gmg/j3I
         7K+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91H7aAbtElqTaptJ9Vb0dyS9FKfuyA5IbH1LTzOZk1w=;
        b=O/lKu36luHEDU2Rgofb7XZLdbGVvpEUflmyLIK42SjQfVyhFiF7uhIvv5Yu5wvBJeZ
         hBpZsb/14FZPJBn7VEWG2p2RIIiwpLGlewtAoAoNG61hXtG6RIzxJQEym0ekCeP65jEw
         M95UbI/9tkQw4l2avmGY9C7XjTZWjD+hj4A/4B0YQzrPXQygymsDgg9bwXsKsJAAK9T/
         y6WToPy8CZhRFdx/S4ddp+wxpZlqMu1k3avdMWR6mg25v2yP7WdRiaMVm0XNsEpPn6U9
         Hwji1FIw3hiP74n8gn/H+29n5XR4pEe56v4Ucf7fMY+ee8Pl4RVoQr+iKnwSXS4mfIbd
         /Mnw==
X-Gm-Message-State: AO0yUKWRFaO7u7KV9HQYent5RBQuxZ4fE8Cvit5XqMoReqBnoPOSQFwx
        jNvuAh8G4m1CKAk507/WJR6QkA==
X-Google-Smtp-Source: AK7set8TwQRjsPo9v5JN/ENZh1nluMWyKJJlKIkzIlbEhiGRce7jfa72hOsMKBiovU00TszO03eK6g==
X-Received: by 2002:a05:6000:184a:b0:2bf:d2fe:8647 with SMTP id c10-20020a056000184a00b002bfd2fe8647mr11234697wri.70.1675408170631;
        Thu, 02 Feb 2023 23:09:30 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f9-20020a5d4dc9000000b002bfb37497a8sm1245058wru.31.2023.02.02.23.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 23:09:30 -0800 (PST)
Message-ID: <870f6ec5-5378-760b-7a30-324ee2d178cf@linaro.org>
Date:   Fri, 3 Feb 2023 08:09:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 6/7] riscv: dts: starfive: jh7110: Add ethernet device
 node
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-7-yanhong.wang@starfivetech.com>
 <55f020de-6058-67d2-ea68-6006186daee3@linaro.org>
 <f22614b4-80ae-8b16-b53e-e43c44722668@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <f22614b4-80ae-8b16-b53e-e43c44722668@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/02/2023 04:14, yanhong wang wrote:
> 
> 
> On 2023/1/18 23:51, Krzysztof Kozlowski wrote:
>> On 18/01/2023 07:17, Yanhong Wang wrote:
>>> Add JH7110 ethernet device node to support gmac driver for the JH7110
>>> RISC-V SoC.
>>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> ---
>>>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 93 ++++++++++++++++++++++++
>>>  1 file changed, 93 insertions(+)
>>>
>>> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>> index c22e8f1d2640..c6de6e3b1a25 100644
>>> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
>>> @@ -433,5 +433,98 @@
>>>  			reg-shift = <2>;
>>>  			status = "disabled";
>>>  		};
>>> +
>>> +		stmmac_axi_setup: stmmac-axi-config {
>>
>> Why your bindings example is different?
>>
> 
> There are two gmacs on the StarFive VF2 board, and the two
> gmacs use the same configuration on axi, so the 
> stmmac_axi_setup is independent, which is different
> from the bindings example.
> 
> 
>> Were the bindings tested? Ahh, no they were not... Can you send only
>> tested patches?
>>
>> Was this tested?
>>
> Yes, the bindings have been tested on the StarFive VF2 board and work normally.

Then please tell me how did you test the bindings on the board? How is
it even possible and how the board is related to bindings? As you could
easily see from Rob's reply they fail, so I have doubts that they were
tested. If you still claim they were - please paste the output from
testing command.


Best regards,
Krzysztof

