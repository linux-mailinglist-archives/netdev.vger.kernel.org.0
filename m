Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5A66B7D7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjAPHMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjAPHMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:12:50 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFCBA27E;
        Sun, 15 Jan 2023 23:12:49 -0800 (PST)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30G7Cds2074886;
        Mon, 16 Jan 2023 01:12:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1673853159;
        bh=cc11iHQ63PE/nwdE6OUo30YQ42MZ5Fp6VHmba/e5I70=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=IoTN5noMnqfCSy0a+1iwTWNKgJi8IPqktuzjHJQG5vyNxoZHBh6rM7I5d0Tcvsdiu
         AosYqoj+cxQHT0dPcCzBbbqwpuTOPUbs8I7VpI90aoIodZUcfAGwCmqrLbDxbiSDLa
         FmvUsBEhTgxsrYXTNRXkWp0o7Fc2LdwV19LgeReI=
Received: from DFLE111.ent.ti.com (dfle111.ent.ti.com [10.64.6.32])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30G7CdOm020638
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 16 Jan 2023 01:12:39 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 16
 Jan 2023 01:12:38 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 16 Jan 2023 01:12:39 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30G7CX7s084527;
        Mon, 16 Jan 2023 01:12:34 -0600
Message-ID: <a889a47f-5f44-1ae6-1ab7-3b7e7011b4f7@ti.com>
Date:   Mon, 16 Jan 2023 12:42:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nm@ti.com>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <nsekhar@ti.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next 5/5] arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts
 PPS support
Content-Language: en-US
To:     Roger Quadros <rogerq@kernel.org>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-6-s-vadapalli@ti.com>
 <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <6ae650c9-d68d-d2fc-8319-b7784cd2a749@kernel.org>
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

Roger,

On 13/01/23 15:48, Roger Quadros wrote:
> Hi,
> 
> On 11/01/2023 13:44, Siddharth Vadapalli wrote:
>> The CPTS driver is capable of configuring GENFy (Periodic Signal Generator
>> Function) present in the CPTS module, to generate periodic output signals
>> with a custom time period. In order to generate a PPS signal on the GENFy
>> output, the device-tree property "ti,pps" has to be used. The "ti,pps"
>> property is used to declare the mapping between the CPTS HWx_TS_PUSH
>> (Hardware Timestamp trigger) input and the GENFy output that is configured
>> to generate a PPS signal. The mapping is of the form:
>> <x-1 y>
>> where the value x corresponds to HWx_TS_PUSH input (1-based indexing) and
>> the value y corresponds to GENFy (0-based indexing).
> 
> You mean there is no HWx_TX_PUSH0 pin? so user needs to use 0 for HWx_TX_PUSH1 pin?

The HWx_TX_PUSH pins correspond to the cpts_hw1_push, cpts_hw2_push,...,
cpts_hw8_push pins. The names are documented at:

Link:
https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations

Thus, considering that the documentation uses 1-based indexing, I wanted to
indicate that the driver expects 0-based indexing, and therefore the user would
have to provide (x-1) for cpsw_hwx_push pin.

> 
> Can you please define macros for HWx_TS_PUSH and GENFy so we avoid
> human error with this different indexing methods?
> 
> DT should contain the name exactly in hardware.
> 
> So if pin is called HWx_TX_PUSH1 in hardware then DT should contain HWx_TX_PUSH(1).

The pins are called HW1_TX_PUSH, HW2_TX_PUSH and so on. This 1-based indexing is
followed in the Technical Reference Manual. Similarly, the documentation in the
link above also uses 1-based indexing: cpts_hw1_push, cpts_hw2_push, and so on.

However, for the GENFy pins, the documentation consistently uses 0-based
indexing. Thus, the driver expects indices that are 0-based and the user is
expected to convert the x to x-1 for the HWx_TX_PUSH pins while the y in GENFy
pins can be used directly as it is already 0-based indexing.

> 
>>
>> To verify that the signal is a PPS signal, the GENFy output signal is fed
>> into the CPTS HWx_TS_PUSH input, which generates a timestamp event on the
>> rising edge of the GENFy signal. The GENFy output signal can be routed to
>> the HWx_TS_PUSH input by using the Time Sync Router. This is done by
>> mentioning the mapping between the GENFy output and the HWx_TS_PUSH input
>> within the "timesync_router" device-tree node.
>>
>> The Input Sources to the Time Sync Router are documented at: [1]
>> The Output Destinations of the Time Sync Router are documented at: [2]
>>
>> The PPS signal can be verified using testptp and ppstest tools as follows:
>>  # ./testptp -d /dev/ptp0 -P 1
>>  pps for system time request okay
>>  # ./ppstest /dev/pps0
>>  trying PPS source "/dev/pps0"
>>  found PPS source "/dev/pps0"
>>  ok, found 1 source(s), now start fetching data...
>>  source 0 - assert 48.000000013, sequence: 8 - clear  0.000000000, sequence: 0
>>  source 0 - assert 49.000000013, sequence: 9 - clear  0.000000000, sequence: 0
>>  source 0 - assert 50.000000013, sequence: 10 - clear  0.000000000, sequence: 0
>>
>> Add an example in the device-tree, enabling PPS generation on GENF1. The
>> HW3_TS_PUSH Timestamp trigger input is used to verify the PPS signal.
>>
>> [1]
>> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-input-sources
>> [2]
>> Link: https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/am62x/interrupt_cfg.html#timesync-event-router0-interrupt-router-output-destinations
>>
>> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
>> ---
>>  arch/arm64/boot/dts/ti/k3-am625-sk.dts | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>> index 4f179b146cab..962a922cc94b 100644
>> --- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
>> @@ -366,6 +366,10 @@ &cpsw3g {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&main_rgmii1_pins_default
>>  		     &main_rgmii2_pins_default>;
>> +
>> +	cpts@3d000 {
>> +		ti,pps = <2 1>;
>> +	};
>>  };
>>  
>>  &cpsw_port1 {
>> @@ -464,3 +468,19 @@ partition@3fc0000 {
>>  		};
>>  	};
>>  };
>> +
>> +#define TS_OFFSET(pa, val)	(0x4+(pa)*4) (0x10000 | val)
> 
> Should this go in ./include/dt-bindings/pinctrl/k3.h ?
> That way every board DT file doesn't have to define it.
> 
> The name should be made more platform specific.
> e.g. K3_TS_OFFSET if it is the same for all K3 platforms.
> If not then please add Platform name instead of K3.

The offsets are board specific. If it is acceptable, I will add board specific
macro for the TS_OFFSET definition in the ./include/dt-bindings/pinctrl/k3.h
file. Please let me know.

Regards,
Siddharth.
