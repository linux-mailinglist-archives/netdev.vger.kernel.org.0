Return-Path: <netdev+bounces-5260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 799C371072C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A4111C20E26
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B3ED2E0;
	Thu, 25 May 2023 08:19:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91338BE78
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:19:07 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD4F818C;
	Thu, 25 May 2023 01:19:04 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34P8IdMa088728;
	Thu, 25 May 2023 03:18:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1685002719;
	bh=7VamqbMYAJFJmQ+I85X/FgnVMg8pLLAOtK3pZ1kRL9Q=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=odZ0wS76m+PVzhY1L0vwLX8JmwY9wtoMZZ27gIQ8QlF7cdRCLwMOqPVzMj2SqevfG
	 Kc1lZZjiTLlm8OkeJNxW3M+cF+gYhPaW/tNzLUSC81GK4DbZukzM6R3Bcejebcp7dx
	 8rSve8tbekX3SrZm55U+Ci1+sILPU3Zy4J5E4iRw=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34P8IdkH022658
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 25 May 2023 03:18:39 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 25
 May 2023 03:18:39 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 25 May 2023 03:18:39 -0500
Received: from [172.24.221.38] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34P8IYY0016393;
	Thu, 25 May 2023 03:18:35 -0500
Message-ID: <827377ae-091b-8888-18b9-bb574d7ff3ca@ti.com>
Date: Thu, 25 May 2023 03:18:34 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: DP83867 ethernet PHY regression
Content-Language: en-US
To: Francesco Dolcini <francesco@dolcini.it>,
        Johannes Pointner
	<h4nn35.work@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>, <vikram.sharma@ti.com>
CC: Bagas Sanjaya <bagasdotme@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner
 Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
 <ZG4ISE3WXlTM3H54@debian.me>
 <CAHvQdo0gucr-GcWc9YFxsP4WwPUdK9GQ6w-5t9CuqqvPTv+VcA@mail.gmail.com>
 <ZG8PS/CSpHXIA6wt@francesco-nb.int.toradex.com>
From: "Bajjuri, Praneeth" <praneeth@ti.com>
In-Reply-To: <ZG8PS/CSpHXIA6wt@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Andrew,Francesco,

On 5/25/2023 2:33 AM, Francesco Dolcini wrote:
> Hello Johannes,
> 
> On Thu, May 25, 2023 at 08:31:00AM +0200, Johannes Pointner wrote:
>> On Wed, May 24, 2023 at 3:22 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>>>
>>> On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
>>>> Hello all,
>>>> commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
>>>> established link") introduces a regression on my TI AM62 based board.
>>>>
>>>> I have a working DTS with Linux TI 5.10 downstream kernel branch, while
>>>> testing the DTS with v6.4-rc in preparation of sending it to the mailing
>>>> list I noticed that ethernet is working only on a cold poweron.
>>>>
>>>> With da9ef50f545f reverted it always works.

Thank you for bringing this issue to attention.
I have looped Siddharth and vikram to further investigate and provide input.


>>>>
>>>> Here the DTS snippet for reference:
>>>>
>>>> &cpsw_port1 {
>>>>        phy-handle = <&cpsw3g_phy0>;
>>>>        phy-mode = "rgmii-rxid";
>>>> };
>>>>
>>>> &cpsw3g_mdio {
>>>>        assigned-clocks = <&k3_clks 157 20>;
>>>>        assigned-clock-parents = <&k3_clks 157 22>;
>>>>        assigned-clock-rates = <25000000>;
>>>>
>>>>        cpsw3g_phy0: ethernet-phy@0 {
>>>>                compatible = "ethernet-phy-id2000.a231";
>>>>                reg = <0>;
>>>>                interrupt-parent = <&main_gpio0>;
>>>>                interrupts = <25 IRQ_TYPE_EDGE_FALLING>;
>>>>                reset-gpios = <&main_gpio0 17 GPIO_ACTIVE_LOW>;
>>>>                reset-assert-us = <10>;
>>>>                reset-deassert-us = <1000>;
>>>>                ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
>>>>                ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
>>>>        };
>>>> };
>>>>
>>>
>>> Thanks for the regression report. I'm adding it to regzbot:
>>>
>>> #regzbot ^introduced: da9ef50f545f86
>>> #regzbot title: TI AM62 DTS regression due to dp83867 soft reset
>>
>> Hello Francesco,
>>
>> I had a similar issue with a patch like this, but in my case it was the DP83822.
>> https://lore.kernel.org/netdev/CAHvQdo2yzJC89K74c_CZFjPydDQ5i22w36XPR5tKVv_W8a2vcg@mail.gmail.com/
>> I also raised the question for the commit da9ef50f545f.
>> https://lore.kernel.org/lkml/CAHvQdo1U_L=pETmTJXjdzO+k7vNTxMyujn99Y3Ot9xAyQu=atQ@mail.gmail.com/
>>
>> The problem was/is for me that the phy gets the clock from the CPU and
>> the phy is already initialized in the u-boot.
>> During the Linux kernel boot up there is a short amount of time where
>> no clock is delivered to the phy.
>> The phy didn't like this and was most of the time not usable anymore.
>> The only thing that brought the phy/link back was resetting the phy
>> using the phytool.
> 
> I had a look and it seems that is a different issue here, but I cannot
> exclude that this is related.
> 
> First the link up/down, negotiation and mdio and related communication
> is perfectly fine, what it looks like is not working is that no data is
> flowing over RGMII.
> 
> Second, also in our case the clock is coming from the SoC, however this
> clock is enabled way earlier in the boot, and at that time the phy is
> even in reset.
> 
>   phy reset asserted
>   . SPL on TI AM62 R5
>     . enable clock
>   . SPL on TI AM62 A
>   . U-Boot proper on TI AM62 A
>     .release phy reset
> 
> The phy reset is also configured in the DTS and used by the Linux driver.
> 
> In addition to that, as I already clarified in my second email, the
> issue is happening also on a cold poweron. It happens most of the time,
> but not always.
> 
> Francesco
> 
> 

