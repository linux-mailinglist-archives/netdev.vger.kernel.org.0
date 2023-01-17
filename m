Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C92B66D9FD
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbjAQJcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbjAQJbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF2523670;
        Tue, 17 Jan 2023 01:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E871461228;
        Tue, 17 Jan 2023 09:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D01C433EF;
        Tue, 17 Jan 2023 09:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673947842;
        bh=Pa8118QX+TAvlu83PlPPJ0HZtwugWhDjYy0v4yJQQrA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=heHCYglHXa1m77v/+hkmFmnKPZvw5j7MCUdrcAwkYvskrQVBk3W0eP0ecf95UGjcA
         5RQ0f4T6gFWNRFc3OnYfPnFiloTBx4GG5v9LeBoeMgV8WfVuy9wQMh8g+kHqHpejcT
         3MVyBijAhGjMjAUAMhKZ8DwbVUf9BYJHFDnLpeNyYuBFeh2Mq0m7UIHrGQ9DXgp1yg
         bzBOVafcjmueRI8HHI3Bvbt/MEdcu+/q+8ksTtTDW440QwaKB3JLEIuymGIzDJKLBD
         Bv31mSCXB4zAK5N4aaf9TUIuVlLwOpTW8/VxgcFnRBVGzp/Kx9dUZlHOWbSc8ct5Lb
         fzVbBNBoJDAEg==
Message-ID: <7bc26f28-2541-8cc4-3cde-abbe4bdf8911@kernel.org>
Date:   Tue, 17 Jan 2023 11:30:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts
 PPS support
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nm@ti.com, kristo@kernel.org, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-6-s-vadapalli@ti.com>
 <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
 <a889a47f-5f44-1ae6-1ab7-3b7e7011b4f7@ti.com>
 <2007adb5-0980-eee3-8d2f-e30183cf408e@kernel.org>
 <4d7ac24a-0a35-323c-045c-cc5b3d3c715a@ti.com>
 <566700c6-df9b-739b-81ff-8745eea10ff3@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <566700c6-df9b-739b-81ff-8745eea10ff3@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2023 07:28, Siddharth Vadapalli wrote:
> Vignesh,
> 
> On 16/01/23 22:00, Vignesh Raghavendra wrote:
>>
>>
>> On 16/01/23 9:35 pm, Roger Quadros wrote:
>>>>>> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>> index 4f179b146cab..962a922cc94b 100644
>>>>>> --- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>>>>>> @@ -366,6 +366,10 @@ &cpsw3g {
>>>>>>  	pinctrl-names = "default";
>>>>>>  	pinctrl-0 = <&main_rgmii1_pins_default
>>>>>>  		     &main_rgmii2_pins_default>;
>>>>>> +
>>>>>> +	cpts@3d000 {
>>>>>> +		ti,pps = <2 1>;
>>>>>> +	};
>>>>>>  };
>>>>>>  
>>>>>>  &cpsw_port1 {
>>>>>> @@ -464,3 +468,19 @@ partition@3fc0000 {
>>>>>>  		};
>>>>>>  	};
>>>>>>  };
>>>>>> +
>>>>>> +#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
>>>>> Should this go in ./include/dt-bindings/pinctrl/k3.h ?
>>>>> That way every board DT file doesn't have to define it.
>>>>>
>>>>> The name should be made more platform specific.
>>>>> e.g. K3_TS_OFFSET if it is the same for all K3 platforms.
>>>>> If not then please add Platform name instead of K3.
>>>> The offsets are board specific. If it is acceptable, I will add board specific
>>>> macro for the TS_OFFSET definition in the ./include/dt-bindings/pinctrl/k3.h
>>>> file. Please let me know.
>>> If it is board specific then it should remain in the board file.
>>
>>
>> The values you pass to macro maybe board specific. But the macro
>> definition itself same for a given SoC right? Also, is its same across
>> K3 family ?
>>

I misunderstood then. I agree with Vignesh.

>> Please use SoC specific prefix like AM62X_TS_OFFSET() or K3_TS_OFFSET()
>> accordingly.
> 
> For certain SoCs including AM62X, the macro is:
> #define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
> while for other SoCs (refer [0]), the macro is:
> #define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x80000000 | val)
> 
> Therefore, I will use SoC specific prefix in the macro. Please let me know if
> the SoC specific macro can be added to the ./include/dt-bindings/pinctrl/k3.h
> file for each SoC. If not, I will add the SoC specific macro in the board file
> itself.

Not in board file please. It should go in ./include/dt-bindings/pinctrl/k3.h

> 
> [0] https://lwn.net/Articles/819313/
> 
> Regards,
> Siddharth.

cheers,
-roger
