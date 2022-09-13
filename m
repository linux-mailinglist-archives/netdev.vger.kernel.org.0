Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFA5B69DF
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbiIMIuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIMIus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:50:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2EE578B4
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:50:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bo13so3086586wrb.1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 01:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Ohjc9dEdH44oeiSaUzXYNAwgxLv5Lg5idMppRaZ9XgA=;
        b=H808Dg3rwQCarMzG/PWEUqyNlqs2cBSV17PuIMFqjM3kvWX45qIqUmhvWUU4v04vXS
         0eJroHx8Kdni1sh7tVSm9UXlpW5kpdCGAO1krmaBES063TG628AYqm139SIne85TKeYv
         ItPvqqmnsktPAlPmNZUmB7wXEe4ZwSDtZeaanDdV52Mp8yYScAuDg3SZtSIG0d6Jxxrx
         8g6vbtffCehAae/JJ/eaTXBkNzVo9hgNCLia3fM8O1jVdHSQHgRCJfvfRH5F88kFzhjV
         oVbt3qDSM0KmLwlbv3r17rs9tgX6gUBtI+BE1sr7+t0qG484rKgw7Cs3B8uATWIJSJ1c
         rUwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ohjc9dEdH44oeiSaUzXYNAwgxLv5Lg5idMppRaZ9XgA=;
        b=NAve4BoVKYj3vprPKiVerNBwBzOibnSQwbUy+0uK2HD75boZL/jQWP37GMh9WcKAXs
         1horSzxI74qLj088RIZFuAFRkhWcv2ctJ7bK2gEkr3h9+TyrfxKPf8tkMWzWNuhoGTgR
         KWQBQdYbV6T+RYyBNuEvii/aPdYq7gZj5n4h7bE6M6DNpSx+SmfaADVBNmoVgSNYB3Z2
         ZoHu6NTrPKO1bDrMETBsBUnjaFftfrJjhKpM9L2SwB+aPKfB8FoH7nKUTlZCZLuDRlpJ
         hxZ67/X9MXKsYR6Z9MRP9hACwerm6tfR6R9/lK+6KDN66KgxVtHzUI0YRPQx2xIlWMfY
         +mlw==
X-Gm-Message-State: ACgBeo2iHqbKnZcmqIFgD0vex2TXQiHhTcUY+bKFLuqQ2tEILt/JkDOb
        soJxi4tjhRmEbHmKi8biADxKtA==
X-Google-Smtp-Source: AA6agR4hv6qBRnUNqNnuJw0oXOGkLN22P0OlaGd2jb4dYMuQ1e1O4+iJDjQISHd8l/vJyW+uxepzSA==
X-Received: by 2002:a5d:6c63:0:b0:22a:4247:1e7c with SMTP id r3-20020a5d6c63000000b0022a42471e7cmr10784681wrz.625.1663059045577;
        Tue, 13 Sep 2022 01:50:45 -0700 (PDT)
Received: from [10.119.22.201] ([89.101.193.70])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c4fd300b003b3180551c8sm12549252wmq.40.2022.09.13.01.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 01:50:45 -0700 (PDT)
Message-ID: <1a683d12-eee9-e35b-3808-4856fe4dc0f2@linaro.org>
Date:   Tue, 13 Sep 2022 10:50:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/4] dt-bindings: net: qcom,ethqos: Convert bindings to
 yaml
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-2-bhupesh.sharma@linaro.org>
 <dcf449f5-ad28-d262-98d5-72c6ba2b7aea@linaro.org>
 <ccd6f6c2-458d-832a-7299-d9d9ffb652a8@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <ccd6f6c2-458d-832a-7299-d9d9ffb652a8@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/09/2022 19:28, Bhupesh Sharma wrote:
> Hi Krzysztof,
> 
> Thanks for your comments.
> 
> On 9/8/22 8:08 PM, Krzysztof Kozlowski wrote:
>> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>>> Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
>>>
>>> Cc: Bjorn Andersson <andersson@kernel.org>
>>> Cc: Rob Herring <robh@kernel.org>
>>> Cc: Vinod Koul <vkoul@kernel.org>
>>> Cc: David Miller <davem@davemloft.net>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> ---
>>>   .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ---------
>>>   .../devicetree/bindings/net/qcom,ethqos.yaml  | 139 ++++++++++++++++++
>>
>> You need to update maintainers - old path.
> 
> Sure, my bad. Will do in v2.
> 
>>>   2 files changed, 139 insertions(+), 66 deletions(-)
>>>   delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>>   create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>> deleted file mode 100644
>>> index 1f5746849a71..000000000000
>>> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>> +++ /dev/null
>>> @@ -1,66 +0,0 @@
>>> -Qualcomm Ethernet ETHQOS device
>>> -
>>> -This documents dwmmac based ethernet device which supports Gigabit
>>> -ethernet for version v2.3.0 onwards.
>>> -
>>> -This device has following properties:
>>> -
>>> -Required properties:
>>> -
>>> -- compatible: Should be one of:
>>> -		"qcom,qcs404-ethqos"
>>> -		"qcom,sm8150-ethqos"
>>> -
>>> -- reg: Address and length of the register set for the device
>>> -
>>> -- reg-names: Should contain register names "stmmaceth", "rgmii"
>>> -
>>> -- clocks: Should contain phandle to clocks
>>> -
>>> -- clock-names: Should contain clock names "stmmaceth", "pclk",
>>> -		"ptp_ref", "rgmii"
>>> -
>>> -- interrupts: Should contain phandle to interrupts
>>> -
>>> -- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
>>> -
>>> -Rest of the properties are defined in stmmac.txt file in same directory
>>> -
>>> -
>>> -Example:
>>> -
>>> -ethernet: ethernet@7a80000 {
>>> -	compatible = "qcom,qcs404-ethqos";
>>> -	reg = <0x07a80000 0x10000>,
>>> -		<0x07a96000 0x100>;
>>> -	reg-names = "stmmaceth", "rgmii";
>>> -	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
>>> -	clocks = <&gcc GCC_ETH_AXI_CLK>,
>>> -		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
>>> -		<&gcc GCC_ETH_PTP_CLK>,
>>> -		<&gcc GCC_ETH_RGMII_CLK>;
>>> -	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
>>> -			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
>>> -	interrupt-names = "macirq", "eth_lpi";
>>> -	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
>>> -	snps,reset-active-low;
>>> -
>>> -	snps,txpbl = <8>;
>>> -	snps,rxpbl = <2>;
>>> -	snps,aal;
>>> -	snps,tso;
>>> -
>>> -	phy-handle = <&phy1>;
>>> -	phy-mode = "rgmii";
>>> -
>>> -	mdio {
>>> -		#address-cells = <0x1>;
>>> -		#size-cells = <0x0>;
>>> -		compatible = "snps,dwmac-mdio";
>>> -		phy1: phy@4 {
>>> -			device_type = "ethernet-phy";
>>> -			reg = <0x4>;
>>> -		};
>>> -	};
>>> -
>>> -};
>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>> new file mode 100644
>>> index 000000000000..f05df9b0d106
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>> @@ -0,0 +1,139 @@
>>> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Qualcomm Ethernet ETHQOS device
>>> +
>>> +maintainers:
>>> +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> +
>>> +description:
>>> +  This binding describes the dwmmac based Qualcomm ethernet devices which
>>> +  support Gigabit ethernet (version v2.3.0 onwards).
>>> +
>>> +  So, this file documents platform glue layer for dwmmac stmmac based Qualcomm
>>> +  ethernet devices.
>>> +
>>> +allOf:
>>> +  - $ref: "snps,dwmac.yaml#"
>>
>> No need for quotes.
> 
> Ok.
> 
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - qcom,qcs404-ethqos
>>> +      - qcom,sm8150-ethqos
>>> +
>>> +  reg: true
>>
>> I think both devices use two reg spaces.
> 
> On this platform the two reg spaces are 64-bit, whereas for other
> platforms based on dwmmac, for e.g. stm32 have 32-bit address space.

Then for this platform this should be made specific/constrained, so it
must be two items.

> 
>>> +
>>> +  reg-names:
>>> +    minItems: 1
>>
>> Why allowing only one item?
> 
> Ok, let me remove this in v2.

And then as well you allow only one item... This should be specific. If
not - why?

> 
>>> +    items:
>>> +      - const: stmmaceth
>>> +      - const: rgmii
>>> +
>>> +  interrupts: true
>>
>> This should be specific/fixed.
>>
>>> +
>>> +  interrupt-names: true
>>
>> This should be specific/fixed.
> 
> These are same as in $ref: "snps,dwmac.yaml#", so
> do we really need to specify them here? I remember on the sdhci-msm
> YAML patch review, Rob mentioned that we should just set the property to 
> true, in such cases.

But it is not specific in dwmac.yaml. You use "xxx: true" when you want
to accept property from other schema, assuming it is defined there
properly. However the snps,dwmac does not define it in specific way
because it expects specific implementation to narrow the details.

> 
> Am I missing something here?
> 
>>> +
>>> +  clocks:
>>> +    minItems: 1
>>> +    maxItems: 4
>>
>> Why such flexibility?
> 
> Ok, let me just keep 'maxItems: 4' here for now.
> 
>>> +
>>> +  clock-names:
>>> +    minItems: 1
>>> +    items:
>>> +      - const: stmmaceth
>>> +      - const: pclk
>>> +      - const: ptp_ref
>>> +      - const: rgmii
>>> +
>>> +  iommus:
>>> +    minItems: 1
>>> +    maxItems: 2
>>
>> Aren't we using only one MMU?
> 
> It was just for future compatibility, but I get your point.
> Let me keep the 'maxItems: 1' here for now.
> 
>>> +
>>> +  mdio: true
>>> +
>>> +  phy-handle: true
>>> +
>>> +  phy-mode: true
>>> +
>>> +  snps,reset-gpio: true
>>> +
>>> +  snps,tso:
>>> +    $ref: /schemas/types.yaml#/definitions/flag
>>> +    description:
>>> +      Enables the TSO feature otherwise it will be managed by MAC HW capability register.
>>> +
>>> +  power-domains: true
>>> +
>>> +  resets: true
>>> +
>>> +  rx-fifo-depth: true
>>> +
>>> +  tx-fifo-depth: true
>>
>> You do not list all these properties, because you use
>> unevaluatedProperties. Drop all of these "xxx :true".
> 
> Same query as above. May be I am missing something here.

You do not list any properties:true from other schema, if you use
unevaluatedProperties:false.


Best regards,
Krzysztof
