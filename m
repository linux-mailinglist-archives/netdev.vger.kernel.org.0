Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD013D5FB2
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236535AbhGZPS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhGZPSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:18:37 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25DCC061764
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:59:05 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id r18so12496197iot.4
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 08:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2oqVdc+Bwmni6M3nVJzlpNG4FMWWLNOhFE43b4PtG5Q=;
        b=cKI0ApA8ngPZMooBLOh7lfAS1DsT2EHd2K3e68CR4zgtntvO2LDikDqPfrKKxfL+HZ
         KjDxlBy4CqosymqCj4oljmWfEhXMB9Ljoaq1uG3SCr3OXux7uJbEVNvDlCSaSSudh+4q
         gFlnjYV+fYFBzX+CxkZIODAe3Vek39iWL6hvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2oqVdc+Bwmni6M3nVJzlpNG4FMWWLNOhFE43b4PtG5Q=;
        b=Uj57hksk7fEMITRmp9Q97rbgGz6I2PCa0Yy4vKA8T4XZsYRR6XBciuVAJKt4f7YEOH
         fMhKx8AKk2gcsy5RubNWy/vcqVFH0d4uHYAHLuWyHqpxCjYj3Bq0y1HZ+Xue0Dde8bwc
         FnCEvzEdZHJepTDuEC5ZUt/MwrjCWjMnO2XuwzVJVYLZoMjGh9wd1yMq2ZkuPOM+FLHV
         q2CFUG/DmwquGUjYHkumcvX4fkog1veHu9xtuF7sgu/f2/qeAgFVZ85fqiwpQV4njaXJ
         1SlPyMsP2BEeN9PT+tX9FchQZYHUi9802TovyQfiVVJdGJbdqC/v/G9ar2SaV+inwsmB
         phQw==
X-Gm-Message-State: AOAM532XN1MGEfSIAYS1fKEVenSrRbPt3GN4DCKsYbTKio8w8jF+E3ec
        zrL2naUTNt7f05SkcYejHRri2g==
X-Google-Smtp-Source: ABdhPJzcoLCiWULduAJ6beoqhxsv3ChnwQVAVpBm3E4lg/mBvDeOOmGaoHxC4yOFi27MB7GKWKBa+Q==
X-Received: by 2002:a5e:c109:: with SMTP id v9mr15382903iol.76.1627315145241;
        Mon, 26 Jul 2021 08:59:05 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h24sm169070ioj.32.2021.07.26.08.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 08:59:04 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: qcom,ipa: make imem
 interconnect optional
To:     Rob Herring <robh@kernel.org>, Alex Elder <elder@linaro.org>
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210719212456.3176086-1-elder@linaro.org>
 <20210719212456.3176086-2-elder@linaro.org>
 <20210723205252.GA2550230@robh.at.kernel.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <6c1779aa-c90c-2160-f8b9-497fb8c32dc5@ieee.org>
Date:   Mon, 26 Jul 2021 10:59:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723205252.GA2550230@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/21 3:52 PM, Rob Herring wrote:
> On Mon, Jul 19, 2021 at 04:24:54PM -0500, Alex Elder wrote:
>> On some newer SoCs, the interconnect between IPA and SoC internal
>> memory (imem) is not used.  Reflect this in the binding by moving
>> the definition of the "imem" interconnect to the end and defining
>> minItems to be 2 for both the interconnects and interconnect-names
>> properties.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   .../devicetree/bindings/net/qcom,ipa.yaml      | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> index ed88ba4b94df5..4853ab7017bd9 100644
>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
>> @@ -87,16 +87,18 @@ properties:
>>         - const: ipa-setup-ready
>>   
>>     interconnects:
>> +    minItems: 2
>>       items:
>> -      - description: Interconnect path between IPA and main memory
>> -      - description: Interconnect path between IPA and internal memory
>> -      - description: Interconnect path between IPA and the AP subsystem
>> +      - description: Path leading to system memory
>> +      - description: Path between the AP and IPA config space
>> +      - description: Path leading to internal memory
>>   
>>     interconnect-names:
>> +    minItems: 2
>>       items:
>>         - const: memory
>> -      - const: imem
>>         - const: config
>> +      - const: imem
> 
> What about existing users? This will generate warnings. Doing this for
> the 2nd item would avoid the need for .dts updates:
> 
> - enum: [ imem, config ]

If I understand correctly, the effect of this would be that
the second item can either be "imem" or "config", and the third
(if present) could only be "imem"?

And you're saying that otherwise, existing users (the only
one it applies to at the moment is "sdm845.dtsi") would
produce warnings, because the interconnects are listed
in an order different from what the binding specifies.

Is that correct?

If so, what you propose suggests "imem" could be listed twice.
It doesn't make sense, and maybe it's precluded in other ways
so that's OK.  But I'd be happy to update "sdm845.dtsi" to
address your concern.  (Maybe that's something you would rather
avoid?)

Also, I need to make a separate update to "sm8350.dtsi" because
that was defined before I understood what I do now about the 
interconnects.  It uses the wrong names, and should combine
its first two interconnects into just one.

					-Alex

> 
> Rob
> 

