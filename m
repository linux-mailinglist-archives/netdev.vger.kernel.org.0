Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E967A6293BE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiKOJAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiKOJAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:00:37 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A689B101C2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:00:34 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d9so18348108wrm.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UqMA6Tje+3ZsVcAAIQPTB3aQZjTGfrywbsqDdzk9JQs=;
        b=KIp2+/chwKI09PZkHXOBaaLZqJANenWBoecDu/vhLEPD8onbbS1Dlly1mkfV7tefeZ
         6sw8kVUIFff+j7w99uAp1bPMm5B8+hngwOFKybRZBl0BhBYmWMmsMzSaTxCLetRaLhNE
         hdkGZwUdt7t8k9QhYgHQU8zJ7bVLuZ2IErfgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqMA6Tje+3ZsVcAAIQPTB3aQZjTGfrywbsqDdzk9JQs=;
        b=emWjwRtk44v9mt7U547e9+vK1PW4Aa5KH0KVgZSdLVSkEeLjexEY34noy8tuy2tid0
         42N2kvzVxdHN+QhA5J3D7q0TT538ZBiUxzQ1OkRzXQm58PyZK4HbNsbVZAcUQ49QU1ZQ
         tX9aLJ9SS4r+mHcbDV3P/RDGhgkSu1lA4aUDva0L3/yVqF5NzLCMfNihbM38+cNSud+q
         neBdot3ipAu6I2ZI5nSpG87qzm0IK0LS6bFMdi3jEbO6tVHFBHfuHX+8oUy5gddv4OUh
         91o/dP4JE8nH2LXq1tM55L9mNs95hfHHvyDd+DgpBeyUH1iav7gGqu9dEdBRRnpmt+UT
         4ACg==
X-Gm-Message-State: ANoB5pmb6stvFQG7iWWF98lA4Z8PnREzb8iurFT6xeHj8dMyMqkfRi+b
        spi1aRpXDWmArItX8QbUqjb78w==
X-Google-Smtp-Source: AA0mqf54F/lZDKhCg3Oy0nmHzH6qldXo1KDM/vSOj3Y+3NQg4tQNXmzbhq8Eh9Boh+IgZWdHw86TQw==
X-Received: by 2002:adf:a4c1:0:b0:236:6f18:37e6 with SMTP id h1-20020adfa4c1000000b002366f1837e6mr9637216wrb.262.1668502833056;
        Tue, 15 Nov 2022 01:00:33 -0800 (PST)
Received: from [10.211.55.3] ([167.98.215.174])
        by smtp.googlemail.com with ESMTPSA id w9-20020adfee49000000b00228cd9f6349sm11842579wro.106.2022.11.15.01.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 01:00:32 -0800 (PST)
Message-ID: <48fbae83-728e-d7ec-7516-4f8c972a1a1d@ieee.org>
Date:   Tue, 15 Nov 2022 03:00:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: qcom,ipa: deprecate
 modem-init
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alex Elder <elder@linaro.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221112200717.1533622-1-elder@linaro.org>
 <20221112200717.1533622-2-elder@linaro.org>
 <de98dbb4-afb5-de05-1e75-2959aa720333@linaro.org>
 <2f827660-ae9d-01dd-ded8-7fd4c2f8f8ae@ieee.org>
 <88fd2f42-6f20-7bbe-1a4d-1f482c153f07@linaro.org>
Content-Language: en-US
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <88fd2f42-6f20-7bbe-1a4d-1f482c153f07@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/22 01:59, Krzysztof Kozlowski wrote:
> On 14/11/2022 18:48, Alex Elder wrote:
>> On 11/14/22 03:56, Krzysztof Kozlowski wrote:
>>> On 12/11/2022 21:07, Alex Elder wrote:
>>>> GSI firmware for IPA must be loaded during initialization, either by
>>>> the AP or by the modem.  The loader is currently specified based on
>>>> whether the Boolean modem-init property is present.
>>>>
>>>> Instead, use a new property with an enumerated value to indicate
>>>> explicitly how GSI firmware gets loaded.  With this in place, a
>>>> third approach can be added in an upcoming patch.
>>>>
>>>> The new qcom,gsi-loader property has two defined values:
>>>>     - self:   The AP loads GSI firmware
>>>>     - modem:  The modem loads GSI firmware
>>>> The modem-init property must still be supported, but is now marked
>>>> deprecated.
>>>>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> ---
>>>>    .../devicetree/bindings/net/qcom,ipa.yaml     | 59 +++++++++++++++----
>>>>    1 file changed, 46 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> index e752b76192df0..0dfd6c721e045 100644
>>>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> @@ -124,12 +124,22 @@ properties:
>>>>          - const: ipa-clock-enabled-valid
>>>>          - const: ipa-clock-enabled
>>>>    
>>>> +  qcom,gsi-loader:
>>>> +    enum:
>>>> +      - self
>>>> +      - modem
>>>> +    description:
>>>> +      This indicates how GSI firmware should be loaded.  If the AP loads
>>>
>>> s/This indicates/Indicate/
>>> (or any other grammar without describing DT syntax but hardware/system)
>>
>> OK.
>>
>>>> +      and validates GSI firmware, this property has value "self".  If the
>>>> +      modem does this, this property has value "modem".
>>>> +
>>>>      modem-init:
>>>> +    deprecated: true
>>>>        type: boolean
>>>>        description:
>>>> -      If present, it indicates that the modem is responsible for
>>>> -      performing early IPA initialization, including loading and
>>>> -      validating firwmare used by the GSI.
>>>> +      This is the older (deprecated) way of indicating how GSI firmware
>>>> +      should be loaded.  If present, the modem loads GSI firmware; if
>>>> +      absent, the AP loads GSI firmware.
>>>>    
>>>>      memory-region:
>>>>        maxItems: 1
>>>> @@ -155,15 +165,36 @@ required:
>>>>      - interconnects
>>>>      - qcom,smem-states
>>>>    
>>>> -# If modem-init is not present, the AP loads GSI firmware, and
>>>> -# memory-region must be specified
>>>> -if:
>>>> -  not:
>>>> -    required:
>>>> -      - modem-init
>>>> -then:
>>>> -  required:
>>>> -    - memory-region
>>>> +allOf:
>>>> +  # If qcom,gsi-loader is present, modem-init must not be present
>>>> +  - if:
>>>> +      required:
>>>> +        - qcom,gsi-loader
>>>> +    then:
>>>> +      properties:
>>>> +        modem-init: false
>>>
>>> This is ok, but will not allow you to keep deprecated property in DTS
>>> for the transition period. We talked about this that you need to keep
>>> both or wait few cycles before applying DTS cleanups.
>>
>> My intention is expressed in the comment.  Is it because of the
>> "if .... required ... qcom,gsi-loader"?
>>
>> Should it be "if ... properties ... qcom,gsi-loader"?
> 
> You disallow modem-init here, so it cannot be present in DTS if
> gsi-loader is present. Therefore the deprecated case like this:
>    qcom,gsi-loader = "modem"
>    modem-init;
> is not allowed by the schema.
> 
> As I said, it is fine, but your DTS should wait a cycle.

OK, then this is exactly as I intended.  I am planning to wait
until Linux v6.2-rc1 is published before I post the DTS updates
that implement this change.  It is not technically necessary
until IPA v5.0 is fully supported, and I don't have confidence
all of that will accepted before then.

If I did it "your way" first I could get it done now, but then
I'd want to do another round later to make it this way.

I will still send an updated series shortly, to address your
other comment about wording in the description.  But I will
not be changing this part.

Thanks for the explanation Krzysztof.

					-Alex


> 
> 
> Best regards,
> Krzysztof
> 

