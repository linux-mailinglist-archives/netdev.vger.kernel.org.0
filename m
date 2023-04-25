Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80436EDD59
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjDYH5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjDYH5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:57:19 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2843293;
        Tue, 25 Apr 2023 00:57:14 -0700 (PDT)
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P6OTAD022623;
        Tue, 25 Apr 2023 09:56:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=hdaBXsJgbQP2/aGkUlXeWBc2DwqHvn9brTrgvp+8UKU=;
 b=6ynGTmcZFLSqobiHNMsJIyIdry7k2cdLeW+ErTk2A8pa8tcAOtcLyGcfxjTQ8/kvS3Wt
 rzQC7TKb7XBoI9/JR+RHe9L3lMMGDPu1mEv0FyNGXLSlzuTGkEvHj5ibHey7NI4lNJ/W
 BgAKFkVeoivlWPU0JTWKMETMoDuRorWrD8kMIFu2EssME7gkUhk2qRhGU1x/UrDIJ4ia
 t/EiJMhQoNSzdNbxYnT9PvTlSvm1jOq2c9HjY2yCpQOfF5XNhVVJ651jJgMRR83EevJ5
 S4Xegdkdq4arvcybj/Ijm7hoIRzEFFEZOaqN5MjeziFz3MTsk9T4QUtR8eDc9HoWO8fm Eg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3q48evrd70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 09:56:32 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1C99F10002A;
        Tue, 25 Apr 2023 09:56:27 +0200 (CEST)
Received: from Webmail-eu.st.com (shfdag1node1.st.com [10.75.129.69])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8BD3E2171DF;
        Tue, 25 Apr 2023 09:56:27 +0200 (CEST)
Received: from [10.201.21.121] (10.201.21.121) by SHFDAG1NODE1.st.com
 (10.75.129.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 25 Apr
 2023 09:56:26 +0200
Message-ID: <f1fbf285-1b41-0d98-eea6-b352d3b3bd77@foss.st.com>
Date:   Tue, 25 Apr 2023 09:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Linux-stm32] [PATCH v3 6/6] ARM: dts: stm32: add ETZPC as a
 system bus for STM32MP13x boards
To:     Oleksii Moisieiev <Oleksii_Moisieiev@epam.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "olivier.moysan@foss.st.com" <olivier.moysan@foss.st.com>,
        "arnaud.pouliquen@foss.st.com" <arnaud.pouliquen@foss.st.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "fabrice.gasnier@foss.st.com" <fabrice.gasnier@foss.st.com>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Peng Fan <peng.fan@oss.nxp.com>
References: <20230127164040.1047583-1-gatien.chevallier@foss.st.com>
 <20230127164040.1047583-7-gatien.chevallier@foss.st.com>
 <da51fd69-e3e8-510c-00b1-b5213d0696b1@pengutronix.de>
 <64ac012e-e471-9093-b253-4798bbfa8cb4@pengutronix.de>
 <837908e8-8ace-5c2e-f9fb-8b50054426f2@foss.st.com>
 <b0049051-b571-79bf-1820-c0eb18e39dc2@pengutronix.de>
 <f6b038d4-3524-f8eb-390f-11d90a8ac5b6@foss.st.com>
 <a1ef17b0-1a8f-5633-de30-1d96130ccc66@epam.com>
Content-Language: en-US
From:   Gatien CHEVALLIER <gatien.chevallier@foss.st.com>
In-Reply-To: <a1ef17b0-1a8f-5633-de30-1d96130ccc66@epam.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.21.121]
X-ClientProxiedBy: SHFCAS1NODE2.st.com (10.75.129.73) To SHFDAG1NODE1.st.com
 (10.75.129.69)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-21_01,2023-02-09_01
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/23 12:19, Oleksii Moisieiev wrote:
> Hello,
> 
> I'm just wandering what is the status of the Patch Series?
> 
> Cc'ed Peng Fang as he also has an interest in the domain-controller
> bindings.
> 
> Oleksii.
>

Hello Oleksii,

I need to rework this patch series before resubmitting it. I did not 
forget it :) I'd like to provide a good use-case on how to property can 
be used and maybe narrow down its perimeter/use-cases.

Peng, to which extent are you interested in this binding? What would be 
your use-case?

Best regards,
Gatien

> On 27.02.23 13:26, Gatien CHEVALLIER wrote:
>> Hello Ahmad,
>>
>> Sorry for the delay :)
>>
>> On 2/13/23 12:27, Ahmad Fatoum wrote:
>>> Hello Gatien,
>>>
>>> On 13.02.23 11:54, Gatien CHEVALLIER wrote:
>>>> On 2/9/23 09:10, Ahmad Fatoum wrote:
>>>>> On 09.02.23 08:46, Ahmad Fatoum wrote:
>>>>>> Hello Gatien,
>>>>>>
>>>>>> On 27.01.23 17:40, Gatien Chevallier wrote:
>>>>>>> The STM32 System Bus is an internal bus on which devices are
>>>>>>> connected.
>>>>>>> ETZPC is a peripheral overseeing the firewall bus that configures
>>>>>>> and control access to the peripherals connected on it.
>>>>>>>
>>>>>>> For more information on which peripheral is securable, please read
>>>>>>> the STM32MP13 reference manual.
>>>>>>
>>>>>> Diff is way too big. Please split up the alphabetic reordering
>>>>>> into its
>>>>>> own commit, so actual functional changes are apparent.
>>>>>
>>>>> Ah, I see now that you are moving securable peripherals into a new
>>>>> bus.
>>>>> I share Uwe's confusion of considering the ETZPC as bus.
>>>>>
>>>>> Does this configuration even change dynamically? Why can't you
>>>>> implement
>>>>> this binding in the bootloader and have Linux only see a DT where
>>>>> unavailable
>>>>> nodes are status = "disabled"; secure-status = "okay"?
>>>>>
>>>>> For inspiration, see barebox' device tree fixups when devices are
>>>>> disabled
>>>>> per fuse:
>>>>>
>>>>> https://urldefense.com/v3/__https://elixir.bootlin.com/barebox/v2023.01.0/source/drivers/base/featctrl.c*L122__;Iw!!GF_29dbcQIUBPA!2CT6VXNxfrLUg3mPkiAykgwwu8y8TVPaVa5FupuehHDyeuPvx4a2aNuMs-ayUCqP8q364P8u0GxYprlqwrvgvnXndYBmii57$
>>>>> [elixir[.]bootlin[.]com]
>>>>>
>>>>> Cheers,
>>>>> Ahmad
>>>>
>>>> This configuration can change dynamically. The binding will be
>>>> implemented in the bootloader, where the ETZPC is already
>>>> implemented as a bus in our downstream.
>>>>
>>>> I find the mentionned example valid.
>>>>
>>>> Now, why is it a bus? :D
>>>>
>>>> It is the result of the discussion on the previous submission by
>>>> Benjamin (Sorry for the lack of link but I saw that you participated
>>>> on these threads)+ we need the bus mechanism to control whether a
>>>> subnode should be probed or not. You can see it as a firewall bus.
>>>>
>>>> The ETZPC relies on the ARM TrustZone extension to the AHB bus and
>>>> propagation through bridges to the APB bus. Therefore, I find it
>>>> relevant to consider it as a bus, what is your opinion?
>>>>
>>>> This patchset is a first step to the implementation of an API to
>>>> control accesses dynamically.
>>>
>>> I still don't get what's dynamic about this. Either:
>>>
>>>     - Configuration _can_ change while Linux is running: You'll need
>>> to do
>>>       way more than what your current bus provides to somwhow
>>> synchronize state
>>>       with the secure monitor; otherwise a newly secured device will
>>> cause the driver
>>>       to trigger data aborts that you'll have to handle and unbind the
>>> driver.
>>>       (like if a USB drive is yanked out).
>>>
>>>     - Configuration _can't_ change while Linux is running: You can
>>> have the bootloader
>>>       fixup the device tree and Linux need not care at all about
>>> devices that the
>>>       ETZPC is securing.
>>>
>>> My understanding is that the latter is your use case, so I don't see
>>> why we
>>> even need the normal world to be aware of the partitioning.
>>>
>>> Cheers,
>>> Ahmad
>>>
>> What about the case where we do not have a U-Boot/bootloader to fixup
>> the device tree?
>>
>> On the other hand, ETZPC is a hardware firewall and is on the bus.
>> Therefore, shouldn't it be represented as a bus in the file that
>> describes the hardware?
>>
>> Best regards,
>> Gatien
>>
>>>>
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Ahmad
>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>>>>>> ---
>>>>>>>
>>>>>>> No changes in V2.
>>>>>>>
>>>>>>> Changes in V3:
>>>>>>>       -Use appriopriate node name: bus
>>>>>>>
>>>>>>>     arch/arm/boot/dts/stm32mp131.dtsi  | 407
>>>>>>> +++++++++++++++--------------
>>>>>>>     arch/arm/boot/dts/stm32mp133.dtsi  |  51 ++--
>>>>>>>     arch/arm/boot/dts/stm32mp13xc.dtsi |  19 +-
>>>>>>>     arch/arm/boot/dts/stm32mp13xf.dtsi |  18 +-
>>>>>>>     4 files changed, 258 insertions(+), 237 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/arm/boot/dts/stm32mp131.dtsi
>>>>>>> b/arch/arm/boot/dts/stm32mp131.dtsi
>>>>>>> index accc3824f7e9..24462a647101 100644
>>>>>>> --- a/arch/arm/boot/dts/stm32mp131.dtsi
>>>>>>> +++ b/arch/arm/boot/dts/stm32mp131.dtsi
>>>>>>> @@ -253,148 +253,6 @@ dmamux1: dma-router@48002000 {
>>>>>>>                 dma-channels = <16>;
>>>>>>>             };
>>>>>>>     -        adc_2: adc@48004000 {
>>>>>>> -            compatible = "st,stm32mp13-adc-core";
>>>>>>> -            reg = <0x48004000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc ADC2>, <&rcc ADC2_K>;
>>>>>>> -            clock-names = "bus", "adc";
>>>>>>> -            interrupt-controller;
>>>>>>> -            #interrupt-cells = <1>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            status = "disabled";
>>>>>>> -
>>>>>>> -            adc2: adc@0 {
>>>>>>> -                compatible = "st,stm32mp13-adc";
>>>>>>> -                #io-channel-cells = <1>;
>>>>>>> -                #address-cells = <1>;
>>>>>>> -                #size-cells = <0>;
>>>>>>> -                reg = <0x0>;
>>>>>>> -                interrupt-parent = <&adc_2>;
>>>>>>> -                interrupts = <0>;
>>>>>>> -                dmas = <&dmamux1 10 0x400 0x80000001>;
>>>>>>> -                dma-names = "rx";
>>>>>>> -                status = "disabled";
>>>>>>> -
>>>>>>> -                channel@13 {
>>>>>>> -                    reg = <13>;
>>>>>>> -                    label = "vrefint";
>>>>>>> -                };
>>>>>>> -                channel@14 {
>>>>>>> -                    reg = <14>;
>>>>>>> -                    label = "vddcore";
>>>>>>> -                };
>>>>>>> -                channel@16 {
>>>>>>> -                    reg = <16>;
>>>>>>> -                    label = "vddcpu";
>>>>>>> -                };
>>>>>>> -                channel@17 {
>>>>>>> -                    reg = <17>;
>>>>>>> -                    label = "vddq_ddr";
>>>>>>> -                };
>>>>>>> -            };
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        usbotg_hs: usb@49000000 {
>>>>>>> -            compatible = "st,stm32mp15-hsotg", "snps,dwc2";
>>>>>>> -            reg = <0x49000000 0x40000>;
>>>>>>> -            clocks = <&rcc USBO_K>;
>>>>>>> -            clock-names = "otg";
>>>>>>> -            resets = <&rcc USBO_R>;
>>>>>>> -            reset-names = "dwc2";
>>>>>>> -            interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            g-rx-fifo-size = <512>;
>>>>>>> -            g-np-tx-fifo-size = <32>;
>>>>>>> -            g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
>>>>>>> -            dr_mode = "otg";
>>>>>>> -            otg-rev = <0x200>;
>>>>>>> -            usb33d-supply = <&usb33>;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        spi4: spi@4c002000 {
>>>>>>> -            compatible = "st,stm32h7-spi";
>>>>>>> -            reg = <0x4c002000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc SPI4_K>;
>>>>>>> -            resets = <&rcc SPI4_R>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            dmas = <&dmamux1 83 0x400 0x01>,
>>>>>>> -                   <&dmamux1 84 0x400 0x01>;
>>>>>>> -            dma-names = "rx", "tx";
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        spi5: spi@4c003000 {
>>>>>>> -            compatible = "st,stm32h7-spi";
>>>>>>> -            reg = <0x4c003000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc SPI5_K>;
>>>>>>> -            resets = <&rcc SPI5_R>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            dmas = <&dmamux1 85 0x400 0x01>,
>>>>>>> -                   <&dmamux1 86 0x400 0x01>;
>>>>>>> -            dma-names = "rx", "tx";
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        i2c3: i2c@4c004000 {
>>>>>>> -            compatible = "st,stm32mp13-i2c";
>>>>>>> -            reg = <0x4c004000 0x400>;
>>>>>>> -            interrupt-names = "event", "error";
>>>>>>> -            interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> -                     <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc I2C3_K>;
>>>>>>> -            resets = <&rcc I2C3_R>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            dmas = <&dmamux1 73 0x400 0x1>,
>>>>>>> -                   <&dmamux1 74 0x400 0x1>;
>>>>>>> -            dma-names = "rx", "tx";
>>>>>>> -            st,syscfg-fmp = <&syscfg 0x4 0x4>;
>>>>>>> -            i2c-analog-filter;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        i2c4: i2c@4c005000 {
>>>>>>> -            compatible = "st,stm32mp13-i2c";
>>>>>>> -            reg = <0x4c005000 0x400>;
>>>>>>> -            interrupt-names = "event", "error";
>>>>>>> -            interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> -                     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc I2C4_K>;
>>>>>>> -            resets = <&rcc I2C4_R>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            dmas = <&dmamux1 75 0x400 0x1>,
>>>>>>> -                   <&dmamux1 76 0x400 0x1>;
>>>>>>> -            dma-names = "rx", "tx";
>>>>>>> -            st,syscfg-fmp = <&syscfg 0x4 0x8>;
>>>>>>> -            i2c-analog-filter;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        i2c5: i2c@4c006000 {
>>>>>>> -            compatible = "st,stm32mp13-i2c";
>>>>>>> -            reg = <0x4c006000 0x400>;
>>>>>>> -            interrupt-names = "event", "error";
>>>>>>> -            interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> -                     <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc I2C5_K>;
>>>>>>> -            resets = <&rcc I2C5_R>;
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            dmas = <&dmamux1 115 0x400 0x1>,
>>>>>>> -                   <&dmamux1 116 0x400 0x1>;
>>>>>>> -            dma-names = "rx", "tx";
>>>>>>> -            st,syscfg-fmp = <&syscfg 0x4 0x10>;
>>>>>>> -            i2c-analog-filter;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>>             rcc: rcc@50000000 {
>>>>>>>                 compatible = "st,stm32mp13-rcc", "syscon";
>>>>>>>                 reg = <0x50000000 0x1000>;
>>>>>>> @@ -431,34 +289,6 @@ mdma: dma-controller@58000000 {
>>>>>>>                 dma-requests = <48>;
>>>>>>>             };
>>>>>>>     -        sdmmc1: mmc@58005000 {
>>>>>>> -            compatible = "st,stm32-sdmmc2", "arm,pl18x",
>>>>>>> "arm,primecell";
>>>>>>> -            arm,primecell-periphid = <0x20253180>;
>>>>>>> -            reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
>>>>>>> -            interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc SDMMC1_K>;
>>>>>>> -            clock-names = "apb_pclk";
>>>>>>> -            resets = <&rcc SDMMC1_R>;
>>>>>>> -            cap-sd-highspeed;
>>>>>>> -            cap-mmc-highspeed;
>>>>>>> -            max-frequency = <130000000>;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>> -        sdmmc2: mmc@58007000 {
>>>>>>> -            compatible = "st,stm32-sdmmc2", "arm,pl18x",
>>>>>>> "arm,primecell";
>>>>>>> -            arm,primecell-periphid = <0x20253180>;
>>>>>>> -            reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
>>>>>>> -            interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc SDMMC2_K>;
>>>>>>> -            clock-names = "apb_pclk";
>>>>>>> -            resets = <&rcc SDMMC2_R>;
>>>>>>> -            cap-sd-highspeed;
>>>>>>> -            cap-mmc-highspeed;
>>>>>>> -            max-frequency = <130000000>;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> -
>>>>>>>             usbh_ohci: usb@5800c000 {
>>>>>>>                 compatible = "generic-ohci";
>>>>>>>                 reg = <0x5800c000 0x1000>;
>>>>>>> @@ -486,29 +316,6 @@ iwdg2: watchdog@5a002000 {
>>>>>>>                 status = "disabled";
>>>>>>>             };
>>>>>>>     -        usbphyc: usbphyc@5a006000 {
>>>>>>> -            #address-cells = <1>;
>>>>>>> -            #size-cells = <0>;
>>>>>>> -            #clock-cells = <0>;
>>>>>>> -            compatible = "st,stm32mp1-usbphyc";
>>>>>>> -            reg = <0x5a006000 0x1000>;
>>>>>>> -            clocks = <&rcc USBPHY_K>;
>>>>>>> -            resets = <&rcc USBPHY_R>;
>>>>>>> -            vdda1v1-supply = <&reg11>;
>>>>>>> -            vdda1v8-supply = <&reg18>;
>>>>>>> -            status = "disabled";
>>>>>>> -
>>>>>>> -            usbphyc_port0: usb-phy@0 {
>>>>>>> -                #phy-cells = <0>;
>>>>>>> -                reg = <0>;
>>>>>>> -            };
>>>>>>> -
>>>>>>> -            usbphyc_port1: usb-phy@1 {
>>>>>>> -                #phy-cells = <1>;
>>>>>>> -                reg = <1>;
>>>>>>> -            };
>>>>>>> -        };
>>>>>>> -
>>>>>>>             rtc: rtc@5c004000 {
>>>>>>>                 compatible = "st,stm32mp1-rtc";
>>>>>>>                 reg = <0x5c004000 0x400>;
>>>>>>> @@ -536,6 +343,220 @@ ts_cal2: calib@5e {
>>>>>>>                 };
>>>>>>>             };
>>>>>>>     +        etzpc: bus@5c007000 {
>>>>>>> +            compatible = "st,stm32mp13-sys-bus";
>>>>>>> +            reg = <0x5c007000 0x400>;
>>>>>>> +            #address-cells = <1>;
>>>>>>> +            #size-cells = <1>;
>>>>>>> +            feature-domain-controller;
>>>>>>> +            #feature-domain-cells = <1>;
>>>>>>> +            ranges;
>>>>>>> +
>>>>>>> +            adc_2: adc@48004000 {
>>>>>>> +                compatible = "st,stm32mp13-adc-core";
>>>>>>> +                reg = <0x48004000 0x400>;
>>>>>>> +                interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc ADC2>, <&rcc ADC2_K>;
>>>>>>> +                clock-names = "bus", "adc";
>>>>>>> +                interrupt-controller;
>>>>>>> +                #interrupt-cells = <1>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                feature-domains = <&etzpc 33>;
>>>>>>> +                status = "disabled";
>>>>>>> +
>>>>>>> +                adc2: adc@0 {
>>>>>>> +                    compatible = "st,stm32mp13-adc";
>>>>>>> +                    #io-channel-cells = <1>;
>>>>>>> +                    #address-cells = <1>;
>>>>>>> +                    #size-cells = <0>;
>>>>>>> +                    reg = <0x0>;
>>>>>>> +                    interrupt-parent = <&adc_2>;
>>>>>>> +                    interrupts = <0>;
>>>>>>> +                    dmas = <&dmamux1 10 0x400 0x80000001>;
>>>>>>> +                    dma-names = "rx";
>>>>>>> +                    status = "disabled";
>>>>>>> +
>>>>>>> +                    channel@13 {
>>>>>>> +                        reg = <13>;
>>>>>>> +                        label = "vrefint";
>>>>>>> +                    };
>>>>>>> +                    channel@14 {
>>>>>>> +                        reg = <14>;
>>>>>>> +                        label = "vddcore";
>>>>>>> +                    };
>>>>>>> +                    channel@16 {
>>>>>>> +                        reg = <16>;
>>>>>>> +                        label = "vddcpu";
>>>>>>> +                    };
>>>>>>> +                    channel@17 {
>>>>>>> +                        reg = <17>;
>>>>>>> +                        label = "vddq_ddr";
>>>>>>> +                    };
>>>>>>> +                };
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            usbotg_hs: usb@49000000 {
>>>>>>> +                compatible = "st,stm32mp15-hsotg", "snps,dwc2";
>>>>>>> +                reg = <0x49000000 0x40000>;
>>>>>>> +                clocks = <&rcc USBO_K>;
>>>>>>> +                clock-names = "otg";
>>>>>>> +                resets = <&rcc USBO_R>;
>>>>>>> +                reset-names = "dwc2";
>>>>>>> +                interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                g-rx-fifo-size = <512>;
>>>>>>> +                g-np-tx-fifo-size = <32>;
>>>>>>> +                g-tx-fifo-size = <256 16 16 16 16 16 16 16>;
>>>>>>> +                dr_mode = "otg";
>>>>>>> +                otg-rev = <0x200>;
>>>>>>> +                usb33d-supply = <&usb33>;
>>>>>>> +                feature-domains = <&etzpc 34>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            spi4: spi@4c002000 {
>>>>>>> +                compatible = "st,stm32h7-spi";
>>>>>>> +                reg = <0x4c002000 0x400>;
>>>>>>> +                interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc SPI4_K>;
>>>>>>> +                resets = <&rcc SPI4_R>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                dmas = <&dmamux1 83 0x400 0x01>,
>>>>>>> +                       <&dmamux1 84 0x400 0x01>;
>>>>>>> +                dma-names = "rx", "tx";
>>>>>>> +                feature-domains = <&etzpc 18>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            spi5: spi@4c003000 {
>>>>>>> +                compatible = "st,stm32h7-spi";
>>>>>>> +                reg = <0x4c003000 0x400>;
>>>>>>> +                interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc SPI5_K>;
>>>>>>> +                resets = <&rcc SPI5_R>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                dmas = <&dmamux1 85 0x400 0x01>,
>>>>>>> +                       <&dmamux1 86 0x400 0x01>;
>>>>>>> +                dma-names = "rx", "tx";
>>>>>>> +                feature-domains = <&etzpc 19>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            i2c3: i2c@4c004000 {
>>>>>>> +                compatible = "st,stm32mp13-i2c";
>>>>>>> +                reg = <0x4c004000 0x400>;
>>>>>>> +                interrupt-names = "event", "error";
>>>>>>> +                interrupts = <GIC_SPI 73 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> +                         <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc I2C3_K>;
>>>>>>> +                resets = <&rcc I2C3_R>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                dmas = <&dmamux1 73 0x400 0x1>,
>>>>>>> +                       <&dmamux1 74 0x400 0x1>;
>>>>>>> +                dma-names = "rx", "tx";
>>>>>>> +                st,syscfg-fmp = <&syscfg 0x4 0x4>;
>>>>>>> +                i2c-analog-filter;
>>>>>>> +                feature-domains = <&etzpc 20>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            i2c4: i2c@4c005000 {
>>>>>>> +                compatible = "st,stm32mp13-i2c";
>>>>>>> +                reg = <0x4c005000 0x400>;
>>>>>>> +                interrupt-names = "event", "error";
>>>>>>> +                interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> +                         <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc I2C4_K>;
>>>>>>> +                resets = <&rcc I2C4_R>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                dmas = <&dmamux1 75 0x400 0x1>,
>>>>>>> +                       <&dmamux1 76 0x400 0x1>;
>>>>>>> +                dma-names = "rx", "tx";
>>>>>>> +                st,syscfg-fmp = <&syscfg 0x4 0x8>;
>>>>>>> +                i2c-analog-filter;
>>>>>>> +                feature-domains = <&etzpc 21>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            i2c5: i2c@4c006000 {
>>>>>>> +                compatible = "st,stm32mp13-i2c";
>>>>>>> +                reg = <0x4c006000 0x400>;
>>>>>>> +                interrupt-names = "event", "error";
>>>>>>> +                interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
>>>>>>> +                         <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc I2C5_K>;
>>>>>>> +                resets = <&rcc I2C5_R>;
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                dmas = <&dmamux1 115 0x400 0x1>,
>>>>>>> +                       <&dmamux1 116 0x400 0x1>;
>>>>>>> +                dma-names = "rx", "tx";
>>>>>>> +                st,syscfg-fmp = <&syscfg 0x4 0x10>;
>>>>>>> +                i2c-analog-filter;
>>>>>>> +                feature-domains = <&etzpc 22>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            sdmmc1: mmc@58005000 {
>>>>>>> +                compatible = "st,stm32-sdmmc2", "arm,pl18x",
>>>>>>> "arm,primecell";
>>>>>>> +                arm,primecell-periphid = <0x20253180>;
>>>>>>> +                reg = <0x58005000 0x1000>, <0x58006000 0x1000>;
>>>>>>> +                interrupts = <GIC_SPI 50 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc SDMMC1_K>;
>>>>>>> +                clock-names = "apb_pclk";
>>>>>>> +                resets = <&rcc SDMMC1_R>;
>>>>>>> +                cap-sd-highspeed;
>>>>>>> +                cap-mmc-highspeed;
>>>>>>> +                max-frequency = <130000000>;
>>>>>>> +                feature-domains = <&etzpc 50>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            sdmmc2: mmc@58007000 {
>>>>>>> +                compatible = "st,stm32-sdmmc2", "arm,pl18x",
>>>>>>> "arm,primecell";
>>>>>>> +                arm,primecell-periphid = <0x20253180>;
>>>>>>> +                reg = <0x58007000 0x1000>, <0x58008000 0x1000>;
>>>>>>> +                interrupts = <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +                clocks = <&rcc SDMMC2_K>;
>>>>>>> +                clock-names = "apb_pclk";
>>>>>>> +                resets = <&rcc SDMMC2_R>;
>>>>>>> +                cap-sd-highspeed;
>>>>>>> +                cap-mmc-highspeed;
>>>>>>> +                max-frequency = <130000000>;
>>>>>>> +                feature-domains = <&etzpc 51>;
>>>>>>> +                status = "disabled";
>>>>>>> +            };
>>>>>>> +
>>>>>>> +            usbphyc: usbphyc@5a006000 {
>>>>>>> +                #address-cells = <1>;
>>>>>>> +                #size-cells = <0>;
>>>>>>> +                #clock-cells = <0>;
>>>>>>> +                compatible = "st,stm32mp1-usbphyc";
>>>>>>> +                reg = <0x5a006000 0x1000>;
>>>>>>> +                clocks = <&rcc USBPHY_K>;
>>>>>>> +                resets = <&rcc USBPHY_R>;
>>>>>>> +                vdda1v1-supply = <&reg11>;
>>>>>>> +                vdda1v8-supply = <&reg18>;
>>>>>>> +                feature-domains = <&etzpc 5>;
>>>>>>> +                status = "disabled";
>>>>>>> +
>>>>>>> +                usbphyc_port0: usb-phy@0 {
>>>>>>> +                    #phy-cells = <0>;
>>>>>>> +                    reg = <0>;
>>>>>>> +                };
>>>>>>> +
>>>>>>> +                usbphyc_port1: usb-phy@1 {
>>>>>>> +                    #phy-cells = <1>;
>>>>>>> +                    reg = <1>;
>>>>>>> +                };
>>>>>>> +            };
>>>>>>> +
>>>>>>> +        };
>>>>>>> +
>>>>>>>             /*
>>>>>>>              * Break node order to solve dependency probe issue
>>>>>>> between
>>>>>>>              * pinctrl and exti.
>>>>>>> diff --git a/arch/arm/boot/dts/stm32mp133.dtsi
>>>>>>> b/arch/arm/boot/dts/stm32mp133.dtsi
>>>>>>> index df451c3c2a26..be6061552683 100644
>>>>>>> --- a/arch/arm/boot/dts/stm32mp133.dtsi
>>>>>>> +++ b/arch/arm/boot/dts/stm32mp133.dtsi
>>>>>>> @@ -33,35 +33,38 @@ m_can2: can@4400f000 {
>>>>>>>                 bosch,mram-cfg = <0x1400 0 0 32 0 0 2 2>;
>>>>>>>                 status = "disabled";
>>>>>>>             };
>>>>>>> +    };
>>>>>>> +};
>>>>>>>     -        adc_1: adc@48003000 {
>>>>>>> -            compatible = "st,stm32mp13-adc-core";
>>>>>>> -            reg = <0x48003000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc ADC1>, <&rcc ADC1_K>;
>>>>>>> -            clock-names = "bus", "adc";
>>>>>>> -            interrupt-controller;
>>>>>>> -            #interrupt-cells = <1>;
>>>>>>> +&etzpc {
>>>>>>> +    adc_1: adc@48003000 {
>>>>>>> +        compatible = "st,stm32mp13-adc-core";
>>>>>>> +        reg = <0x48003000 0x400>;
>>>>>>> +        interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +        clocks = <&rcc ADC1>, <&rcc ADC1_K>;
>>>>>>> +        clock-names = "bus", "adc";
>>>>>>> +        interrupt-controller;
>>>>>>> +        #interrupt-cells = <1>;
>>>>>>> +        #address-cells = <1>;
>>>>>>> +        #size-cells = <0>;
>>>>>>> +        feature-domains = <&etzpc 32>;
>>>>>>> +        status = "disabled";
>>>>>>> +
>>>>>>> +        adc1: adc@0 {
>>>>>>> +            compatible = "st,stm32mp13-adc";
>>>>>>> +            #io-channel-cells = <1>;
>>>>>>>                 #address-cells = <1>;
>>>>>>>                 #size-cells = <0>;
>>>>>>> +            reg = <0x0>;
>>>>>>> +            interrupt-parent = <&adc_1>;
>>>>>>> +            interrupts = <0>;
>>>>>>> +            dmas = <&dmamux1 9 0x400 0x80000001>;
>>>>>>> +            dma-names = "rx";
>>>>>>>                 status = "disabled";
>>>>>>>     -            adc1: adc@0 {
>>>>>>> -                compatible = "st,stm32mp13-adc";
>>>>>>> -                #io-channel-cells = <1>;
>>>>>>> -                #address-cells = <1>;
>>>>>>> -                #size-cells = <0>;
>>>>>>> -                reg = <0x0>;
>>>>>>> -                interrupt-parent = <&adc_1>;
>>>>>>> -                interrupts = <0>;
>>>>>>> -                dmas = <&dmamux1 9 0x400 0x80000001>;
>>>>>>> -                dma-names = "rx";
>>>>>>> -                status = "disabled";
>>>>>>> -
>>>>>>> -                channel@18 {
>>>>>>> -                    reg = <18>;
>>>>>>> -                    label = "vrefint";
>>>>>>> -             ��  };
>>>>>>> +            channel@18 {
>>>>>>> +                reg = <18>;
>>>>>>> +                label = "vrefint";
>>>>>>>                 };
>>>>>>>             };
>>>>>>>         };
>>>>>>> diff --git a/arch/arm/boot/dts/stm32mp13xc.dtsi
>>>>>>> b/arch/arm/boot/dts/stm32mp13xc.dtsi
>>>>>>> index 4d00e7592882..a1a7a40c2a3e 100644
>>>>>>> --- a/arch/arm/boot/dts/stm32mp13xc.dtsi
>>>>>>> +++ b/arch/arm/boot/dts/stm32mp13xc.dtsi
>>>>>>> @@ -4,15 +4,14 @@
>>>>>>>      * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for
>>>>>>> STMicroelectronics.
>>>>>>>      */
>>>>>>>     -/ {
>>>>>>> -    soc {
>>>>>>> -        cryp: crypto@54002000 {
>>>>>>> -            compatible = "st,stm32mp1-cryp";
>>>>>>> -            reg = <0x54002000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc CRYP1>;
>>>>>>> -            resets = <&rcc CRYP1_R>;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> +&etzpc {
>>>>>>> +    cryp: crypto@54002000 {
>>>>>>> +        compatible = "st,stm32mp1-cryp";
>>>>>>> +        reg = <0x54002000 0x400>;
>>>>>>> +        interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +        clocks = <&rcc CRYP1>;
>>>>>>> +        resets = <&rcc CRYP1_R>;
>>>>>>> +        feature-domains = <&etzpc 42>;
>>>>>>> +        status = "disabled";
>>>>>>>         };
>>>>>>>     };
>>>>>>> diff --git a/arch/arm/boot/dts/stm32mp13xf.dtsi
>>>>>>> b/arch/arm/boot/dts/stm32mp13xf.dtsi
>>>>>>> index 4d00e7592882..b9fb071a1471 100644
>>>>>>> --- a/arch/arm/boot/dts/stm32mp13xf.dtsi
>>>>>>> +++ b/arch/arm/boot/dts/stm32mp13xf.dtsi
>>>>>>> @@ -4,15 +4,13 @@
>>>>>>>      * Author: Alexandre Torgue <alexandre.torgue@foss.st.com> for
>>>>>>> STMicroelectronics.
>>>>>>>      */
>>>>>>>     -/ {
>>>>>>> -    soc {
>>>>>>> -        cryp: crypto@54002000 {
>>>>>>> -            compatible = "st,stm32mp1-cryp";
>>>>>>> -            reg = <0x54002000 0x400>;
>>>>>>> -            interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> -            clocks = <&rcc CRYP1>;
>>>>>>> -            resets = <&rcc CRYP1_R>;
>>>>>>> -            status = "disabled";
>>>>>>> -        };
>>>>>>> +&etzpc {
>>>>>>> +    cryp: crypto@54002000 {
>>>>>>> +        compatible = "st,stm32mp1-cryp";
>>>>>>> +        reg = <0x54002000 0x400>;
>>>>>>> +        interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
>>>>>>> +        clocks = <&rcc CRYP1>;
>>>>>>> +        resets = <&rcc CRYP1_R>;
>>>>>>> +        status = "disabled";
>>>>>>>         };
>>>>>>>     };
>>>>>>
>>>>>
>>>>
>>>> Regarding the patch itself, I can separate it in two patches.
>>>> 1)Introduce ETZPC
>>>> 2)Move peripherals under ETZPC
>>>>
>>>> Best regards,
>>>> Gatien
>>>>
>> >
