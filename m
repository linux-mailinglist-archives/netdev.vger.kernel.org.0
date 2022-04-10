Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8814FAF96
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiDJSns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiDJSns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:43:48 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2039F36B48
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 11:41:36 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id i204-20020a1c3bd5000000b0038eb92fa965so103406wma.4
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 11:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=A1rfWzH4fgjPMrhWhDmpyiNf+0xujI8AbqGTUYKiaUg=;
        b=H0mKhqvjyO9KcvoivG+TE4uA+IB8V4agxhRyfXFP2rnLK00h6WFFSNtzuviz+BJ1wq
         8ZFKeunDRfRiJ37+fwQEoJJYCrFRC6gCwPlFuNc+CMS4ggJl90sHXUNAT+PY1yOn5+e2
         XDO1sALDY+pFHquBlC/IRQi38w2qRgJfdJre4aqHn7vYunZRvkahoF3Z8r2DkNoB+yLA
         gmJlv75BnkYm7mFLmm9zZ1d9Gibu8a/szUQDoSlfL+YCDQDqWyc3hrMhvw72kYFYVUrL
         DX9S0x8tipd3vqjowzLCeS6yuDvhDOw0+RcznoqokJk7H+nnyGXJF6p1ZRT6/42CAcNj
         5dYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A1rfWzH4fgjPMrhWhDmpyiNf+0xujI8AbqGTUYKiaUg=;
        b=nBGs90QGnKiKbTU8zZvbpcuIhuD1mbHKZEicNT1ldrHLSaL98mA3SS3yaifBfmuAGx
         f37RLIt/D0zf8aH+wAZcMc8lulgMnklWr/Zs6WcXvosMLtLzRuWdbb6liI2AGcV4dqOj
         XKixcvmMTVclCWZHrh6hi1K4ivqC1t9iGDBPyC3bDNhqB9hiulz41UK8r6aH4GtefvoH
         SengkLPDbZjOkWoAv6qBNOTpoMeyG1chSKNLwsyyegQwkKBpwa9n3V7lYuTeV95MmtN7
         m19PStxPWp7B1iK8NI3KsHQW6xThgDDvofR5HbRNuqLgvVDMcsTkbLplLM11gErpbLHY
         Qf9Q==
X-Gm-Message-State: AOAM531M2W9zFYKYrT7dNiiz7XNgUerPXS0MDEaS0BSE+60oTuC1bUV2
        Y3tNCdPhjVVcgCP2D514BSBSjA==
X-Google-Smtp-Source: ABdhPJxq5zfdvLS9ZK5Gea3PTlQQyCnutvO8q9NZjjUpdQ/Uc7XZtgE84KO7dM42UDCHdIeAKXiOBg==
X-Received: by 2002:a05:600c:1c24:b0:38e:a2c2:9f6f with SMTP id j36-20020a05600c1c2400b0038ea2c29f6fmr12081661wms.69.1649616094456;
        Sun, 10 Apr 2022 11:41:34 -0700 (PDT)
Received: from ?IPV6:2a10:8000:dc4b::1001? ([2a10:8000:dc4b::1001])
        by smtp.gmail.com with ESMTPSA id u11-20020a056000038b00b00203e5c9aa09sm34891966wrf.27.2022.04.10.11.41.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 11:41:34 -0700 (PDT)
Message-ID: <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
Date:   Sun, 10 Apr 2022 21:41:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220410104626.11517-2-josua@solid-run.com>
 <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

\o/

Thank you for the quick reply!

Am 10.04.22 um 17:21 schrieb Krzysztof Kozlowski:
> On 10/04/2022 12:46, Josua Mayer wrote:
>> The ADIN1300 supports generating certain clocks on its GP_CLK pin.
>> Add a DT property to specify the frequency.
>>
>> Due to the complexity of the clock configuration register, for now only
>> 125MHz is documented.
> Thank you for your patch. There is something to discuss/improve.
>
> Adjust subject prefix to the subsystem (dt-bindings, not dt, missing net).
Ack. So something like
dt-bindings: net: adin: document clk-out property
>> Signed-off-by: Josua Mayer <josua@solid-run.com>
>> ---
>>   Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> index 1129f2b58e98..4e421bf5193d 100644
>> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
>> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
>> @@ -36,6 +36,11 @@ properties:
>>       enum: [ 4, 8, 12, 16, 20, 24 ]
>>       default: 8
>>   
>> +  adi,clk-out-frequency:
> Use types defined by the dtschema, so "adi,clk-out-hz". Then no need for
> type/ref.
That sounds useful, I was not aware. The only inspiration I used was the 
at803x driver ...
It seemed natural to share the property name as it serves the same 
purpose here.
>> +    description: Clock output frequency in Hertz.
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    enum: [125000000]
> If only one value, then "const: 125000000", but why do you need such
> value in DT if it is always the same?
Yes yes yes.
 From my understanding of the adin1300 data-sheet, it can provide either 
a 25MHz clock or a 125MHz clock on its GP_CLK pin. So for the context of 
this feature we would have two options. However because we found the 
documentation very confusing we skipped the 25MHz option.

Actually my statement above omits some of the options.
- There are actually two 125MHz clocks, the first called "recovered" and 
the second "free running".
- One can let the phy choose the rate based on its internal state.
This is indicated on page 73 of the datasheet
(https://www.analog.com/media/en/technical-documentation/data-sheets/adin1300.pdf)

Because of this confusion we wanted to for now only allow selecting the 
free-running 125MHz clock.

Sincerely
Josua Mayer

