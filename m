Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B826C389E
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCURus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCURuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:50:46 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EED515D6;
        Tue, 21 Mar 2023 10:50:44 -0700 (PDT)
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LFCjkB011925;
        Tue, 21 Mar 2023 18:50:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=y0KlYJt6rx8ndn2XMFbV20udYR6+jSpQILTQmqixjj0=;
 b=S4Kt+hmBPcC+fMY/0pngwOonkxa5Pu/evww+5KfD+YZKMuV7eG82Xi5Pk8YuCZkBM1C6
 uaBXpB1rt8IGKkstX9uIMxdUuvbCqiAmfx4VXERxix8wvbAUVJ5ed0CBf0kb0icpOtUS
 CTAqFWbrtZIWlDj5rSYlIdED2FQVVEpPjJ/OpYIqah2ltXkqR2Rq3qnzxgO4TmzxThYd
 YvY4ZfjBLaZn39QRzu+1Qd5g3gfzs2xmcQD6sI5+NV7gVqSLnMrnsQv/IdiHHUvK0zxP
 jyA4SQTLDAjkyjFCKfclHKvOW8JqsjuaQ/A5i1BNIfWjWx8ocsFXCvSF59wmSpnY9OUr ew== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3pfb67agfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Mar 2023 18:50:18 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9A40010002A;
        Tue, 21 Mar 2023 18:50:16 +0100 (CET)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8DABE21B529;
        Tue, 21 Mar 2023 18:50:16 +0100 (CET)
Received: from [10.201.21.93] (10.201.21.93) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 21 Mar
 2023 18:50:15 +0100
Message-ID: <d1f31c4f-d752-4702-7888-06bd7a6080d9@foss.st.com>
Date:   Tue, 21 Mar 2023 18:50:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RESEND PATCH v7 0/5] can: bxcan: add support for ST bxCAN
 controller
Content-Language: en-US
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh@kernel.org>, Rob Herring <robh+dt@kernel.org>
CC:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        <michael@amarulasolutions.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-can@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <netdev@vger.kernel.org>
References: <20230315211040.2455855-1-dario.binacchi@amarulasolutions.com>
 <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
From:   Alexandre TORGUE <alexandre.torgue@foss.st.com>
In-Reply-To: <CABGWkvpHHLNzZHDMzWveoHtApmR3czVvoCOnuWBZt-UoLVU-6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.21.93]
X-ClientProxiedBy: EQNCAS1NODE3.st.com (10.75.129.80) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dario,


On 3/21/23 12:25, Dario Binacchi wrote:
> A gentle ping to remind you of this series.
> I have no idea why it hasn't deserved any response for quite some
> time.
> Is there anything I am still missing?
> 
> Please let me know.

I'm just waiting driver (+dt-binding) merge. I prefer that dt-bindings 
and driver patches are merged first (to avoid yaml issue with DT 
pacthes). To be honest, I have not checked the status about those patches.


Cheers
Alex



> Thanks and regards,
> 
> Dario
> 
> 
> On Wed, Mar 15, 2023 at 10:10 PM Dario Binacchi
> <dario.binacchi@amarulasolutions.com> wrote:
>>
>> The series adds support for the basic extended CAN controller (bxCAN)
>> found in many low- to middle-end STM32 SoCs.
>>
>> The driver design (one core module and one driver module) was inspired
>> by other ST drivers (e. g. drivers/iio/adc/stm32-adc.c,
>> drivers/iio/adc/stm32-adc-core.c) where device instances share resources.
>> The shared resources functions are implemented in the core module, the
>> device driver in a separate module.
>>
>> The driver has been tested on the stm32f469i-discovery board with a
>> kernel version 5.19.0-rc2 in loopback + silent mode:
>>
>> ip link set can0 type can bitrate 125000 loopback on listen-only on
>> ip link set up can0
>> candump can0 -L &
>> cansend can0 300#AC.AB.AD.AE.75.49.AD.D1
>>
>> For uboot and kernel compilation, as well as for rootfs creation I used
>> buildroot:
>>
>> make stm32f469_disco_sd_defconfig
>> make
>>
>> but I had to patch can-utils and busybox as can-utils and iproute are
>> not compiled for MMU-less microcotrollers. In the case of can-utils,
>> replacing the calls to fork() with vfork(), I was able to compile the
>> package with working candump and cansend applications, while in the
>> case of iproute, I ran into more than one problem and finally I decided
>> to extend busybox's ip link command for CAN-type devices. I'm still
>> wondering if it was really necessary, but this way I was able to test
>> the driver.
>>
>> Changes in v7:
>> - Add Vincent Mailhol's Reviewed-by tag.
>> - Remove all unused macros for reading/writing the controller registers.
>> - Add CAN_ERR_CNT flag to notify availability of error counter.
>> - Move the "break" before the newline in the switch/case statements.
>> - Print the mnemotechnic instead of the error value in each netdev_err().
>> - Remove the debug print for timings parameter.
>> - Do not copy the data if CAN_RTR_FLAG is set in bxcan_start_xmit().
>> - Populate ndev->ethtool_ops with the default timestamp info.
>>
>> Changes in v6:
>> - move can1 node before gcan to keep ordering by address.
>>
>> Changes in v5:
>> - Add Rob Herring's Acked-by tag.
>> - Add Rob Herring's Reviewed-by tag.
>> - Put static in front of bxcan_enable_filters() definition.
>>
>> Changes in v4:
>> - Remove "st,stm32f4-bxcan-core" compatible. In this way the can nodes
>>   (compatible "st,stm32f4-bxcan") are no longer children of a parent
>>    node with compatible "st,stm32f4-bxcan-core".
>> - Add the "st,gcan" property (global can memory) to can nodes which
>>    references a "syscon" node containing the shared clock and memory
>>    addresses.
>> - Replace the node can@40006400 (compatible "st,stm32f4-bxcan-core")
>>    with the gcan@40006600 node ("sysnode" compatible). The gcan node
>>    contains clocks and memory addresses shared by the two can nodes
>>    of which it's no longer the parent.
>> - Add to can nodes the "st,gcan" property (global can memory) which
>>    references the gcan@40006600 node ("sysnode compatibble).
>> - Add "dt-bindings: arm: stm32: add compatible for syscon gcan node" patch.
>> - Drop the core driver. Thus bxcan-drv.c has been renamed to bxcan.c and
>>    moved to the drivers/net/can folder. The drivers/net/can/bxcan directory
>>    has therefore been removed.
>> - Use the regmap_*() functions to access the shared memory registers.
>> - Use spinlock to protect bxcan_rmw().
>> - Use 1 space, instead of tabs, in the macros definition.
>> - Drop clock ref-counting.
>> - Drop unused code.
>> - Drop the _SHIFT macros and use FIELD_GET()/FIELD_PREP() directly.
>> - Add BXCAN_ prefix to lec error codes.
>> - Add the macro BXCAN_RX_MB_NUM.
>> - Enable time triggered mode and use can_rx_offload().
>> - Use readx_poll_timeout() in function with timeouts.
>> - Loop from tail to head in bxcan_tx_isr().
>> - Check bits of tsr register instead of pkts variable in bxcan_tx_isr().
>> - Don't return from bxcan_handle_state_change() if skb/cf are NULL.
>> - Enable/disable the generation of the bus error interrupt depending
>>    on can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING.
>> - Don't return from bxcan_handle_bus_err() if skb is NULL.
>> - Drop statistics updating from bxcan_handle_bus_err().
>> - Add an empty line in front of 'return IRQ_HANDLED;'
>> - Rename bxcan_start() to bxcan_chip_start().
>> - Rename bxcan_stop() to bxcan_chip_stop().
>> - Disable all IRQs in bxcan_chip_stop().
>> - Rename bxcan_close() to bxcan_ndo_stop().
>> - Use writel instead of bxcan_rmw() to update the dlc register.
>>
>> Changes in v3:
>> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
>> - Add description to the parent of the two child nodes.
>> - Move "patterProperties:" after "properties: in top level before "required".
>> - Add "clocks" to the "required:" list of the child nodes.
>> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
>> - Add "clocks" to can@0 node.
>> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
>> - Remove a blank line.
>> - Remove 'Dario Binacchi <dariobin@libero.it>' SOB.
>> - Fix the documentation file path in the MAINTAINERS entry.
>> - Do not increment the "stats->rx_bytes" if the frame is remote.
>> - Remove pr_debug() call from bxcan_rmw().
>>
>> Changes in v2:
>> - Change the file name into 'st,stm32-bxcan-core.yaml'.
>> - Rename compatibles:
>>    - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>>    - st,stm32-bxcan -> st,stm32f4-bxcan
>> - Rename master property to st,can-master.
>> - Remove the status property from the example.
>> - Put the node child properties as required.
>> - Remove a blank line.
>> - Fix sparse errors.
>> - Create a MAINTAINERS entry.
>> - Remove the print of the registers address.
>> - Remove the volatile keyword from bxcan_rmw().
>> - Use tx ring algorithm to manage tx mailboxes.
>> - Use can_{get|put}_echo_skb().
>> - Update DT properties.
>>
>> Dario Binacchi (5):
>>    dt-bindings: arm: stm32: add compatible for syscon gcan node
>>    dt-bindings: net: can: add STM32 bxcan DT bindings
>>    ARM: dts: stm32: add CAN support on stm32f429
>>    ARM: dts: stm32: add pin map for CAN controller on stm32f4
>>    can: bxcan: add support for ST bxCAN controller
>>
>>   .../bindings/arm/stm32/st,stm32-syscon.yaml   |    2 +
>>   .../bindings/net/can/st,stm32-bxcan.yaml      |   83 ++
>>   MAINTAINERS                                   |    7 +
>>   arch/arm/boot/dts/stm32f4-pinctrl.dtsi        |   30 +
>>   arch/arm/boot/dts/stm32f429.dtsi              |   29 +
>>   drivers/net/can/Kconfig                       |   12 +
>>   drivers/net/can/Makefile                      |    1 +
>>   drivers/net/can/bxcan.c                       | 1088 +++++++++++++++++
>>   8 files changed, 1252 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
>>   create mode 100644 drivers/net/can/bxcan.c
>>
>> --
>> 2.32.0
>>
> 
> 

