Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE366DA29
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbjAQJmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236477AbjAQJlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:41:06 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35FC8233D9;
        Tue, 17 Jan 2023 01:39:50 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30H9dVR0074470;
        Tue, 17 Jan 2023 03:39:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673948371;
        bh=hCiMEEOZ0FA8xfOwTl/n4EZiudIDwrwZeoE9cRopsZM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=cvWEJ4Gj9JaBKSK0BBWt5ooV2x9m9QfJfCM0v5TB7WWQZEPc8is83BIpbShZzcwqr
         NFwqcfEFgR/ZljXrDeRfHsuTYJJEQ2+FQwBjQEvdipZL+Zrqes3rdkxngaq2b5uru+
         xkVITYKTvik9s+e7s9uR76Jqs9IAF01MWxBuSi1o=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30H9dVWR108848
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Jan 2023 03:39:31 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 17
 Jan 2023 03:39:31 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 17 Jan 2023 03:39:31 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30H9dPuq018076;
        Tue, 17 Jan 2023 03:39:26 -0600
Message-ID: <3bd25e86-37c9-e2c5-d957-2ed111a3f4a7@ti.com>
Date:   Tue, 17 Jan 2023 15:09:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, <kristo@kernel.org>,
        <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts
 PPS support
Content-Language: en-US
To:     Roger Quadros <rogerq@kernel.org>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-6-s-vadapalli@ti.com>
 <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
 <a889a47f-5f44-1ae6-1ab7-3b7e7011b4f7@ti.com>
 <2007adb5-0980-eee3-8d2f-e30183cf408e@kernel.org>
 <4d7ac24a-0a35-323c-045c-cc5b3d3c715a@ti.com>
 <566700c6-df9b-739b-81ff-8745eea10ff3@ti.com>
 <7bc26f28-2541-8cc4-3cde-abbe4bdf8911@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <7bc26f28-2541-8cc4-3cde-abbe4bdf8911@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Roger,

On 17/01/23 15:00, Roger Quadros wrote:
> On 17/01/2023 07:28, Siddharth Vadapalli wrote:
>> Vignesh,
>>
>> On 16/01/23 22:00, Vignesh Raghavendra wrote:
>>>
>>>
>>> On 16/01/23 9:35 pm, Roger Quadros wrote:
>>>>>>> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>>> index 4f179b146cab..962a922cc94b 100644
>>>>>>> --- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>>> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>>> @@ -366,6 +366,10 @@ &cpsw3g {
>>>>>>>  	pinctrl-names = "default";
>>>>>>>  	pinctrl-0 = <&main_rgmii1_pins_default
>>>>>>>  		     &main_rgmii2_pins_default>;
>>>>>>> +
>>>>>>> +	cpts@3d000 {
>>>>>>> +		ti,pps = <2 1>;
>>>>>>> +	};
>>>>>>>  };
>>>>>>>  
>>>>>>>  &cpsw_port1 {
>>>>>>> @@ -464,3 +468,19 @@ partition@3fc0000 {
>>>>>>>  		};
>>>>>>>  	};
>>>>>>>  };
>>>>>>> +
>>>>>>> +#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
>>>>>> Should this go in ./include/dt-bindings/pinctrl/k3.h ?
>>>>>> That way every board DT file doesn't have to define it.
>>>>>>
>>>>>> The name should be made more platform specific.
>>>>>> e.g. K3_TS_OFFSET if it is the same for all K3 platforms.
>>>>>> If not then please add Platform name instead of K3.
>>>>> The offsets are board specific. If it is acceptable, I will add board specific
>>>>> macro for the TS_OFFSET definition in the ./include/dt-bindings/pinctrl/k3.h
>>>>> file. Please let me know.
>>>> If it is board specific then it should remain in the board file.
>>>
>>>
>>> The values you pass to macro maybe board specific. But the macro
>>> definition itself same for a given SoC right? Also, is its same across
>>> K3 family ?
>>>
> 
> I misunderstood then. I agree with Vignesh.
> 
>>> Please use SoC specific prefix like AM62X_TS_OFFSET() or K3_TS_OFFSET()
>>> accordingly.
>>
>> For certain SoCs including AM62X, the macro is:
>> #define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
>> while for other SoCs (refer [0]), the macro is:
>> #define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x80000000 | val)
>>
>> Therefore, I will use SoC specific prefix in the macro. Please let me know if
>> the SoC specific macro can be added to the ./include/dt-bindings/pinctrl/k3.h
>> file for each SoC. If not, I will add the SoC specific macro in the board file
>> itself.
> 
> Not in board file please. It should go in ./include/dt-bindings/pinctrl/k3.h

Thank you for letting me know. I will do so in the device-tree series that I
will post once the bindings and driver patches get merged.

The v2 series for the bindings and driver patches that I am referring to is at:
https://lore.kernel.org/r/20230116085534.440820-1-s-vadapalli@ti.com/

Regards,
Siddharth.
