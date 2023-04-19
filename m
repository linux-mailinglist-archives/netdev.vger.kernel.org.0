Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEDE6E82D5
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjDSUku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 16:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjDSUkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 16:40:49 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2071B6A5B;
        Wed, 19 Apr 2023 13:40:48 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JKePwK094762;
        Wed, 19 Apr 2023 15:40:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681936825;
        bh=jOrxa9o67/74X9hSjtDGSG0DsUqVFc0DPP8/q1F7lUA=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=dJiy0JCCecFVI/WM8n+HkyJbRjQRn7q9di9toqnVl3BnFe5cbVdER1tJSMdrIap+l
         HmCOt/34ZZ4Frfy2LSjE2C4vQY9iA6InfLUZdyxZTRLFCcPGnruOAweIsw5tE77WWJ
         mN9RKSgzhxu/w8mVY0YFV6QrSqd/tdrO3QqeCdvw=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JKeP7b029513
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 15:40:25 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 15:40:24 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 15:40:24 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JKeOSH000620;
        Wed, 19 Apr 2023 15:40:24 -0500
Message-ID: <52a37e51-4143-9017-42ee-8d17c67028e3@ti.com>
Date:   Wed, 19 Apr 2023 15:40:24 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Andrew Davis <afd@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230413223051.24455-1-jm@ti.com>
 <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
 <6eb588ef-ab12-186d-b0d3-35fc505a225a@ti.com>
 <20230419-stretch-tarantula-e0d21d067483-mkl@pengutronix.de>
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230419-stretch-tarantula-e0d21d067483-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On 4/19/2023 1:10 AM, Marc Kleine-Budde wrote:
> On 18.04.2023 11:15:35, Mendez, Judith wrote:
>> Hello Marc,
>>
>> On 4/14/2023 12:49 PM, Marc Kleine-Budde wrote:
>>> On 13.04.2023 17:30:46, Judith Mendez wrote:
>>>> On AM62x there is one MCAN in MAIN domain and two in MCU domain.
>>>> The MCANs in MCU domain were not enabled since there is no
>>>> hardware interrupt routed to A53 GIC interrupt controller.
>>>> Therefore A53 Linux cannot be interrupted by MCU MCANs.
>>>
>>> Is this a general hardware limitation, that effects all MCU domain
>>> peripherals? Is there a mailbox mechanism between the MCU and the MAIN
>>> domain, would it be possible to pass the IRQ with a small firmware on
>>> the MCU? Anyways, that's future optimization.
>>
>> This is a hardware limitation that affects AM62x SoC and has been carried
>> over to at least 1 other SoC. Using the MCU is an idea that we have juggled
>> around for a while, we will definitely keep it in mind for future
>> optimization. Thanks for your feedback.
> 
> Once you have a proper IRQ de-multiplexer, you can integrate it into the
> system with a DT change only. No need for changes in the m_can driver.
> 

Is this a recommendation for the current patch?

The reason I am asking is because adding firmware for the M4 to forward
a mailbox with the IRQ to the A53 sounds like a good idea and we have 
been juggling the idea, but it is not an ideal solution if customers are
using the M4 for other purposes like safety.

>>>> This solution instantiates a hrtimer with 1 ms polling interval
>>>> for a MCAN when there is no hardware interrupt. This hrtimer
>>>> generates a recurring software interrupt which allows to call the
>>>> isr. The isr will check if there is pending transaction by reading
>>>> a register and proceed normally if there is.
>>>>
>>>> On AM62x this series enables two MCU MCAN which will use the hrtimer
>>>> implementation. MCANs with hardware interrupt routed to A53 Linux
>>>> will continue to use the hardware interrupt as expected.
>>>>
>>>> Timer polling method was tested on both classic CAN and CAN-FD
>>>> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
>>>> switching.
>>>>
>>>> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
>>>> 1 MBPS timer polling interval is the better timer polling interval
>>>> since it has comparable latency to hardware interrupt with the worse
>>>> case being 1ms + CAN frame propagation time and CPU load is not
>>>> substantial. Latency can be improved further with less than 1 ms
>>>> polling intervals, howerver it is at the cost of CPU usage since CPU
>>>> load increases at 0.5 ms and lower polling periods than 1ms.
> 
> Have you seen my suggestion of the poll-interval?
> 
> Some Linux input drivers have the property poll-interval, would it make
> sense to ass this here too?

Looking at some examples, I do think we could implement this 
poll-interval attribute, then read in the driver and initialize the 
hrtimer based on this. I like the idea to submit as a future 
optimization patch, thanks!

regards,
Judith
