Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222BE6B2351
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjCILpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbjCILpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:45:10 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522799FE57;
        Thu,  9 Mar 2023 03:45:09 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 329BilmV067182;
        Thu, 9 Mar 2023 05:44:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678362288;
        bh=/q/r+VqIDQV+nyf/HFdFt7S4d1PgKsozHa8XIbxD8aY=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=nAnAGXYW/BIh78fUHAF8Qk8hBwnEkuy5WmwDM9NDgykbzDS94TzunNiSbEHM08EZf
         SIWLabHhn09QBlt8dfoAKNl6ODNLNseANMBusUJ7MwbOnfTuRmU91N+5Vx38gcKRZl
         U/BcI1f82iMoQ6L9rvjidTWmPcFBFyVr70O/u3WA=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 329BiliX027723
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 Mar 2023 05:44:47 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 9
 Mar 2023 05:44:47 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 9 Mar 2023 05:44:47 -0600
Received: from [10.24.69.114] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 329BifPD012701;
        Thu, 9 Mar 2023 05:44:42 -0600
Message-ID: <d7f18805-7b26-e2c9-a40e-262165ec8f9b@ti.com>
Date:   Thu, 9 Mar 2023 17:14:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG
 Ethernet
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>,
        MD Danish Anwar <danishanwar@ti.com>
CC:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>,
        <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
 <20230210192001.GB2923614-robh@kernel.org>
 <43df3c2c-d0d0-f2b8-cf8b-8a2453ca43b4@ti.com>
 <63dbbda7-a444-8dac-6399-45e305652155@linaro.org>
From:   Md Danish Anwar <a0501179@ti.com>
Organization: Texas Instruments
In-Reply-To: <63dbbda7-a444-8dac-6399-45e305652155@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 07/03/23 14:28, Krzysztof Kozlowski wrote:
> On 07/03/2023 05:57, Md Danish Anwar wrote:
>>>> +allOf:
>>>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>>>> +
>>>> +properties:
>>>> +  compatible:
>>>> +    enum:
>>>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>>>> +
>>>> +  ti,sram:
>>>> +    $ref: /schemas/types.yaml#/definitions/phandle
>>>> +    description:
>>>> +      phandle to MSMC SRAM node
>>>
>>> I believe we have a standard 'sram' property to point to SRAM nodes 
>>> assuming this is just mmio-sram or similar.
>>>
>>
>> Yes, we have standard 'sram' property but Krzysztof had asked me to make the
>> sram property vendor specific in last revision of this series.
> 
> Sorry about that. I missed that we already have a 'sram'. The question
> remains whether this is a phandle to MMIO SRAM or similar (sram.yaml).
> 
> Best regards,
> Krzysztof
> 

The SRAM that we are using here is phandle to MMIO-SRAM only. In the example
section you can see, sram node points to msmc_ram (ti,sram = <&msmc_ram>;) And
msmc_ram has compatible as "mmio-sram" in k3-am65-main.dtsi [1].

	msmc_ram: sram@70000000 {
		compatible = "mmio-sram";
		reg = <0x0 0x70000000 0x0 0x200000>;

So I can use 'sram' property as there is no need to make this as ti specific.
Let me know if it seems good to you.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/ti/k3-am65-main.dtsi?h=v6.3-rc1#n11

-- 
Thanks and Regards,
Danish.
