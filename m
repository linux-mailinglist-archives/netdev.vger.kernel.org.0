Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E0C5375B9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbiE3Ho4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbiE3Hoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:44:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014FB19013
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:44:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 129-20020a1c0287000000b003974edd7c56so4481693wmc.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bnpEW7nMdnLUWHsrYaoPJkkFbJzKl+q7DVeAQrmJHVU=;
        b=JB0c78RWNFb3Fwjqblop4TyBp7NP1xGg+vtK5lMyNSIKU++yViaXpW5P0vb3HFo34B
         dkBJOEvhE5k/T+ORBBdHSEcEXslvrCQkXnAOg4KGuPtptapbHAfn21KWN4pm08tbQIAx
         QLcuQlNwi+gnv0ihfPtmb2j6NZj9eN8s33nYcGBwCpK6rExGtxdzlIaGAmtNgAyL+YzS
         fDipelzFHJhMwxDbZdrbtXm05llbCmhWXs6o+X5ZYvi/p3zJXV5v+QX5L2A6EJVRmGKC
         Xr9RWAyVnOyJCEs4RDoXOz1WrthPubzfD4EBQVM33l4HGQ7BefmarpO8d/41AHYj1RVL
         DQ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bnpEW7nMdnLUWHsrYaoPJkkFbJzKl+q7DVeAQrmJHVU=;
        b=1mCQTKCW+ws58Wxoy3nKqJFg5kCioS/3rhDPpnFyfSczG1qnBUqYypvnRAKvQdV+0K
         Q2abreK7lCX0B+NU/tLellh0q5EoKxfjRfu2hrQOFWO+XQf2esIdTsxRIeXewMJggrFa
         f5M4RD8RxX9B1DkGA2tP9UlkM9YaEGd3vFVmffNuLiFsQgqroKcmP9lD03/Vm8d9/9nr
         sOI5jDTWTEO77+ucpoKzKRhmIGLPEibm2TEdMMqJjUGEP61fsa+DmllnztiWc4/MjGEV
         S/4VBlASvBOO0JC9q14JdbbaRfEYNU4cRxkC6MBmLGlETPquR9/lsQ33aND9RthEshGp
         6jFg==
X-Gm-Message-State: AOAM532e+Cp+5c8mTbCkTTktx3k7OvIoUCAsctfR7+j5xkhov4N4plSi
        FvCb5zaqGlkO6yKXUo1nQg5Fcw==
X-Google-Smtp-Source: ABdhPJxssOq1UwbvJ5ynBakhPj2QnIQqlSvm4YjcIGNbbEEGjJ9gIy27Nb3fuzdIKfo/9cxDPTdhoA==
X-Received: by 2002:a05:600c:3ac7:b0:397:5cb4:a2b5 with SMTP id d7-20020a05600c3ac700b003975cb4a2b5mr17564297wms.5.1653896690614;
        Mon, 30 May 2022 00:44:50 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6dac000000b0020feb9c44c2sm9278719wrs.20.2022.05.30.00.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 00:44:50 -0700 (PDT)
Message-ID: <e6e83743-1441-dc53-fd1f-cdfb9a24932a@linaro.org>
Date:   Mon, 30 May 2022 09:44:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 1/2] dt-bindings: net: broadcom-bluetooth: Add property
 for autobaud mode
Content-Language: en-US
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
References: <cover.1653057480.git.hakan.jansson@infineon.com>
 <cb20a6f49c91521d54c847ee4dc14451b0ee91dd.1653057480.git.hakan.jansson@infineon.com>
 <996ac5f2-3cf3-e67a-144b-4fdac9bbc20d@linaro.org>
 <b090ec5a-6d9a-71e3-d4d0-e491b14b558e@infineon.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <b090ec5a-6d9a-71e3-d4d0-e491b14b558e@infineon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/05/2022 11:21, Hakan Jansson wrote:
> Hi Krzysztof,
> 
> Thanks for responding.
> 
> On 5/22/2022 10:14 AM, Krzysztof Kozlowski wrote:
>>> Some devices (e.g. CYW5557x) require autobaud mode to enable FW loading.
>> Which devices support this? You probably need allOf:if:then.
> 
> Most devices _support_ autobaud mode but I don't have a definitive list. 
> The CYW5557x is the first device family to _require_ autobaud mode for 
> FW loading as far as I know.
> 
>>> Autobaud mode can also be required on some boards where the controller
>>> device is using a non-standard baud rate when first powered on.
>>>
>>> This patch adds a property, "brcm,uses-autobaud-mode", to enable autobaud
>>> mode selection.
>> Don't use "This patch":
>> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95
> 
> Sorry, will change in next rev.
> 
>>> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
>>> ---
>>> V1 -> V2: Modify property description
>>>
>>>   .../devicetree/bindings/net/broadcom-bluetooth.yaml      | 9 +++++++++
>>>   1 file changed, 9 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>> index 5aac094fd217..a29f059c21cc 100644
>>> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
>>> @@ -92,6 +92,15 @@ properties:
>>>          pcm-sync-mode: slave, master
>>>          pcm-clock-mode: slave, master
>>>
>>> +  brcm,uses-autobaud-mode:
>> Based on description, I understand the host triggers using autobaud.
> 
> Correct, the host triggers using autobaud.
> 
>> However here you word it as "uses", so it is independent of host, it
>> looks like property of a device.
> 
> I've been thinking of it as a a property of a specific board HW, 
> inherited either from a property of the device being used or from a 
> property of the HW design (e.g. a PCB using an alternate crystal 
> frequency yielding a non-standard baud rate).
> 
>>   The commit msg describes it even
>> different - "require autobaud".
> 
> Yes, the commit message describes two separate reasons why autobaud mode 
> would be required:
> 
> 1. Requirement coming from Device: "Some devices (e.g. CYW5557x) require 
> autobaud mode to enable FW loading."
> 
> 2. Requirement coming from HW design: "Autobaud mode can also be 
> required on some boards where the controller device is using a 
> non-standard baud rate when first powered on."
> 
>> This leads to second issue - it looks like there is some hardware
>> property (requiring to use autobaud) which should be described by
>> bindings. But instead you describe desired operational feature.
> 
> Sorry about that. I've really been struggling with what should go into 
> the description. Any suggestions or hints would be much appreciated.
> 
> How about, changing the property name to "brcm,requires-autobaud-mode" 
> and the description to:
> "Set this property if autobaud mode is required. Autobaud mode is 
> required if the device's baud rate in normal mode is not supported by 
> the host or if the device requires autobaud mode startup before loading FW."
> 
> Would that be an appropriate name and description?

Yes, sounds good. I also have trouble to name it nicely.

Sorry for late reply.

Best regards,
Krzysztof
