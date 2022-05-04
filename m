Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2551979F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345093AbiEDGzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345090AbiEDGzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:55:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3BC20BFF
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:51:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n10so1073599ejk.5
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 23:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IjvhY+zx5+cDpT9+ShvD2wIBZoNgfMhne2yk1qc9gqc=;
        b=eic7UFuqSIPHIgZ3jSbVJ+u7i6PpSPVY7e3+WBdyR38qmzv+FWuisIiMkWe2KpzS4R
         UnwvMe2voQGKKSuW8ZMI5JMcJuI3KmJ8A1rPmi9AAtCmgjaT0GP0zo5gAqixMJ8VDV0A
         ZWXOYJlyVr6o+MnZZ6r5g2M58A7uEP4AHQtRmLBwEd6U/CAxwh0Rj84HbMsS1dJMUkQe
         6PXQTqyiXSz90DZ2JHQG9chh1I2MpCxYverENN9RufkpiACPTDTLdX76RjFtceWLbva6
         Ewux8w8+l0bPoexCeRMh+kTwR6MujG9lElvDL0zkzoJvMFTp3ZomeFypBMZbY7WGWlPH
         fuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IjvhY+zx5+cDpT9+ShvD2wIBZoNgfMhne2yk1qc9gqc=;
        b=2sJ9rbvP+dJ403HQHyyY53sXzPlaCIZoW4WokFwuJEZvT6ZD5Dn7KSKycgV1j/lbU7
         Zy1zwaJAa2l0XJE0pkfWh7cespkVEl3ZS+lnTw9ZqfrJGyiuRzG3xtfqQxiIOfhJ/ZrF
         RvvVDl5VHBZtGYdlSPA2gG88tUkndtm0dZ3jvnDrnlIgheQf+xt6obPJxawC6Ehhp5zy
         ozbT+fpkOrZF5YU57EjajVCZZVJ6Sma+gbZIDk1/IcGJxESHWkAr79J+ZLVkAqhw6Yn4
         o6Px5Dcd65uQ+DZG7LBygaKayAKhUtEnsNcU2SP3CzxXmxA8KgfqamrLazswIfFIOnQT
         l0Ww==
X-Gm-Message-State: AOAM531zstzkwt9kCrTQxsnoxYegV9++CbO2Ht/q/YrwIGazqIs07Omj
        7AQvX5PxUSANBLdfM01xLVoMWw==
X-Google-Smtp-Source: ABdhPJwsbQjpa6yGQ2U7HY/Ae/uny1/EgLYf0Rw+8IrJbKAirCTUtkOfDH52DAkl4hVSuhbxoPgI8w==
X-Received: by 2002:a17:906:a089:b0:6ef:e9e6:1368 with SMTP id q9-20020a170906a08900b006efe9e61368mr18809029ejy.626.1651647102720;
        Tue, 03 May 2022 23:51:42 -0700 (PDT)
Received: from [192.168.0.208] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id el8-20020a170907284800b006f3ef214e0asm5370519ejc.112.2022.05.03.23.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 23:51:42 -0700 (PDT)
Message-ID: <95aea078-3e85-79c3-79c0-430bd7c0fbae@linaro.org>
Date:   Wed, 4 May 2022 08:51:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Aw: Re: Re: [RFC v1] dt-bindings: net: dsa: convert binding for
 mediatek switches
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220502153238.85090-1-linux@fw-web.de>
 <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org>
 <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25>
 <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org>
 <trinity-213ab6b1-ccff-4429-b76c-623c529f6f73-1651590197578@3c-app-gmx-bap25>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <trinity-213ab6b1-ccff-4429-b76c-623c529f6f73-1651590197578@3c-app-gmx-bap25>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/05/2022 17:03, Frank Wunderlich wrote:
> 
> have not posted this version as it was failing in dtbs_check, this was how i tried:
> 
> https://github.com/frank-w/BPI-R2-4.14/blob/8f2033eb6fcae273580263c3f0b31f0d48821740/Documentation/devicetree/bindings/net/dsa/mediatek.yaml#L177

You have mixed up indentation of the second if (and missing -).

(...)

>>>
>>> basicly this "ports"-property should be required too, right?
>>
>> Previous binding did not enforce it, I think, but it is reasonable to
>> require ports.
> 
> basicly it is required in dsa.yaml, so it will be redundant here
> 
> https://elixir.bootlin.com/linux/v5.18-rc5/source/Documentation/devicetree/bindings/net/dsa/dsa.yaml#L55
> 
> this defines it as pattern "^(ethernet-)?ports$" and should be processed by dsa-core. so maybe changing it to same pattern instead of moving up as normal property?

Just keep what is already used in existing DTS.

>>> for 33 there seem no constant..all other references to pio node are with numbers too and there seem no binding
>>> header defining the gpio pins (only functions in include/dt-bindings/pinctrl/mt7623-pinfunc.h)
>>
>> ok, then my comment
> 
> you mean adding a comment to the example that GPIO-flags/constants should be used instead of magic numbers?

I think something was cut from my reply. I wanted to say:
"ok, then my comment can be skipped"

But I think your check was not correct. I looked at bpi-r2 DTS (mt7623n)
and pio controller uses GPIO flags.

Best regards,
Krzysztof
