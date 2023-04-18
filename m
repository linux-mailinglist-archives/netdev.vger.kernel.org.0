Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765346E6927
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 18:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDRQQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 12:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbjDRQQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 12:16:00 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201309015;
        Tue, 18 Apr 2023 09:15:58 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33IGFZBV066640;
        Tue, 18 Apr 2023 11:15:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681834535;
        bh=b2Muf9dAA40HdBdETNXJB5N4N/DA+1zVrwJXAjg9daI=;
        h=Date:Subject:To:References:From:CC:In-Reply-To;
        b=VTZiIC/ITCgUJh36OJI1SkfMDN5QGiLg2ijgpecW+kqi+6VVdF7n0Bkh8wUPZ9By/
         2uYskEJ56d2qeTyEiA7O2hwDju2j6q/gBFOdKAxUDVQb63Ng4+7QEzFkZMzqxiFCl/
         IzgigGjLVcA3kOzDip1NpvCYL2/zcywxUycvbFFw=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33IGFZhc017910
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Apr 2023 11:15:35 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 18
 Apr 2023 11:15:35 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 18 Apr 2023 11:15:35 -0500
Received: from [128.247.81.102] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33IGFZ19006354;
        Tue, 18 Apr 2023 11:15:35 -0500
Message-ID: <6eb588ef-ab12-186d-b0d3-35fc505a225a@ti.com>
Date:   Tue, 18 Apr 2023 11:15:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
To:     Marc Kleine-Budde <mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
Content-Language: en-US
From:   "Mendez, Judith" <jm@ti.com>
CC:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Andrew Davis <afd@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
In-Reply-To: <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
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

On 4/14/2023 12:49 PM, Marc Kleine-Budde wrote:
> On 13.04.2023 17:30:46, Judith Mendez wrote:
>> On AM62x there is one MCAN in MAIN domain and two in MCU domain.
>> The MCANs in MCU domain were not enabled since there is no
>> hardware interrupt routed to A53 GIC interrupt controller.
>> Therefore A53 Linux cannot be interrupted by MCU MCANs.
> 
> Is this a general hardware limitation, that effects all MCU domain
> peripherals? Is there a mailbox mechanism between the MCU and the MAIN
> domain, would it be possible to pass the IRQ with a small firmware on
> the MCU? Anyways, that's future optimization.
> 

This is a hardware limitation that affects AM62x SoC and has been 
carried over to at least 1 other SoC. Using the MCU is an idea that we 
have juggled around for a while, we will definitely keep it in mind for 
future optimization. Thanks for your feedback.

>> This solution instantiates a hrtimer with 1 ms polling interval
>> for a MCAN when there is no hardware interrupt. This hrtimer
>> generates a recurring software interrupt which allows to call the
>> isr. The isr will check if there is pending transaction by reading
>> a register and proceed normally if there is.
>>
>> On AM62x this series enables two MCU MCAN which will use the hrtimer
>> implementation. MCANs with hardware interrupt routed to A53 Linux
>> will continue to use the hardware interrupt as expected.
>>
>> Timer polling method was tested on both classic CAN and CAN-FD
>> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
>> switching.
>>
>> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
>> 1 MBPS timer polling interval is the better timer polling interval
>> since it has comparable latency to hardware interrupt with the worse
>> case being 1ms + CAN frame propagation time and CPU load is not
>> substantial. Latency can be improved further with less than 1 ms
>> polling intervals, howerver it is at the cost of CPU usage since CPU
>> load increases at 0.5 ms and lower polling periods than 1ms.
> 
> Some Linux input drivers have the property poll-interval, would it make
> sense to ass this here too?
> 
>> Note that in terms of power, enabling MCU MCANs with timer-polling
>> implementation might have negative impact since we will have to wake
>> up every 1 ms whether there are CAN packets pending in the RX FIFO or
>> not. This might prevent the CPU from entering into deeper idle states
>> for extended periods of time.
>>
>> This patch series depends on 'Enable CAN PHY transceiver driver':
>> https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/
> 
> Marc
> 

regards,
Judith
