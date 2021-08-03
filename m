Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EDB3DEDD0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhHCMYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbhHCMYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:24:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3972EC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 05:24:08 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m13so24003063iol.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 05:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sSAJdBXerSiLD/jae6wSlhsV/AYk+DynXxE+wOZYVUg=;
        b=bRVwX6iPyAZEcpuyB4yiUnUe+peBOZ6yDCqxfRHK/MWWbE8extM3sSfAt80FJslR6X
         w7dtV2Q8CnEkU3c2O9xunDbtV6DjsudWluolBahN/iVlRWXcGhWPKHd5aioLLzH8Ee7g
         S4xBD5bemnxGWjWWt/Sahnh3ca8DkVBQ29A70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sSAJdBXerSiLD/jae6wSlhsV/AYk+DynXxE+wOZYVUg=;
        b=hnu9siiRyEBk1J+hj7LoZlvw9QDAV3hscGxzuGBGbeyMnZMmx+s5fFo8kAqqHuHbrd
         AiIqc23uVYP8EsqypPaLsClWy4dwWIV/Ei4lnUr61LyLX6w9eQz1WwibKj9ySqZHxdVH
         CAC8CYyLiqNIW1PfbX1KtXEYVF8Ln8rUv14QMol5v5S3A/EIST6VN1rPT8KkrkOg05M3
         9EYrvGV2j2OJYANJ7CrUgy9J12QZFDPdSQGRGwUGBiCMlVTIxwGq+VBYyRxay1e1xn00
         tF3y065auhPENGIMlt2xelGQw4NSl/IWMu9sTIOMw9BlthvT1B9o7C2koVHt0mfkE9ID
         oQag==
X-Gm-Message-State: AOAM530cjlv5kEfpNERUu8PgwKrsONBbiptG8s8uADLNh7iGLDU7ngco
        hliP027jYQ8zjqANhnap//RIBQ==
X-Google-Smtp-Source: ABdhPJzEGU9BDQUsOAVRriRZRQdWv2S8IfGFXRpD5rGJTVc1Hwa4BETVCCidP6Tqo9bvfIRHF54dBg==
X-Received: by 2002:a5d:9284:: with SMTP id s4mr605937iom.131.1627993447634;
        Tue, 03 Aug 2021 05:24:07 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k2sm6244589ior.40.2021.08.03.05.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 05:24:06 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: qcom,ipa: make imem
 interconnect optional
To:     Rob Herring <robh@kernel.org>
Cc:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Gross, Andy" <agross@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Evan Green <evgreen@chromium.org>, cpratapa@codeaurora.org,
        subashab@codeaurora.org, Alex Elder <elder@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210719212456.3176086-1-elder@linaro.org>
 <20210719212456.3176086-2-elder@linaro.org>
 <20210723205252.GA2550230@robh.at.kernel.org>
 <6c1779aa-c90c-2160-f8b9-497fb8c32dc5@ieee.org>
 <CAL_JsqKTdUxro-tgCQBzhudaUFQ5GejJL2EMuX2ArcP0JTiG3g@mail.gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <8e75f8b0-5677-42b0-54fe-06e7c69f6669@ieee.org>
Date:   Tue, 3 Aug 2021 07:24:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKTdUxro-tgCQBzhudaUFQ5GejJL2EMuX2ArcP0JTiG3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 10:33 AM, Rob Herring wrote:
> On Mon, Jul 26, 2021 at 9:59 AM Alex Elder <elder@ieee.org> wrote:
>>
>> On 7/23/21 3:52 PM, Rob Herring wrote:
>>> On Mon, Jul 19, 2021 at 04:24:54PM -0500, Alex Elder wrote:
>>>> On some newer SoCs, the interconnect between IPA and SoC internal
>>>> memory (imem) is not used.  Reflect this in the binding by moving
>>>> the definition of the "imem" interconnect to the end and defining
>>>> minItems to be 2 for both the interconnects and interconnect-names
>>>> properties.
>>>>
>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>> ---
>>>>    .../devicetree/bindings/net/qcom,ipa.yaml      | 18 ++++++++++--------
>>>>    1 file changed, 10 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> index ed88ba4b94df5..4853ab7017bd9 100644
>>>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>>>> @@ -87,16 +87,18 @@ properties:
>>>>          - const: ipa-setup-ready
>>>>
>>>>      interconnects:
>>>> +    minItems: 2
>>>>        items:
>>>> -      - description: Interconnect path between IPA and main memory
>>>> -      - description: Interconnect path between IPA and internal memory
>>>> -      - description: Interconnect path between IPA and the AP subsystem
>>>> +      - description: Path leading to system memory
>>>> +      - description: Path between the AP and IPA config space
>>>> +      - description: Path leading to internal memory
>>>>
>>>>      interconnect-names:
>>>> +    minItems: 2
>>>>        items:
>>>>          - const: memory
>>>> -      - const: imem
>>>>          - const: config
>>>> +      - const: imem
>>>
>>> What about existing users? This will generate warnings. Doing this for
>>> the 2nd item would avoid the need for .dts updates:
>>>
>>> - enum: [ imem, config ]

In other words:

   interconnect-names:
     minItems: 2
     items:
       - const: memory
       - enum: [ imem, config ]
       - const: imem

What do I do with the "interconnects" descriptions in that case?
How do I make the "interconnect-names" specified this way align
with the described interconnect values?  Is that necessary?

>> If I understand correctly, the effect of this would be that
>> the second item can either be "imem" or "config", and the third
>> (if present) could only be "imem"?
> 
> Yes for the 2nd, but the 3rd item could only be 'config'.

Sorry, yes, that's what I meant.  I might have misread the
diff output.

>> And you're saying that otherwise, existing users (the only
>> one it applies to at the moment is "sdm845.dtsi") would
>> produce warnings, because the interconnects are listed
>> in an order different from what the binding specifies.
>>
>> Is that correct?
> 
> Yes.
> 
>> If so, what you propose suggests "imem" could be listed twice.
>> It doesn't make sense, and maybe it's precluded in other ways
>> so that's OK.
> 
> Good observation. There are generic checks that the strings are unique.

I think I don't like that quite as much, because that
"no duplicates" rule is implied.  It also avoids any
confusion in the "respectively" relationship between
interconnects and interconnect-names.

I understand what you're suggesting though, and I would
be happy to update the binding in the way you suggest.
I'd like to hear what you say about my questions above
before doing so.

>>   But I'd be happy to update "sdm845.dtsi" to
>> address your concern.  (Maybe that's something you would rather
>> avoid?)
> 
> Better to not change DT if you don't have to. You're probably okay if
> all clients (consumers of the dtb) used names and didn't care about

In the IPA driver, wherever names are specified for things in DT,
names (only) are used to look them up.  So I'm "probably okay."

> the order. And I have no idea if all users of SDM845 are okay with a
> DTB change being required. That's up to QCom maintainers. I only care
> that ABI breakages are documented as such.
> 
>> Also, I need to make a separate update to "sm8350.dtsi" because
>> that was defined before I understood what I do now about the
>> interconnects.  It uses the wrong names, and should combine
>> its first two interconnects into just one.
> 
> If the interconnects was ignored in that case, then the change doesn't matter.

That platform is not yet fully supported by the IPA driver, thus
there is (so far) no instance where it is used.  Resolving this
is part of enabling support for that.

Thanks.

					-Alex


> Rob
> 

