Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6F760BEA1
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJXXcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiJXXbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:31:44 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50F0C4C10
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:52:43 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d142so8874349iof.7
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GkmpsNViylq9BB1MxlxYNFU9pC/HN95G5AphBwXIurI=;
        b=PGDd8ik8IIwKMIUsrm1jKXFQuLvqCRne6jdZeJ4bATC8PlKLBy+xP6ra7bzvwU4EDY
         nG7fYF+SYQWA92kpD6XvUbVp9/qx/y3igNzKGu9EYc1cj6D3upzQNZFGXOoW1iSBTB5E
         fn+RNtDYNRhYQbHmf8/0aYChksmKoUhSIJ41QkPi/i8MY8PsPh0Zw8ecuMEi31Gei4Q6
         nV5UIGT7Qjq2PgPXhjD4edUcxw/KIYWvXF4/hPeDoFxtrxAx4jgLDQA8cchQHhKLY/4v
         RCV0M9sfC1ZDdi/pnUjMyNcZYUD4ja8t8FS6F3Yoduk/RpvMADAyzhsyMc+XgIoLSXhG
         uFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkmpsNViylq9BB1MxlxYNFU9pC/HN95G5AphBwXIurI=;
        b=GXAX7huKgrkwNiDs6uaIP0t1FNL+WJkkLru2wzwbqqH99hf0YOctEv6M+oLwz1Mbdv
         mowlf4B52Tif+sVUyubOyRireUZ/Lm+/6cw9l9KTJ/NmYmX6RhSFSQZQEZznx+Db2K8R
         tlZ3Mw7Ss26YQOfc3KlgFHbRFwjr9hQx/6emE6KeCsRv/BIIe0I04u0bbbuaJNOzO9Lx
         eDBL6ymSPIBAEitY4MRTnMfEj/2kFTZZm1fqIaXWxsQo33+5YAoXnuDct6mFG+LzEBO6
         YPHgDvlff5ozZx05VOE9/tiP+nn0mqP9Dq+jZ0DCdATLTQtkvyGxnZ6cvvyD0/7dNx7j
         1RwQ==
X-Gm-Message-State: ACrzQf0e82FdnJdicb8oVZYSbT0V+BIUV23Ip38ovj1gwRDkId5Wn7uA
        NhNXNylKfRLhaBsC1NGegS34gNBLrH6B2Q==
X-Google-Smtp-Source: AMsMyM6ZkZ/psZ7xFtzSk2+QefOCkJiSaxQwDA09YPJIno7suqbPrkOOfDSNwZb+THNYQaurWqW+lA==
X-Received: by 2002:a05:620a:28d2:b0:6ef:a7f:dee4 with SMTP id l18-20020a05620a28d200b006ef0a7fdee4mr16570214qkp.400.1666644475623;
        Mon, 24 Oct 2022 13:47:55 -0700 (PDT)
Received: from [192.168.1.8] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id w3-20020ac857c3000000b0039442ee69c5sm490305qta.91.2022.10.24.13.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 13:47:55 -0700 (PDT)
Message-ID: <e9608a55-7b2f-330d-df98-eedd0be53f47@linaro.org>
Date:   Mon, 24 Oct 2022 16:47:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
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
 <20221024185312.GA2037160-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221024185312.GA2037160-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/10/2022 14:53, Rob Herring wrote:
> On Sat, Oct 22, 2022 at 12:05:15PM -0400, Krzysztof Kozlowski wrote:
>> On 21/10/2022 13:10, Sebastian Reichel wrote:
>>> The queue configuration is referenced by snps,mtl-rx-config and
>>> snps,mtl-tx-config. Most in-tree DTs put the referenced object
>>> as child node of the dwmac node.
>>>
>>> This adds proper description for this setup, which has the
>>> advantage of properly making sure only known properties are
>>> used.
>>>
>>> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
>>> ---
>>>  .../devicetree/bindings/net/snps,dwmac.yaml   | 154 ++++++++++++------
>>>  1 file changed, 108 insertions(+), 46 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index 13b984076af5..0bf6112cec2f 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -167,56 +167,118 @@ properties:
>>>    snps,mtl-rx-config:
>>>      $ref: /schemas/types.yaml#/definitions/phandle
>>>      description:
>>> -      Multiple RX Queues parameters. Phandle to a node that can
>>> -      contain the following properties
>>> -        * snps,rx-queues-to-use, number of RX queues to be used in the
>>> -          driver
>>> -        * Choose one of these RX scheduling algorithms
>>> -          * snps,rx-sched-sp, Strict priority
>>> -          * snps,rx-sched-wsp, Weighted Strict priority
>>> -        * For each RX queue
>>> -          * Choose one of these modes
>>> -            * snps,dcb-algorithm, Queue to be enabled as DCB
>>> -            * snps,avb-algorithm, Queue to be enabled as AVB
>>> -          * snps,map-to-dma-channel, Channel to map
>>> -          * Specifiy specific packet routing
>>> -            * snps,route-avcp, AV Untagged Control packets
>>> -            * snps,route-ptp, PTP Packets
>>> -            * snps,route-dcbcp, DCB Control Packets
>>> -            * snps,route-up, Untagged Packets
>>> -            * snps,route-multi-broad, Multicast & Broadcast Packets
>>> -          * snps,priority, bitmask of the tagged frames priorities assigned to
>>> -            the queue
>>> +      Multiple RX Queues parameters. Phandle to a node that
>>> +      implements the 'rx-queues-config' object described in
>>> +      this binding.
>>> +
>>> +  rx-queues-config:
>>
>> If this field is specific to this device, then you need vendor prefix:
>> snps,rq-queues-config
> 
> Not for a node name...

Right.

Best regards,
Krzysztof

