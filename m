Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04737608E58
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiJVQF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 12:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJVQFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 12:05:23 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A157E3B
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 09:05:19 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id y10so3846757qvo.11
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5lbMIM7nqIxTYy2koXXs7MyMh9wpyXwtXg0X2VOHXFc=;
        b=F5E+liIdea+OsqP4JP+Hx95UC7IQ2arOq/S8Kze1a25DhYuO5GTIedOvNktocdNLSH
         sRKTDmu7vDhILLOBLz2l4ZaWfiXR4QMynCvXUXPWnp/U9SR9gR0kvQoo4cX3YRo+iSS3
         0oNFyfABKnrOMfMoVGPkMO+gbKa2uaPI0lniRWTbuuzCCnplmgWaxH+1qPwldhe94xrI
         HJsaLf1pc6oxudB6ErUyp/aOq3onWh7LbL8hIwG8deI/ZlWx4HikMVzsyPsvxKyW8+ai
         AqxT7hi0o+0DkgvY7P069kE4ZhsQw0BYRK048YVJM3TK26aJBU5wUuysKv1vA3PulR3f
         cNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lbMIM7nqIxTYy2koXXs7MyMh9wpyXwtXg0X2VOHXFc=;
        b=6Ol0kIvMSF8pHrJlXbnhRFntFYf07I6jd7jbDwA1JLnjwxmRuCQ13QUmBLZElOu9a0
         fEDjiZwrucby+bfXlzjES5/ma46iXTLRLNsMFnCYjOR2OXWjb3oU42QJFL+z6RRmt3+Q
         oMbVmHIVM/5JIwy7so3KSNXb7MAQQ7do7F9PfH8bwap+DQ4gpNCvGn8Vp75NTU0hz7F+
         Lh5HbcSSd8SCz/dQgNC18m0sQCcWYL2HeJQefcFA927rSX1R+HmbCFNKDvn3GTtbt9z4
         RJDByT+H5uU1rG5wtY03p6L5OIyPPj/VHxtMA17l96URBHTyJsTR4Aq5Fooou/BT+9R+
         pw+A==
X-Gm-Message-State: ACrzQf2X3hroQou10zulEk1Gw9kj+L2wej3pdSLrIU0fLWnB5bxt8ewA
        2QFIUbht6HwnaFyBlXcY6Pbkiw==
X-Google-Smtp-Source: AMsMyM4L8SOoJcHWB9Q0dIN94Hk87oL/EEsykY5C9qsUdGXYtJTn3+Vuax6HmhZeJmRpEnPnR5NCww==
X-Received: by 2002:a05:6214:226f:b0:4bb:6579:5a2 with SMTP id gs15-20020a056214226f00b004bb657905a2mr882005qvb.32.1666454719053;
        Sat, 22 Oct 2022 09:05:19 -0700 (PDT)
Received: from [10.203.8.70] ([205.153.95.177])
        by smtp.gmail.com with ESMTPSA id t12-20020ac8530c000000b0039a55f78792sm9677424qtn.89.2022.10.22.09.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 09:05:18 -0700 (PDT)
Message-ID: <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
Date:   Sat, 22 Oct 2022 12:05:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Content-Language: en-US
To:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221021171055.85888-1-sebastian.reichel@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 13:10, Sebastian Reichel wrote:
> The queue configuration is referenced by snps,mtl-rx-config and
> snps,mtl-tx-config. Most in-tree DTs put the referenced object
> as child node of the dwmac node.
> 
> This adds proper description for this setup, which has the
> advantage of properly making sure only known properties are
> used.
> 
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 154 ++++++++++++------
>  1 file changed, 108 insertions(+), 46 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 13b984076af5..0bf6112cec2f 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -167,56 +167,118 @@ properties:
>    snps,mtl-rx-config:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> -      Multiple RX Queues parameters. Phandle to a node that can
> -      contain the following properties
> -        * snps,rx-queues-to-use, number of RX queues to be used in the
> -          driver
> -        * Choose one of these RX scheduling algorithms
> -          * snps,rx-sched-sp, Strict priority
> -          * snps,rx-sched-wsp, Weighted Strict priority
> -        * For each RX queue
> -          * Choose one of these modes
> -            * snps,dcb-algorithm, Queue to be enabled as DCB
> -            * snps,avb-algorithm, Queue to be enabled as AVB
> -          * snps,map-to-dma-channel, Channel to map
> -          * Specifiy specific packet routing
> -            * snps,route-avcp, AV Untagged Control packets
> -            * snps,route-ptp, PTP Packets
> -            * snps,route-dcbcp, DCB Control Packets
> -            * snps,route-up, Untagged Packets
> -            * snps,route-multi-broad, Multicast & Broadcast Packets
> -          * snps,priority, bitmask of the tagged frames priorities assigned to
> -            the queue
> +      Multiple RX Queues parameters. Phandle to a node that
> +      implements the 'rx-queues-config' object described in
> +      this binding.
> +
> +  rx-queues-config:

If this field is specific to this device, then you need vendor prefix:
snps,rq-queues-config

> +    type: object
> +    properties:
> +      snps,rx-queues-to-use:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: number of RX queues to be used in the driver
> +      snps,rx-sched-sp:
> +        type: boolean
> +        description: Strict priority
> +      snps,rx-sched-wsp:
> +        type: boolean
> +        description: Weighted Strict priority
> +    patternProperties:
> +      "^queue[0-9]$":
> +        description: Each subnode represents a queue.
> +        type: object
> +        properties:
> +          snps,dcb-algorithm:
> +            type: boolean
> +            description: Queue to be enabled as DCB
> +          snps,avb-algorithm:
> +            type: boolean
> +            description: Queue to be enabled as AVB
> +          snps,map-to-dma-channel:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: DMA channel id to map
> +          snps,route-avcp:
> +            type: boolean
> +            description: AV Untagged Control packets
> +          snps,route-ptp:
> +            type: boolean
> +            description: PTP Packets
> +          snps,route-dcbcp:
> +            type: boolean
> +            description: DCB Control Packets
> +          snps,route-up:
> +            type: boolean
> +            description: Untagged Packets
> +          snps,route-multi-broad:
> +            type: boolean
> +            description: Multicast & Broadcast Packets
> +          snps,priority:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: Bitmask of the tagged frames priorities assigned to the queue
> +    additionalProperties: false

Please update the DTS example with all this.

>  
>    snps,mtl-tx-config:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> -      Multiple TX Queues parameters. Phandle to a node that can
> -      contain the following properties
> -        * snps,tx-queues-to-use, number of TX queues to be used in the
> -          driver
> -        * Choose one of these TX scheduling algorithms
> -          * snps,tx-sched-wrr, Weighted Round Robin
> -          * snps,tx-sched-wfq, Weighted Fair Queuing
> -          * snps,tx-sched-dwrr, Deficit Weighted Round Robin
> -          * snps,tx-sched-sp, Strict priority
> -        * For each TX queue
> -          * snps,weight, TX queue weight (if using a DCB weight
> -            algorithm)
> -          * Choose one of these modes
> -            * snps,dcb-algorithm, TX queue will be working in DCB
> -            * snps,avb-algorithm, TX queue will be working in AVB
> -              [Attention] Queue 0 is reserved for legacy traffic
> -                          and so no AVB is available in this queue.
> -          * Configure Credit Base Shaper (if AVB Mode selected)
> -            * snps,send_slope, enable Low Power Interface
> -            * snps,idle_slope, unlock on WoL
> -            * snps,high_credit, max write outstanding req. limit
> -            * snps,low_credit, max read outstanding req. limit
> -          * snps,priority, bitmask of the priorities assigned to the queue.
> -            When a PFC frame is received with priorities matching the bitmask,
> -            the queue is blocked from transmitting for the pause time specified
> -            in the PFC frame.
> +      Multiple TX Queues parameters. Phandle to a node that
> +      implements the 'tx-queues-config' object described in
> +      this binding.
> +
> +  tx-queues-config:
> +    type: object
> +    properties:
> +      snps,tx-queues-to-use:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: number of TX queues to be used in the driver
> +      snps,tx-sched-wrr:
> +        type: boolean
> +        description: Weighted Round Robin
> +      snps,tx-sched-wfq:
> +        type: boolean
> +        description: Weighted Fair Queuing
> +      snps,tx-sched-dwrr:
> +        type: boolean
> +        description: Deficit Weighted Round Robin
> +      snps,tx-sched-sp:
> +        type: boolean
> +        description: Strict priority
> +    patternProperties:
> +      "^queue[0-9]$":
> +        description: Each subnode represents a queue.
> +        type: object
> +        properties:
> +          snps,weight:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description: TX queue weight (if using a DCB weight algorithm)
> +          snps,dcb-algorithm:
> +            type: boolean
> +            description: TX queue will be working in DCB
> +          snps,avb-algorithm:

Is DCB and AVB compatible with each other? If not, then this should be
rather enum (with a string for algorithm name).

This applies also to other fields which are mutually exclusive.

> +            type: boolean
> +            description:
> +              TX queue will be working in AVB.
> +              Queue 0 is reserved for legacy traffic and so no AVB is
> +              available in this queue.
> +          snps,send_slope:

Use hyphens, no underscores.
(This is already an incompatible change in bindings, so we can fix up
the naming)

> +            type: boolean
> +            description: enable Low Power Interface
> +          snps,idle_slope:
> +            type: boolean
> +            description: unlock on WoL
> +          snps,high_credit:
> +            type: boolean
> +            description: max write outstanding req. limit

Is it really a boolean?

> +          snps,low_credit:
> +            type: boolean
> +            description: max read outstanding req. limit

Same question

> +          snps,priority:
> +            $ref: /schemas/types.yaml#/definitions/uint32
> +            description:
> +              Bitmask of the tagged frames priorities assigned to the queue.
> +              When a PFC frame is received with priorities matching the bitmask,
> +              the queue is blocked from transmitting for the pause time specified
> +              in the PFC frame.
> +    additionalProperties: false
>  
>    snps,reset-gpio:
>      deprecated: true

Best regards,
Krzysztof

