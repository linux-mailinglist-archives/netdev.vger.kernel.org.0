Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA595F3482
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiJCR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJCR3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:29:33 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B2D17AB6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:29:31 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id o7so10337162lfk.7
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 10:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=D/fZmUSeupPl5TA1An+5fKtJeTIV2CBPNXJdyZ0NK1c=;
        b=Uq+Hm+d7n3APDB5EBW5GcCZWg9vmHxe9tVYc8CoupCmOi3pYq/b4Q6k1GN9x+qp9r+
         JccSl+imhnMwBFgBaUoWsyrJHs73LPchcoCmxlNiyEB45cjJuM52X+IPazhGOMPJLdRn
         PYGPOiZPxI1bZsoSDDDM6kqhSGnzFhuU59OnG9akkpiMSNUzaO0W9UIbDjs/MGG0/Jh6
         b8+48SqFJRjfpiwDWlk1mzBBf8bK0upqyU+e1F6Tl12G0CyCWh0pwBAA429yrnVhULA4
         0lVPsheo51ajZXju8C9ae+xCklNjewTPI3buE9gnFd5KtsfqY7h5ZPs0fvWUU+VkqGaP
         xT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=D/fZmUSeupPl5TA1An+5fKtJeTIV2CBPNXJdyZ0NK1c=;
        b=bPPbcY3PKxjErcXL42cF/iO8IqgOkmrQQHEE+7MSIhCI0DRXNn0ehAUYmttwqb7uOS
         JAqU7hT9VXxcyntLu4AjzjBw7l6NLEvgMIRxfzKDDlYqbq1LwBIgf5wGhfBuf1SKvJiv
         axfYwKJfL0pGZOo/UKUTv+Bt/wI5IC2vfxys1HmoOaR3EyqRvJ8IDK/G/NHeAskSU+mT
         KDasMnt6ggkn3J3csYFMbwF/h2Ul0kKhItqhfHv9rB3F4AyZJB3Ke0pp1awXIHmW7otI
         VGcv4XulyV4pILhJnHMhCyamq0TZ2AxeFHoSX0lCefvjjk7EkTmX0k7BtO2Jb/L0kMPj
         H3ZQ==
X-Gm-Message-State: ACrzQf2YOxSWt4cFQbuUIL2CuoLJDPX7YZKD6Z778K9BD3xqKUFSJj5J
        FBliXiwI1LqrYO2FVl0Plss+95SdDk2DKQ==
X-Google-Smtp-Source: AMsMyM4+gyTTKBhBGjjlxdjoWx6AngDl0e9fE6aqjqfrpPKRSPkHli2+Zkt7P4vuveNqnJqEkpFSzg==
X-Received: by 2002:a05:6512:33c3:b0:4a2:4c1a:a07 with SMTP id d3-20020a05651233c300b004a24c1a0a07mr935559lfg.551.1664818170172;
        Mon, 03 Oct 2022 10:29:30 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u1-20020a056512128100b0049b8c0571e5sm1537519lfs.113.2022.10.03.10.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 10:29:29 -0700 (PDT)
Message-ID: <5ea6145b-ed59-8deb-df7c-57e26e4ecb20@linaro.org>
Date:   Mon, 3 Oct 2022 19:29:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] dt-bindings: net: marvell,pp2: convert to json-schema
To:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>, mw@semihalf.com
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, upstream@semihalf.com
References: <CAPv3WKcW+O_CYd2vY2xhTKojVobo=Bm5tdFdJ8w33FHximPTcA@mail.gmail.com>
 <20221003170613.132548-1-mig@semihalf.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221003170613.132548-1-mig@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 19:06, Michał Grzelak wrote:
> On 02/10/2022 10:23, Marcin Wojtas wrote:
>> niedz., 2 paź 2022 o 10:00 Krzysztof Kozlowski
>> <krzysztof.kozlowski@linaro.org> napisał(a):
>>>
>>> On 01/10/2022 17:53, Michał Grzelak wrote:
>>>> Hi Krzysztof,
>>>>
>>>> Thanks for your comments and time spent on reviewing my patch.
>>>> All of those improvements will be included in next version.
>>>> Also, I would like to know your opinion about one.
>>>>
>>>>>> +
>>>>>> +  marvell,system-controller:
>>>>>> +    $ref: /schemas/types.yaml#/definitions/phandle
>>>>>> +    description: a phandle to the system controller.
>>>>>> +
>>>>>> +patternProperties:
>>>>>> +  '^eth[0-9a-f]*(@.*)?$':
>>>>>
>>>>> The name should be "(ethernet-)?port", unless anything depends on
>>>>> particular naming?
>>>>
>>>> What do you think about pattern "^(ethernet-)?eth[0-9a-f]+(@.*)?$"?
>>>> It resembles pattern found in net/ethernet-phy.yaml like
>>>> properties:$nodename:pattern:"^ethernet-phy(@[a-f0-9]+)?$", while
>>>> still passing `dt_binding_check' and `dtbs_check'. It should also
>>>> comply with your comment.
>>>
>>> Node names like ethernet-eth do not make much sense because they contain
>>> redundant ethernet or eth. AFAIK, all other bindings like that call
>>> these ethernet-ports (or sometimes shorter - ports). Unless this device
>>> is different than all others?
>>>
>>
>> IMO "^(ethernet-)?port@[0-9]+$" for the subnodes' names could be fine
>> (as long as we don't have to modify the existing .dtsi files) - there
>> is no dependency in the driver code on that.
> 
> Indeed, driver's code isn't dependent; however, there is a dependency
> on 'eth[0-2]' name in all relevant .dts and .dtsi files, e.g.:
> 
> https://github.com/torvalds/linux/blob/master/arch/arm/boot/dts/armada-375.dtsi#L190
> https://github.com/torvalds/linux/blob/master/arch/arm64/boot/dts/marvell/armada-cp11x.dtsi#L72
> 
> Ports under 'ethernet' node are named eth[0-2], thus those and all .dts files 
> including the above would have to be modified to pass through `dtbs_check'.

I didn't get it. What is the "dependency"? Usage of some names is not a
dependency... Old bindings were not precising any specific name of
subnodes, therefore I commented to change it. If the DTS already use
some other name, you can change them if none of upstream implementations
(BSD, bootloaders, firmware, Linux kernel) depend on it.

Best regards,
Krzysztof

