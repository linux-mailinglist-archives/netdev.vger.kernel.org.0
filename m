Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEDB552B8A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiFUHMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345537AbiFUHMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:12:43 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F618222BA
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:12:35 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ej4so14118584edb.7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 00:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rZJJbO9tmvN3skIIZSoGEawfNisxmFvqIY3afbWNk0k=;
        b=x2XlL1khCI/cWLpErGp+GFQadkpgwCUNIt+y1cFMvLTJ8QTD7icTnugWki3Lf7ie0f
         CzpfEy2ptqM4Or39eOzCVLWFUbbJ2PC9H0+mGo9O0onCHMRUuPsb3WAeSPuJruh0qEHI
         hqvnIxLIflrU6ZD/ACM33uG6PKa2OeNCvg6GXPKN3zkTWRDrNdF9rOWDhcki1S8gcNaQ
         Q1z1S5ftZ1jeXv98c1WhlbFXcXrCnDbSkd7cVLYa9sLp7OyywI19eVDbBck+Xtr+lToJ
         hPC69Xik8O4j6WZJgBESUKybjciq3r2LktSTdr4j8UhSCxkdLptWhSOGA+Po/D8cl8tM
         umDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rZJJbO9tmvN3skIIZSoGEawfNisxmFvqIY3afbWNk0k=;
        b=eLTIZzstVnGVrkfT9Fshon5j2cIzRvFV8zyyeq/kOlfApxFffuvSqPSojXQAxhEyMx
         FovFRTlkdx0NTCXruDdmTLDb/kk09uoWcpn8D2hl+ROpiybxBPnppTC0Hlml3VzEDTJU
         LXgeqeqIbwtUN+lxV/jRlimEtp0ryTXmWGUy4bPWc1WnoAv2DyJ/euQcOatZSYT7I0fh
         BNCrMDJ5365Dwh2vVM9eQxDapnydQi1h3wVVv0GWjcZNnMF62jCYX4R81WMU+zaS1Q9W
         CBjMooxfg2kCut0bWSW0AhFDPkjQ+9osml81kUZI8QNth0wVa757uE/OQ1hwrKVn6R04
         Ci2A==
X-Gm-Message-State: AJIora8zX9ItgoNrRW8Rrzd0EnopKT8o93IGp4O1AAr6uBKzOYdY7/Io
        AbmqLXSFw2K3OoW+o+YTS8zCYw==
X-Google-Smtp-Source: AGRyM1vrygzsyf1XkfWBidpFgjIUaEYcyGJLiMBB9DaYIq+y5D3cEOQOG47m6jnRBlKuRDUEajM72Q==
X-Received: by 2002:aa7:c1c7:0:b0:435:5cb2:c202 with SMTP id d7-20020aa7c1c7000000b004355cb2c202mr27028883edp.10.1655795553854;
        Tue, 21 Jun 2022 00:12:33 -0700 (PDT)
Received: from [192.168.0.216] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id e16-20020a170906315000b0071cef6c53aesm6096627eje.0.2022.06.21.00.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 00:12:33 -0700 (PDT)
Message-ID: <1c2bbc12-0aa5-6d2a-c701-577ce70f7502@linaro.org>
Date:   Tue, 21 Jun 2022 09:12:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-2-sean.anderson@seco.com>
 <110c4a4b-8007-1826-ee27-02eaedd22d8f@linaro.org>
 <535a0389-6c97-523d-382f-e54d69d3907e@seco.com>
 <d79239ce-3959-15f8-7121-478fc6d432e4@linaro.org>
 <e6ed314d-290f-ace5-b0ff-01a9a2edca88@seco.com>
 <16684442-35d4-df51-d9f7-4de36d7cf6fd@linaro.org>
 <50fa16ce-ac24-8e4c-5d81-0218535cd05c@seco.com>
 <e922714b-29c7-0f41-9e5c-9a0aef9fb5de@linaro.org>
 <5d724f49-71c4-96ad-b756-06b5683fa112@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5d724f49-71c4-96ad-b756-06b5683fa112@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/06/2022 20:51, Sean Anderson wrote:
> On 6/20/22 2:21 PM, Krzysztof Kozlowski wrote:
>>>>> - samsung_usb2_phy_config in drivers/phy/samsung/
>>>>
>>>> This one is a good example - where do you see there compatibles with
>>>> arbitrary numbers attached?
>>>
>>> samsung_usb2_phy_of_match in drivers/phy/samsung/phy-samsung-usb2.c
>>>
>>> There is a different compatible for each SoC variant. Each compatible selects a struct
>>> containing
>>>
>>> - A list of phys, each with custom power on and off functions
>>> - A function which converts a rate to an arbitrary value to program into a register
>>>
>>> This is further documented in Documentation/driver-api/phy/samsung-usb2.rst
>>
>> Exactly, please follow this approach. Compatible is per different
>> device, e.g. different SoC variant. Of course you could have different
>> devices on same SoC, but "1" and "2" are not different devices.
> 
> (in this case they are)

In a meaning of descriptive compatible - it's not.

>>>
>>> - For some SerDes on the same SoC, these fields are reserved
>>
>> That all sounds like quite different devices, which indeed usually is
>> described with different compatibles. Still "xxx-1" and "xxx-2" are not
>> valid compatibles. You need to come with some more reasonable name
>> describing them. Maybe the block has revision or different model/vendor.
> 
> There is none AFAIK. Maybe someone from NXP can comment (since there are many
> undocumented registers).

Maybe it's also possible to invent some reasonable name based on
protocols supported? If nothing comes then please add a one-liner
comment explaining logic behind 1/2 suffix.

>>> The compatibles suggested were "fsl,ls1046-serdes-1" and -2. As noted above, these are separate
>>> devices which, while having many similarities, have different register layouts and protocol
>>> support. They are *not* 100% compatible with each other. Would you require that clock drivers
>>> for different SoCs use the same compatibles just because they had the same registers, even though
>>> the clocks themselves had different functions and hierarchy?
>>
>> You miss the point. Clock controllers on same SoC have different names
>> used in compatibles. We do not describe them as "vendor,aa-clk-1" and
>> "vendor,aa-clk-2".
>>
>> Come with proper naming and entire discussion might be not valid
>> (although with not perfect naming Rob might come with questions). I
>> cannot propose the name because I don't know these hardware blocks and I
>> do not have access to datasheet.
>>
>> Other way, if any reasonable naming is not possible, could be also to
>> describe the meaning of "-1" suffix, e.g. that it does not mean some
>> index but a variant from specification.
> 
> The documentation refers to these devices as "SerDes1", "SerDes2", etc.
> 
> Wold you prefer something like
> 
> serdes0: phy@1ea0000 {
> 	compatible = "fsl,ls1046a-serdes";
> 	variant = <0>;
> };

No, it's the same problem, just embeds compatible in different property.

Best regards,
Krzysztof
