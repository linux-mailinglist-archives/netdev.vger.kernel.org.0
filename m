Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5949A51FD05
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbiEIMkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiEIMkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:40:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0361511E1F9
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 05:36:10 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so19216632wrg.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 05:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jCx7kbE4U1tF0YGrW+htV6mu4Y5YtAaVSHTYv9DBZvE=;
        b=lO/ZAzzGt/HM2WqkUT6jCN0LL3c8MfhZh8g4Xv5Ig+cJLVxTZR+D84rQDRIFFn3D36
         zByTMllwgZwPx61O5akvMB6ESBVVpOT3y5HsIYOvizd0KEfZw0miQrpXes/JVXo+/kkX
         RWH5YGytWA1jwnfEBhjyxkxoBFAINRof1LGcNWOrnW06kTEyCyFWN+wasbUH2ULkn7Zz
         badItzk+lK9C1OxZ9mWxrkKoLN/08HFV5oSnvZ6x7M5LJawbRaxWdkgEqAl1/ZYFQF9M
         GJwa8TpesBk+RveJ3dIxfsnS7dPUz4i5OSZ237YqgbsrZGRldoI+D0hAt0sIxHIt+Ek1
         DY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jCx7kbE4U1tF0YGrW+htV6mu4Y5YtAaVSHTYv9DBZvE=;
        b=NMiPO9Op5hpXf3ywastkemXqQKompTXPBrD76Xz0c7wfzWNoXRJhgTuyhiLE+E7z1j
         b++1smmkNK2KfywhRM3dX2aLLvZRugaAHdNAAJVd6JNzrW0+lN/DpVZ3kT0tzjKP0EBG
         9YlZiGoJRf5R6Prp54lHxl6lT5xSEaRRpv6R9fctso7UliSCMkIPa7za0xBB895vD3II
         XlQxicBQ8YpR9LozE0/wCHnBoLT6kZJ2KOsqH7r7838w0lAf4E9I9yiS1nuN4/PEL/RC
         oBJzs1uZvPuE8MKTh1ToDyq7YPepOTfNdIJXwQsl8bUTFRsfs0KYLmjmduUwylAADH3M
         6tkQ==
X-Gm-Message-State: AOAM532AhAJdJnWheQNYS+kYDxPSnhipKRoFRBxIEjcFvxo5crzzp7+h
        3pX0KpXBvTATzl/eepw++1JoiQ==
X-Google-Smtp-Source: ABdhPJyDlPVKbgpRvBySpk6wiBE1xHgwrmVXo1c36Ltaz4gCgVg7+qbex2foPxQyHkJBEXrR+hEuog==
X-Received: by 2002:a5d:5707:0:b0:20a:c768:bc8 with SMTP id a7-20020a5d5707000000b0020ac7680bc8mr13772614wrv.565.1652099768554;
        Mon, 09 May 2022 05:36:08 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id v12-20020a5d610c000000b0020c5253d8e1sm2558192wrt.45.2022.05.09.05.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:36:07 -0700 (PDT)
Message-ID: <db888673-7513-e084-9266-1848e4cf36a4@solid-run.com>
Date:   Mon, 9 May 2022 15:36:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Andrew Lunn <andrew@lunn.ch>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-2-josua@solid-run.com>
 <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 05.05.22 um 23:24 schrieb Krzysztof Kozlowski:
> On 28/04/2022 10:28, Josua Mayer wrote:
>
> Thank you for your patch. There is something to discuss/improve.
>
>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> index 1129f2b58e98..3e0c6304f190 100644
>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> @@ -36,6 +36,23 @@ properties:
>>       enum: [ 4, 8, 12, 16, 20, 24 ]
>>       default: 8
>>   
>> +  adi,phy-output-clock:
>> +    description: Select clock output on GP_CLK pin. Three clocks are available:
>> +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
>> +      The phy can also automatically switch between the reference and the
>> +      respective 125MHz clocks based on its internal state.
>> +    $ref: /schemas/types.yaml#/definitions/string
>> +    enum:
>> +    - 25mhz-reference
>> +    - 125mhz-free-running
>> +    - 125mhz-recovered
>> +    - adaptive-free-running
>> +    - adaptive-recovered
> Missing two spaces of indentation for all these items.
>
>> +
>> +  adi,phy-output-reference-clock:
>> +    description: Enable 25MHz reference clock output on CLK25_REF pin.
>> +    $ref: /schemas/types.yaml#/definitions/flag
> This could be just "type:boolean".
I will change it accordingly, thanks.
> Best regards,
> Krzysztof
