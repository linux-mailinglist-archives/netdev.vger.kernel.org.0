Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2636F539031
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbiEaMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343980AbiEaMAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 08:00:11 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D9F4B876;
        Tue, 31 May 2022 05:00:10 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 24VBxvmB051554;
        Tue, 31 May 2022 06:59:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1653998397;
        bh=NCF8qzJXZvRI2xr8UI7DFywm74Lxqfy9OUTIpn0OUjM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=IeW/gJ/cW2iicX2vwufN757RUnpatOCqMfqdZ58Fq/aJ6SV2wxTomRe4AKDsaUANV
         kCrq58L4vM4EEe4mHBO/A0x3+HaQbJsKb5x5e3vX1VPE5rGdOjxF09sdz8xEH0/mu4
         PnZEuKtEjALRGWjEdRToGt+Jsr6Nc6WDnIvnvqZU=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 24VBxvQw030965
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 31 May 2022 06:59:57 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 31
 May 2022 06:59:56 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 31 May 2022 06:59:56 -0500
Received: from [172.24.220.119] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 24VBxnGq089567;
        Tue, 31 May 2022 06:59:50 -0500
Message-ID: <c13f79c9-ffca-d81d-8904-95c424dd19bc@ti.com>
Date:   Tue, 31 May 2022 17:29:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <nm@ti.com>, <ssantosh@kernel.org>,
        <s-anna@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@kernel.org>, <grygorii.strashko@ti.com>, <vigneshr@ti.com>,
        <kishon@ti.com>, <robh+dt@kernel.org>, <afd@ti.com>,
        <andrew@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
 <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
 <a47f5d18-9ecc-a679-b407-799e4a15c6cf@linaro.org>
From:   Puranjay Mohan <p-mohan@ti.com>
In-Reply-To: <a47f5d18-9ecc-a679-b407-799e4a15c6cf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

On 31/05/22 17:18, Krzysztof Kozlowski wrote:
> On 31/05/2022 13:27, Puranjay Mohan wrote:
>>>> +examples:
>>>> +  - |
>>>> +
>>>> +    /* Example k3-am654 base board SR2.0, dual-emac */
>>>> +    pruss2_eth: pruss2_eth {
>>>> +            compatible = "ti,am654-icssg-prueth";
>>>
>>> Again missed Rob's comment.
>>
>> One of Rob's comment was to make the indentation as 4 which I have done.
> 
> I clearly do not see indentation of 4, but there is 8 instead.

I changed the indentation at the wrong place.

> 
> Let's count:
> +    pruss2_eth: pruss2_eth {
^ here, it was 8 in v1 so, I changed it to 4

> +            compatible = "ti,am654-icssg-prueth";
>      12345678^
> 

Compatible is the child of pruss2_eth, so, It should have 4+4 = 8?

> It's 8...
> 
>>
>> The second comment was about 'ti,prus'.
>>
>> So, ti,prus , firmware-name, and ti,pruss-gp-mux-sel are a part of
>> remoteproc/ti,pru-consumer.yaml which I have included with
>>
>> allOf:
>>   - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>>
>> So, I thought it is not required to add them again.
>>
>> I will add it in next version, if that is how it should be done.
> I was referring to the indentation.
> 
> Krzysztof

Thanks,
Puranjay
