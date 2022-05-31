Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650DB5397C9
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347674AbiEaUJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347671AbiEaUJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:09:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFDA9BAF8
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:09:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jx22so28703011ejb.12
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eZrqEogM3AC65qLUBGgKYLN1COH7t9H43DIeDqTbWeM=;
        b=ahmNmpmxpbeXN3p+oLN0WAuNIkQGXYspiWXJJPLOPVNg85kI1Vmj1V81j1iUz3xIQB
         gE3rc7bnXNlGkdc+jJn2EQVoJt+7yls4GtxiAFe78mWY0qg3syrPp4F401WDR333Jj/D
         2/Oug3DdDAaUyW/oBPbcIBPD/Ty4FC27EpZvWr/06vvUt0Os4ZIukzgRIWn4BIiK4+NN
         3LyMvsvzlGdODTPEKImiegzlvNrg2pYwNJDDyxsuydzKHWS64OGwcpnYrcaqPi0liZbl
         YvO/GpogfF3ynfDtz9U0ISqk0juCHzlLioMXStcfrv175qr/5MgGHp+1oCSfUK6rGr6D
         PtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eZrqEogM3AC65qLUBGgKYLN1COH7t9H43DIeDqTbWeM=;
        b=JXJrur7NFv5q4bmLcwW3N05pglTJHSmqQKOIkjiK39OkhORb9f6xj4xQv8EHOwtv2/
         DFdpm7/0bNZP67CxZzGjpGDqWGvfEQeQt42CCI07K0vv1dGoZ2+mS/O4tZPfKMiQdMEm
         k3/nVeA9MyYKXP0p5Rm2tRV8DOBKUQKaHlN8X10O2MOIUXOjnnUBwcgc/VUUCPRdotuw
         AusabWrlH1CGhN6ZtdHlGYk1SRkaxDm8PQF2P1Ehif4p+Z6IGYYBd3H60kc75l/krnSe
         UlSL5bIl4c7zmhEs9rGBGtRHDYgwYVOuVSuxKybX3TCeqeakG2tN2+7bfArcq3hNS94J
         YkvA==
X-Gm-Message-State: AOAM5302xxwKivu2w6o9iJHNPId6xUv5AxXlFTBt3QcrtYx8ZCdd3U0h
        zZoaJm2TTxsSRylF49+MseR2zA==
X-Google-Smtp-Source: ABdhPJxQcSBLgp8rl0PFg5TdavasM1siJ6YGHYF/R0Ke8fqbzI8ktceopS4djH1H3+zc68roBs0lUA==
X-Received: by 2002:a17:906:a10e:b0:6f3:e70b:b572 with SMTP id t14-20020a170906a10e00b006f3e70bb572mr53306748ejy.546.1654027748808;
        Tue, 31 May 2022 13:09:08 -0700 (PDT)
Received: from [192.168.0.179] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id d21-20020a170906641500b006febce7081esm5374701ejm.177.2022.05.31.13.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 13:09:08 -0700 (PDT)
Message-ID: <3ffc8e2e-4161-c61a-abda-9a7ca000e7aa@linaro.org>
Date:   Tue, 31 May 2022 22:09:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Content-Language: en-US
To:     Radhey Shyam Pandey <radheys@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "harini.katakam@amd.com" <harini.katakam@amd.com>,
        "michal.simek@amd.com" <michal.simek@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git@amd.com" <git@amd.com>
References: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
 <SA1PR02MB85602AA1C1A0157A2F0DA28BC7DD9@SA1PR02MB8560.namprd02.prod.outlook.com>
 <6f3d43ca-c980-851d-e7b2-869371a1f4ec@linaro.org>
 <SA1PR02MB856087686FE497BDCE413E89C7DC9@SA1PR02MB8560.namprd02.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <SA1PR02MB856087686FE497BDCE413E89C7DC9@SA1PR02MB8560.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2022 20:19, Radhey Shyam Pandey wrote:
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: Tuesday, May 31, 2022 12:40 AM
>> To: Radhey Shyam Pandey <radheys@xilinx.com>; Radhey Shyam Pandey
>> <radhey.shyam.pandey@amd.com>; davem@davemloft.net;
>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
>> harini.katakam@amd.com; michal.simek@amd.com
>> Cc: netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-
>> kernel@vger.kernel.org; git@amd.com
>> Subject: Re: [PATCH net-next] dt-bindings: net: xilinx: document xilinx emaclite
>> driver binding
>>
>> On 30/05/2022 15:21, Radhey Shyam Pandey wrote:
>>>>
>>>>> +        local-mac-address = [00 0a 35 00 00 00];
>>>>
>>>> Each device should get it's own MAC address, right? I understand you
>>>> leave it for bootloader, then just fill it with 0.
>>>
>>> The emaclite driver uses of_get_ethdev_address() to get mac from DT.
>>> i.e  'local-mac-address' if present in DT it will be read and this MAC
>>> address is programmed in the MAC core. So I think it's ok to have a
>>> user defined mac-address (instead of 0s) here in DT example?
>>
>> And you want to program the same MAC address in every device in the world?
>> How would that work?
> 
> I agree, for most of practical usecases mac address will be set by bootloader[1].
> But just thinking for usecases where uboot can't read from non-volatile memory
> user are still provided with option to set local-mac-address in DT and let linux
> also configures it? Also see this in couple of other networking driver examples. 

Which is not necessarily correct approach
> 
> cdns,macb.yaml:  local-mac-address: true
> cdns,macb.yaml:            local-mac-address = [3a 0e 03 04 05 06];
> brcm,systemport.yaml:        local-mac-address = [ 00 11 22 33 44 55 ];

This brcm looks like an invalid MAC, so could be just placeholder.

> 
> In emaclite yaml - as it an example I will set it mac-address to 0 to align 
> with common usecase.  local-mac-address = [00 00 00 00 00 00]
> 

Thanks.


Best regards,
Krzysztof
