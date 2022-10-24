Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353C060C01C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJYAue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiJYAuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:50:08 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E74F615E
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 16:29:12 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id s17so7053844qkj.12
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 16:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sDEiOO2OxUQEqcJLQZ7kBsOvRFZBqkT37nDYaev+ddU=;
        b=TwfP4qZqh4BiLDQV8bKcN09HTJJB3GwPlAFBoCOIaBVjuUKx835RqDrfXzzU0I+ATj
         3z9IxlU39VJ/0T02QQc0PW7mT6gt2vaVNpAO0NjZuUv/skIp+iHZ0oA36GcU/Sul4PRj
         5vSlCegDDJxYot192NhL05+XWH3q4iAKh6mtBNdlaRbIDwPetrJDYZ5hWXjd3AHeG5rY
         SDTNF449Tsmg/z0kkgdWdUW83n4ZNeomfkPZHZKp2Vyvk+QjRUKHSi+2v2/kPfkou6Wc
         1l32r/V5jg8XUnPFCvrjg+PwtGc62cG2rvO6NGeyAUTqhkjq2HJ6Dso/Q0j0+L/Up4Wn
         qI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sDEiOO2OxUQEqcJLQZ7kBsOvRFZBqkT37nDYaev+ddU=;
        b=zizNHxOd6ry31iqMFDb6MyUHH3hVIp0RxL0e21nlX7tg0/Vtm/0K7sltRAhkipplHY
         UEtj6ow4xce2od21LkNSIFTVTUP5oAVNQDNNi71Cye9Gq5EWsvMNmmbIQsJrpfqPU0Y1
         aCdHxtW2U+H1KGpa8zlyNyriecWA2Eaa3Gy3Hai18jOdstaMPpeiw477CUWqQPBk2GI8
         nC3GNBwVtl1JzXqWDzkLYYkMnzENHQrthfrH+MAvXCyrnRgVU1SrI7S5mic6xBqVHW/k
         cLFtZmeBjm3/yS1kAFZRl8rz78sKB3EyeBsRdCPsD2peJ2geYMcrMee4oRwNuw1Lp6Jc
         bzLg==
X-Gm-Message-State: ACrzQf2Q5VhDcAE6NxuWRG53moOqOf6o2kotiJ5jB7QDEt2wi9rhzC8n
        5w4uONvFKjbNTBXctX0Uy7HORA==
X-Google-Smtp-Source: AMsMyM4ZQwkLHu6v8w+ZHyWFThFAVPZOqYX9ByMlpVhRAn8QqQIOhDADr3uBRhpmvP4in84UZwkutA==
X-Received: by 2002:a05:620a:2f5:b0:6ee:82ea:b531 with SMTP id a21-20020a05620a02f500b006ee82eab531mr24796730qko.324.1666654151315;
        Mon, 24 Oct 2022 16:29:11 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id h6-20020a375306000000b006f3a20dccaesm805379qkb.136.2022.10.24.16.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 16:29:10 -0700 (PDT)
Message-ID: <3aa78c08-6d19-8480-cf31-2de41642b100@linaro.org>
Date:   Mon, 24 Oct 2022 19:29:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
 <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
 <20221024222850.5zq426cnn75twmvn@mercury.elektranox.org>
 <aa146042-2130-9fc3-adcd-c6d701084b4a@linaro.org>
In-Reply-To: <aa146042-2130-9fc3-adcd-c6d701084b4a@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/10/2022 19:28, Krzysztof Kozlowski wrote:
> On 24/10/2022 18:28, Sebastian Reichel wrote:
>> Hi,
>>
>> On Sat, Oct 22, 2022 at 12:05:15PM -0400, Krzysztof Kozlowski wrote:
>>> On 21/10/2022 13:10, Sebastian Reichel wrote:
>>>> The queue configuration is referenced by snps,mtl-rx-config and
>>>> snps,mtl-tx-config. Most in-tree DTs put the referenced object
>>>> as child node of the dwmac node.
>>>>
>>>> This adds proper description for this setup, which has the
>>>> advantage of properly making sure only known properties are
>>>> used.
>>>>
>>>> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
>>>> ---
>>>> [...]
>>>
>>> Please update the DTS example with all this.
>>
>> ok
> 
> BTW, I also found:
> 
> https://lore.kernel.org/linux-devicetree/20201214091616.13545-5-Sergey.Semin@baikalelectronics.ru/
>>
>>>
>>>>  
>>>>    snps,mtl-tx-config:
>>>>      $ref: /schemas/types.yaml#/definitions/phandle
>>>>      description:
>>>> -      Multiple TX Queues parameters. Phandle to a node that can
>>>> -      contain the following properties
>>>> -        * snps,tx-queues-to-use, number of TX queues to be used in the
>>>> -          driver
>>>> -        * Choose one of these TX scheduling algorithms
>>>> -          * snps,tx-sched-wrr, Weighted Round Robin
>>>> -          * snps,tx-sched-wfq, Weighted Fair Queuing
>>>> -          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
>>>> -          * snps,tx-sched-sp, Strict priority
>>>> -        * For each TX queue
>>>> -          * snps,weight, TX queue weight (if using a DCB weight
>>>> -            algorithm)
>>>> -          * Choose one of these modes
>>>> -            * snps,dcb-algorithm, TX queue will be working in DCB
>>>> -            * snps,avb-algorithm, TX queue will be working in AVB
>>>> -              [Attention] Queue 0 is reserved for legacy traffic
>>>> -                          and so no AVB is available in this queue.
>>>> -          * Configure Credit Base Shaper (if AVB Mode selected)
>>>> -            * snps,send_slope, enable Low Power Interface
>>>> -            * snps,idle_slope, unlock on WoL
>>>> -            * snps,high_credit, max write outstanding req. limit
>>>> -            * snps,low_credit, max read outstanding req. limit
>>>> -          * snps,priority, bitmask of the priorities assigned to the queue.
>>>> -            When a PFC frame is received with priorities matching the bitmask,
>>>> -            the queue is blocked from transmitting for the pause time specified
>>>> -            in the PFC frame.
>>>> +      Multiple TX Queues parameters. Phandle to a node that
>>>> +      implements the 'tx-queues-config' object described in
>>>> +      this binding.
>>>> +
>>>> +  tx-queues-config:
>>>> +    type: object
>>>> +    properties:
>>>> +      snps,tx-queues-to-use:
>>>> +        $ref: /schemas/types.yaml#/definitions/uint32
>>>> +        description: number of TX queues to be used in the driver
>>>> +      snps,tx-sched-wrr:
>>>> +        type: boolean
>>>> +        description: Weighted Round Robin
>>>> +      snps,tx-sched-wfq:
>>>> +        type: boolean
>>>> +        description: Weighted Fair Queuing
>>>> +      snps,tx-sched-dwrr:
>>>> +        type: boolean
>>>> +        description: Deficit Weighted Round Robin
>>>> +      snps,tx-sched-sp:
>>>> +        type: boolean
>>>> +        description: Strict priority
>>>> +    patternProperties:
>>>> +      "^queue[0-9]$":
>>>> +        description: Each subnode represents a queue.
>>>> +        type: object
>>>> +        properties:
>>>> +          snps,weight:
>>>> +            $ref: /schemas/types.yaml#/definitions/uint32
>>>> +            description: TX queue weight (if using a DCB weight algorithm)
>>>> +          snps,dcb-algorithm:
>>>> +            type: boolean
>>>> +            description: TX queue will be working in DCB
>>>> +          snps,avb-algorithm:
>>>
>>> Is DCB and AVB compatible with each other? If not, then this should be
>>> rather enum (with a string for algorithm name).
>>>
>>> This applies also to other fields which are mutually exclusive.
>>
>> Yes and I agree it is ugly. But this is not a new binding, but just
>> properly describing the existing binding. It's not my fault :)
> 
> I understand (and did not think it's your fault), but you are
> redesigning them. Existing DTS will have to be updated. If this is
> already implemented by some other DTS, then well... they did not follow
> bindings, so it's their fault. :)
> 
> What I want to say, why refactoring it if the new format is still poor?
>>
>>>> +            type: boolean
>>>> +            description:
>>>> +              TX queue will be working in AVB.
>>>> +              Queue 0 is reserved for legacy traffic and so no AVB is
>>>> +              available in this queue.
>>>> +          snps,send_slope:
>>>
>>> Use hyphens, no underscores.
>>> (This is already an incompatible change in bindings, so we can fix up
>>> the naming)
>>
>> No, this is not an incompatible change in the bindings. It's 100%
>> compatible. What this patch does is removing the text description
>> for 'snps,mtl-tx-config' and instead documenting the node in YAML
>> syntax. 'snps,mtl-tx-config' does not specify where this node should
>> be, so many DTS files do this:
> 
> Old binding did not document "tx-queues-config". Old binding had
> "snps,mtl-tx-config" which was a phandle, so this is an ABI break of
> bindings.

Bah, not ABI break, just change in bindings, of course :)

Best regards,
Krzysztof

